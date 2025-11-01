#import "../../../public/utils.typ": (
  admonition, blog-post, bluesky-embed, github-card, github-gist, img, note,
  proofreaders-list, rust-btw, section, tenor-gif, tilslut-entry, tilslut-type,
  todo, typst, video, youtube-channel,
)
#show: blog-post.with(
  "Nix Flakifying a Native Rust App",
  description: [A step-by-step post on how I packaged and built a Rust application that depends on ffmpeg at runtime for Nix. I walk through the hurdles I ran into and how I solved them, often with links if you want to read more. While not written explicitly, I also show why reproducibility matters and how Nix helps with it. Another goal of this blog post is to show off Tanim, the package I packaged (heh, idk why that sentence is funny to me).],
  assumed-audience: (
    "People who're familiar with Typst and want to use it for animations",
    "People who want Manim but with Typst",
    "People who want to see how Rust packages with native dependencies are packaged for nix",
    "Rust developers who want to use a Nix Flake for reproducible environment",
  ),
  tags: (
    "Fighting with Nix",
    "Image Generation",
    "Nix flakes",
    "NixOS",
    "Typst",
    "Rust",
  ),
  category: "Programming",
  proofreaders: (proofreaders-list.divyesh, proofreaders-list.ash),
  tilslut: (
    tilslut-entry(
      title: "Replacing a running Linux system with NixOS over SSH",
      by: "crescentrose",
      url: "https://crescentro.se/posts/ssh-nixos/",
      type: tilslut-type.blogpost,
      comment: "
        Fun read about how to replace a traditional distro with NixOS and it also explains how nixos-anywhere [1] might work.
      ",
      links: (
        link(
          "https://github.com/nix-community/nixos-anywhere",
        )[nixos-anywhere on GitHub],
      ),
    ),
    tilslut-entry(
      title: "Nix derivations by hand, without guessing",
      by: "Max Bernstein",
      url: "https://bernsteinbear.com/blog/nix-by-hand/",
      type: tilslut-type.blogpost,
      comment: "
        In this blogpost itself [1] I mentioned the weird way to get hash, and I don't like relying on \"magic\" like that. Max's blogpost shows how the hash is calculated and removed the mystery. Even if I'm never going to calculate the hash by hand, It's good to know there's something I can refer back to if I ever need to.
      ",
      links: (
        link(
          "https://sakurakat.systems/posts/build-rust-app-in-nix/#finding-the-hash",
        )[Finding the hash],
      ),
    ),
    tilslut-entry(
      title: "I got rescued while filming a TV show",
      by: "Beau Miles",
      url: "https://www.youtube.com/watch?v=qwymos8oDrI",
      type: tilslut-type.youtube,
      comment: "I originally found Beau through an admittedly stupid video [1] where he ate canned beans for over a month, and his cinematography captivated me -- his voice, the narration, the videography -- everything. It tickles a part of my brain I didn't even know existed. In this video, he shows some behind-the-scenes of a TV series for Red Bull, which is very different from his usual style. I think this video shows how professional extreme sports athletes do what they do. After he messes up, Nouria Newman, the woman he was interviewing, not only commands him on what to do, what not to do, but she also grabs the kayak and the paddle and brings everything back to safety while staying calm and collected. Nouria shows how mastery lets you handle so much going wrong, and how Beau's instincts were completely off.",
      links: (
        link("https://www.youtube.com/watch?v=RYsTlfhDSDY")[
          40 days eating only canned beans (191 tins) by Beau Miles on YouTube
        ]
      ),
    ),
    tilsut-entry(
      url: "https://www.youtube.com/watch?v=a8mRGkGlLJA",
      title: "7 Techniques to INSTANTLY Upgrade Your Vegetables",
      by: "Brian Lagerstrom",
      type: tilslut-type.youtube,
      comment: "
        I love how he's teaching how to make individual veggies taste good. I don't want to rely on meat to make food taste good. I like veggies. If you follow me on Bluesky, you've probably seen me post the soups I make and then how I use the soup for pasta or noodles or whatever later on. I'm also a fan of how Ethan Chlebowski talks about food [1]. Brian's video shows how to make the individual components taste good so you don't need to rely on recipes.

        I feel recipes are too restrictive. They're great when you're starting out and getting a feel for cooking so you build good instincts, but I don't think they're great for the long term. I've seen people complain about buying a whole cabbage for a specific recipe and then having to throw out 3/4th of it because no other recipe uses it. There are apps that help you plan a whole week's worth of meals upfront, and I think they're great, but I don't want to rely on a service that might go down anytime.

        I want to be able to go to the veggie market, see what vibes with me that day, buy the veggies, and use them. My mom often complains that I don't have recipes for what I want; I think it's better this way. It would be better if I planned the meal upfront and didn't make stuff up based on what I want at that moment, but it's fine. I feel like this style of cooking is just how my brain works. Maybe this is why I like programming. Recipes feel like strict top-to-bottom checklists and procedures, like a preflight checklist for airplanes. I want to use what I have on hand. I'm not working in the food industry; I'm cooking for myself.

        I know there's something like \"complementary protein\", or \"complete food\", with pairings that make it hard to end up with nutritional imbalances-similar to [2]. I should have something like that for myself for a week's worth of meals, but I'm too lazy to set it up.
      ",
      links: (
        link(
          "https://www.youtube.com/watch?v=srMEoe_5y6g",
        )[Why Recipes are holding you back from learning how to cook by Ethan Chlebowski on YouTube],
        link(
          "https://www.health.harvard.edu/nutrition/nutritional-power-couples",
        )[Nutritional power couples - Harvard Health],
      ),
    ),
  ),
)

= What is "Tanim"?
If you've seen #youtube-channel([3Blue1Brown on YouTube], "3Blue1Brown"), then you probably know what Manim is.

#github-card("manimCommunity/manim")

I had always wished for something similar for #typst() #rust-btw(pre: "written in ", post: [ -- totally not biased lol]).

So when I saw that LiquidHelium had created a thread in the Typst Discord channel titled "tanim: animation, but with typst," I got very excited.

#github-card("liquidhelium/tanim")

Tanim is supposed to serve the same function for Typst that Manim does for Python.

There are alternatives, like
+ #github-card("motion-canvas/motion-canvas")
+ #github-card("remotion-dev/remotion")

However, they're both JavaScript-based, and I don't want to use JS. I'd rather use Typst since that's what I'm using to author content and diagrams.

And since there's no flake for it yet, I might as well learn how to make one myself-I've been meaning to learn the process for ages anyway.

= Building the program

Alright, so bear with me. Usually I ask a human, but this is a specific enough request that I can use an LLM to start.

I started by asking Gemini what I need to do to build a Rust package from source in Nix.

Gemini said I need to add `flake.nix` to the root of the project, but in my case I want to download the source code from GitHub. When I said that, it mentioned ```nix pkgs.fetchFromGitHub```.

Alright, that's my first step then.

I searched for `fetchFromGitHub` and found
#link("https://ryantm.github.io/nixpkgs/builders/fetchers/")[Fetchers | nixpkgs].

I'm not sure why the official repo doesn't have it deployed, but sure -- I'll just use this version I found. It's very useful.

`fetchFromGitHub` is a function that downloads a repo from GitHub.

Now that I have the source code, I need to build it. There's a section on language frameworks in the sidebar, so I used that: #link("https://ryantm.github.io/nixpkgs/languages-frameworks/rust/#compiling-rust-applications-with-cargo")[Rust | nixpkgs > buildRustPackage: Compiling Rust applications with Cargo].

```nix
{
  stdenv,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "tanim"; # Name of the package
  version = "unstable";

  src = fetchFromGitHub {
    owner = "liquidhelium";
    repo = "tanim";
    rev = "d78c52dbc611ebb9c574e55dc6a4a6bef69e7a17";
    hash = "sha256-X4toMLTPNtaxQQBDGNvnTrmReMGzNbjuFXgG318Z53s=";
  };

  cargoHash = "sha256-55eYNoUcUZ4EoEVM6j8urFHq+XXXEy97gXWPRArscxw=";
}
```

Some points for the above code:

I used `unstable` because tanim itself is not being tagged and released on GitHub with versions.

`rev` is the specific commit I want to download.
It's used to make the process reproducible,
which removes (or at the very least reduces) the likelihood of surprises.

`hash` and `cargoHash` are SHA-256 hashes.
As I understand it,
they're used as keys to check whether Nix has already completed the task,
and if so, use the cached output.
This allows Nix to avoid duplicating work as you might imagine.
How to find the hash is described in the next section.

== Finding the hash

There is a convenience function described in a post I found.
I searched for it and found this resource.

#link(
  "https://dmarcoux.com/posts/hash-in-nix-packages/",
)[Dany Marcoux | Use lib.fakeHash as a Placeholder for Hashes in Nix Packages]

The usual procedure is to use a fake hash,
run the file,
and then replace it with the correct hash given by the command.

== Running the file

I didn't know how to run the file, so I asked Gemini because it's a specific thing.

#let nix-expr-build(ctr) = {
  ctr.step()
  context raw(
    lang: "bash",
    block: true,
    ctr.display(both: true, (..nums) => (
      "# attempt " + nums.pos().map(str).join("/") + "\n"
    ))
      + ```bash nix-build -E 'with import <nixpkgs> {}; callPackage ./tanim.nix {}'```.text,
  )
}
#let nix-build-ctr = counter("nix-build-ctr")

#nix-expr-build(nix-build-ctr)

It gave me the command
Which tracks with
#link("https://dmarcoux.com/posts/hash-in-nix-packages/#:~:text=NixOS%20configuration%20with-,callPackage%20./your_package_file.nix%20%7B%7D,-.%20The%20build")[```nix callPackage ./your_package_file.nix {}```  on Dany Marcoux | Use lib.fakeHash as a Placeholder for Hashes in Nix Packages],
so I ran the command and waited.

= Error: failed to run custom build command for `ffmpeg-sys-next v7.1.3`

Ono

Let's read the stack trace!

```typc
  thread 'main' panicked at /build/tanim-unstable-vendor/ffmpeg-sys-next-7.1.3/build.rs:1035:14:
  called `Result::unwrap()` on an `Err` value: Could not run `PKG_CONFIG_ALLOW_SYSTEM_LIBS=1 PKG_CONFIG_ALLOW_SYSTEM_CFLAGS=1 pkg-config --libs --cflags libavutil`
  The pkg-config command could not be found.

  Most likely, you need to install a pkg-config package for your OS.
  Try `apt install pkg-config`, or `yum install pkg-config`, or `brew install pkgconf`
  or `pkg install pkg-config`, or `apk add pkgconfig` depending on your distribution.

  If you've already installed it, ensure the pkg-config command is one of the
  directories in the PATH environment variable.
```

>Try ```bash apt install pkg-config```
I'm gonna assume it means `pkg-config` is missing.

After searching around for a bit I found #link("https://discourse.nixos.org/t/how-to-add-pkg-config-file-to-a-nix-package/8264/3")[How to Add pkg-config file to a Nix Package? on NixOS Discourse].

It seems like they just added `pkg-config` to `nativeBuildInputs`, so let's try that.

Add `pkg-config` to the inputs to "import" it

```diff
{
  stdenv,
  fetchFromGitHub,
  rustPlatform,
+ pkg-config,
}:
```

Then add it to `nativeBuildInputs`

```diff
  cargoHash = "sha256-55eYNoUcUZ4EoEVM6j8urFHq+XXXEy97gXWPRArscxw=";

+  nativeBuildInputs = [
+    pkg-config
+  ];
}
```

#nix-expr-build(nix-build-ctr)

= The system library `libavutil` required by crate `ffmpeg-sys-next` was not found.

Error, again.

Reading the stack trace again:

```
  The system library `libavutil` required by crate `ffmpeg-sys-next` was not found.
  The file `libavutil.pc` needs to be installed and the PKG_CONFIG_PATH environment variable must contain its parent directory.
  The PKG_CONFIG_PATH environment variable is not set.
```

It needs `libavutil`.

I searched for how to add it to `buildInputs` but couldn't find anything via DuckDuckGo, so I switched to Google and found this #link("https://github.com/NixOS/nixpkgs/issues/322768#issuecomment-2192812214")[Package request: libavutil \#322768 on GitHub].

```diff
  pkg-config,
+ ffmpeg,
```

```diff
   nativeBuildInputs = [
     pkg-config
   ];

+ buildInputs = [
+   ffmpeg
+ ];
}
```

#nix-expr-build(nix-build-ctr)

= Unable to find libclang

Error again:

```typc
  thread 'main' panicked at /build/tanim-unstable-vendor/bindgen-0.70.1/lib.rs:622:27:
  Unable to find libclang: "couldn't find any valid shared libraries matching: ['libclang.so', 'libclang-*.so', 'libclang.so.*', 'libclang-*.so.*'], set the `LIBCLANG_PATH` environment variable to a path where one of these files can be found (invalid: [])"
  note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
```

Now it needs clang.

I searched for it and found
#link("https://discourse.nixos.org/t/how-to-correctly-populate-a-clang-and-llvm-development-environment-using-nix-shell/3864/2")[How to correctly populate a clang and llvm development environment using nix-shell? on NixOS Discourse],

which had
#link(
  "https://github.com/NixOS/nixpkgs/pull/67725",
)[LIBCLANG_PATH hook \#67725 on GitHub]

which itself had the comment #link("https://github.com/NixOS/nixpkgs/pull/67725#issuecomment-626231544")[Closing in favor of \#85489 by matthewbauer commented on May 10, 2020].

Then #link("https://github.com/NixOS/nixpkgs/pull/85489")[LIBCLANG_PATH hook [updated] \#85489 on GitHub] finally had something:

```nix
bulidInputs = [ libclang ];
```

but that didn't work.
#footnote[Reading again, it might've worked if I had typed it correctly LOL, either way, I'm gonna keep it as is and not fix the typo now.]

Dead end.

Next, I tried #link("https://hoverbear.org/blog/rust-bindgen-in-nix/")[Using rust-bindgen in Nix by Ana Hobden (Hoverbear)]:

```nix
  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";
```

That did not work.

On to the next result.
I found #link("https://gist.github.com/yihuang/b874efb97e99d4b6d12bf039f98ae31e?permalink_comment_id=4311076#gistcomment-4311076")[build rust project using bindgen with nix],

which finally worked.

```diff
  nativeBuildInputs = [
    pkg-config
+   rustPlatform.bindgenHook
  ];
}
```

#nix-expr-build(nix-build-ctr)

= Success!!!

The nix-build expression builds and stores the result in the nix-store, creates a symlink to the result as `result`, and the output of the expression was a runnable binary. So, as per convention, the binary will be in `./result/bin` with whatever name was given to the binary. In this case, `tanim-cli`.

So, to test the binary we can do ```bash ./result/bin/tanim-cli --help```

#img(
  "https://r2.sakurakat.systems/build-rust-app-in-nix--run-tanim-cli-success.png",
  alt: "Screenshot of me running \"tanim-cli\" in terminal",
)

#tenor-gif(
  [Autism Creature Yippee Creature GIF],
  "https://tenor.com/view/autism-creature-yippee-creature-yippee-autism-woo-gif-10988973615622974862",
  dims: (480, 476),
  width: 80%,
)

= Flake-ifying

Flakes are unofficially the official way to package stuff.

So let's turn the expression into a flake and use Naersk to build the Rust application.
#github-card("nix-community/naersk")

As I understand it, the benefit of using naersk is that it caches dependencies.
I avoided using Naersk since fewer moving parts mean fewer complications.
However, now that I have figured out how to compile the application, I'll do it the proper way by using naersk.

There's an official template, so initializing the template is easy.

```bash
nix flake init -t github:nix-community/naersk
```

First, we need to download the source code for the program.

```nix
{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nix-community/naersk";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, flake-utils, naersk, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs) {
          inherit system;
        };

        naersk' = pkgs.callPackage naersk {};

        tanimSrc = pkgs.fetchFromGitHub {
            owner = "liquidhelium";
            repo = "tanim";
            rev = "d78c52dbc611ebb9c574e55dc6a4a6bef69e7a17";
            hash = "sha256-X4toMLTPNtaxQQBDGNvnTrmReMGzNbjuFXgG318Z53s=";
        };
      in rec {
        # For `nix build` & `nix run`:
        # packages.default = naersk'.buildPackage {
        #   src = ./.;
        # };

        # For `nix develop`:
        # devShells.default = pkgs.mkShell {
        #   nativeBuildInputs = with pkgs; [ rustc cargo ];
        # };
      }
    );
}
```

Add package to dev shell

```nix
        tanimSrc = pkgs.fetchFromGitHub {
            owner = "liquidhelium";
            repo = "tanim";
            rev = "d78c52dbc611ebb9c574e55dc6a4a6bef69e7a17";
            hash = "sha256-X4toMLTPNtaxQQBDGNvnTrmReMGzNbjuFXgG318Z53s=";
        };

        tanim = naersk'.buildPackage {
            src = tanimeSrc;
        };
        # ...snip

        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [ tanim ];
        };
```

Do ```bash nix develop``` and wait for the first error.

...... and we get it

Let's try this for now

```diff
        tanim = naersk'.buildPackage {
           src = tanimSrc;
+
+          buildInputs = [
+            pkgs.ffmpeg
+          ];
+
+          nativeBuildInputs = [
+            pkgs.pkg-config
+            pkgs.llvmPackages_latest.llvm
+            # rustPlatform.bindgenHook
+            # notice that this line is commented
+          ];
        };
```

Now it can't find `libclang`, so I'm making progress.

If I use ```nix rustPlatform.bindgenHook``` directly, it can't find it, so let's use ```nix pkgs.rustPlatform.bindgenHook```

```diff
             pkgs.llvmPackages_latest.llvm
-            # rustPlatform.bindgenHook
-            # notice that this line is commented
+            pkgs.rustPlatform.bindgenHook
           ];
```

and we successfully have it in our ```bash $PATH``` now 🎉🎉🎉

= Proper way to add packages to dev shell

`nativeBuildInputs` does the job, but it's not the correct way to do it.

The proper way to add packages to the development environment is via `packages`.

```diff
        devShells.default = pkgs.mkShell {
-          nativeBuildInputs = with pkgs; [ tanim ];
+          packages = with pkgs; [ tanim ];
        };
```

= Testing the package

Now that the application has been packaged properly,
let's write an example Typst file to use the CLI.

```typ
#let t = sys.inputs.at("t", default: 300)

#rect(
    height: 100%,
    width: 100%,
    fill: rgb("f0f0f0"),
    align(
        center + horizon,
        text(16pt, "Frame: " + str(t))
    )
)
```

Use the command
```bash
tanim-cli --frames 0..=120 --output animation.mp4 animation.typ
```

#video(
  "https://r2.sakurakat.systems/build-rust-app-in-nix--animation.mp4",
  height: 1754,
  width: 1240,
  loop: false,
)

= Updating the flake to the latest version

I found a memory leak in the program, and it was fixed in the latest version. So might as well update to the latest version.

If the hash is not updated, Nix will assume nothing has changed and will use the old source code, so remove it and see what it complains.

```diff
        tanimSrc = pkgs.fetchFromGitHub {
          owner = "liquidhelium";
          repo = "tanim";
-         rev = "d78c52dbc611ebb9c574e55dc6a4a6bef69e7a17";

+         rev = "06decc2170de01e54511b86a3d657acb0ba9a06e";
-         hash = "sha256-X4toMLTPNtaxQQBDGNvnTrmReMGzNbjuFXgG318Z53s=";
        };

```

As expected, it complains that there is no hash, then says that the correct hash is `sha256-EJoNVbp6k1o0KUlIRhr3bdrtDAETwSOqu516EYBA6RA=`.
This is how I got the new hash.

```diff
        tanimSrc = pkgs.fetchFromGitHub {
          owner = "liquidhelium";
          repo = "tanim";

          rev = "06decc2170de01e54511b86a3d657acb0ba9a06e";
+         hash = "sha256-EJoNVbp6k1o0KUlIRhr3bdrtDAETwSOqu516EYBA6RA=";
        };

```

And it builds.

To test whether the memory leak is fixed, let's run the stupid "bee movie" meme example.

#raw(
  "#let script = ```
According to all known laws
of aviation,
there is no way a bee
should be able to fly.
Its wings are too small to get
its fat little body off the ground.
The bee, of course, flies anyway
because bees don't care
what humans think is impossible.
// ..snip..
.```.text

#let script = script.split(\"\\n\").join(\" \").split(\" \")
#let chars-max = 905

#let t = int(sys.inputs.at(\"t\", default: chars-max))

#set page(
  header: [script.len() = #script.len()],
  footer: [
    t = #t / #script.len() (#calc.round(t / script.len() * 100, digits: 2)%)#linebreak()
    #{
      let perc = t / script.len()
      box(width: perc * 100%, {
        line(length: 100%)
      })
      box(width: (1 - perc) * 100%, {
        line(length: 100%, stroke: black.lighten(50%))
      })
    }
  ],
)

#text(if t <= chars-max {
  script.slice(0, t).join(\" \")
} else {
  script.slice(t, script.len()).join(\" \")
})",
  lang: "typst",
  block: true,
)

The script takes the input `t` from the CLI as the frame number and renders that frame. The CLI then stitches the frames together using ffmpeg. Each frame one word is added, and when the frame is full (calculated to be 905 words) one word is removed from the start; the remaining words adjust to fill the space. My aim was to give the illusion that words are coming and going, kinda like the Star Wars opening crawl.

== Resulting video

The video was sped up in post to fit 10 seconds since I didn't want to calculate how to do it in the typst file.

#video(
  "https://r2.sakurakat.systems/build-rust-app-in-nix--bee-movie-script.mp4",
  width: 1240,
  height: 1754,
  loop: true,
)

= Specifying the toolchain

Now that I have a working video, there's still one more piece I need to add to make builds reproducible and deterministic.

That piece is the toolchain, which specifies the versions of rustc, cargo, and so on.

Naersk helped make the build deterministic, but I don't know what version of rustc it used.
To specify that, I have to add `fenix`

Add fenix to the inputs. #github-card("nix-community/fenix")

```diff
  nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
+ fenix = {
+     url = "github:nix-community/fenix";
+     inputs.nixpkgs.follows = "nixpkgs";
+ };
```

Get the toolchain

```nix
        toolchain = fenix.packages.${system}.fromToolchainName {
          name = "1.90.0";
          sha256 = "sha256-SJwZ8g0zF2WrKDVmHrVG3pD2RGoQeo24MEXnNx5FyuI=";
        };
```

Use the toolchain in naersk
```diff
-       naersk' = pkgs.callPackage naersk { };
+       naersk' = pkgs.callPackage naersk {
+         cargo = toolchain.cargo;
+         rustc = toolchain.rustc;
+       };
```

Naersk also uses fenix, so I should make it follow the fenix I have in my flake and, while I'm at it, also make its nixpkgs follow mine.
```diff
-   naersk.url = "github:nix-community/naersk";
+   naersk = {
+     url = "github:nix-community/naersk";
+     inputs.nixpkgs.follows = "nixpkgs";
+     inputs.fenix.follows = "fenix";
+   };
```

Aaaaaand it should just work? Let's try ```bash nix develop```.

It successfully builds, but if I run ```bash tanim-cli --help```, it complains that `libavutil.so.59` isn't present.

Huh, weird. Let's try executing `ffmpeg`.
```text
[kat@nixos:/mnt/d/Sync/Projects/tanim-test]$ ffmpeg
bash: ffmpeg: command not found
```

Huh, weird.

Let's search for "nix buildInputs" and see other results.

Looking at #link("https://gist.github.com/CMCDragonkai/45359ee894bc0c7f90d562c4841117b5")[Understanding Nix Inputs \#nix] on GitHub Gists,
it mentions `propagatedBuildInputs`, which keeps the build inputs for runtime as well as build time. Let's try that.

```diff
-         buildInputs = [
+         propagatedBuildInputs = [
            pkgs.ffmpeg
          ];
```

Huh, weird.

I checked a lot of source code on GitHub and I don't see what I'm doing wrong.

I want to check if libavutil is even in the path or whatever.

I know `LD_LIBRARY_PATH` is a thing; let's check its contents.

```bash
nix develop
echo $LD_LIBRARY_PATH
```

Huh, weird. It's empty.

I don't know how to check all environment variables in a nix shell, but I know how to do it in nushell.

```bash
nu
```
```nu
echo $env
```

It prints out a lot of stuff; reading from the top, ```bash $NIX_LDFLAGS``` seems interesting.

Going back to bash
```bash
echo $NIX_LDFLAGS
```

the above command gives
```text
-rpath /mnt/d/Sync/Projects/tanim-test/outputs/out/lib -L/nix/store/wxjs6sb18xkfx3dgwrlmg2z77jn98iqa-ffmpeg-7.1.1-lib/lib -L/nix/store/wxjs6sb18xkfx3dgwrlmg2z77jn98iqa-ffmpeg-7.1.1-lib/lib
```

The fact that the same folder for ffmpeg is passed twice is weird, but it shouldn't be causing a problem like this.

IDK. Let's just ask someone.

I asked #link("https://github.com/OPNA2608")[OPNA2608 (Cosima Neidahl)] about my problem, and she quickly found the problem.

As of writing, Rust 1.90 was released not so long ago, and with v1.90 they changed the default linker to LLD.

The new linker is the problem. Cosima had been helping with the exact problem I was having and directed me to #link("https://github.com/NixOS/nixpkgs/pull/451179")[rust: 1.89.0 -> 1.90.0 by NyCodeGHG · Pull Request \#451179 · NixOS/nixpkgs].

I was just going to revert to 1.89, but this seems more interesting.

After reading the changed files, I think the change to `RUSTFLAGS` is important
#link(
  "https://github.com/NixOS/nixpkgs/pull/451179/files#diff-4e187944d64589b494c60f7d5830369ec133ad88972265734587bab64880c942R105-R110",
)[rust: 1.89.0 -> 1.90.0 by NyCodeGHG · Pull Request \#451179 · NixOS/nixpkgs]

```diff

          propagatedNativeBuildInputs = [
            pkgs.pkg-config
            pkgs.rustPlatform.bindgenHook
            pkgs.llvmPackages_latest.llvm
          ];

+         RUSTFLAGS = nixpkgs.lib.concatStringsSep " " ([
+           # Increase codegen units to introduce parallelism within the compiler.
+           "-Ccodegen-units=10"
+           # Upstream defaults to lld on x86_64-unknown-linux-gnu, we want to use our linker
+           "-Clinker-features=-lld"
+           "-Clink-self-contained=-linker"
+         ]);
        };
```

Run ```bash nix develop``` and ```bash tanim-cli --frames 0..=120 --output example.mp4 example.typ```

and it works again! :3

= Final flake

```nix
{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.fenix.follows = "fenix";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      flake-utils,
      naersk,
      nixpkgs,
      fenix,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = (import nixpkgs) {
          inherit system;
        };

        toolchain = fenix.packages.${system}.fromToolchainName {
          name = "1.90.0";
          sha256 = "sha256-SJwZ8g0zF2WrKDVmHrVG3pD2RGoQeo24MEXnNx5FyuI=";
        };

        naersk' = pkgs.callPackage naersk {
          cargo = toolchain.cargo;
          rustc = toolchain.rustc;
        };

        tanimSrc = pkgs.fetchFromGitHub {
          owner = "liquidhelium";
          repo = "tanim";
          rev = "06decc2170de01e54511b86a3d657acb0ba9a06e";
          hash = "sha256-EJoNVbp6k1o0KUlIRhr3bdrtDAETwSOqu516EYBA6RA=";
        };

        tanim = naersk'.buildPackage {
          src = tanimSrc;

          propagatedBuildInputs = [
            pkgs.ffmpeg
          ];

          propagatedNativeBuildInputs = [
            pkgs.pkg-config
            pkgs.rustPlatform.bindgenHook
            pkgs.llvmPackages_latest.llvm
          ];

          # Taken from https://github.com/NixOS/nixpkgs/pull/451179
          RUSTFLAGS = nixpkgs.lib.concatStringsSep " " ([
            # Increase codegen units to introduce parallelism within the compiler.
            "-Ccodegen-units=10"
            # Upstream defaults to lld on x86_64-unknown-linux-gnu, we want to use our linker
            "-Clinker-features=-lld"
            "-Clink-self-contained=-linker"
          ]);
        };
      in
      rec {
        packages.default = tanim;

        apps.default = flake-utils.lib.mkApp {
          drv = tanim;
          exePath = "/bin/tanim-cli";
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [ tanim ];
        };
      }
    );
}
```

= Liar, you added more things!

If you read the code above (first off, thank you?), you probably noticed an extra export: `apps`.

The app is what runs when you do ```bash nix run```. If you don't feel like cloning the flake, you can just run:
```bash
nix run github:pawarherschel/tanim-flake
```
It'll run the binary. Then you can have to pass the rest of the arguments by adding `--` and then your arguments.

#img(
  "https://r2.sakurakat.systems/build-rust-app-in-nix--nix-run-remote.png",
  alt: "output for the command \"nix run github:pawarherschel/tanim-flake/?rev=1498d218e74437039ebd5da5b331284a2d4ff9ed -- --help\"",
)

= Recreating a version of tanim

Let's have some fun! Since I've already procrastinated on this post, I'll keep the explanation to a minimum.

From what I can tell, `tanim-cli` doesn't do anything too special.
It uses the convention that `t` is the frame number and stitches the frames together.

So I figured, let's remake it with nix flakes!

== Configure Typst

```nix
commonArgs = t: {
  typstSource = "main.typ";

  typstOpts = {
    format = "png";
    pages = 1;
    input = [
      (lib.strings.concatStrings [
        "t="
        (builtins.toString t)
      ])
    ];
  };

  fontPaths = [
    # Add paths to fonts here
    # "${pkgs.roboto}/share/fonts/truetype"
  ];

  virtualPaths = [
    # Add paths that must be locally accessible to typst here
    # {
    #   dest = "icons";
    #   src = "${inputs.font-awesome}/svgs/regular";
    # }
  ];
};
```

- Make `commonArgs` a function that takes the frame number as `t`
- Set the output format to png
- Set the number of pages to 1
- Pass the frame number to Typst

== Typix calls

#github-card("loqusion/typix")

I started with the Typix template and removed most of what I didn't need.

```nix
let
  framesStart = 0;
  framesEnd = 100;

  build-frame =
    t:
    typixLib.buildTypstProject (
      commonArgs t
      // {
        inherit src;
      }
    );

  build-frames = builtins.genList (
    x:
    let
      t = framesStart + x;
    in
    (build-frame t).out
  ) (framesEnd - framesStart);
in { }
```

- Declare the starting and ending frame
- Create a `build-frame` function that takes `t`
- Create a list of all frames

== Save paths for frames

This step is required for ffmpeg since the frames aren't in the usual `frame%03d.png` format.

```nix
save-frame-paths =
  let
    txt = lib.strings.concatStringsSep "\n" (
      builtins.map (
        x:
        lib.strings.concatStrings [
          "file '"
          x
          "'\nduration 0.03333"
        ]
      ) built-frames
    );
  in
  pkgs.writeText "meow.txt" txt;
```

- Concatenate file paths in the required format with the frame duration
- Create a text file called "meow.txt" and store it in the Nix store

== Stitch the video together

```nix
stitch-frames = pkgs.writeShellApplication {
  name = "stitch-frames";
  text =
    let
      frames = "-f concat -safe 0 -i ${save-frame-paths}";
      videoFilter = "-vf scale='trunc(iw/2)*2:trunc(ih/2)*2',fps=30";
    in
    "${ffmpeg}/bin/ffmpeg ${frames} ${videoFilter} -c:v libx264 -pix_fmt yuv420p ./output.mp4";
};
```

== Run the script

```nix
build-video = pkgs.stdenvNoCC.mkDerivation {
  pname = "tanim-as-nix-flake";
  version = "0.1";
  frames = built-frames;
  buildInputs = [
    ffmpeg
  ];
  frameList = save-frame-paths;
  script = stitch-frames;

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out

    ${stitch-frames}/bin/stitch-frames

    cp output.mp4 $out/output.mp4
  '';
};
```

- Create a derivation that runs the script and copies the output to the store

== Copy the video to current folder

```nix
video-path = builtins.path { path = build-video; };

copy-video = pkgs.writeShellApplication {
  name = "copy-output-to-cwd";
  runtimeInputs = [ pkgs.coreutils ];
  text = ''
    cp -LT --no-preserve=mode ${video-path}/output.mp4 output.mp4
  '';
};
```

- Get the Nix store path for the derivation
- Copy the video to the current directory

== Final flake


```nix
{
  description = "A Typst project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    typix = {
      url = "github:loqusion/typix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    # Example of downloading icons from a non-flake source
    # font-awesome = {
    #   url = "github:FortAwesome/Font-Awesome";
    #   flake = false;
    # };
  };

  outputs =
    inputs@{
      nixpkgs,
      typix,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        framesStart = 0;
        framesEnd = 100;

        pkgs = nixpkgs.legacyPackages.${system};
        inherit (pkgs) lib;

        typixLib = typix.lib.${system};

        src = typixLib.cleanTypstSource ./.;
        commonArgs = t: {
          typstSource = "main.typ";

          typstOpts = {
            format = "png";
            pages = 1;
            input = [
              (lib.strings.concatStrings [
                "t="
                (builtins.toString t)
              ])
            ];
          };

          fontPaths = [
            # Add paths to fonts here
            # "${pkgs.roboto}/share/fonts/truetype"
          ];

          virtualPaths = [
            # Add paths that must be locally accessible to typst here
            # {
            #   dest = "icons";
            #   src = "${inputs.font-awesome}/svgs/regular";
            # }
          ];
        };

        # Compile a Typst project, *without* copying the result
        # to the current directory
        build-frame =
          t:
          typixLib.buildTypstProject (
            commonArgs t
            // {
              inherit src;
            }
          );

        built-frames = builtins.genList (
          x:
          let
            t = framesStart + x;
          in
          (build-frame t).out
        ) (framesEnd - framesStart);

        ffmpeg = pkgs.ffmpeg-headless;

        save-frame-paths =
          let
            txt = lib.strings.concatStringsSep "\n" (
              builtins.map (
                x:
                lib.strings.concatStrings [
                  "file '"
                  x
                  "'\nduration 0.03333"
                ]
              ) built-frames
            );
          in
          pkgs.writeText "meow.txt" txt;

        stitch-frames = pkgs.writeShellApplication {
          name = "stitch-frames";
          text =
            let
              frames = "-f concat -safe 0 -i ${save-frame-paths}";
              videoFilter = "-vf scale='trunc(iw/2)*2:trunc(ih/2)*2',fps=30";
            in
            "${ffmpeg}/bin/ffmpeg ${frames} ${videoFilter} -c:v libx264 -pix_fmt yuv420p ./output.mp4";
        };

        build-video = pkgs.stdenvNoCC.mkDerivation {
          pname = "tanim-as-nix-flake";
          version = "0.1";
          frames = built-frames;
          buildInputs = [
            ffmpeg
          ];
          frameList = save-frame-paths;
          script = stitch-frames;

          dontUnpack = true;

          installPhase = ''
            mkdir -p $out

            ${stitch-frames}/bin/stitch-frames

            cp output.mp4 $out/output.mp4
          '';
        };

        video-path = builtins.path { path = build-video; };

        copy-video = pkgs.writeShellApplication {
          name = "copy-output-to-cwd";
          runtimeInputs = [ pkgs.coreutils ];
          text = ''
            cp -LT --no-preserve=mode ${video-path}/output.mp4 output.mp4
          '';
        };
      in
      {
        packages.default = copy-video;
      }
    );
}
```

== Testing the flake

I made the Bee Movie demo again, and it's definitely slower than Tanim, but it should run better across runs since it also caches the individual frames.

= New section for things I like

I wanted a place to add "#underline[T]hings #underline[I]'ve #underline[L]iked #underline[S]ince I #underline[L]ast #underline[U]pdated #underline[T]ext". Let's take the first letter of each word and shorten it to "TILSLUT".

As the name suggests, I'm gonna put things I've liked since the last post. It's a way to save blog posts, articles, Bluesky posts, videos, topics, food -- whatever I like.

I eventually want to post them as I get them, but for now I'm at a crossroads. I can either make a website and write in Typst to save stuff or create a custom Typst-to-Leaflet document compiler. At the pace life's moving for me, the year's pretty much over. I want to hit my goal of learning Blender this year, so I don't want to pick up something that'll take ages. At the same time, Typst-to-Leaflet seems doable and fun enough that I'd try it -- and I won't have to deal with pesky JavaScript.

I guess only time will tell.
