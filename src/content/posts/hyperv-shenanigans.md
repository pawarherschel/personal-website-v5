---
title: HyperV Shenanigans
published: 2025-04-13
description: This blog post covers how I created a Hyper-V VM from my laptop's NixOS Config flake along with all the errors and mistakes I made. I went through all of this trouble just so I won't have to start my laptop to rice and edit the config.
tags: 
  - NixOS
  - Virtualization
  - Hyper-V
  - Nix flakes
  - nixos-generators
  - Fighting with Nix
category: Programming
draft: false
---

# Introduction

I wanted to rice my laptop without turning it on,
so I thought, "Hey, I can just make a VM in Hyper-V",
because I didn't want to deal with VMWare or VirtualBox.
"I already use NixOS on WSL2, so I can just reuse the VHDX for the VM!",
or so I thought.
Then, quickly found out I can't just reuse it.

---

<img height="901" src="https://r2.sakurakat.systems/hyperv-shenanigans--no-tty.png" title="Screenshot showing No TTY" width="1467" alt="Screenshot of Hyper-V Manager with a VM booted up but the display is completely black. This shows that there is no TTY."/>

The dang thing doesn't even show a TTY!
Then, I remembered [github:nix-community/nixos-generators](https://github.com/nix-community/nixos-generators) exists.
Might as well use nixos generators, how hard can it be? It can't be that bad right? right???

Thus, as usual, I proceeded to fuck around and find out the age old lesson of:

## Software Programming Mantra

<img alt="We do this not because it is easy, but because we thought it would be easy" height="794" src="https://r2.sakurakat.systems/hyperv-shenanigans--mantra.svg" title="Software Programming Mantra" width="1058"/>

:::note
I journaled the whole journey on Bluesky!

Check it out here: https://bsky.app/profile/sakurakat.systems/post/3llnz5asyms2c

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:rwi65xn77uzhgyewkfbuuziz/app.bsky.feed.post/3llnz5asyms2c" data-bluesky-cid="bafyreiglr2t5dl777thtxucftt5qlwbq6j57jftmwclktvjxjtnmanbd6e" data-bluesky-embed-color-mode="system"><p lang="en">trying to make a hyperv VM with nixos so i can rice my laptop without turning it on</p>&mdash; Kathryn&lt;&#x27;u1f338&gt; (<a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz?ref_src=embed">@sakurakat.systems</a>) <a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz/post/3llnz5asyms2c?ref_src=embed">March 31, 2025 at 2:39 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

You can also read the skeets as an article here: https://skywriter.blue/pages/did:plc:rwi65xn77uzhgyewkfbuuziz/post/3llnz5asyms2c 
:::

# Enter [github\:nix-community/nixos-generators](https://github.com/nix-community/nixos-generators)

::github{repo="nix-community/nixos-generators"}

I first started by invoking `nixos-generator` and passed my nixos config via the `--flake` option.
I 
But, it kept saying `nixos/modules/virtualisation/disk-size-option.nix` is missing.

Now, I am new to flakes and Nix in general, so I couldn't figure out why it didn't find the option.

So, I figured the best course of action would be copying the example from website, and then slowly make changes.
That is, create a minimal working config, and then adapt it to my needs.

## Getting the minimal working config to work

It worked, but then I realized I used the wrong config, I used wsl's config instead of my laptop's config 🤦.
Well, at the very least I know it works now.

:::note
I had some errors after I changed it to my laptop's config, 
but I didn't record what the errors where.

Lesson learned ig
:::

I then made a stupid mistake.
See, NixOS allows you to have configuration for multiple... lets say... environments.
When you do `sudo nixos rebuild test --flake .`, 
the config which gets selected depends on the machine's hostname.
You can also specify which one you want to build by doing
`sudo nixos rebuild test --flake .#<hostname>`.
So, technically, I should have different hostnames for different machines,
à la `kats-laptop`, `kats-wsl`, `kats-rpi`, `kats-hyperv-vm`.
Along with a modular config, this allows you to have a single config which you can
push to GitHub or some any other place, and the only thing you have to do is rebuild.
I do want to modularize my config, I'm just being lazy because it works good enough.
Also-also, the `#<hostname>` part isn't limited to nixos configs,
in general it's to select a target. 
If you've used the `nix shell nixpkgs#<app>` command, you're selecting which target to build and expost to the shell.
Another place you might've selected the target is `nix build github:<owner>/<repo>#<branch>`.
These are the outputs from the flake.
Recently, I had to update [github\:MarceColl/zen-browser-flake](https://github.com/MarceColl/zen-browser-flake)
so it builds the latest version of the zen browser.
In the flake, you can choose if you want to use the build which was optimized
for newer systems, or the compatibility one.
:::info
You can read the short thread I made on bluesky 
<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:rwi65xn77uzhgyewkfbuuziz/app.bsky.feed.post/3lm3jib32pk2s" data-bluesky-cid="bafyreiae6gdke4n6voeg5sizs5skqguxjkihcbz4jes4mxp674jecjg2zq" data-bluesky-embed-color-mode="system"><p lang="en">My pc is in quarantine rn because of some RAM issues.
I spent the whole day just lazying around and relaxed for once, took naps, etc.

I suddenly remembered that I have a laptop I can use instead of bedrot.

Downloaded zen using github.com/MarceColl/ze...<br><br><a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz/post/3lm3jib32pk2s?ref_src=embed">[image or embed]</a></p>&mdash; Kathryn&lt;&#x27;u1f338&gt; (<a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz?ref_src=embed">@sakurakat.systems</a>) <a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz/post/3lm3jib32pk2s?ref_src=embed">April 5, 2025 at 11:36 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>
:::

While trying to get the vm image to build, at some point, I went from 
trying to build the `hyperv` target to trying to build the `install-iso-hyperv`.
As the name suggests, `install-iso-hyperv` builds an iso instead of an hyperv image which I can just load in the Hyper-V manager.
It acts as a LiveISO which you can try out before deciding if you want to install it or not,
but I wanted the image, so time to remake it with the `hyperv` target.
Also, the size of ISO was ~2.6gb.
I was also unsure if 20gb would be enough for the VM, so I bumped it up to 40gb.

## Back to failing to build

I thought that changing the image size to 40gb was the problem,
so I changed it back to 20gb,
I can just increase the disk size in Hyper-V manager.

The build failed, again.
I checked the logs and found this:
```
Model:  (file)
Disk /build/nixos.raw: 4295MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:
Number  Start   End     Size    File system  Name     Flags
1      8389kB  269MB   261MB   fat32        ESP      boot, esp
2      269MB   4294MB  4024MB  ext4         primary
```

## Lead astray

I made a lot of wrong assumptions, you can read it all from [this](https://bsky.app/profile/sakurakat.systems/post/3lloeoe3ylc2o) part of the thread,
I will just skip over the details in this post.
<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:rwi65xn77uzhgyewkfbuuziz/app.bsky.feed.post/3lloeoe3ylc2o" data-bluesky-cid="bafyreicenmdklh3lqdn53du4eb5gnhrygmcflzcobt76cmyk6i5ew7ghri" data-bluesky-embed-color-mode="system"><p lang="en">Model:  (file)
Disk /build/nixos.raw: 4295MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:
Number  Start   End     Size    File system  Name     Flags
1      8389kB  269MB   261MB   fat32        ESP      boot, esp
2      269MB   4294MB  4024MB  ext4         primary</p>&mdash; Kathryn&lt;&#x27;u1f338&gt; (<a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz?ref_src=embed">@sakurakat.systems</a>) <a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz/post/3lloeoe3ylc2o?ref_src=embed">March 31, 2025 at 6:05 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

Tl;dr: The things I changed to make it easier to debug were causing the build to fail even after I fixed the problem.

The fix was to add
```nix
{
  virtualisation.diskSize = 20 * 1024;
}
```
to the modules array, around [here](https://github.com/pawarherschel/nixos-config/blob/7042e5c893375afcf62d4f2bea0112d874e7210e/flake.nix#L56)
<img alt="Screenshot of flake.nix on GitHub, the line where the above mentioned modifications have to be added is highlighted in yellow" height="1347" src="https://r2.sakurakat.systems/hyperv-shenanigans--github-line.png" title="Screenshot of the required file on GitHub with area highlighted in yellow" width="1680"/>

## Build success

I copied the successful build from the nix store to windows.

When I tried to load it as a VM

<img alt="An error occurred while attempting to start the selected virtual machine(s). New Virtual Machine&#39; failed to start. Synthetic SCSI Controller (Instance ID 1666945F-9962-4366-83F3-AA863F98254B): Failed to Power on with Error &#39;The requested operation could not be completed due to a virtual disk system limitation. Virtual hard disk files must be uncompressed and unencrypted and must not be sparse.&#39;. Attachment &#39;D:\build-dir\nixos-image-hyperv-25.05pre-git-x86_64-linux.vhdx&#39; failed to open because of error: &#39;The requested operation could not be completed due to a virtual disk system limitation. Virtual hard disk files must be uncompressed and unencrypted and must not be sparse.&#39;." height="432" src="https://r2.sakurakat.systems/hyperv-shenanigans--compressed-file.png" title="Screenshot of Hyper-V Manager&#39;s error" width="702"/>

Let's read this error,
- VM failed to start
- Something about limitations
- "disk file must be `uncompressed` and `unencrypted` and must not be `sparse`"
    - `uncompressed`: I compress my disks so that's easy enough to solve.
    - `unencrypted`: I don't think this should be a problem? I don't have bitlocker on.
    - `sparse`: I'm not even sure how I'd solve it, maybe the Hyper-V Manager has some tool I can use.

Ok, lets uncompress it first, easy solution, 
`right click file > properties > advanced > uncheck Compress contents to save disk space`

Next error:

<img alt="Virtual Machine Boot Summary 1. SCSI Disk (0,0) The unsigned image&#39;s hash is not allowed (DB) 2. Network Adapter (00155D006403) A boot image was not found. No operating system was loaded. Your virtual machine may be configured incorrectly. Exit and re-configure your VM or click restart to retry the current boot sequence again." height="768" src="https://r2.sakurakat.systems/hyperv-shenanigans--unsigned-image.png" title="Screenshot of Hyper-V UEFI&#39;s Error" width="1024"/>
- "No operating system was loaded. Your virtual machine may be configured incorrectly. Exit and re-configure your VM or click restart to retry the current boot sequence again."
    - Hm, that doesnt tell a lot, lets read the earlier stuff
- "The `unsigned image's hash` is not allowed (DB)"
    - Oh, I think I know what's wrong, secure boot!

## VM booted successfully

I checked the VHDX file nixos-generators created and saw it was 4gb.

Then, the realization hit, the error I saw in the (Lead Astray)[#lead-astray] section was telling me that the VHDX file was 4gb, and not all the various things I thought it was.
I'm gonna be honest, I forgot what I was yapping about at this point:
<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:rwi65xn77uzhgyewkfbuuziz/app.bsky.feed.post/3llqdomz7ml2g" data-bluesky-cid="bafyreie46uis7vcjglxma73ivutlnxsmbvt3dcdl2ahmpeukz6eourw2zi" data-bluesky-embed-color-mode="system"><p lang="en">i removed the sudo and im back to this error
       error: path &#x27;/nix/store/7a2rzcz3mjaq6ni71nn3zv6v3kxk8zab-nixpkgs/nixpkgs/nixos/modules/virtualisation/disk-size-option.nix&#x27; does not exist</p>&mdash; Kathryn&lt;&#x27;u1f338&gt; (<a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz?ref_src=embed">@sakurakat.systems</a>) <a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz/post/3llqdomz7ml2g?ref_src=embed">April 1, 2025 at 12:53 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

## Struggles with logging in as `ksakura`

<img alt="&lt;&lt;&lt; Welcome to NixOS hyperv-25.05.20250330.52faf48 (x86_64) - tty1 &gt;&gt;&gt; Run &#39;nixos-help&#39; for the NixOS manual. kats-laptop login: ksakura Password: &lt;REDACTED&gt; Login incorrect kats-laptop login: ksakura Password: &lt;REDACTED&gt; Login incorrect kats-laptop login:" height="768" src="https://r2.sakurakat.systems/hyperv-shenanigans--no-user-password.png" title="Screenshot of TTY1 where I tried to log in" width="1024"/>

One of the memes about NixOS is that, everything is declarative, except the installation process.

<img alt="Extracted text: YOU&#39;VE USED IMPERATIVE ACTIONS DURING SYSTEM DEPLOYMENT SYSADMIN CONFISCATES YOUR NIX-CHAN -999,999,999 DERIVATIONS. Explaination: Nix aims for perfect reproducibility, using imperative action means the change was not recorded in the config file, and thus, you broke the rule of perfect reproducibility, making it an impure flake" src="https://r2.sakurakat.systems/hyperv-shenanigans--nix-chan.png" title="Meme about you using imperative action while deploying the system" width="1922" height="1440"/>
(src: https://youtu.be/nLwbNhSxLd4?list=TLPQMTQwNDIwMjVqtjGiwPFIvg&t=759)\
This is documented on [mynixos.com](https://mynixos.com/nixpkgs/option/users.users.%3Cname%3E.initialPassword#:~:text=If%20none%20of%20the%20password%20options%20are%20set%2C%20then%20no%20password%20is%20assigned%20to%20the%20user%2C%20and%20the%20user%20will%20not%20be%20able%20to%20do%20password%2Dbased%20logins),\
"If none of the password options are set, then no password is assigned to the user, and the user will not be able to do password-based logins."\
And the fix is also on [mynixos.org](https://mynixos.com/nixpkgs/option/users.users.%3Cname%3E.hashedPassword)\
"To generate a hashed password run mkpasswd."

## Successfully logged in

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:rwi65xn77uzhgyewkfbuuziz/app.bsky.feed.post/3llqitkdpyn2g" data-bluesky-cid="bafyreidiqtyoespfqdxfvapnwmw75cvmayqi3snlqtm6xzx6o2axqeycee" data-bluesky-embed-color-mode="system"><p lang="en">HELL YEAH<br><br><a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz/post/3llqitkdpyn2g?ref_src=embed">[image or embed]</a></p>&mdash; Kathryn&lt;&#x27;u1f338&gt; (<a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz?ref_src=embed">@sakurakat.systems</a>) <a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz/post/3llqitkdpyn2g?ref_src=embed">April 1, 2025 at 2:25 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

## Removing the errors

I had errors in `nushell`, and `Hyprland` because the config files were for the older version of the programs.
See, one of the debugging steps I did was to run `nix flake update`,
which pulled down the latest version of `nixpkgs`, 
and thus, updated the packages.
I "just" have to replace the current flake lock file in the VM with the one from my laptop.

## No config files

<img alt="The user ran `ls /etc/nixos`, where the config files are supposed to exist, however, the output shows that the directory is empty" src="https://r2.sakurakat.systems/hyperv-shenanigans--no-config-files.png" title="Screenshot of TTY1 which shows that the config files for nixos don&#39;t exist" width="1024" height="768"/>
```
> ls /etc/nixos/
Empty List
```

huh, thats concerning.
I guess I didn't run the installer, so the config files weren't generated.

### Solution
1. run `nixos-generate-config`
2. clone my laptop's config
3. replace `hardware-configuration.nix` from my laptop with the one \[Step 1\] generated
4. `sudo nixos-rebuild test --flake .`

### Problems again

<img alt="The user tried to rebuild NixOS but while building a specific package, the proccess tried to use more memory than what was allocated to it, thus ending up in an out of memory situation." height="768" src="https://r2.sakurakat.systems/hyperv-shenanigans--oom.png" title="Screenshot of TTY1 showing the process tried to use more memory than what exists" width="1024"/>

- "building `determinate-nix`-util-3.2.1"
    - Problems with determinate nix? 
- "`Out of memory`: Killed process 1316 (nix)"
    - Out of ram...? that shouldn't be the case

Let's just remove determinate nix for now

<img alt="Due to the immutable nature of the nix packaging system, it uses quite a bit of space. Usually you&#39;d just garbage collect to recover space but in this case it was easier to resize the vm&#39;s harddrive" height="768" src="https://r2.sakurakat.systems/hyperv-shenanigans--no-disk-space.png" title="Screenshot of TTY1 showing the VM is out of disk space" width="1024"/>

- "mkdir: cannot create directory '<omit>': `No space left on device`"
    - Oh, ok, lets run `df -h`

`df -h` reports 100% used on `/`

Easy, just increase the disk space
`file > settings > hard drive > edit > expand disk`

<img alt="What size do you want to make the virtual hard disk? Current size is 40 GB. New size: 40 GB (Maximum: 64 TB) Out of Bounds Specify a number between 41 and 65536." height="839" src="https://r2.sakurakat.systems/hyperv-shenanigans--resize-vhdx.png" title="Screenshot of the setting which is required to resize the virtual hard disk" width="1550"/>
:::note
ignore the error for `Out of Bounds`
I took the screenshot after resizing and checking if it works
:::

## Final stretch

reboot the vm\
`sudo nixos-rebuild test --flake .`

<img alt="Screenshot of Nushell running in kitty terminal. The text size in terminal is very large, and the cursor is glitching and leaving trails." height="768" src="https://r2.sakurakat.systems/hyperv-shenanigans--success.png" title="Screenshot of Hyprland running in the VM" width="1024"/>

Success!

The glitchiness is from Hyperland not liking to be ran under a VM.

restart the vm theres more generations!

<img alt="NixOS (Generation 2 NixOS Warbler 25.05.20250129.9d3ae80 (Linux 6.12.11), bu&lt;cut off&gt;     NixOS (Generation 1 NixOS Warbler hyperv-25.05.20250330.52faf48 (Linux 6.12.&lt;cut off&gt; Reboot Into Firmware Interface" height="768" src="https://r2.sakurakat.systems/hyperv-shenanigans--bootloader.png" title="Screenshot of the bootloader of the VM" width="1024"/>

Now, bring back determinate nix, and it builds successfully!

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:rwi65xn77uzhgyewkfbuuziz/app.bsky.feed.post/3lmmdyfqgrd22" data-bluesky-cid="bafyreiff52642twa3lzzxfh3su4fxrcgbo25arhqjs4h4d5vh66thf4whe" data-bluesky-embed-color-mode="system"><p lang="en">determinate-nix says hello 🐱<br><br><a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz/post/3lmmdyfqgrd22?ref_src=embed">[image or embed]</a></p>&mdash; Kathryn&lt;&#x27;u1f338&gt; (<a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz?ref_src=embed">@sakurakat.systems</a>) <a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz/post/3lmmdyfqgrd22?ref_src=embed">April 12, 2025 at 4:13 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

# The End (for now)

I now have a working VM where I can experiment.

But was it worth it? Not really.\
Do I regret going through all this effort? Not at all.

I actually tried
to rice my laptop when I had nothing else I wanted to do.
But, it just didn't feel worth it.
It takes so much time, while I don't like using Hyprland due to the author,
it's just not worth it to switch to niri, atleast for me.

I do eventually want to update to newer packages
but that's a thing for later.
I can also use the vm to modularize my config.  

---

- Link to the first skeet:
    - https://bsky.app/profile/sakurakat.systems/post/3llnz5asyms2c
- Read the thread on Skywriter.blue:
    - https://skywriter.blue/pages/did:plc:rwi65xn77uzhgyewkfbuuziz/post/3llnz5asyms2c

