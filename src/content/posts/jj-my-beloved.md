---
title: "How Jujutsu VCS helps to lower the barrier to perfect git history"
description: "Keeping a clean Git history is hard, but Jujutsu VCS changes that! Learn more about Jujutsu VCS in this blog post."
published: 2025-05-04
image: https://r2.sakurakat.systems/jj-my-beloved--banner.png
tags:
  - Jujutsu
  - VCS
  - Git
category: Tools
draft: false
---

Working properly with Git is a chore.
I need to make sure the commits are descriptive
(often following [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)),
and the commits need to be atomic.
I used
to spend a non-trivial amount of time and effort
trying to keep my history sensible, and still failed.
While I knew about history editing,
I always thought it was for experts.
Also, when I used `git`, 
I preferred to use JetBrains' IDE features rather than the CLI, 
and even then, I stuck to the basic `add`,
`commit`, `push`, `checkout` commands,
and occasionally `merge` and `rebase`.
[Jujutsu (`jj`)](https://jj-vcs.github.io/) changed that.
`jj` made it easy to fix the usual mistakes I'd make with `git`.
It's different from `git`,
but once they clicked, I couldn't go back.
Also, from what I've been told,
you will also like `jj` more
if you're a fan of [Mercurial](https://www.mercurial-scm.org/).
You don't need to choose between `jj` and `git` either, you can use both!
Learn more here:
[Co-located Jujutsu/Git repos](https://jj-vcs.github.io/jj/latest/git-compatibility/#co-located-jujutsugit-repos). 
That's what I did to learn `jj`.
In this blog post I want to show you the building blocks to use `jj`.

:::caution[ASSUMED AUDIENCE]

Existing `git` users who share the same pain points.

Somebody who loved `hg`, and is unhappy about `git`.

:::

# Minimal workflow

Let's
talk about the standard minimal workflow I used for `git`,
and compare it with `jj`.


| Action                | Git                                                      | Jujutsu                                                |
|-----------------------|----------------------------------------------------------|--------------------------------------------------------|
| Start tracking a file | `git add .`                                              | All files are tracked by default                       |
| Commit the file       | `git commit -m "(hopefully descriptive) commit message"` | `jj commit -m "commit message (easy to change later)"` |
| Push to repo          | `git push`                                               | `jj git push -b "branch-name"`                         |
| Check status          | `git status`                                             | `jj st`                                                |

That's it!
When I first learned about `git`,
those were the only commands I'd use.

Later, I learned about branches.
I had no use for branches
until I had to collaborate with people in college
(college rant[^college-rant]).

[^college-rant]: See, in Indian colleges, the "team" in "team project" is in name only.
Most of the projects are either copied directly from GitHub,
or from a YouTube video.
One person does the "coding"; 
another does the documentation required for the project 
(which is just asking ChatGPT to write the docs), 
and the rest just exist.
The number of people in a class
who actually program are usually in single digits.
If the stolen projects don't run, 
they just go to the classmates who know,
and then make them fix it, 
sometimes in exchange for money.
So, I never really got the chance to do teamwork until last semester of third year, and last year.
I even conducted git and GitHub workshops.
But, I'm bad at explaining, so while I did make the slides, I left the explanation to my peers who were way better at teaching.

# Branches

In `git`, you first create a branch, and then start working on it.
So, I had to be careful of what branch I'm working in.
Digital artists have the problem of "Working on the wrong layer";
I had the problem of "Working on the wrong branch".

`jj` sidesteps the problem, you commit changes, and then assign the branch equivalent (bookmark) to those changes.

More on branches later in [# Working with branches/bookmarks](#working-with-branchesbookmarks)

# Partially committing changes

Part of keeping a good git history is only using atomic commits.
I'd always get distracted and do more than one commit worth of work.
So, I'd want to commit only certain files, and certain sections of the file.
I never found out how to do that using the `git` cli.
I always did it via my IDE.

<div id="ayumis-comment">

:::note

As far as partially committing changes goes, in git you can only stage some and not all files (and only parts of them by using `git add -p` IIRC) or you can use `git gui`.

~ ayumi

:::

</div>

In `jj`, you can split a commit by using `jj split`.
You then select the changes you want to commit in a TUI.

## Working with the `jj split` TUI

### `Down arrow` to move the "cursor" down, and `Up arrow` to move the "cursor" up

### `Right arrow` to expand a section, and `Left arrow` to collapse the section

<img height="1380" src="https://r2.sakurakat.systems/jj-my-beloved--jj-split-tui-1.png" width="2560"/>

In the image above,
I've expanded the changes for `TermErrors.yml` file.

Currently, none of the changes are selected.

Selecting a change adds it to first commit,
and the rest of the changes are in the second commit.

Let's select the first change in `TermsErrors.yml`.

### `spacebar` to select changes

1. Press `Down arrow`
   <img height="1380" src="https://r2.sakurakat.systems/jj-my-beloved--jj-split-tui-2.png" width="2560"/>
2. Press `spacebar`
   <img height="1380" src="https://r2.sakurakat.systems/jj-my-beloved--jj-split-tui-3.png" width="2560"/>

You'll notice there are three selection states:

- `[ ]`: None of the children are selected.
- `[◐]`: Children are partially selected.
- `[●]`: All the children are selected.

### `c` to confirm changes

I use [Helix (`hx`)](https://helix-editor.com) in terminal,
so, the commit messages are edited in `hx`.

<img height="1380" src="https://r2.sakurakat.systems/jj-my-beloved--jj-split-tui-helix.png" width="2560"/>

```jj-commit
JJ: This commit contains the following changes:
JJ:     M .vale-styles\RedHat\TermsErrors.yml
```

Only the changes I selected from `TermsErrors.yml` are in the commit.

Let's check the status

```powershell
jj st
```

<img height="292" src="https://r2.sakurakat.systems/jj-my-beloved--jj-split-tui-jj-st.png" width="749"/>

:::note

I use `jj st` is an alias for `jj status` in the cli.
I use it so often, I instinctively type `st` instead of `status`.

:::

# Reading the status

Let's address the sections one by one.

```diff
  PS D:\Sync\Projects\personal-website-v5> jj st
+ Working copy changes:
  M .vale-styles\RedHat\TermsErrors.yml
  D src\content\posts\draft.md
  A src\content\posts\img.png
  A src\content\posts\img_1.png
  A src\content\posts\img_2.png
  A src\content\posts\img_3.png
  M src\content\posts\jj-my-beloved.md
  Working copy  (@) : omrruoov cb05513b (no description set)
  Parent commit (@-): lwymzvzm 1263aaec feat: reduce vale noise
```

What's a working copy?

`jj` doesn't have a staging area.
It treats the current state of the repo as a commit,
and when you edit the repo,
you're editing the commit.


```diff
  PS D:\Sync\Projects\personal-website-v5> jj st
  Working copy changes:
+ [M] .vale-styles\RedHat\TermsErrors.yml
+ [D] src\content\posts\draft.md
+ [A] src\content\posts\img.png
+ [A] src\content\posts\img_1.png
+ [A] src\content\posts\img_2.png
+ [A] src\content\posts\img_3.png
+ [M] src\content\posts\jj-my-beloved.md
  Working copy  (@) : omrruoov cb05513b (no description set)
  Parent commit (@-): lwymzvzm 1263aaec feat: reduce vale noise
```

You can notice that there are three prefixes for the files.
- `A`: New file that will be added
- `D`: File deleted
- `M`: File modified

```diff
  PS D:\Sync\Projects\personal-website-v5> jj st
  Working copy changes:
  M .vale-styles\RedHat\TermsErrors.yml
  D src\content\posts\draft.md
  A src\content\posts\img.png
  A src\content\posts\img_1.png
  A src\content\posts\img_2.png
  A src\content\posts\img_3.png
  M src\content\posts\jj-my-beloved.md
+ Working copy  ([@]) : omrruoov cb05513b (no description set)
+ Parent commit ([@-]): lwymzvzm 1263aaec feat: reduce vale noise
```

There's also `@` and `@-`.
"What are those?" you might ask.

`@` is the current commit. This is the commit you're editing.

`@-` is the previous commit.

Similarly, `@+` is the next commit.

You can add multiple `+` or `-`.

Another way to think about the number of `-`(or `+`) is
if `@-` is the "father" of the commit, then
`@---` refers to "grand-grandfather" of the commit. 

There's also two of what seem to be hashes.

```diff
- Working copy  (@) : 
+ [omrruoov] [cb05513b] (no description set)
- Parent commit (@-): 
+ [lwymzvzm] [1263aaec] feat: reduce vale noise
```

The first hash on each line 
(`omrruoov` and `lwymzvzm`) are change ID.
These will remain persistent through changes.

:::note

If you're familiar with Mercurial's "revset"
terminology, the change ID is the ID for the revset.

For others, you can think of "revset" as a commit in `git`. 
It's technically wrong, but I can't think of a parallel in `git`.

You already know one revset: "@".

An interesting revset is `root()` which is a virtual commit,
and all the commits are "descendants" of "root()".

So, the first commit in the repo is `root()+`,
and all the commits from `root()` to the current commit `@` can be expressed as
`root()..@`.

Revsets are really cool,
read more about them on the docs here:
https://jj-vcs.github.io/jj/latest/revsets/.

I will be using "revset" from here on where it's appropriate
as it will reduce confusion in the long term.

:::

The second hash on each line 
(`cb05513b` and `1263aaec`) are commit ID.
These will change as you modify the commit.

<img height="56" src="https://r2.sakurakat.systems/jj-my-beloved--read-status-highlight.png" width="459"/>

Entering the full hash is inconvenient,
and unless you have really good memory, 
you can't memorize the hash.
So, `jj` allows you to use the least number of letters from the hash 
that won't cause any collisions,
and highlights them.
In this case `om`, `cb`, `lw`, and `1`.

So, I can use `om` refer to commit with change ID `omrruoov`,
and `lw` for the previous one.

# Working with branches/bookmarks

Bookmarks are what `git` calls branches.

While working in `git`,
the best practice is to work in a separate branch,
and then merge all the changes into the main branch.
But you might've noticed I forgot to create a branch!
If I was using `git`, I would be panicking now.

However, as discussed in [# Branches](#branches), 
I don't need to panic.

Let's create the bookmark

```powershell
jj bookmark create jj-my-beloved -r "@"
```

:::note

I need to wrap the `@` in double quotes as I'm using PowerShell.

From https://jj-vcs.github.io/jj/latest/windows/#typing-in-powershell:
> PowerShell uses @ as part the [array sub-expression operator](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_arrays?view=powershell-7.4#the-array-sub-expression-operator), so it often needs to be escaped or quoted in commands:

:::


The command seems fine till `jj-my-beloved`, 
and then there's `-r "@"`. 
What does that mean?

`-r` is shorthand for `--revision`.
You pass the change ID or revset to it
(tbh I assumed `-r` stood for `revset`).
`jj` will then create a new branch, 
and the latest commit in the branch will be that revset.

`@`, as discussed before, is just shorthand for the current commit.
So,
the command will select the current working commit as the latest commit.

# Pushing changes

Let's try pushing changes to the repo

```powershell
jj git push -b "jj-my-beloved"
```

:::note

Notice that the command is `jj git...` and not just `jj...`

That's because `jj` was built with different backends in mind, 
where backend in this case refers to different VCS.
So, you can add support for multiple VCS to `jj`.
You aren't just limited to `git`.

I would guess that if there are some backend-specific features,
they will have the backend's name in the command
(like `git` here).

:::

<img height="138" src="https://r2.sakurakat.systems/jj-my-beloved--jj-git-push.png" width="1103"/>

Here, we run into one of the many safeguards `jj` has.

In this case, the branch `jj-my-beloved` doesn't exist in `origin`.

To allow `jj` to create a new branch you need
to pass the `-N`/`--allow-new` flag.

So,

```powershell
jj git push -b "jj-my-beloved" -N
```

:::warning

HARSH TRANSITION

:::

I like to commit all my changes at the end of day.

:::note

Or you know,

<img height="715" src="https://r2.sakurakat.systems/jj-my-beloved--in-case-of-fire.png" width="1024"/>

:::

If I'm using `git`,
I can't just use the usual command of `git commit`.
I would need
to take aside time to ensure my git history is "good enough".
But with `jj`,
I can do `jj commit` and end my work any time,
and then deal with the messy history afterward.


I can just commit everything using the below command,
and then worry about splitting and combining the changes tomorrow.

```powershell
jj commit -m "checkpoint: EOD"
```

:::note

If you didn't notice `-m` is the same flag
you use to add messages using `git`

:::

<img height="119" src="https://r2.sakurakat.systems/jj-my-beloved--EOD.png" width="917"/>

<div id="andrew-eod">

:::note

You can do the same with different branch:

```bash
git checkout -b tmp && git all -A && git commit -m "checkpoint: EOD"
```

or directly on your branch, if it's just yours.
Then just do `git reset HEAD~`.

~ Andrew

:::

</div>

# Squashing changes

You might've noticed,
I'm writing this blog post 
and showing you examples of how I use `jj`
by showing screenshots of the commands I'm using.
So, all the changes since the "EOD" commit haven't been commited.

How can I be sure my changes aren't commited?
Let's check the status.

```powershell
jj st
```

<img height="160" src="https://r2.sakurakat.systems/jj-my-beloved--jj-squash-jj-st.png" width="910"/>

It says `(no description set)`,
which means I haven't described the change in the commit,
but it doesn't say `(empty)`, which means the commit isn't empty. 
You can interpret that
as I have changes that I haven't commited yet. 

In `git` I _think_ I would need to amend the changes.
I never did it using the cli tho, always through my IDE.

In `jj` however, the command is

```powershell
jj squash
```

<img height="104" src="https://r2.sakurakat.systems/jj-my-beloved--jj-squash-actual.png" width="910"/>

Voilà!

# Cleaning yesterday's history mess

Yesterday I used `jj commit`, so all the changes were commited,
so now I'm editing a different commit. 

When I commited, I accidentally commited the temporary images,
and deleted `draft.md`.

Let's revert those mistakes!

As mentioned in [# Reading the status](#reading-the-status),
you can just use the highlighted part of the change ID instead of typing the whole thing.
So, from here-on, I'm going to use the shortened form.

```powershell
jj split yx
```

I want to keep the changes to this file, 
so I need to add the file to first commit, 
and the rest will in the working commit.

I also need to undo deleting `draft.md`,
let's split the current change again, 
this time, `draft.md` will be in first commit.

<img height="220" src="https://r2.sakurakat.systems/jj-my-beloved--jj-split-jj-st.png" width="951"/>

# Reverting commits

There are two ways to undo the mistake in `git` AFAIK,
`git reset` and `git revert`.

`jj` has similar commands.
1. `jj backout -r <revision>`
    - Reverts the commit by creating a commit that cancels out the commit.
    - Reversible.
    - similar to `git revert`
2. `jj abandon -r <revision>`
    - Just, straight up, delete the commit. 
    - Irreversible.
    - similar to `git reset --hard`

In my case, I'd prefer to not touch the file.
Since the "last updated date"
on my posts are taken from the git history.

So, I'm going to use abandon.

```powershell
jj abandon -r pp
```

# Editing history

This is where the power of `jj` comes through the most.

In [# Partially committing changes](#partially-committing-changes), 
I only commited part of the `TermsErrors.yml` file.

Let's fix that.

First I need to find the change ID for the commit.

Let's use 

```powershell
jj log
```

<img height="171" src="https://r2.sakurakat.systems/jj-my-beloved--editing-history-jj-log.png" width="951"/>

The letters I need to enter are "lw"

Let's commit the `TermsErrors.yml` file, so `jj split`.

<img height="162" src="https://r2.sakurakat.systems/jj-my-beloved--editing-history-jj-split.png" width="1381"/>

I need to move the commit into "lw"

```powershell
jj squash --from sx --into lw
```

<img height="351" src="https://r2.sakurakat.systems/jj-my-beloved--editing-history-squash-commit-message.png" width="848"/>

<img height="162" src="https://r2.sakurakat.systems/jj-my-beloved--editing-history-jj-log-after-squash.png" width="957"/>

:::note

In [# Reading the status](#reading-the-status) I said that commit ID changes, and change ID remains the same.

You can see it here!

Notice how earlier,
the commit ID for "lw" was "1", 
and now it's "24".

:::

# Show the changes in commit

Let's see the changes in the revision/change "lw"

```powershell
jj show lw
```

<img height="735" src="https://r2.sakurakat.systems/jj-my-beloved--jj-show-lw.png" width="1175"/>

Oops,
I forgot to remove the duplicated description from the commit message.

Let's edit the commit message.

```powershell
jj describe lw
```

<div id="andrew-describe">

:::note

You can change it with `git commit --amend hash`.
But only first,
the rest through `git rebase -i`.
I assume
`jj` does this behind the scene anyway,
because changing any commit will change the hash of the rest.

~ Andrew

:::

</div>

<img height="217" src="https://r2.sakurakat.systems/jj-my-beloved--jj-describe-lw.png" width="911"/>

Done!

:::note

unlike `git`'s way of doing things, 
`jj describe` can be used any time.

In fact, `jj commit -m "msg"`
is an alias for `jj describe -m "msg"` followed by `jj new`.

:::

# Merging branches

Another common operation is merging branches.

Let's say I want to update the template for my website.
For my setup,
I have "origin" as my fork, 
and "upstream" as the original template.  

Let's fetch the changes from all remotes.

```powershell
jj git fetch --all-remotes
```

Merging changes in `jj` is the same
as creating a new commit with two parents.
To use a different remote for a branch/bookmark,
you need to write it in the form `bookmark@remote`. 

```powershell
jj new "@" "main@upstream"
```

<img height="443" src="https://r2.sakurakat.systems/jj-my-beloved--update-template-conflicts.png" width="1717"/>

Oh, no! So many conflicts!

Fortunately,
conflicts feel easier to solve in `jj` for whatever reason.

# Solving merge conflicts

In `jj`, conflicts are first-class citizens. 
You can just, leave the conflicts as they as are if you need to. 

The recommended way to resolve merge conflicts is
to create a new commit,
resolve the conflicts, and then squash the commit.
This is called the Squash Workflow.
More on that later in [# Squash Workflow](^squash-workflow).

So, `jj new`.

`jj` also has an inbuilt conflict resolver, but I prefer to resolve them in my IDE.

You can use the inbuilt resolver by using 

```powershell
jj resolve
```

OK, now, the template is updated,
I want to remove the images from git history, again ^^;
I need to first change to the "rs" commit, and then split.

```powershell
jj edit rs
jj split
```

Now, I have a problem.

I need to bring the images' commit to latest commit.

Let's think about what I need to do to achieve that.

1. I need to rebase the commits.
2. The change ID for the images' commit is "sw".
3. The change ID for the latest commit is "wm".
4. I need to move the commit so "sw" is before "wm".

```powershell
jj rebase -r sw --insert-before wm
```

So what does the command do?
It moves the revision "sw", 
and insert it before "wm".\
Perfect!

<img height="224" src="https://r2.sakurakat.systems/jj-my-beloved--jj-rebase-results.png" width="1087"/>

Done!

That being said, I need to squash "wm" 
into "sw", and then split again,
as I'm editing the blog post live ^^;
The changes from me writing into this document are in "wm".

No problem, easy enough, just use split!

# Case Study

As you see, even with just a few commands, I can do so much.
Let's
talk about a real world example where editing history came useful.

As I mentioned in [# Reverting commits](#reverting-commits),
I use git history to find the last updated date.

When I released [Hyper-V shenanigans with `nixos-generators`](/posts/hyperv-shenanigans/),
I ran the linter in my IDE and didn't check what files it "touched".

Turns out, it touched all the Markdown files,
and so, the "last updated date" for all my posts became `2025-04-25`.

It took me ~10 minutes to fix the mistake, 
where I spent a lot of time just fumbling commands.

While doing it, one of `jj`'s safeguards activated, 
preventing me from editing a commit that I have already pushed.

<div id="andrew-edited-commits">

:::note

`git` will stop you from pushing edited commits,
but not editing them locally.

~ Andrew

:::

</div>

<img height="219" src="https://r2.sakurakat.systems/jj-my-beloved--immutable-commits-error.png" width="1374"/>

It was an error like the image above.

I bypassed the safeguard by using `--ignore-immutable` flag, 
and then force pushed.

:::note

`jj` has more safeguards like `jj op log`,
`jj undo`.

But I don't know how to use them yet ^^;

:::

# Squash Workflow

The squash workflow is a general good practice.

It goes as follows:
1. Create a new commit (do not edit the commit)
2. Make the required changes
3. Squash the changes into the old commit

`jj` can directly edit the commits, 
so why would you go through all this effort?

This workflow ensures that the previous commit remains as is, 
and if required, you can reset the changes. 
The changes also remain "atomic", 
in the sense that either you fix the problem (by squashing),
or you don't.
You won't be stuck in a middle phase.

# Links to learn more from experts!

1. Official docs
   - https://jj-vcs.github.io/jj/latest/
2. The tutorial I followed by [Steve Klabnik (@steveklabnik.com)](https://bsky.app/profile/did:plc:3danwc67lo7obz2fmdg6jxcr) that initially sold me on at least trying out `jj`
    - https://steveklabnik.github.io/jujutsu-tutorial/
3. An excellent essay by [Chris Krycho (@chriskrycho.com)](https://bsky.app/profile/did:plc:i55fkgcwrczbj7edpucwl5mz) on `jj`
    - https://v5.chriskrycho.com/essays/jj-init/ 
    - It is also available in video form on YouTube:
    [What if version control was AWESOME?](https://youtu.be/2otjrTzRfVk)  
4. An episode of Bits and Booze by [GitButler](https://www.youtube.com/@gitbutlerapp) where they discuss `jj`
    - [Jujutsu | Ep. 5 Bits and Booze](https://www.youtube.com/watch?v=dwyMlLYIrPk)
5. An article recommended by [amos in goblin mode (@fasterthanlime@hachyderm.io)](https://hachyderm.io/@fasterthanlime)
    - https://zerowidth.com/2025/what-ive-learned-from-jj/
    - Source: [`hachyderm.io` post](https://hachyderm.io/@fasterthanlime/114442568865148840)
    - Alternative source: [`bluesky` post](https://bsky.app/profile/fasterthanli.me/post/3loaqqrdfi22o)
6. [Orhun Parmaksız (@orhun.dev)](https://bsky.app/profile/orhun.dev)'s stream VOD
   dedicated to learning Jujutsu on YouTube
   - [Learning Jujutsu (a version control system)](https://www.youtube.com/watch?v=VcKKhrb4E6s) 

---

# Inspiration for writing the blog post

## Amos (also known as fasterthanlime) posting "jj is going to make me worse at git isn't it"

<img height="1028" src="https://r2.sakurakat.systems/jj-my-beloved--amos-jj-reply.png" width="842"/>

[Link to my reply](https://transfem.social/notes/a7agywefhcnb1m03)

[Fediverse Link to Amos' post](https://hachyderm.io/@fasterthanlime/114438567588642818)

[Bluesky Link to Amos' post](https://bsky.app/profile/fasterthanli.me/post/3lo6xvkhtvk27)

If you want to read more about other people's experiences,
you can read them on fediverse, and bluesky.

## A conversation on Typst's discord server

I recognized
the person was using `jj` because of the distinct output for `jj log`,
and started talking about Amos' post, and how `jj` made life easier.

<img height="392" src="https://r2.sakurakat.systems/jj-my-beloved--typst-T-reply.png" width="832"/>

A random person replied to my message asking how Amos' post can be taken in a negative light.

<img height="618" src="https://r2.sakurakat.systems/jj-my-beloved--typst-M-reply.png" width="876"/>

## Misc

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:qfpnj4og54vl56wngdriaxug/app.bsky.feed.post/3lotgdvwv322c" data-bluesky-cid="bafyreifjo5hggla7fahujjmf4amovgutxa7ejg7ufx7uvi6u5fw6yjy66y" data-bluesky-embed-color-mode="system"><p lang="en">jeez i had a variety of hacks in place to manage simultaeneous streams of work with git (branches, stashes, worktrees).

... and jj just has one tool: jj new. fewer concepts but so much more powerful.</p>&mdash; akshay (<a href="https://bsky.app/profile/did:plc:qfpnj4og54vl56wngdriaxug?ref_src=embed">@oppi.li</a>) <a href="https://bsky.app/profile/did:plc:qfpnj4og54vl56wngdriaxug/post/3lotgdvwv322c?ref_src=embed">May 10, 2025 at 10:34 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

---

# Post-writing discussion

I asked ayumi if, after reading the blog post,
she's at least somewhat interested in `jj`.

Her reply:
> Maybe once it's finished--for example nowadays I mainly contribute to Tangara firmware
> and I need Git submodules support for that, which appears to be absent in jj. 
> Some other things like SHA–256 Git repositories also appear not to work. 
> I'm sure that those two things will be implemented eventually. 
> I played with it a little and getting used to the different workflow 
> would probably take some time in my case, 
> though if I were to guess jj would probably be simpler to use for
> people who either didn’t use a VCS before or haven’t got used 
> (or can’t get used) to Git yet.

Garnet chimed in
and said that she uses `git commit --amend` very often,
and ayumi concurred.

Garnet also commented:
> I like how jj handles commit hashes (as in, allowing you to use the shortened hash)
> but on Git I don't have a much of a problem either because the CLI supports tab completion
> also git has an interactive rebase feature
> `git rebase --interactive`
> it is a little confusing to me sometimes but I take it as a skill issue
> I'm not convinced that it's worth switching to jj but that's just my opinion

ayumi also had a "fun fact" about `jj`
> if you set up commit signing
> and like me have the signature stored on a U2F key it will ask you
> to tap the key every time it sees changes.

By "it sees changes", ayumi meant everytime `jj` is executed.

While trying out `jj`, ayumi noticed a problem,
even three line `jj st` output was shown in the pager.

The solution she found was 
```bash
jj config set --repo ui.pager 'less -F'
```

Another interesting thing,
<blockquote class="mastodon-embed" data-embed-url="https://inuh.net/@evmar/114461788446840271/embed" style="background: #FCF8FF; border-radius: 8px; border: 1px solid #C9C4DA; margin: 0; max-width: 540px; min-width: 270px; overflow: hidden; padding: 0;"> <a href="https://inuh.net/@evmar/114461788446840271" target="_blank" style="align-items: center; color: #1C1A25; display: flex; flex-direction: column; font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Oxygen, Ubuntu, Cantarell, 'Fira Sans', 'Droid Sans', 'Helvetica Neue', Roboto, sans-serif; font-size: 14px; justify-content: center; letter-spacing: 0.25px; line-height: 20px; padding: 24px; text-decoration: none;"> <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="32" height="32" viewBox="0 0 79 75"><path d="M74.7135 16.6043C73.6199 8.54587 66.5351 2.19527 58.1366 0.964691C56.7196 0.756754 51.351 0 38.9148 0H38.822C26.3824 0 23.7135 0.756754 22.2966 0.964691C14.1319 2.16118 6.67571 7.86752 4.86669 16.0214C3.99657 20.0369 3.90371 24.4888 4.06535 28.5726C4.29578 34.4289 4.34049 40.275 4.877 46.1075C5.24791 49.9817 5.89495 53.8251 6.81328 57.6088C8.53288 64.5968 15.4938 70.4122 22.3138 72.7848C29.6155 75.259 37.468 75.6697 44.9919 73.971C45.8196 73.7801 46.6381 73.5586 47.4475 73.3063C49.2737 72.7302 51.4164 72.086 52.9915 70.9542C53.0131 70.9384 53.0308 70.9178 53.0433 70.8942C53.0558 70.8706 53.0628 70.8445 53.0637 70.8179V65.1661C53.0634 65.1412 53.0574 65.1167 53.0462 65.0944C53.035 65.0721 53.0189 65.0525 52.9992 65.0371C52.9794 65.0218 52.9564 65.011 52.9318 65.0056C52.9073 65.0002 52.8819 65.0003 52.8574 65.0059C48.0369 66.1472 43.0971 66.7193 38.141 66.7103C29.6118 66.7103 27.3178 62.6981 26.6609 61.0278C26.1329 59.5842 25.7976 58.0784 25.6636 56.5486C25.6622 56.5229 25.667 56.4973 25.6775 56.4738C25.688 56.4502 25.7039 56.4295 25.724 56.4132C25.7441 56.397 25.7678 56.3856 25.7931 56.3801C25.8185 56.3746 25.8448 56.3751 25.8699 56.3816C30.6101 57.5151 35.4693 58.0873 40.3455 58.086C41.5183 58.086 42.6876 58.086 43.8604 58.0553C48.7647 57.919 53.9339 57.6701 58.7591 56.7361C58.8794 56.7123 58.9998 56.6918 59.103 56.6611C66.7139 55.2124 73.9569 50.665 74.6929 39.1501C74.7204 38.6967 74.7892 34.4016 74.7892 33.9312C74.7926 32.3325 75.3085 22.5901 74.7135 16.6043ZM62.9996 45.3371H54.9966V25.9069C54.9966 21.8163 53.277 19.7302 49.7793 19.7302C45.9343 19.7302 44.0083 22.1981 44.0083 27.0727V37.7082H36.0534V27.0727C36.0534 22.1981 34.124 19.7302 30.279 19.7302C26.8019 19.7302 25.0651 21.8163 25.0617 25.9069V45.3371H17.0656V25.3172C17.0656 21.2266 18.1191 17.9769 20.2262 15.568C22.3998 13.1648 25.2509 11.9308 28.7898 11.9308C32.8859 11.9308 35.9812 13.492 38.0447 16.6111L40.036 19.9245L42.0308 16.6111C44.0943 13.492 47.1896 11.9308 51.2788 11.9308C54.8143 11.9308 57.6654 13.1648 59.8459 15.568C61.9529 17.9746 63.0065 21.2243 63.0065 25.3172L62.9996 45.3371Z" fill="currentColor"/></svg> <div style="color: #787588; margin-top: 16px;">Post by @evmar@inuh.net</div> <div style="font-weight: 500;">View on Mastodon</div> </a> </blockquote> <script data-allowed-prefixes="https://inuh.net/" async src="https://inuh.net/embed.js"></script>


---

# Proofreaders

> Divyesh Patil
> - https://www.linkedin.com/in/divyesh-patil-525808257/

> ayumi (also the comment in [# Partially committing changes](#partially-committing-changes) giving an idea of how to do it in git [ayumi's comment](#ayumis-comment))
> - Opted out of sharing socials

> Andrew (also multiple comments, [1](#andrew-eod), [2](#andrew-describe), [3](#andrew-edited-commits))
> - https://codeberg.org/Andrew15-5

> Garnet
> - Opted out of sharing socials

---

# Updates

## 2025-06-09

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:p3dj242qnnw43v2ctju6hdfy/app.bsky.feed.post/3lqyet4etoc2r" data-bluesky-cid="bafyreibt5tdr747seux667v6ayzlv5b55aflgel3csj4mngtidcexexll4" data-bluesky-embed-color-mode="system"><p lang="en">Thanks I really enjoyed your article! It was the perfect depth for an overview

One question about this note: In fact, jj commit -m &quot;msg&quot; is an alias for jj new followed by jj describe -m &quot;msg&quot;.

Shouldn&#x27;t the order be reversed? First the working changeset is described, then &quot;commited&quot; with jj new?</p>&mdash; tiki.bsky.social (<a href="https://bsky.app/profile/did:plc:p3dj242qnnw43v2ctju6hdfy?ref_src=embed">@tiki.bsky.social</a>) <a href="https://bsky.app/profile/did:plc:p3dj242qnnw43v2ctju6hdfy/post/3lqyet4etoc2r?ref_src=embed">June 7, 2025 at 8:40 AM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

---

# Footnotes
