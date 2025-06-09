---
title: Why Rust?
description: "todo!()"
tags: []
category: Programming
---
another month, another blog post
this time it's something very close to my heart. The programming language I use to express myself : Rust! a lot of you know I love rust, some of you heard about how the industry is adopting rust, but there's a huge enough chunk of people that don't understand why people like rust so much


# Why Rust

People advertise Rust because (so far)
it's the only language that's memory safe,
doesn't have a garbage collector,
and has performance comparable to C
(or as [No Boilerplate](https://noboilerplate.org/) put it, ["Fast, Reliable, Productive,
pick THREE"](https://youtu.be/Z3xPIYHKSoI?list=PLZaoyhMXgBzoM9bfb5pyUOT3zjnaDdSEP&t=68)),
and the industry adoption for Rust is increasing.

I don't need to worry about memory safety,
and performance is great.
But, for me, those aren't the only reasons.

Rust reduces the cognitive load for me.
It has great tooling.
The community is inclusive and welcoming.
It takes the best parts of functional programming,
and brings it to the masses.

Coming from Python,
the biggest upgrade for me wasn't the speed.

**It was predictability.**

Exceptions and ambiguous null objects don't exist.
`Result<T, E>`, and `Option<T>` makes it explicit.
Rust also has better defaults.
But why does that matter?

Usually, the easy way is the better way.

If the borrow checker is making something hard,
then it probably means that the way I structured the program is bad.\
Good practices in other languages, mandatory in rust.

**We stand on the shoulders of giants**,\
and we should take advantage of that.
Let's use the advancements people have made in programming.

Let the computer do what it's best at,
and use the limited time and resources we have to fill in the rest.

---

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:cbkjy5n7bk3ax2wplmtjofq2/app.bsky.feed.post/3lozghbg3kk2i" data-bluesky-cid="bafyreiazx4okxrnh5atduouc5hfisoehrq3c5sjrg4v6uz5bkkdhbh23ma" data-bluesky-embed-color-mode="system"><p lang="en">Rust has a lot of pros and cons, and I get that it isn&#x27;t for everyone. I sure do @smokesignal.events being a single 48.7MB container for both the app and utilities though. #atprotocol #atdev</p>&mdash; Nick Gerakines (<a href="https://bsky.app/profile/did:plc:cbkjy5n7bk3ax2wplmtjofq2?ref_src=embed">@ngerakines.me</a>) <a href="https://bsky.app/profile/did:plc:cbkjy5n7bk3ax2wplmtjofq2/post/3lozghbg3kk2i?ref_src=embed">May 13, 2025 at 7:52 AM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:k644h4rq5bjfzcetgsa6tuby/app.bsky.feed.post/3lozkguapuk2g" data-bluesky-cid="bafyreic3nwj7bbzy6hw7j6ltxpfaad5uwvhu6iorqukjlrnjoandzustl4" data-bluesky-embed-color-mode="system"><p lang="en">love to write small and fast programs (mostly) by default<br><br><a href="https://bsky.app/profile/did:plc:k644h4rq5bjfzcetgsa6tuby/post/3lozkguapuk2g?ref_src=embed">[image or embed]</a></p>&mdash; natalie (<a href="https://bsky.app/profile/did:plc:k644h4rq5bjfzcetgsa6tuby?ref_src=embed">@natalie.sh</a>) <a href="https://bsky.app/profile/did:plc:k644h4rq5bjfzcetgsa6tuby/post/3lozkguapuk2g?ref_src=embed">May 13, 2025 at 9:03 AM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

---

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:denuvqodvvnzxtuitumle4vs/app.bsky.feed.post/3loirmuk6is2q" data-bluesky-cid="bafyreih6574owizr2m3rsyi2phb2fvg3x2j7ohkp7j6bnnx53dqc5dfh44" data-bluesky-embed-color-mode="system"><p lang="en">please do not attempt to fight the collections (you will lose)</p>&mdash; The Museum of English Rural Life (<a href="https://bsky.app/profile/did:plc:denuvqodvvnzxtuitumle4vs?ref_src=embed">@themerl.bsky.social</a>) <a href="https://bsky.app/profile/did:plc:denuvqodvvnzxtuitumle4vs/post/3loirmuk6is2q?ref_src=embed">May 6, 2025 at 4:57 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:rqm4qgf6jdmb35mxatuzi6cq/app.bsky.feed.post/3loj3l3nvak2n" data-bluesky-cid="bafyreihhnxd7lielz7ezwh3aqzw6hel3v4cvkbl7ynac6phc73fxwbjf2u" data-bluesky-embed-color-mode="system"><p lang="en">Rust&#x27;s approach of continually improving built-in stdlib data structures<br><br><a href="https://bsky.app/profile/did:plc:rqm4qgf6jdmb35mxatuzi6cq/post/3loj3l3nvak2n?ref_src=embed">[image or embed]</a></p>&mdash; James Munns (<a href="https://bsky.app/profile/did:plc:rqm4qgf6jdmb35mxatuzi6cq?ref_src=embed">@jamesmunns.com</a>) <a href="https://bsky.app/profile/did:plc:rqm4qgf6jdmb35mxatuzi6cq/post/3loj3l3nvak2n?ref_src=embed">May 6, 2025 at 7:55 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:rqm4qgf6jdmb35mxatuzi6cq/app.bsky.feed.post/3loj4hyzjj22n" data-bluesky-cid="bafyreigtz73thusmo3b4pwrphcww5nmvxs65f5y3tlfskodvtdph66pcca" data-bluesky-embed-color-mode="system"><p lang="en">joke explainer/well actually:

Practically, external crates DO beat the std collections pretty regularly, for a while. However whenever practical, the stdlib will adopt the same techniques used to beat it, meaning that picking `std::collections` is usually a pretty smart choice over a long timescale</p>&mdash; James Munns (<a href="https://bsky.app/profile/did:plc:rqm4qgf6jdmb35mxatuzi6cq?ref_src=embed">@jamesmunns.com</a>) <a href="https://bsky.app/profile/did:plc:rqm4qgf6jdmb35mxatuzi6cq/post/3loj4hyzjj22n?ref_src=embed">May 6, 2025 at 8:11 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:rwi65xn77uzhgyewkfbuuziz/app.bsky.feed.post/3loj5qfchhc2a" data-bluesky-cid="bafyreif3itwfz2bwul5rpgh7p6gtmz3kqxa3sqrc4htb3iimgodekuncze" data-bluesky-embed-color-mode="system"><p lang="en">i still feel like &quot;better defaults&quot; should be in rust&#x27;s sales pitch somewhere</p>&mdash; Kathryn&lt;&#x27;u1f338&gt; (<a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz?ref_src=embed">@sakurakat.systems</a>) <a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz/post/3loj5qfchhc2a?ref_src=embed">May 6, 2025 at 8:33 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

---

https://www.collabora.com/news-and-blog/blog/2025/05/06/matt-godbolt-sold-me-on-rust-by-showing-me-c-plus-plus/

Matt Godbolt, of Compiler Explorer fame, is awesome and you should scour the web for every single bit of content he puts out. That is exactly what I was doing when I watched Correct by Construction: APIs That Are Easy to Use and Hard to Misuse. After 20+ years of working with C/C++, this theme resonates a lot with me.

While watching the talk I kept thinking "Yes! And that's why Rust does it that way." I came out at the end thinking that this talk was actually a great way of getting the intuition for how Rust helps you beyond the whole memory safety thing, and that is what this article intends to show.

---

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:4e5r66uzwealg3tbidn44qcp/app.bsky.feed.post/3loxx4m5ge22s" data-bluesky-cid="bafyreibibw6kncmhhu6xppdiqbinr4orqtsk37bd5mlbclbvkyf6flsfma" data-bluesky-embed-color-mode="system"><p lang="en">using rust has made me care too much about stack vs heap, and indirection cost

I cry every time I can&#x27;t declare a const array or const struct in C# :(</p>&mdash; monaco (<a href="https://bsky.app/profile/did:plc:4e5r66uzwealg3tbidn44qcp?ref_src=embed">@blandsoft.net</a>) <a href="https://bsky.app/profile/did:plc:4e5r66uzwealg3tbidn44qcp/post/3loxx4m5ge22s?ref_src=embed">May 12, 2025 at 5:45 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:4e5r66uzwealg3tbidn44qcp/app.bsky.feed.post/3loxx5wrloc2s" data-bluesky-cid="bafyreiarksiftgrdx7qilifwbfiph4rf3isi3x6h33bdstivm74qskk2im" data-bluesky-embed-color-mode="system"><p lang="en">they should let me have a 32GB stack :)</p>&mdash; monaco (<a href="https://bsky.app/profile/did:plc:4e5r66uzwealg3tbidn44qcp?ref_src=embed">@blandsoft.net</a>) <a href="https://bsky.app/profile/did:plc:4e5r66uzwealg3tbidn44qcp/post/3loxx5wrloc2s?ref_src=embed">May 12, 2025 at 5:46 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:4e5r66uzwealg3tbidn44qcp/app.bsky.feed.post/3loy4pyf47k2s" data-bluesky-cid="bafyreihjzo6ryvgklthlnc7omux7s37nr3njndwptfi3byhiqe4qmamiga" data-bluesky-embed-color-mode="system"><p lang="en">I know that C# has value semantics for structs as arguments, but are they truly pass-by-value, or does CLR treat them as references behind the scenes?

please help C# girlies xoxo</p>&mdash; monaco (<a href="https://bsky.app/profile/did:plc:4e5r66uzwealg3tbidn44qcp?ref_src=embed">@blandsoft.net</a>) <a href="https://bsky.app/profile/did:plc:4e5r66uzwealg3tbidn44qcp/post/3loy4pyf47k2s?ref_src=embed">May 12, 2025 at 7:25 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

---

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:r57wr33osex4c325lfjt5jeq/app.bsky.feed.post/3lolw5vqo722z" data-bluesky-cid="bafyreidtjhd3vs2fryhvd6v2vmoz22oozvrerjs5yvagu4h2k5ruxuojne" data-bluesky-embed-color-mode="system"><p lang="en">B . E . V . Y

Rusting Everything...

#rustlang #esp32 #bevy<br><br><a href="https://bsky.app/profile/did:plc:r57wr33osex4c325lfjt5jeq/post/3lolw5vqo722z?ref_src=embed">[image or embed]</a></p>&mdash; AstraKernel 💫 (<a href="https://bsky.app/profile/did:plc:r57wr33osex4c325lfjt5jeq?ref_src=embed">@astrakernel.bsky.social</a>) <a href="https://bsky.app/profile/did:plc:r57wr33osex4c325lfjt5jeq/post/3lolw5vqo722z?ref_src=embed">May 7, 2025 at 10:56 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:r57wr33osex4c325lfjt5jeq/app.bsky.feed.post/3loobqse2m22c" data-bluesky-cid="bafyreicc47jpo3n5olxlg7lxaewpl56lugtwig7dxqnpeguhkawekkh42m" data-bluesky-embed-color-mode="system"><p lang="en">🎮 Breakout Game for ESP32 with OLED Display - Built in Rust Using the Bevy Engine

Thanks to bevy for introducing no_std support

I am not a game dev and this is my first attempt using Bevy(so, I may not have utilised it properly)

github.com/ImplFerris/e...

#rustlang<br><br><a href="https://bsky.app/profile/did:plc:r57wr33osex4c325lfjt5jeq/post/3loobqse2m22c?ref_src=embed">[image or embed]</a></p>&mdash; AstraKernel 💫 (<a href="https://bsky.app/profile/did:plc:r57wr33osex4c325lfjt5jeq?ref_src=embed">@astrakernel.bsky.social</a>) <a href="https://bsky.app/profile/did:plc:r57wr33osex4c325lfjt5jeq/post/3loobqse2m22c?ref_src=embed">May 8, 2025 at 9:29 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

---


<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:3danwc67lo7obz2fmdg6jxcr/app.bsky.feed.post/3lom3vosajs25" data-bluesky-cid="bafyreibzkzb6b7fs6rfo4zou4sjrynonllwea7wofgvp4ucbn2duyb5qwa" data-bluesky-embed-color-mode="system"><p lang="en">&quot;Implement your language twice&quot;

futhark-lang.org/blog/2025-05...<br><br><a href="https://bsky.app/profile/did:plc:3danwc67lo7obz2fmdg6jxcr/post/3lom3vosajs25?ref_src=embed">[image or embed]</a></p>&mdash; Steve Klabnik (<a href="https://bsky.app/profile/did:plc:3danwc67lo7obz2fmdg6jxcr?ref_src=embed">@steveklabnik.com</a>) <a href="https://bsky.app/profile/did:plc:3danwc67lo7obz2fmdg6jxcr/post/3lom3vosajs25?ref_src=embed">May 8, 2025 at 12:39 AM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:rwi65xn77uzhgyewkfbuuziz/app.bsky.feed.post/3lomfwg6bsc2e" data-bluesky-cid="bafyreidvohn77meqfzcp2btzipdr42blnvp5c62tmop6q4iaqgpl5dkla4" data-bluesky-embed-color-mode="system"><p lang="en">futhark is cool. 
rust did the &quot;the compiler should know when to clean up memory&quot; 
and from what I&#x27;ve seen futhark did &quot;the compiler should automatically run things in parallel, it knows the function graph&quot;</p>&mdash; Kathryn&lt;&#x27;u1f338&gt; (<a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz?ref_src=embed">@sakurakat.systems</a>) <a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz/post/3lomfwg6bsc2e?ref_src=embed">May 8, 2025 at 3:38 AM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

---

Communicating in Types • Kris Jenkins • GOTO 2024

Modern type systems have come a long way since C. They’re no longer just about pleasing the compiler. These days they form a sub-language that helps us express ideas about software clearly & succinctly. A true design language.

So let’s take a look at how a modern type system supports talking about software. How it highlights problems, clarifies designs, and supports reuse. Most importantly, see how types can help you talk to your colleagues.

https://www.youtube.com/watch?v=SOz66dcsuT8

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:ervizwwpagfyicu2w55mrbcq/app.bsky.feed.post/3lnn6juga5622" data-bluesky-cid="bafyreiefeeawlaps5zhkunvcplahf6v2r65tphac6yszpevfihobuc5vcq" data-bluesky-embed-color-mode="system"><p lang="">Modern type systems go beyond the compiler—they&#x27;re a design language. Watch @krisajenkins.bsky.social explore how types improve thinking, communication, and collaboration in software.<br><br><a href="https://bsky.app/profile/did:plc:ervizwwpagfyicu2w55mrbcq/post/3lnn6juga5622?ref_src=embed">[image or embed]</a></p>&mdash; GOTO Conferences (<a href="https://bsky.app/profile/did:plc:ervizwwpagfyicu2w55mrbcq?ref_src=embed">@gotocon.com</a>) <a href="https://bsky.app/profile/did:plc:ervizwwpagfyicu2w55mrbcq/post/3lnn6juga5622?ref_src=embed">April 25, 2025 at 5:33 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:rwi65xn77uzhgyewkfbuuziz/app.bsky.feed.post/3lnngbg3ljk2i" data-bluesky-cid="bafyreicvub4r7zsxytgfgdorvvb4t3kholrmvnst7iez3xuqpbln6735oa" data-bluesky-embed-color-mode="system"><p lang="en">fun, covers all the reasons I prefer strongly typed languages.

another benefit is reducing cognitive load, which Kris hinted at but didn&#x27;t explicitly say during the “Describing context” section.</p>&mdash; Kathryn&lt;&#x27;u1f338&gt; (<a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz?ref_src=embed">@sakurakat.systems</a>) <a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz/post/3lnngbg3ljk2i?ref_src=embed">April 25, 2025 at 7:51 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

---

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:762gyjqhdzhlqi4re62po37o/app.bsky.feed.post/3lp3235bthk2k" data-bluesky-cid="bafyreiant77bp7esz2qxlopokv5tf256zaaerjqgn7pvqxmbdel5klvqtm" data-bluesky-embed-color-mode="system"><p lang="en">i really appreciate rust actually doing interesting things with syntax instead of just &quot;yeah we&#x27;ll just copy C verbatim ig&quot;

&quot;everything is an expression&quot; is very cool imo.</p>&mdash; soweli Neko (<a href="https://bsky.app/profile/did:plc:762gyjqhdzhlqi4re62po37o?ref_src=embed">@nekotachi.bsky.social</a>) <a href="https://bsky.app/profile/did:plc:762gyjqhdzhlqi4re62po37o/post/3lp3235bthk2k?ref_src=embed">May 13, 2025 at 11:16 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:dkkwkim76zeobziul5eaxjm6/app.bsky.feed.post/3lp33byqedk2g" data-bluesky-cid="bafyreih547a2ntdym7paiq3utvaonyxnyrm6rspexmziwlvutsqzsvif5y" data-bluesky-embed-color-mode="system"><p lang="en">Rust also feels like it has struck the perfect balance between: a bunch of hyperspecific syntax for things, and defining things &#x27;in-language&#x27;

like how the ? operator isnt out of place despite optionals being actual enums, or PhantomData being a struct and not an annotation on the generic bound.</p>&mdash; sopwithpuppy.bsky.social (<a href="https://bsky.app/profile/did:plc:dkkwkim76zeobziul5eaxjm6?ref_src=embed">@sopwithpuppy.bsky.social</a>) <a href="https://bsky.app/profile/did:plc:dkkwkim76zeobziul5eaxjm6/post/3lp33byqedk2g?ref_src=embed">May 13, 2025 at 11:37 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

---

<blockquote class="mastodon-embed" data-embed-url="https://fosstodon.org/@rustnl/114505776215440277/embed" style="background: #FCF8FF; border-radius: 8px; border: 1px solid #C9C4DA; margin: 0; max-width: 540px; min-width: 270px; overflow: hidden; padding: 0;"> <a href="https://fosstodon.org/@rustnl/114505776215440277" target="_blank" style="align-items: center; color: #1C1A25; display: flex; flex-direction: column; font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Oxygen, Ubuntu, Cantarell, 'Fira Sans', 'Droid Sans', 'Helvetica Neue', Roboto, sans-serif; font-size: 14px; justify-content: center; letter-spacing: 0.25px; line-height: 20px; padding: 24px; text-decoration: none;"> <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="32" height="32" viewBox="0 0 79 75"><path d="M74.7135 16.6043C73.6199 8.54587 66.5351 2.19527 58.1366 0.964691C56.7196 0.756754 51.351 0 38.9148 0H38.822C26.3824 0 23.7135 0.756754 22.2966 0.964691C14.1319 2.16118 6.67571 7.86752 4.86669 16.0214C3.99657 20.0369 3.90371 24.4888 4.06535 28.5726C4.29578 34.4289 4.34049 40.275 4.877 46.1075C5.24791 49.9817 5.89495 53.8251 6.81328 57.6088C8.53288 64.5968 15.4938 70.4122 22.3138 72.7848C29.6155 75.259 37.468 75.6697 44.9919 73.971C45.8196 73.7801 46.6381 73.5586 47.4475 73.3063C49.2737 72.7302 51.4164 72.086 52.9915 70.9542C53.0131 70.9384 53.0308 70.9178 53.0433 70.8942C53.0558 70.8706 53.0628 70.8445 53.0637 70.8179V65.1661C53.0634 65.1412 53.0574 65.1167 53.0462 65.0944C53.035 65.0721 53.0189 65.0525 52.9992 65.0371C52.9794 65.0218 52.9564 65.011 52.9318 65.0056C52.9073 65.0002 52.8819 65.0003 52.8574 65.0059C48.0369 66.1472 43.0971 66.7193 38.141 66.7103C29.6118 66.7103 27.3178 62.6981 26.6609 61.0278C26.1329 59.5842 25.7976 58.0784 25.6636 56.5486C25.6622 56.5229 25.667 56.4973 25.6775 56.4738C25.688 56.4502 25.7039 56.4295 25.724 56.4132C25.7441 56.397 25.7678 56.3856 25.7931 56.3801C25.8185 56.3746 25.8448 56.3751 25.8699 56.3816C30.6101 57.5151 35.4693 58.0873 40.3455 58.086C41.5183 58.086 42.6876 58.086 43.8604 58.0553C48.7647 57.919 53.9339 57.6701 58.7591 56.7361C58.8794 56.7123 58.9998 56.6918 59.103 56.6611C66.7139 55.2124 73.9569 50.665 74.6929 39.1501C74.7204 38.6967 74.7892 34.4016 74.7892 33.9312C74.7926 32.3325 75.3085 22.5901 74.7135 16.6043ZM62.9996 45.3371H54.9966V25.9069C54.9966 21.8163 53.277 19.7302 49.7793 19.7302C45.9343 19.7302 44.0083 22.1981 44.0083 27.0727V37.7082H36.0534V27.0727C36.0534 22.1981 34.124 19.7302 30.279 19.7302C26.8019 19.7302 25.0651 21.8163 25.0617 25.9069V45.3371H17.0656V25.3172C17.0656 21.2266 18.1191 17.9769 20.2262 15.568C22.3998 13.1648 25.2509 11.9308 28.7898 11.9308C32.8859 11.9308 35.9812 13.492 38.0447 16.6111L40.036 19.9245L42.0308 16.6111C44.0943 13.492 47.1896 11.9308 51.2788 11.9308C54.8143 11.9308 57.6654 13.1648 59.8459 15.568C61.9529 17.9746 63.0065 21.2243 63.0065 25.3172L62.9996 45.3371Z" fill="currentColor"/></svg> <div style="color: #787588; margin-top: 16px;">Post by @rustnl@fosstodon.org</div> <div style="font-weight: 500;">View on Mastodon</div> </a> </blockquote> <script data-allowed-prefixes="https://fosstodon.org/" async src="https://fosstodon.org/embed.js"></script>

---

https://medium.com/@gustavokov/constructor-acquires-destructor-releases-e1455b63289c

On this final article based on Matt Godbolt's talk on making APIs easy to use and hard to misuse, I will discuss locking. This is actually an area where C++ has produced some interesting ideas, most notably something called RAII — Resource Acquisition Is Initialization.

Matt doesn't like that acronym very much, so he proposes a new one that I also think is much better: CADR. It tells you everything you need to know: Constructor Acquires, Destructor Releases. That is basically what the RAII pattern does.

"I am sure there are data races here, the compiler is just not telling me where"

---

- rust rewired my brain
- i now get ancious without result and option type
- always feeling like something will go wrong and i dont know where
- writing js/ts feels like im walking in a minefiled
- it can blow up anytime, anywhere
- its not something i should need to remember
- it should just be standard practice
- people might be able to learn where the standard library can fail, but i dont think its feasible to learn it for every library people consume
- it made me think more about long term planning, i need to deal with Option and Result, it made me realize how much better predictability is in the long run compared to short term gains

---

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:rguhy5hekxvubfr5qasd52gy/app.bsky.feed.post/3lpdf2nsexk2m" data-bluesky-cid="bafyreicxeyyddkgrasytrimfrswyfk4uwstpeql5ckpzgyhsv6kpxrggoq" data-bluesky-embed-color-mode="system"><p lang="en">I’ve been on rust since 2017 edition. Compiler error messages were what got me through the borrow checker learning curve and they’ve come crazy far since then. kobzol.github.io/rust/rustc/2...<br><br><a href="https://bsky.app/profile/did:plc:rguhy5hekxvubfr5qasd52gy/post/3lpdf2nsexk2m?ref_src=embed">[image or embed]</a></p>&mdash; Jeremy Blackburn (<a href="https://bsky.app/profile/did:plc:rguhy5hekxvubfr5qasd52gy?ref_src=embed">@mrjimmyblack.com</a>) <a href="https://bsky.app/profile/did:plc:rguhy5hekxvubfr5qasd52gy/post/3lpdf2nsexk2m?ref_src=embed">May 17, 2025 at 6:54 AM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

---

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:mm7qndperhx2oacoo5edf3f2/app.bsky.feed.post/3lpd54o4k5m42" data-bluesky-cid="bafyreidtzz4i7v5ycq3j2klpje4txytvdc6esjxaz6xvpmwjuvnennjuwa" data-bluesky-embed-color-mode="system"><p lang="en">the more i learn rust, the more i want to use it for everything.

i like the errors, i like clippy, i like the language features, but most of all: I like the way it makes you think.

i think “rust is just for systems programming” is more meme than truth.</p>&mdash; mirrorless gamera (<a href="https://bsky.app/profile/did:plc:mm7qndperhx2oacoo5edf3f2?ref_src=embed">@r.bdr.sh</a>) <a href="https://bsky.app/profile/did:plc:mm7qndperhx2oacoo5edf3f2/post/3lpd54o4k5m42?ref_src=embed">May 17, 2025 at 4:35 AM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

---

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:vt464ohreg6sglmnb4cuctmr/app.bsky.feed.post/3lpjrzakouk2g" data-bluesky-cid="bafyreicsyoui7warps3zyaibqv26phzsdba5gnqi37crnuvdvnp7ofikbm" data-bluesky-embed-color-mode="system"><p lang="en">i&#x27;m massively neurodivergent and i love programming in rust! it sparks joy! i have committed untold atrocities with macros!</p>&mdash; oliver (<a href="https://bsky.app/profile/did:plc:vt464ohreg6sglmnb4cuctmr?ref_src=embed">@eikopf.dev</a>) <a href="https://bsky.app/profile/did:plc:vt464ohreg6sglmnb4cuctmr/post/3lpjrzakouk2g?ref_src=embed">May 19, 2025 at 8:01 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

---

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:wamidydbgu3u6fk3yckaglnz/app.bsky.feed.post/3lplvgetxmk25" data-bluesky-cid="bafyreifcqha2uhhaoid3y37odhxvpnmxqbc7zzeogk5gpm5zbekv6blkoy" data-bluesky-embed-color-mode="system"><p lang="en">languages and linters that make unused variables a fatal error: it&#x27;s on sight

once again, the glorious Rust programming language has charted the correct path here in making it a warning that you can make fatal *if you want*</p>&mdash; philpax (<a href="https://bsky.app/profile/did:plc:wamidydbgu3u6fk3yckaglnz?ref_src=embed">@philpax.me</a>) <a href="https://bsky.app/profile/did:plc:wamidydbgu3u6fk3yckaglnz/post/3lplvgetxmk25?ref_src=embed">May 20, 2025 at 4:08 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:7mnpet2pvof2llhpcwattscf/app.bsky.feed.post/3lpmz47d7z22n" data-bluesky-cid="bafyreif4s4hwkct3gxfhzqzx5gjz6ax6fbps5ckpvklpqn4ks2664oelo4" data-bluesky-embed-color-mode="system"><p lang="en">you should enable it though</p>&mdash; 🖤stellz🖤 (<a href="https://bsky.app/profile/did:plc:7mnpet2pvof2llhpcwattscf?ref_src=embed">@piss.beauty</a>) <a href="https://bsky.app/profile/did:plc:7mnpet2pvof2llhpcwattscf/post/3lpmz47d7z22n?ref_src=embed">May 21, 2025 at 2:46 AM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:wamidydbgu3u6fk3yckaglnz/app.bsky.feed.post/3lpmzjn5zdc2t" data-bluesky-cid="bafyreihper5ggu2h53he5g6dljfyuoelituyz6ah2vw6pfc3rlegdnukgq" data-bluesky-embed-color-mode="system"><p lang="en">keep your sick ways away from me (unless they&#x27;re on CI on main, in which case I agree)</p>&mdash; philpax (<a href="https://bsky.app/profile/did:plc:wamidydbgu3u6fk3yckaglnz?ref_src=embed">@philpax.me</a>) <a href="https://bsky.app/profile/did:plc:wamidydbgu3u6fk3yckaglnz/post/3lpmzjn5zdc2t?ref_src=embed">May 21, 2025 at 2:54 AM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:7mnpet2pvof2llhpcwattscf/app.bsky.feed.post/3lpmzlhpz422n" data-bluesky-cid="bafyreiasyfqtf6z3ppwk72z4zkgllbwekgfglhkkg5ovxs7t6b2romfdre" data-bluesky-embed-color-mode="system"><p lang="en">team &quot;every clippy lint is a fatal error&quot;</p>&mdash; 🖤stellz🖤 (<a href="https://bsky.app/profile/did:plc:7mnpet2pvof2llhpcwattscf?ref_src=embed">@piss.beauty</a>) <a href="https://bsky.app/profile/did:plc:7mnpet2pvof2llhpcwattscf/post/3lpmzlhpz422n?ref_src=embed">May 21, 2025 at 2:55 AM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

---

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:klhtmrnregub7we7h6jwiljm/app.bsky.feed.post/3lpormlhwgk2f" data-bluesky-cid="bafyreidmmwz2j4tarll32jllwpe524etlprli6nicf5jgx5u2hopit63zi" data-bluesky-embed-color-mode="system"><p lang="en">bluesky is the place where I help perpetuate stereotypes of trans women being rust programmers and argue with gay men that they have &gt;20% responsibility for Trump, did you look at all that gold leaf, and somehow I am not canceled 

maybe because those are actual jokes, though, I dunno<br><br><a href="https://bsky.app/profile/did:plc:klhtmrnregub7we7h6jwiljm/post/3lpormlhwgk2f?ref_src=embed">[image or embed]</a></p>&mdash; Ed (<a href="https://bsky.app/profile/did:plc:klhtmrnregub7we7h6jwiljm?ref_src=embed">@ed3d.net</a>) <a href="https://bsky.app/profile/did:plc:klhtmrnregub7we7h6jwiljm/post/3lpormlhwgk2f?ref_src=embed">May 21, 2025 at 7:38 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:ouofdzq4ht6oe3vdr4wn6jxg/app.bsky.feed.post/3lporu5ijlc2g" data-bluesky-cid="bafyreib2jha7eybaajelatcckkfqzre2j7m3nzgikcqhfuua3bmbzwcqbe" data-bluesky-embed-color-mode="system"><p lang="en">Jokes aside, trans women really are wildly overrepresented relative to baseline demographics in the rust community and I&#x27;d love to know the backstory behind that.</p>&mdash; Ben Cates (<a href="https://bsky.app/profile/did:plc:ouofdzq4ht6oe3vdr4wn6jxg?ref_src=embed">@bencates.bsky.social</a>) <a href="https://bsky.app/profile/did:plc:ouofdzq4ht6oe3vdr4wn6jxg/post/3lporu5ijlc2g?ref_src=embed">May 21, 2025 at 7:42 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:dgnvlsiinly3i2waxoltdbyl/app.bsky.feed.post/3lpp3s4rjuc2i" data-bluesky-cid="bafyreihhkxmbcsgnwcxix6cy7dmetlk5537335cav3c5w7ruz72sgqmrzu" data-bluesky-embed-color-mode="system"><p lang="en">greater-than-background-rate of disaffected trans nerd programmers primed precisely for a language LIKE Rust to exist + early Rust founder effect doing SOMETHING incredibly right to make trans ppl feel comfortable and welcomed in the community, is my sketch of what happened there</p>&mdash; J. C. Cantwell 🌻 (<a href="https://bsky.app/profile/did:plc:dgnvlsiinly3i2waxoltdbyl?ref_src=embed">@segfaultvicta.bsky.social</a>) <a href="https://bsky.app/profile/did:plc:dgnvlsiinly3i2waxoltdbyl/post/3lpp3s4rjuc2i?ref_src=embed">May 21, 2025 at 10:40 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:dgnvlsiinly3i2waxoltdbyl/app.bsky.feed.post/3lpp3s4vfv22i" data-bluesky-cid="bafyreie3zn4t3rstl65oqufw7f7nutkibty5ixsgqmkhxttyuh7uavvot4" data-bluesky-embed-color-mode="system"><p lang="en">I don&#x27;t know the specific history in detail but I know that must have been what happened, it probably could have been like, Elm or Elixir or something like that but</p>&mdash; J. C. Cantwell 🌻 (<a href="https://bsky.app/profile/did:plc:dgnvlsiinly3i2waxoltdbyl?ref_src=embed">@segfaultvicta.bsky.social</a>) <a href="https://bsky.app/profile/did:plc:dgnvlsiinly3i2waxoltdbyl/post/3lpp3s4vfv22i?ref_src=embed">May 21, 2025 at 10:40 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

---

i get mental damage everytime i hear about a GC language having data races and memory leaks

maybe I'm just too rustpilled but I just feel like the language should know if a variable is being across threads and it should just use atomic counting instead of normal counting

Kathryn<'u1f338>[MEOW]
— 22/05/2025 12:45 PM
i get mental damage everytime i hear about a GC language having race conditions and memory leaks
mlem-chan — 22/05/2025 12:55 PM
race condition is not something prevented with GC
memory leaks, however, are supposed to be, by the virtue of eliminating manual memory management
Kathryn<'u1f338>[MEOW]
— 22/05/2025 12:56 PM
language level construct
mlem-chan — 22/05/2025 12:56 PM
now, I'm referring to "true" memory leaks
Kathryn<'u1f338>[MEOW]
— 22/05/2025 12:56 PM
like how rust has Send + Sync
mlem-chan — 22/05/2025 12:56 PM
a.k.a. "I lost all my handles and can't free it"
Kathryn<'u1f338>[MEOW]
— 22/05/2025 12:57 PM
also if the language is interpreted, shouldnt it have all the knowledge required to detect if something is crossing thread boundary?
mlem-chan — 22/05/2025 12:57 PM
communities of GC'd languages usually call "I kept the handle to a large object for way too long" a memory leak
Kathryn<'u1f338>[MEOW]
— 22/05/2025 12:57 PM
or am i overestimating what the languages know
Kathryn<'u1f338>[MEOW]
— 22/05/2025 12:57 PM
thats fine, thats a skill issue
ive done a leak like that in godot
it could be a warning but i feel like thats too hard to implement
mlem-chan — 22/05/2025 01:00 PM
if the language sandboxes away the thread launching capability, then yes, it is possible to prevent data races
race conditions are more general
Kathryn<'u1f338>[MEOW]
— 22/05/2025 01:01 PM
ah yes, i meant data race
mlem-chan — 22/05/2025 01:01 PM
and there's no easy way to prevent race conditions in general

---

https://bsky.app/profile/sebastianwoehrl.name/post/3lq5apwprbc2m

https://blog.sebastianwoehrl.name/blog/2025-05-rust/

I work with Kubernetes and other cloud-native technologies every day in my job at MaibornWolff. I not only use existing products, I routinely also implement my own tools. Lately I have mostly used Rust as my programming language. In the past my language of choice was Python, and for many things it still is. I have also used Go. But my clear favorite nowadays is Rust. In this article I want to explain why I like Rust and why I think it is a great language. And why I would use it for Kubernetes development, even though most of the cloud-native ecosystem is written in Go.

---

new language should make function call graph and automatically spread the load across cores

---

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:ff4yuuckbzzpuw4guxvuzgpt/app.bsky.feed.post/3lq5xeu2ikk23" data-bluesky-cid="bafyreigtoonol2sryuhqiaq2es32r5dxrc224uyqye6myfcdhxchxw4zni" data-bluesky-embed-color-mode="system"><p lang="en">Rust rewires your brain. What once seemed simple unfolds into elegant, intricate patterns. As you embrace async, lifetimes, and ownership, you begin to see the world as a web of safe, concurrent, and purposeful flows. Problem-solving becomes art. Complexity becomes clarity.</p>&mdash; Ibrahim (<a href="https://bsky.app/profile/did:plc:ff4yuuckbzzpuw4guxvuzgpt?ref_src=embed">@ibrahim0708.bsky.social</a>) <a href="https://bsky.app/profile/did:plc:ff4yuuckbzzpuw4guxvuzgpt/post/3lq5xeu2ikk23?ref_src=embed">May 27, 2025 at 8:31 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

---

https://dl.acm.org/doi/abs/10.1145/3591278

The Rust type system guarantees memory safety and data-race freedom. However, to satisfy Rust's type rules, many familiar implementation patterns must be adapted substantially. These necessary adaptations complicate programming and might hinder language adoption. In this paper, we demonstrate that, in contrast to manual programming, automatic synthesis is not complicated by Rust's type system, but rather benefits in two major ways. First, a Rust synthesizer can get away with significantly simpler specifications. While in more traditional imperative languages, synthesizers often require lengthy annotations in a complex logic to describe the shape of data structures, aliasing, and potential side effects, in Rust, all this information can be inferred from the types, letting the user focus on specifying functional properties using a slight extension of Rust expressions. Second, the Rust type system reduces the search space for synthesis, which improves performance.
In this work, we present the first approach to automatically synthesizing correct-by-construction programs in safe Rust. The key ingredient of our synthesis procedure is Synthetic Ownership Logic, a new program logic for deriving programs that are guaranteed to satisfy both a user-provided functional specification and, importantly, Rust's intricate type system. We implement this logic in a new tool called RusSOL. Our evaluation shows the effectiveness of RusSOL, both in terms of annotation burden and performance, in synthesizing provably correct solutions to common problems faced by new Rust developers.

---

life is already hard and complicated, the complexity rust adds helps reduce the overall complexity

---

https://ianwwagner.com/blog/ownership-benefits-beyond-memory-safety

Rust’s ownership system is well-known for the ways it enforces memory safety guaranteees. For example, you can’t use some value after it’s been freed. Further, it also ensures that mutability is explicit, and it enforces some extra rules that make most data races impossible. But the ownership system has benefits beyond this which don’t get as much press.

[...]

In summary, the borrow checker is a powerful ally, and you can leverage it to make truly better APIs, saving hours of debugging in the future.

---

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:3eqnxy3kk2bwmtcmcl5gt7fv/app.bsky.feed.post/3lqmii3nel22o" data-bluesky-cid="bafyreifldhow7dipvr3bly5b6avo53xer25ihdrlcexibkac57ea2rddfm" data-bluesky-embed-color-mode="system"><p lang="en">i still love how friendly the rust compiler is, dropping hints on how to fix buggy code. Ferris 🦀 really is the bestest &lt;3</p>&mdash; Lani (<a href="https://bsky.app/profile/did:plc:3eqnxy3kk2bwmtcmcl5gt7fv?ref_src=embed">@laniakita.com</a>) <a href="https://bsky.app/profile/did:plc:3eqnxy3kk2bwmtcmcl5gt7fv/post/3lqmii3nel22o?ref_src=embed">June 2, 2025 at 3:14 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

---

https://bsky.app/profile/whitesponge.bsky.social/post/3lpw5hx77vk2k
