---
title: Why Rust?
published: 2025-06-09
description: "Rust's v1.0 hit 10 year mark recently so I wanted to write about why I like, and prefer Rust over the other languages I've tried. The fact of the matter is that Rust's memory safety plays a smaller role than you'd expect."
tags: ["Rust", "retrospective"]
category: Programming
---

This blog post is laden with emotions, feelings, and opinions, read
[Rust For Foundational Software | corrode Rust Consulting](https://corrode.dev/blog/foundational-software/)
if you want a more neutral and objective take, and not the kat experience.

:::caution[ASSUMED AUDIENCE]

Anyone who wants to know why I like Rust so much (duh).

Developers curious about why people like Rust so much.

Anyone who's interested about the social aspects of programming language
adoption.

:::

# Why Rust

Let's get the obvious points out first.

People advertise Rust because (so far) it's the only language that's memory
safe, doesn't have a garbage collector, and has performance comparable to C (or
as [No Boilerplate](https://noboilerplate.org/) put it,
["Fast, Reliable, Productive,
pick THREE"](https://youtu.be/Z3xPIYHKSoI?list=PLZaoyhMXgBzoM9bfb5pyUOT3zjnaDdSEP&t=68)).

You don't need to worry about memory safety, and performance is great. People
are noticing the advantages, and the industry adoption for Rust is increasing.

While that's a good hook to get people into starting Rust, those aren't the
reason people stick with Rust.

Performance isn't the only factor that matters for industry adoption (see: all
the applications written in Python, and Electron+JS).

Memory safety doesn't matter that much either (see: Zig, a more ergonomic C with
practically the same footguns as far as I can see to C. Or godforbid Go with all
the concurrency hazards, which is praised for easy to use concurrent features,
AND it decided to bring back null pointers).

IMHO, what ended up making a difference is more social than pragmatic. Rust has
great tooling, the community is inclusive. It takes the best parts of functional
programming, and brings it to the masses.

And, for me, coming from Python, the biggest factor was _predictability_.

# Predictability

So, what do I mean when I say predictability?

The first thing which comes to my mind for explaining is that Rust doesn't have
exceptions or implicitly nullable objects.

Rust has `Result<T, E>` which explicitly signals that "This function can fail in
ways that you might be able to recover from".

There are multiple ways to say "null" which signals a different kind of "null".
The most common being `Option<T>` that signals "This function might, or might
not produce a value" where the `Option::None` is treated as null. Others include
`()` (empty tuple) signalling no return value (like `void` return type in C),
`!` (never returns) signalling the function doesn't return anything, not even
`void`.

Rust makes you explicitly deal with `Result`, and `Option`. You can't ignore
them. You can say you don't care about it, or you know it won't happen by doing
`.unwrap()`, but that's you making a choice. In Go, and C, you can ignore the
result. In JS, and Python, you don't even know if the function can error. Zig
saw the benefit and requires you to declare the function can error, but adding
context for _why_ it failed as a payload requires works.

Just knowing if the function can fail, or not return anything reduces cognitive
load. I know when a function is going to fail, and I can react to it.

Next thing, Rust has `Send`, and `Sync` markers. `Send` signals that the object
can safely be sent to another thread. `Sync` signals that the object can safely
be shared with another thread. I think `Send` is pretty easy to understand, it's
just moving an object from one thread to another. `Sync` on the other hand felt
confusing to me, what does it mean for an object to be shared? "Shared" here
means that even if you send a pointer to the object to another thread, when the
other thread dereferences the pointer, the pointer is still valid, and the data
is in "sync" with what the original thread sees.

For example, take the
[Producer–consumer problem](https://en.wikipedia.org/wiki/Producer%E2%80%93consumer_problem).
In this case, the data we send, well, needs to be marked `Send`. The queue on
the other hand needs to be marked `Send`, and `Sync`. At any time, the data is
owned by one thread only, but the queue needs to be accessed from both, the
consumer, and the producer. The producer will send the data to the queue, and
the consumer will consume the data from the queue. So, it is important that both
see the same data.

Rust also has better defaults, good practices in other languages are enforced in
Rust.

Another thing is the dreaded borrow checker, which deserves its own section.

# Borrow checker

I've always wondered, the compiler has access to my code, it should know when
I'm done with a variable and automatically free it. Most variables are temporary
and limited to the scope anyway. Why can't the compiler "just" see that?

When I first heard about how Rust cleans up memory automatically, I was like
"fucking finally". Then I heard about how it forces you to either have, multiple
readers, or a single writer. If you think about it, it's the same thing
databases enforce internally, so it clicked almost instantaneously for me. I
went, "Oh, that's just like a database, that's cool". So I never got why people
kept complaining about the borrow checker.

Like, you guys can make complex software that I can only dream of making, but
the borrow checker is confusing??? Also, aren't you supposed to follow the
readers xor writer rule anyways??? If the compiler makes sure you follow the
rule, isn't that just a good thing?

Sure, it makes it harder to architect large software compared to when you
implicitly follow certain rules, but I feel like if the borrow checker is making
it difficult then I'm doing something wrong.

How does it tie back to predictability?\
Borrow checker makes it so you know if a function is going to delete a value,
modify a variable, or if it just needs to read it. It also removes the confusion
of "does this function modify the value or does it return a new value".

# Tooling

If you release a new language today, you can't just get away with releasing the
language, and the docs.\
You need to have a good LSP.\
You need to have a good package manager.\
You need to have a good build system.\
You need to have a good formatter.\
You need to have a good linter.\
You need to have a good test framework.\
You need to have a good way to view docs.

Rust tooling is so good, people are copying it and creating tooling for other
ecosystems, like uv for Python.

## Rustup -- The mothership

Rustup is the first thing you need to install to use Rust.

Rustup manages Rust versions, and toolchains. Rustup also helps install all the
other tools.

## Cargo -- Build System, Package Manager, Linter

Cargo is the default build system, package manager, linter for Rust.

It's also the entry point to most of the tools below.

Truly a one-for-all tool.

## Rustfmt -- Formatter

Rustfmt is a tool used to format Rust code according to the community's style
guidelines

## Rustdoc -- Documentation Generator

Rustdoc generates documentation and produces HTML that you can read in a
browser.

## Rust-analyzer -- LSP

Rust-analyzer is the default LSP for Rust.

## Clippy -- More advanced linter

Clippy is an add-on linter that makes your code more idiomatic, and prevents
common mistakes.

The lints it has are more advanced compared to the default lints in Cargo.

## Miri -- Undefined Behavior Sanitizer

Miri checks for undefined behavior in unsafe blocks. So, even unsafe isn't as
unsafe as people make it out to be.

## cargo-bench -- Benchmarks

Compile and execute benchmarks.

# User-created tooling

These are some of the tools developed by the community.

## cargo-semver-check -- SemVer violational linter

Lint your crate API changes for semver violations.

## cargo-tarpaulin -- Code Coverage

Tarpaulin is a code coverage reporting tool for the Cargo build system

## cargo-insta -- Snapshot Testing

Cargo Insta is the companion command line tool to assist with snapshot
reviewing.

## cargo-flamegraph -- Profiler

A Rust-powered flamegraph generator with additional support for Cargo projects!
It can be used to profile anything, not just Rust projects! No perl or pipes
required <3

## cargo-pgo -- PGO optimizations

Cargo subcommand that makes it easier to use PGO and BOLT to optimize Rust
binaries.

## divan -- Benchmark

Fast and simple benchmarking for Rust projects

## cargo-fuzz -- Fuzzer

A cargo subcommand for fuzzing with libFuzzer! Easy to use!

## kani -- Model Checking

The Kani Rust Verifier is a bit-precise model checker for Rust.

Kani is particularly useful for verifying unsafe code blocks in Rust, where the
"unsafe superpowers" are unchecked by the compiler.

## creusot -- Formal Verifier

Creusot is a deductive verifier for Rust code. It verifies your code is safe
from panics, overflows, and assertion failures. By adding annotations you can
take it further and verify your code does the correct thing.

# Choices made for Rust

Rust doesn't just have good tooling.

- It also has great error messages for most common mistakes.
- It has the best features from functional programming languages while still
  being performant, compiling to native code, and feeling like a C-style
  language.
  - [Hindley-Milner Type System](https://en.wikipedia.org/wiki/Hindley%E2%80%93Milner_type_system)
  - Type inference
  - Iterators
  - Immutable variables
  - Expression based
- It strikes a good balance between language features, and additional syntax.
  - Operators like `+` can be implemented for any type by implementing the
    appropriate trait.
  - `Option`, and `Result` are just enums and not a special language construct.

# Community

OK, fine, Rust the language is great.

But the people also need to be good, it won't matter how good the language is if
the environment is toxic.

And I'm happy to say that the community is welcoming and has DEI as one of their
core values. It's hard to spend one day in the Rust ecosystem without running
into queer people.

See:
https://blog.rust-lang.org/2025/02/13/2024-State-Of-Rust-Survey-results/#community

![](https://r2.sakurakat.systems/why-rust--dei.png)

But, again, why does it matter?

There's an interesting phenomenon called
[curb cut effect](https://en.wikipedia.org/wiki/Curb_cut_effect), it's an
accessibility feature which helps everyone so much, people don't even notice
it's an accessibility feature.

IMO, the number of queer people in a community is a good sniff test for
toxicity.

Diversity, equitability, and inclusivity are hard metrics to meet as it's not a
single individual's responsibility. DEI needs to be met as a community wide
effort. It's one thing to have a good product, it's another thing to have a
friendly and inclusive community. Likewise, it takes a monumental amount of
coordination and energy to make sure people feel safe.

It's only political if you think different people are... well... not people.

I focus particularly on queer people as there's a huge correlation between being
queer and being neurodivergent, and neurodivergence is a disability.

You might've noticed I keep using the phrase "cognitive load", why is that?\
Rust strikes a good balance between showing information, being explicit, and
requiring you to have implicit knowledge. That makes it attractive to people who
suffer from cognitive impairment. Rust makes it so you can write it safely while
having very little working memory in your brain.

For people who suffer from cognitive impairment, it enables them to write code;\
for others, it enables them to be more efficient.

Repeat with me.\
Accessibility.\
Helps.\
All.

# Sensible Defaults

Rust also has sensible (and better) defaults, which means most common and best
practices have low barrier.

But why does that matter?

Usually, the easy way is the better way.

Take immutable by default for example. In other languages, immutability is an
add-on state. Which signals that it's idiomatic to have mutable variables, and
that mutability is better.

You don't need to constantly remind yourself to do the better thing, the
compiler reminds you.

Rust rewired my brain, when I need to write JS/TS, I get anxious. It feels like
walking in a minefield. I know something is going to blow-up, I just don't know
where. The computer has access to where the mines are, but it won't tell me
where. It's not something I should remember, that's not a feasible ask.

While it's possible to learn where the mines are in the standard library, it's
not possible to learn it for every library.

**We stand on the shoulders of giants**,\
and we should take advantage of that. Let's use the advancements people have
made in programming.

Let the computer do what it's best at, and use the limited time and resources we
have to fill in the rest.

While dealing with the borrow checker and Option/Result can be annoying, it made
me realize how much better predictability is in the long run. The features that
make it more complex in the short term, helps reduce the overall complexity,
especially in the long term.

I think [corrode](https://corrode.dev/blog/foundational-software/) put it the
best,
"[Rust is a day-2-language](https://corrode.dev/blog/foundational-software/#:~:text=Rust%20is%20a%20day%2D2%2Dlanguage)".

I'm not saying Rust is the perfect language, or Rust has everything I've ever
wanted from a programming language; but it's good enough.

Life is all about trade-offs, and I'm saying that Rust's trade-offs are
acceptable for me.

---

# Proofreaders

> Divyesh Patil
>
> - https://www.linkedin.com/in/divyesh-patil-525808257/

---

# Case Studies

While preparing to write this blog post I collected a bunch of other articles
and I want to "react" to them / recommend them.

## Multiple GCP products are experiencing Service issues (2025-06-12)

https://status.cloud.google.com/incidents/ow5i3PPK96RduMcb1SsW

"Without the appropriate error handling, the null pointer caused the binary to
crash."

lol, lmao

![meme of Garfield saying "You are not immune to nullptr"](https://r2.sakurakat.systems/why-rust--nullptr.png)

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:3ohd5nodgvayjdegkhzayr6q/app.bsky.feed.post/3lrl6qqcry222" data-bluesky-cid="bafyreicafv7clnjaorvumrurpbge3ps4x3f2wr3pczua7no2jnr3ej5ogq" data-bluesky-embed-color-mode="system"><p lang="en">on type safety<br><br><a href="https://bsky.app/profile/did:plc:3ohd5nodgvayjdegkhzayr6q/post/3lrl6qqcry222?ref_src=embed">[image or embed]</a></p>&mdash; Adam Chalmers (<a href="https://bsky.app/profile/did:plc:3ohd5nodgvayjdegkhzayr6q?ref_src=embed">@adamchalmers.com</a>) <a href="https://bsky.app/profile/did:plc:3ohd5nodgvayjdegkhzayr6q/post/3lrl6qqcry222?ref_src=embed">June 14, 2025 at 8:12 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

> Frog put the value in a option. "There," he said. "Now we will not deref any
> more null pointers." "But we can unwrap the option," said Toad. "That is
> true," said Frog.

Yes, but, `.unwrap()` would've raised flags. Also, wrapping the pointer in
`Option` would be a pretty big signal that "hey, you want to be more careful
here". In Golang/C++, you don't even know if the value can be null.

---

## Piccolo - A Stackless Lua Interpreter by kyren (Catherine West)

https://kyju.org/blog/piccolo-a-stackless-lua-interpreter/

[Piccolo](https://github.com/kyren/piccolo) is a lua interpreter in pure, mostly
safe Rust.

Kyren gave up on the VM for four years because she couldn't figure out how to
make it work with the borrow checker.

But, in the end, the architecture she ended up making turned out to have more
features like cancellation, and better concurrency.

So, it just made the VM better, and now there's a reason to use it over other
VMs. It's their "killed feature".

Borrow checker doesn't just prevent memory safety bugs, it also forces you to
design the program in a better way.

---

## Matt Godbolt sold me on Rust (by showing me C++) by Gustavo Noronha

https://www.collabora.com/news-and-blog/blog/2025/05/06/matt-godbolt-sold-me-on-rust-by-showing-me-c-plus-plus/

Gustavo said, and I quote "a well designed language saves you a lot of brain
cycles by not forcing you to think about how to protect your code from the
simplest mistakes."

If that's not reducing the cognitive load then IDK what is.

C++ had decades to learn, but it didn't matter.

From my personal experience, when I was following
[Learn OpenGL](https://learnopengl.com/), I kept shooting myself in the foot
because C++ is supposed to have a feature, but MSVC doesn't support it. I tried
to use smart pointers, but I couldn't use them instead of normal pointers.

Also, it doesn't mesh with the way I learn. Initially when I have to learn
something, I go with spoonfeeding. Once I'm done getting spoonfed, I jump
directly into a project, and then proceed to fuck around and find out. I like to
see what methods are available on a given struct, and read the docs for them.

I couldn't do that with C++. I tried to see what other options I can use for
`glBegin`, and all I saw was macro expansions. Enums being just integers was
also extremely annoying, because I could pass `GL_TRIANGLE_STRIP` to... let's
say... `glGenerateMipmap`.

It felt like the language itself is fragmented.

---

## Ownership Benefits Beyond Memory Safety by Ian Wagner

https://ianwwagner.com/blog/ownership-benefits-beyond-memory-safety

Ian says that it prevents subtle bugs where you don't know if a function will
return a new value or modify the old one.

I feel this the most when I write JS/TS, some functions modify the value, some
functions return new value, others modify the value and returns it again, and
then some modify and return the old value.

He also mentions that traditional functional languages also have the same
benefit, but in their case, everything is cloned because everything is
immutable, so you just aren't given the choice. On the other hand, Rust gives
you the choice, and makes the choice explicit.

I'll directly quote him, "the borrow checker is a powerful ally, and you can
leverage it to make truly better APIs, saving hours of debugging in the future."

---

## Evolution of Rust compiler errors by Kobzol (Jakub Beránek)

https://kobzol.github.io/rust/rustc/2025/05/16/evolution-of-rustc-errors.html

One of the best things about Rust is how good the error messages are.

Here, Jakub shows the evolution of error messages.

To quote the article directly "a lot of effort has to be put into the messages
to make them _really good_."

It's interesting to see how the errors went from

info dump which may or may not contain information -> short description but
still a lot of information -> just useful information with lots of white space
-> colored output to attract your attention to the important detail -> actively
telling you what to do.

---

## Communicating in Types • Kris Jenkins • GOTO 2024 by GOTO Conferences

https://www.youtube.com/watch?v=SOz66dcsuT8

Kris discusses how you can use the type system to encode and enforce rules.

Doing so makes communication easier, it allows your code to be the single source
of truth.

---

## Why you should use Rust by Sebastian Woehrl

https://blog.sebastianwoehrl.name/blog/2025-05-rust/

Sebastian starts by giving context that he works in with cloud native
technologies, and more specifically, Kubernetes. Now, I'd expect someone who
uses Kubernetes to use Golang or Python. And he says that he used to use those,
but nowadays, his favorite is Rust.

He says Python is good enough for IO-bound applications, but dynamic typing
makes things hard.

Golang is good for Kubernetes due to the ecosystem, but existence of `nil`,
checking errors being optional, silent initialization, and duck-typing for
interfaces are a design issue and make "make working with a large or complex
codebase unnecessarily hard".

Then he proceeds to talk about why he thinks Rust is great, and why, even though
Rust's ecosystem for cloud-native isn't that good compared to Golang, he still
prefers it. He also goes over the trade-offs.

I do agree with him that the compile times aren't great, but the trade-offs feel
worth it. See:

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:rwi65xn77uzhgyewkfbuuziz/app.bsky.feed.post/3lqkpq2jmk22s" data-bluesky-cid="bafyreigbbxuqug5a6ihsn6pspavxrhw6nzdly7imlytyjes5ghcdxs2yhm" data-bluesky-embed-color-mode="system"><p lang="en">started working on game #3, spent 1 hour setting up, and then the next 7 hours battling quaternions and bevy, the compilation times are so atrocious JFC

i almost considered starting over in godot</p>&mdash;
Kathryn&lt;&#x27;u1f338&gt;
(<a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz?ref_src=embed">@sakurakat.systems</a>)
<a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz/post/3lqkpq2jmk22s?ref_src=embed">June
1, 2025 at 10:18
PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

---

## Constructor acquires, destructor releases by Gustavo Noronha

https://medium.com/@gustavokov/constructor-acquires-destructor-releases-e1455b63289c

I think just the quote "I am sure there are data races here, the compiler is
just not telling me where" is enough \:P

---

## Leveraging Rust Types for Program Synthesis by Jonáš Fiala (ETH Zurich, Switzerland), Shachar Itzhaky (Technion, Israel), Peter Müller (ETH Zurich, Switzerland) Nadia Polikarpova (University of California at San Diego, USA), Ilya Sergey (National University of Singapore, Singapore)

https://dl.acm.org/doi/abs/10.1145/3591278

The paper goes over their tool which generates code from just type signatures.

If
[Kris Jenkin's talk](#communicating-in-types-kris-jenkins-goto-2024-by-goto-conferences)
intrigued you, you should read this paper.

---

## Codegen your problems away - device-driver toolkit - Dion Dokter by RustNL

https://www.youtube.com/watch?v=xt1vcL5rF1c

I found the "HOLD ON! You can run `cargo run` AND `cargo doc` AND `cargo fmt`
AND `rustup update` And it just works?" slide hilarious, it also highlights how
good the tools are for Rust, especially when it comes to embedded development.
You don't need to install anything different for embedded development, and I
think that's a huge benefit.

---

## We deserve helpful tools - Pietro Albini by RustNL

https://youtu.be/aHjSraYpsLw

Pietro talks about the momentous effort that goes into making sure Rust's error
messages improve over time.

---

## It's Embedded Rust Time - Bart Massey by RustNL

https://www.youtube.com/watch?v=e0T_x7SeNLM

Bart talks about how great the experience is Rust for embedded. It's similar to
[Dior's talk](#codegen-your-problems-away-device-driver-toolkit-dion-dokter-by-rustnl)
but covers it from a professor's point of view, and as someone who was working
in Rust embedded since before Rust Embedded Working Group was a thing.

---

## Rust Could be a Good Beginner Language by SCP-iota (Hazel)

https://scp-iota.github.io/software/2025/06/11/rust-for-beginners.html

Hazel says that one of the biggest problem with learning Rust coming from
another language is that you need to, quote, "Forget Everything You Know", so
it's easier for beginners to learn Rust, since its just like learning any other
language.

---

# Comments on Bluesky

These are just some of the posts I found on Bluesky (and one on Mastodon)

---

## ngerakines.me and natalie.sh on why they like Rust

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:cbkjy5n7bk3ax2wplmtjofq2/app.bsky.feed.post/3lozghbg3kk2i" data-bluesky-cid="bafyreiazx4okxrnh5atduouc5hfisoehrq3c5sjrg4v6uz5bkkdhbh23ma" data-bluesky-embed-color-mode="system"><p lang="en">Rust has a lot of pros and cons, and I get that it isn&#x27;t for everyone. I sure do @smokesignal.events being a single 48.7MB container for both the app and utilities though. #atprotocol #atdev</p>&mdash; Nick Gerakines (<a href="https://bsky.app/profile/did:plc:cbkjy5n7bk3ax2wplmtjofq2?ref_src=embed">@ngerakines.me</a>) <a href="https://bsky.app/profile/did:plc:cbkjy5n7bk3ax2wplmtjofq2/post/3lozghbg3kk2i?ref_src=embed">May 13, 2025 at 7:52 AM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:k644h4rq5bjfzcetgsa6tuby/app.bsky.feed.post/3lozkguapuk2g" data-bluesky-cid="bafyreic3nwj7bbzy6hw7j6ltxpfaad5uwvhu6iorqukjlrnjoandzustl4" data-bluesky-embed-color-mode="system"><p lang="en">love to write small and fast programs (mostly) by default<br><br><a href="https://bsky.app/profile/did:plc:k644h4rq5bjfzcetgsa6tuby/post/3lozkguapuk2g?ref_src=embed">[image or embed]</a></p>&mdash; natalie (<a href="https://bsky.app/profile/did:plc:k644h4rq5bjfzcetgsa6tuby?ref_src=embed">@natalie.sh</a>) <a href="https://bsky.app/profile/did:plc:k644h4rq5bjfzcetgsa6tuby/post/3lozkguapuk2g?ref_src=embed">May 13, 2025 at 9:03 AM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

---

## jamesmunns.com on the ever improving standard library

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:denuvqodvvnzxtuitumle4vs/app.bsky.feed.post/3loirmuk6is2q" data-bluesky-cid="bafyreih6574owizr2m3rsyi2phb2fvg3x2j7ohkp7j6bnnx53dqc5dfh44" data-bluesky-embed-color-mode="system"><p lang="en">please do not attempt to fight the collections (you will lose)</p>&mdash; The Museum of English Rural Life (<a href="https://bsky.app/profile/did:plc:denuvqodvvnzxtuitumle4vs?ref_src=embed">@themerl.bsky.social</a>) <a href="https://bsky.app/profile/did:plc:denuvqodvvnzxtuitumle4vs/post/3loirmuk6is2q?ref_src=embed">May 6, 2025 at 4:57 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:rqm4qgf6jdmb35mxatuzi6cq/app.bsky.feed.post/3loj3l3nvak2n" data-bluesky-cid="bafyreihhnxd7lielz7ezwh3aqzw6hel3v4cvkbl7ynac6phc73fxwbjf2u" data-bluesky-embed-color-mode="system"><p lang="en">Rust&#x27;s approach of continually improving built-in stdlib data structures<br><br><a href="https://bsky.app/profile/did:plc:rqm4qgf6jdmb35mxatuzi6cq/post/3loj3l3nvak2n?ref_src=embed">[image or embed]</a></p>&mdash; James Munns (<a href="https://bsky.app/profile/did:plc:rqm4qgf6jdmb35mxatuzi6cq?ref_src=embed">@jamesmunns.com</a>) <a href="https://bsky.app/profile/did:plc:rqm4qgf6jdmb35mxatuzi6cq/post/3loj3l3nvak2n?ref_src=embed">May 6, 2025 at 7:55 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:rqm4qgf6jdmb35mxatuzi6cq/app.bsky.feed.post/3loj4hyzjj22n" data-bluesky-cid="bafyreigtz73thusmo3b4pwrphcww5nmvxs65f5y3tlfskodvtdph66pcca" data-bluesky-embed-color-mode="system"><p lang="en">joke explainer/well actually:

Practically, external crates DO beat the std collections pretty regularly, for a
while. However whenever practical, the stdlib will adopt the same techniques
used to beat it, meaning that picking `std::collections` is usually a pretty
smart choice over a long timescale</p>&mdash; James Munns
(<a href="https://bsky.app/profile/did:plc:rqm4qgf6jdmb35mxatuzi6cq?ref_src=embed">@jamesmunns.com</a>)
<a href="https://bsky.app/profile/did:plc:rqm4qgf6jdmb35mxatuzi6cq/post/3loj4hyzjj22n?ref_src=embed">May
6, 2025 at 8:11
PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:rwi65xn77uzhgyewkfbuuziz/app.bsky.feed.post/3loj5qfchhc2a" data-bluesky-cid="bafyreif3itwfz2bwul5rpgh7p6gtmz3kqxa3sqrc4htb3iimgodekuncze" data-bluesky-embed-color-mode="system"><p lang="en">i still feel like &quot;better defaults&quot; should be in rust&#x27;s sales pitch somewhere</p>&mdash; Kathryn&lt;&#x27;u1f338&gt; (<a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz?ref_src=embed">@sakurakat.systems</a>) <a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz/post/3loj5qfchhc2a?ref_src=embed">May 6, 2025 at 8:33 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

---

## blandsoft.net on how Rust makes them care about indirection cost now

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:4e5r66uzwealg3tbidn44qcp/app.bsky.feed.post/3loxx4m5ge22s" data-bluesky-cid="bafyreibibw6kncmhhu6xppdiqbinr4orqtsk37bd5mlbclbvkyf6flsfma" data-bluesky-embed-color-mode="system"><p lang="en">using rust has made me care too much about stack vs heap, and indirection cost

I cry every time I can&#x27;t declare a const array or const struct in C#
:(</p>&mdash; monaco
(<a href="https://bsky.app/profile/did:plc:4e5r66uzwealg3tbidn44qcp?ref_src=embed">@blandsoft.net</a>)
<a href="https://bsky.app/profile/did:plc:4e5r66uzwealg3tbidn44qcp/post/3loxx4m5ge22s?ref_src=embed">May
12, 2025 at 5:45
PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:4e5r66uzwealg3tbidn44qcp/app.bsky.feed.post/3loxx5wrloc2s" data-bluesky-cid="bafyreiarksiftgrdx7qilifwbfiph4rf3isi3x6h33bdstivm74qskk2im" data-bluesky-embed-color-mode="system"><p lang="en">they should let me have a 32GB stack :)</p>&mdash; monaco (<a href="https://bsky.app/profile/did:plc:4e5r66uzwealg3tbidn44qcp?ref_src=embed">@blandsoft.net</a>) <a href="https://bsky.app/profile/did:plc:4e5r66uzwealg3tbidn44qcp/post/3loxx5wrloc2s?ref_src=embed">May 12, 2025 at 5:46 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:4e5r66uzwealg3tbidn44qcp/app.bsky.feed.post/3loy4pyf47k2s" data-bluesky-cid="bafyreihjzo6ryvgklthlnc7omux7s37nr3njndwptfi3byhiqe4qmamiga" data-bluesky-embed-color-mode="system"><p lang="en">I know that C# has value semantics for structs as arguments, but are they truly pass-by-value, or does CLR treat them as references behind the scenes?

please help C# girlies xoxo</p>&mdash; monaco
(<a href="https://bsky.app/profile/did:plc:4e5r66uzwealg3tbidn44qcp?ref_src=embed">@blandsoft.net</a>)
<a href="https://bsky.app/profile/did:plc:4e5r66uzwealg3tbidn44qcp/post/3loy4pyf47k2s?ref_src=embed">May
12, 2025 at 7:25
PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

---

## astrakernel.bsky.social showing bevy running on esp32

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:r57wr33osex4c325lfjt5jeq/app.bsky.feed.post/3lolw5vqo722z" data-bluesky-cid="bafyreidtjhd3vs2fryhvd6v2vmoz22oozvrerjs5yvagu4h2k5ruxuojne" data-bluesky-embed-color-mode="system"><p lang="en">B . E . V . Y

Rusting Everything...

#rustlang #esp32
#bevy<br><br><a href="https://bsky.app/profile/did:plc:r57wr33osex4c325lfjt5jeq/post/3lolw5vqo722z?ref_src=embed">[image
or embed]</a></p>&mdash; AstraKernel 💫
(<a href="https://bsky.app/profile/did:plc:r57wr33osex4c325lfjt5jeq?ref_src=embed">@astrakernel.bsky.social</a>)
<a href="https://bsky.app/profile/did:plc:r57wr33osex4c325lfjt5jeq/post/3lolw5vqo722z?ref_src=embed">May
7, 2025 at 10:56
PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:r57wr33osex4c325lfjt5jeq/app.bsky.feed.post/3loobqse2m22c" data-bluesky-cid="bafyreicc47jpo3n5olxlg7lxaewpl56lugtwig7dxqnpeguhkawekkh42m" data-bluesky-embed-color-mode="system"><p lang="en">🎮 Breakout Game for ESP32 with OLED Display - Built in Rust Using the Bevy Engine

Thanks to bevy for introducing no_std support

I am not a game dev and this is my first attempt using Bevy(so, I may not have
utilised it properly)

github.com/ImplFerris/e...

#rustlang<br><br><a href="https://bsky.app/profile/did:plc:r57wr33osex4c325lfjt5jeq/post/3loobqse2m22c?ref_src=embed">[image
or embed]</a></p>&mdash; AstraKernel 💫
(<a href="https://bsky.app/profile/did:plc:r57wr33osex4c325lfjt5jeq?ref_src=embed">@astrakernel.bsky.social</a>)
<a href="https://bsky.app/profile/did:plc:r57wr33osex4c325lfjt5jeq/post/3loobqse2m22c?ref_src=embed">May
8, 2025 at 9:29
PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

---

## gotocon.com showing Kris Jenkin's talk

https://www.youtube.com/watch?v=SOz66dcsuT8

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:ervizwwpagfyicu2w55mrbcq/app.bsky.feed.post/3lnn6juga5622" data-bluesky-cid="bafyreiefeeawlaps5zhkunvcplahf6v2r65tphac6yszpevfihobuc5vcq" data-bluesky-embed-color-mode="system"><p lang="">Modern type systems go beyond the compiler—they&#x27;re a design language. Watch @krisajenkins.bsky.social explore how types improve thinking, communication, and collaboration in software.<br><br><a href="https://bsky.app/profile/did:plc:ervizwwpagfyicu2w55mrbcq/post/3lnn6juga5622?ref_src=embed">[image or embed]</a></p>&mdash; GOTO Conferences (<a href="https://bsky.app/profile/did:plc:ervizwwpagfyicu2w55mrbcq?ref_src=embed">@gotocon.com</a>) <a href="https://bsky.app/profile/did:plc:ervizwwpagfyicu2w55mrbcq/post/3lnn6juga5622?ref_src=embed">April 25, 2025 at 5:33 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:rwi65xn77uzhgyewkfbuuziz/app.bsky.feed.post/3lnngbg3ljk2i" data-bluesky-cid="bafyreicvub4r7zsxytgfgdorvvb4t3kholrmvnst7iez3xuqpbln6735oa" data-bluesky-embed-color-mode="system"><p lang="en">fun, covers all the reasons I prefer strongly typed languages.

another benefit is reducing cognitive load, which Kris hinted at but didn&#x27;t
explicitly say during the “Describing context” section.</p>&mdash;
Kathryn&lt;&#x27;u1f338&gt;
(<a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz?ref_src=embed">@sakurakat.systems</a>)
<a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz/post/3lnngbg3ljk2i?ref_src=embed">April
25, 2025 at 7:51
PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

---

## nekotachi.bsky.com and sopwithpuppy.bsky.social talking about how Rust made good language design decisions

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:762gyjqhdzhlqi4re62po37o/app.bsky.feed.post/3lp3235bthk2k" data-bluesky-cid="bafyreiant77bp7esz2qxlopokv5tf256zaaerjqgn7pvqxmbdel5klvqtm" data-bluesky-embed-color-mode="system"><p lang="en">i really appreciate rust actually doing interesting things with syntax instead of just &quot;yeah we&#x27;ll just copy C verbatim ig&quot;

&quot;everything is an expression&quot; is very cool imo.</p>&mdash; soweli Neko
(<a href="https://bsky.app/profile/did:plc:762gyjqhdzhlqi4re62po37o?ref_src=embed">@nekotachi.bsky.social</a>)
<a href="https://bsky.app/profile/did:plc:762gyjqhdzhlqi4re62po37o/post/3lp3235bthk2k?ref_src=embed">May
13, 2025 at 11:16
PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:dkkwkim76zeobziul5eaxjm6/app.bsky.feed.post/3lp33byqedk2g" data-bluesky-cid="bafyreih547a2ntdym7paiq3utvaonyxnyrm6rspexmziwlvutsqzsvif5y" data-bluesky-embed-color-mode="system"><p lang="en">Rust also feels like it has struck the perfect balance between: a bunch of hyperspecific syntax for things, and defining things &#x27;in-language&#x27;

like how the ? operator isnt out of place despite optionals being actual enums,
or PhantomData being a struct and not an annotation on the generic
bound.</p>&mdash; sopwithpuppy.bsky.social
(<a href="https://bsky.app/profile/did:plc:dkkwkim76zeobziul5eaxjm6?ref_src=embed">@sopwithpuppy.bsky.social</a>)
<a href="https://bsky.app/profile/did:plc:dkkwkim76zeobziul5eaxjm6/post/3lp33byqedk2g?ref_src=embed">May
13, 2025 at 11:37
PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

---

## rustnl on fosstodon.org talking about how Martin Larralde's research was accelerated by SIMD (because it's easier than in C)

https://youtu.be/ZtmrfRMZNps

<blockquote class="mastodon-embed" data-embed-url="https://fosstodon.org/@rustnl/114505776215440277/embed" style="background: #FCF8FF; border-radius: 8px; border: 1px solid #C9C4DA; margin: 0; max-width: 540px; min-width: 270px; overflow: hidden; padding: 0;"> <a href="https://fosstodon.org/@rustnl/114505776215440277" target="_blank" style="align-items: center; color: #1C1A25; display: flex; flex-direction: column; font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Oxygen, Ubuntu, Cantarell, 'Fira Sans', 'Droid Sans', 'Helvetica Neue', Roboto, sans-serif; font-size: 14px; justify-content: center; letter-spacing: 0.25px; line-height: 20px; padding: 24px; text-decoration: none;"> <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="32" height="32" viewBox="0 0 79 75"><path d="M74.7135 16.6043C73.6199 8.54587 66.5351 2.19527 58.1366 0.964691C56.7196 0.756754 51.351 0 38.9148 0H38.822C26.3824 0 23.7135 0.756754 22.2966 0.964691C14.1319 2.16118 6.67571 7.86752 4.86669 16.0214C3.99657 20.0369 3.90371 24.4888 4.06535 28.5726C4.29578 34.4289 4.34049 40.275 4.877 46.1075C5.24791 49.9817 5.89495 53.8251 6.81328 57.6088C8.53288 64.5968 15.4938 70.4122 22.3138 72.7848C29.6155 75.259 37.468 75.6697 44.9919 73.971C45.8196 73.7801 46.6381 73.5586 47.4475 73.3063C49.2737 72.7302 51.4164 72.086 52.9915 70.9542C53.0131 70.9384 53.0308 70.9178 53.0433 70.8942C53.0558 70.8706 53.0628 70.8445 53.0637 70.8179V65.1661C53.0634 65.1412 53.0574 65.1167 53.0462 65.0944C53.035 65.0721 53.0189 65.0525 52.9992 65.0371C52.9794 65.0218 52.9564 65.011 52.9318 65.0056C52.9073 65.0002 52.8819 65.0003 52.8574 65.0059C48.0369 66.1472 43.0971 66.7193 38.141 66.7103C29.6118 66.7103 27.3178 62.6981 26.6609 61.0278C26.1329 59.5842 25.7976 58.0784 25.6636 56.5486C25.6622 56.5229 25.667 56.4973 25.6775 56.4738C25.688 56.4502 25.7039 56.4295 25.724 56.4132C25.7441 56.397 25.7678 56.3856 25.7931 56.3801C25.8185 56.3746 25.8448 56.3751 25.8699 56.3816C30.6101 57.5151 35.4693 58.0873 40.3455 58.086C41.5183 58.086 42.6876 58.086 43.8604 58.0553C48.7647 57.919 53.9339 57.6701 58.7591 56.7361C58.8794 56.7123 58.9998 56.6918 59.103 56.6611C66.7139 55.2124 73.9569 50.665 74.6929 39.1501C74.7204 38.6967 74.7892 34.4016 74.7892 33.9312C74.7926 32.3325 75.3085 22.5901 74.7135 16.6043ZM62.9996 45.3371H54.9966V25.9069C54.9966 21.8163 53.277 19.7302 49.7793 19.7302C45.9343 19.7302 44.0083 22.1981 44.0083 27.0727V37.7082H36.0534V27.0727C36.0534 22.1981 34.124 19.7302 30.279 19.7302C26.8019 19.7302 25.0651 21.8163 25.0617 25.9069V45.3371H17.0656V25.3172C17.0656 21.2266 18.1191 17.9769 20.2262 15.568C22.3998 13.1648 25.2509 11.9308 28.7898 11.9308C32.8859 11.9308 35.9812 13.492 38.0447 16.6111L40.036 19.9245L42.0308 16.6111C44.0943 13.492 47.1896 11.9308 51.2788 11.9308C54.8143 11.9308 57.6654 13.1648 59.8459 15.568C61.9529 17.9746 63.0065 21.2243 63.0065 25.3172L62.9996 45.3371Z" fill="currentColor"/></svg> <div style="color: #787588; margin-top: 16px;">Post by @rustnl@fosstodon.org</div> <div style="font-weight: 500;">View on Mastodon</div> </a> </blockquote> <script data-allowed-prefixes="https://fosstodon.org/" async src="https://fosstodon.org/embed.js"></script>

---

## mrjimmyblack.com on how error messages got them through the borrow checker learning curve

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:rguhy5hekxvubfr5qasd52gy/app.bsky.feed.post/3lpdf2nsexk2m" data-bluesky-cid="bafyreicxeyyddkgrasytrimfrswyfk4uwstpeql5ckpzgyhsv6kpxrggoq" data-bluesky-embed-color-mode="system"><p lang="en">I’ve been on rust since 2017 edition. Compiler error messages were what got me through the borrow checker learning curve and they’ve come crazy far since then. kobzol.github.io/rust/rustc/2...<br><br><a href="https://bsky.app/profile/did:plc:rguhy5hekxvubfr5qasd52gy/post/3lpdf2nsexk2m?ref_src=embed">[image or embed]</a></p>&mdash; Jeremy Blackburn (<a href="https://bsky.app/profile/did:plc:rguhy5hekxvubfr5qasd52gy?ref_src=embed">@mrjimmyblack.com</a>) <a href="https://bsky.app/profile/did:plc:rguhy5hekxvubfr5qasd52gy/post/3lpdf2nsexk2m?ref_src=embed">May 17, 2025 at 6:54 AM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

---

## r.bdr.sh talking about Rust's developer experience

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:mm7qndperhx2oacoo5edf3f2/app.bsky.feed.post/3lpd54o4k5m42" data-bluesky-cid="bafyreidtzz4i7v5ycq3j2klpje4txytvdc6esjxaz6xvpmwjuvnennjuwa" data-bluesky-embed-color-mode="system"><p lang="en">the more i learn rust, the more i want to use it for everything.

i like the errors, i like clippy, i like the language features, but most of all:
I like the way it makes you think.

i think “rust is just for systems programming” is more meme than
truth.</p>&mdash; mirrorless gamera
(<a href="https://bsky.app/profile/did:plc:mm7qndperhx2oacoo5edf3f2?ref_src=embed">@r.bdr.sh</a>)
<a href="https://bsky.app/profile/did:plc:mm7qndperhx2oacoo5edf3f2/post/3lpd54o4k5m42?ref_src=embed">May
17, 2025 at 4:35
AM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

---

## eikopf.dev on them being neurodivergent and loving rust

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:vt464ohreg6sglmnb4cuctmr/app.bsky.feed.post/3lpjrzakouk2g" data-bluesky-cid="bafyreicsyoui7warps3zyaibqv26phzsdba5gnqi37crnuvdvnp7ofikbm" data-bluesky-embed-color-mode="system"><p lang="en">i&#x27;m massively neurodivergent and i love programming in rust! it sparks joy! i have committed untold atrocities with macros!</p>&mdash; oliver (<a href="https://bsky.app/profile/did:plc:vt464ohreg6sglmnb4cuctmr?ref_src=embed">@eikopf.dev</a>) <a href="https://bsky.app/profile/did:plc:vt464ohreg6sglmnb4cuctmr/post/3lpjrzakouk2g?ref_src=embed">May 19, 2025 at 8:01 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

---

## philpax.me on Rust's design decisions and piss.beauty being masochist with clippy

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:wamidydbgu3u6fk3yckaglnz/app.bsky.feed.post/3lplvgetxmk25" data-bluesky-cid="bafyreifcqha2uhhaoid3y37odhxvpnmxqbc7zzeogk5gpm5zbekv6blkoy" data-bluesky-embed-color-mode="system"><p lang="en">languages and linters that make unused variables a fatal error: it&#x27;s on sight

once again, the glorious Rust programming language has charted the correct path
here in making it a warning that you can make fatal _if you want_</p>&mdash;
philpax
(<a href="https://bsky.app/profile/did:plc:wamidydbgu3u6fk3yckaglnz?ref_src=embed">@philpax.me</a>)
<a href="https://bsky.app/profile/did:plc:wamidydbgu3u6fk3yckaglnz/post/3lplvgetxmk25?ref_src=embed">May
20, 2025 at 4:08
PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:7mnpet2pvof2llhpcwattscf/app.bsky.feed.post/3lpmz47d7z22n" data-bluesky-cid="bafyreif4s4hwkct3gxfhzqzx5gjz6ax6fbps5ckpvklpqn4ks2664oelo4" data-bluesky-embed-color-mode="system"><p lang="en">you should enable it though</p>&mdash; 🖤stellz🖤 (<a href="https://bsky.app/profile/did:plc:7mnpet2pvof2llhpcwattscf?ref_src=embed">@piss.beauty</a>) <a href="https://bsky.app/profile/did:plc:7mnpet2pvof2llhpcwattscf/post/3lpmz47d7z22n?ref_src=embed">May 21, 2025 at 2:46 AM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:wamidydbgu3u6fk3yckaglnz/app.bsky.feed.post/3lpmzjn5zdc2t" data-bluesky-cid="bafyreihper5ggu2h53he5g6dljfyuoelituyz6ah2vw6pfc3rlegdnukgq" data-bluesky-embed-color-mode="system"><p lang="en">keep your sick ways away from me (unless they&#x27;re on CI on main, in which case I agree)</p>&mdash; philpax (<a href="https://bsky.app/profile/did:plc:wamidydbgu3u6fk3yckaglnz?ref_src=embed">@philpax.me</a>) <a href="https://bsky.app/profile/did:plc:wamidydbgu3u6fk3yckaglnz/post/3lpmzjn5zdc2t?ref_src=embed">May 21, 2025 at 2:54 AM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:7mnpet2pvof2llhpcwattscf/app.bsky.feed.post/3lpmzlhpz422n" data-bluesky-cid="bafyreiasyfqtf6z3ppwk72z4zkgllbwekgfglhkkg5ovxs7t6b2romfdre" data-bluesky-embed-color-mode="system"><p lang="en">team &quot;every clippy lint is a fatal error&quot;</p>&mdash; 🖤stellz🖤 (<a href="https://bsky.app/profile/did:plc:7mnpet2pvof2llhpcwattscf?ref_src=embed">@piss.beauty</a>) <a href="https://bsky.app/profile/did:plc:7mnpet2pvof2llhpcwattscf/post/3lpmzlhpz422n?ref_src=embed">May 21, 2025 at 2:55 AM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

I do something similar! I have a majority of clippy lints on and find them
helpful rather than overwhelming or useless.

---

## bencates.bsky.social talking about trans women being overrepresented in Rust community and segfaultvicta.bsky.social theorizing why

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:klhtmrnregub7we7h6jwiljm/app.bsky.feed.post/3lpormlhwgk2f" data-bluesky-cid="bafyreidmmwz2j4tarll32jllwpe524etlprli6nicf5jgx5u2hopit63zi" data-bluesky-embed-color-mode="system"><p lang="en">bluesky is the place where I help perpetuate stereotypes of trans women being rust programmers and argue with gay men that they have &gt;20% responsibility for Trump, did you look at all that gold leaf, and somehow I am not canceled

maybe because those are actual jokes, though, I
dunno<br><br><a href="https://bsky.app/profile/did:plc:klhtmrnregub7we7h6jwiljm/post/3lpormlhwgk2f?ref_src=embed">[image
or embed]</a></p>&mdash; Ed
(<a href="https://bsky.app/profile/did:plc:klhtmrnregub7we7h6jwiljm?ref_src=embed">@ed3d.net</a>)
<a href="https://bsky.app/profile/did:plc:klhtmrnregub7we7h6jwiljm/post/3lpormlhwgk2f?ref_src=embed">May
21, 2025 at 7:38
PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:ouofdzq4ht6oe3vdr4wn6jxg/app.bsky.feed.post/3lporu5ijlc2g" data-bluesky-cid="bafyreib2jha7eybaajelatcckkfqzre2j7m3nzgikcqhfuua3bmbzwcqbe" data-bluesky-embed-color-mode="system"><p lang="en">Jokes aside, trans women really are wildly overrepresented relative to baseline demographics in the rust community and I&#x27;d love to know the backstory behind that.</p>&mdash; Ben Cates (<a href="https://bsky.app/profile/did:plc:ouofdzq4ht6oe3vdr4wn6jxg?ref_src=embed">@bencates.bsky.social</a>) <a href="https://bsky.app/profile/did:plc:ouofdzq4ht6oe3vdr4wn6jxg/post/3lporu5ijlc2g?ref_src=embed">May 21, 2025 at 7:42 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:dgnvlsiinly3i2waxoltdbyl/app.bsky.feed.post/3lpp3s4rjuc2i" data-bluesky-cid="bafyreihhkxmbcsgnwcxix6cy7dmetlk5537335cav3c5w7ruz72sgqmrzu" data-bluesky-embed-color-mode="system"><p lang="en">greater-than-background-rate of disaffected trans nerd programmers primed precisely for a language LIKE Rust to exist + early Rust founder effect doing SOMETHING incredibly right to make trans ppl feel comfortable and welcomed in the community, is my sketch of what happened there</p>&mdash; J. C. Cantwell 🌻 (<a href="https://bsky.app/profile/did:plc:dgnvlsiinly3i2waxoltdbyl?ref_src=embed">@segfaultvicta.bsky.social</a>) <a href="https://bsky.app/profile/did:plc:dgnvlsiinly3i2waxoltdbyl/post/3lpp3s4rjuc2i?ref_src=embed">May 21, 2025 at 10:40 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:dgnvlsiinly3i2waxoltdbyl/app.bsky.feed.post/3lpp3s4vfv22i" data-bluesky-cid="bafyreie3zn4t3rstl65oqufw7f7nutkibty5ixsgqmkhxttyuh7uavvot4" data-bluesky-embed-color-mode="system"><p lang="en">I don&#x27;t know the specific history in detail but I know that must have been what happened, it probably could have been like, Elm or Elixir or something like that but</p>&mdash; J. C. Cantwell 🌻 (<a href="https://bsky.app/profile/did:plc:dgnvlsiinly3i2waxoltdbyl?ref_src=embed">@segfaultvicta.bsky.social</a>) <a href="https://bsky.app/profile/did:plc:dgnvlsiinly3i2waxoltdbyl/post/3lpp3s4vfv22i?ref_src=embed">May 21, 2025 at 10:40 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

I have personally experienced how Tim Click makes sure the community is
welcoming and comfortable for everyone.

---

## laniakita.com on how useful the Rust compiler is

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:3eqnxy3kk2bwmtcmcl5gt7fv/app.bsky.feed.post/3lqmii3nel22o" data-bluesky-cid="bafyreifldhow7dipvr3bly5b6avo53xer25ihdrlcexibkac57ea2rddfm" data-bluesky-embed-color-mode="system"><p lang="en">i still love how friendly the rust compiler is, dropping hints on how to fix buggy code. Ferris 🦀 really is the bestest &lt;3</p>&mdash; Lani (<a href="https://bsky.app/profile/did:plc:3eqnxy3kk2bwmtcmcl5gt7fv?ref_src=embed">@laniakita.com</a>) <a href="https://bsky.app/profile/did:plc:3eqnxy3kk2bwmtcmcl5gt7fv/post/3lqmii3nel22o?ref_src=embed">June 2, 2025 at 3:14 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

---

## emily.news replying to steveklabnik.com on how Rust feels more comfortable

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:3danwc67lo7obz2fmdg6jxcr/app.bsky.feed.post/3lreg6xpqqs2f" data-bluesky-cid="bafyreiebflkorcul6zjxd7rbbqxwu5xagoxfwg62yh5ouo2s3z7sdgaxjq" data-bluesky-embed-color-mode="system"><p lang="en">#rustlang Could be a Good Beginner Language

scp-iota.github.io/software/202...<br><br><a href="https://bsky.app/profile/did:plc:3danwc67lo7obz2fmdg6jxcr/post/3lreg6xpqqs2f?ref_src=embed">[image
or embed]</a></p>&mdash; Steve Klabnik
(<a href="https://bsky.app/profile/did:plc:3danwc67lo7obz2fmdg6jxcr?ref_src=embed">@steveklabnik.com</a>)
<a href="https://bsky.app/profile/did:plc:3danwc67lo7obz2fmdg6jxcr/post/3lreg6xpqqs2f?ref_src=embed">June
12, 2025 at 3:37
AM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:u6raddo3hh67enk46yz4fsik/app.bsky.feed.post/3lrehq7s4622w" data-bluesky-cid="bafyreicfvasph7fvhnbvxmgajd6q3gb7tb6lfkjqltzeebi44dgwectpza" data-bluesky-embed-color-mode="system"><p lang="en">okay i have been sincerely thinking this since i first started using any Rust. it feels so much more comfortable to engage with a system where the behaviors and boundaries are more explicit, where the tooling is more deeply integrated and more intelligent.</p>&mdash; E = mily² (<a href="https://bsky.app/profile/did:plc:u6raddo3hh67enk46yz4fsik?ref_src=embed">@emily.news</a>) <a href="https://bsky.app/profile/did:plc:u6raddo3hh67enk46yz4fsik/post/3lrehq7s4622w?ref_src=embed">June 12, 2025 at 4:05 AM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

---

## elias.sh quoting corrode.dev's article

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:4wzxhr2phh76uqpgha6rwddq/app.bsky.feed.post/3lrhok5bdvs2r" data-bluesky-cid="bafyreiehxafvkinxyh3w74tmuti2bvfshemgemjzi7w2txl7fahcksmvoq" data-bluesky-embed-color-mode="system"><p lang="en">&quot;I believe that we should shift the focus away from memory safety (which these languages also have) and instead focus on the explicitness, expressiveness, and ecosystem of Rust that is highly competitive with these languages&quot; corrode.dev/blog/foundat...<br><br><a href="https://bsky.app/profile/did:plc:4wzxhr2phh76uqpgha6rwddq/post/3lrhok5bdvs2r?ref_src=embed">[image or embed]</a></p>&mdash; Elias de oliveira Granja 🦀 (<a href="https://bsky.app/profile/did:plc:4wzxhr2phh76uqpgha6rwddq?ref_src=embed">@elias.sh</a>) <a href="https://bsky.app/profile/did:plc:4wzxhr2phh76uqpgha6rwddq/post/3lrhok5bdvs2r?ref_src=embed">June 13, 2025 at 10:44 AM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

This post was the reason I read the article and found out just how much better
and objective their article is lmao.
