---
title: "How Jujutsu VCS lowers the barrier to perfect git history"
published: 2025-05-04
tags: []
draft: true
---

Working properly with Git is a chore.
I need to make sure your commits are descriptive,
often following [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).
Another pain point is keeping commits atomic.
That slows me down,
since I need
to make sure the changes
I'm doing,
fit in the commit goal I'm working towards.
I used
to spend a non-trivial amount of time and effort
trying to keep my history sensible, and still failed.
While I knew about history editing,
I always thought it was for experts.
When I used `git`, 
I preferred to use JetBrains' IDE features rather than the CLI.
Even then, I stuck to the basic `add`,
`commit`, `push`, `checkout` commands,
and occasionally `merge` and `rebase`.
[Jujutsu (`jj`)](https://jj-vcs.github.io/)(my history with jj:[^my-history-with-jj]) changed that.
`jj` made it easy to fix the usual mistakes I'd make with `git`.
There are differences from `git`, but they're easy to adapt to.
From what I've been told, you will also like `jj` more if you're a fan of [Mercurial](https://www.mercurial-scm.org/).
You can use both, `git`, and `jj` in the same repo 
(learn more here: [Co-located Jujutsu/Git repos](https://jj-vcs.github.io/jj/latest/git-compatibility/#co-located-jujutsugit-repos)). 
That's what I did to learn `jj`.
Let's learn about the building blocks to use `jj`.

[^my-history-with-jj]: I started hearing about `jj` from
[Steve Klabnik (@steveklabnik.com)](https://bsky.app/profile/steveklabnik.com).
I had known about `jj` for a while before that.
I don't remember when or where I first heard about `jj`,
but I distinctly remember making a mental note about it when
[Orhun Parmaksız (@orhun.dev)](https://bsky.app/profile/orhun.dev),
dedicated a stream to learning Jujutsu
([Learning Jujutsu (a version control system)](https://www.youtube.com/watch?v=VcKKhrb4E6s)).

# Minimal workflow

Let's
talk about the standard minimal workflow I used to do using `git`,
and compare it with `jj`.


| Action                     | Git                                                      | Jujutsu                                                |
|----------------------------|----------------------------------------------------------|--------------------------------------------------------|
| Start tracking a file      | `git add .`                                              | Implicitly tracked by default                          |
| Save the state of the file | `git commit -m "(hopefully descriptive) commit message"` | `jj commit -m "commit message (easy to change later)"` |
| push to repo               | `git push`                                               | `jj git push -b "branch-name"`                         |
| Check status               | `git status`                                             | `jj st`                                                |

That's it,
when I first learned about `git`,
those were the only commands I'd use.

Later on, I learned about branches.
I had no use for branches
until I had to collaborate with people in college(college rant[^college-rant]).

[^college-rant]: See, in Indian colleges, the "team" in "team project" is in name only.
Majority of the projects are either copied directly from GitHub,
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

# Branches

In `git`, you first create a branch, and then start working on it.
So, I had to be careful of what branch I'm working in.
Digital artists have the problem of "Working on the wrong layer";
I had the problem of "Working on the wrong branch".

`jj` sidesteps the problem, you commit changes, and then assign the branch equivalent (bookmark) to those changes.

# Partially committing changes

I never found out how to commit only certain files,
or certain parts of a file.
I always did it via my IDE.

In `jj`, you can split a commit by using `jj split`.
You then select the changes you want to commit in a TUI.

Controls:

## `Down arrow` to move the "cursor" down, and `Up arrow` to move the "cursor" up

## `Right arrow` to expand a section, and `Left arrow` to collapse the section

![img.png](img.png)

In the above image,
I’ve expanded the changes for `TermErrors.yml` file.

Currently, none of the changes are selected.

Selecting a change adds it to first commit,
and the rest of the changes are in the second commit.

## `spacebar` to select changes

Let's select the first change in `TermsErrors.yml`.

1. Press `Down arrow`
    ![img_1.png](img_1.png) 
2. Press `spacebar`
    ![img_2.png](img_2.png)

You'll notice there are three states of "selectedness".

- `[ ]`: None of the children are selected.
- `[◐]`: Children are partially selected.
- `[●]`: All the children are selected.

## `c` to confirm changes

I use [Helix (`hx`)](https://helix-editor.com) in terminal,
so, the commit messages are edited in `hx`.

![img_3.png](img_3.png)

```jj
JJ: This commit contains the following changes:
JJ:     M .vale-styles\RedHat\TermsErrors.yml
```

Only the changes I selected from `TermsErrors.yml` are in the commit.

Let's check the status

```powershell
jj st
```

![img_4.png](img_4.png)

# Reading the status

Let's address the below-highlighted lines first.

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

You can add multiple `+` or `-`

If `@-` is the "father" of the commit, then
`@---` refers to "grand-grandfather" of the commit. 

There's also two of what seem to be hashes.

```diff
- Working copy  (@) : 
+ [omrruoov] [cb05513b] (no description set)
- Parent commit (@-): 
+ [lwymzvzm] [1263aaec] feat: reduce vale noise
```

The first hash (`omrruoov` and `lwymzvzm`) are change ID.
These will remain persistent through changes.

The second hash (`cb05513b` and `1263aaec`) are commit ID.
These will change as you modify the commit.

The CLI also conveniently highlights the minimal hash 
I need to enter to address the commit.

So, `om` for the current commit,
and `lw` for the previous commit.

# Working with branches

Bookmarks are what `git` calls branches.

I forgot to create a branch!
If I was using `git`, I would be panicking now.

As discussed in [# Branches](#branches), I don't need to worry about that.

Let's create the bookmark

```powershell
jj bookmark create jj-my-beloved -r "@"
```

The command seems fine till `jj-my-beloved`, 
and then there's `-r "@"`. 
What does that mean?

`-r` is shorthand for `--revision`.
You pass the change ID to it.
`jj` will then create a new branch, 
and the latest commit in the branch will be the commit with that change ID.

`@`, as discussed before, is just shorthand for the current commit.
So,
the command will select the current working commit as the latest commit.

# Pushing changes

Let's try pushing changes to the repo

```powershell
jj git push -b "jj-my-beloved"
```

![img_5.png](img_5.png)

Here, we run into the many safeguards `jj` has.

In this case, the branch `jj-my-beloved` doesn't exist in `origin`.

To allow `jj` to create a new branch you need
to pass the `-N`/`--allow-new` flag.

:::warning[ALARM]
Oops!
It's dinner time.
Time to wind down for the day! 
:::

Let's just commit everything using the below command.

```powershell
jj commit -m "checkpoint: EOD"
```

![img_6.png](img_6.png)

I can do this now,
and then worry about splitting and combining the changes tomorrow.
Something I would try to not do using `git`.

# Squashing changes

I wrote all the text, and didn't commit it.
I _think_ in `git` I'd need to amend changes.

In `jj` however, the command is
```powershell
jj squash
```
![img_7.png](img_7.png)

Voilà!

# Cleaning yesterday's history mess

Since I used `commit`, I'm now on a different commit.

I also accidentally commited the temporary images,
and deleted `draft.md`.

Let's revert those mistakes!

```powershell
jj split yx
```

I want to keep the changes to this file, 
so I need to add the file to first commit, 
and the rest will in the working commit.

I also need to undo deleting `draft.md`,
let's split the current change again, 
this time, `draft.md` will be in first commit.

![img_8.png](img_8.png)

# Reverting commits

There are two ways to undo the mistake in `git`,
`git reset` and `git revert`.

`jj` also has two ways,
1. `jj backout -r <revision>`
    - Reverts the commit by creating a commit that cancels out the commit
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

In (# Partially committing changes)[#partially-committing-changes], 
I only commited part of the `TermsErrors.yml` file.

Let's fix that.

First I need to find the change ID for the commit.

Let's use 

```powershell
jj log
```

![img_9.png](img_9.png)

The letters I need to enter are "lw"

Let's commit the `TermsErrors.yml` file, so `jj split`.

![img_10.png](img_10.png)

I need to move the commit into "lw"

```powershell
jj squash --from sx --into lw
```
![img_11.png](img_11.png)
![img_12.png](img_12.png)

Notice how earlier,
the commit ID for "lw" was "1", 
and now it's "24".
But, the change ID remained same!

# Show the changes in commit

```powershell
jj show lw
```

![img_13.png](img_13.png)

Oops,
I forgot to remove the duplicated description from the commit message.

Let's edit the commit message.

```powershell
jj describe lw
```

![img_14.png](img_14.png)

Done!

# Merging branches

I want to update the template for my website.

Let's fetch the changes from `upstream`

```powershell
jj git fetch --all-remotes
```

Merging changes in `jj` is the same
as creating a new commit with two parents.

```powershell
jj new "@" "main@upstream"
```


