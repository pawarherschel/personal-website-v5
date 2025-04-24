---
title: Hyper-V shenanigans with `nixos-generators`
published: 2025-04-13
description: This blog post covers how I created a Hyper-V VM from my laptop's NixOS Config flake along with some errors and mistakes I made. I went through all this trouble just, so I won't have to start my laptop to rice and edit the config.
image: https://r2.sakurakat.systems/hyperv-shenanigans--banner.jpg
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

:::IMPORTANT

Please wait
for the Bluesky embeds to load to avoid the content shifting while reading.

:::

# Introduction

I wanted to rice my laptop without turning it on.
So, I thought, "Hey, I can just make a VM in Hyper-V".

:::caution[todo]

why hyper-v?
because I didn't want to deal with VMware or VirtualBox

:::

"I already use NixOS on WSL2,
so I can just reuse the VHDX for the VM!" -- or so I thought.
Then, I quickly found out I can't just reuse it.

:::caution[todo]

take them on a journey, make the vm from scratch, find the wsl vhdx, etc

:::

---

<img height="901"
src="https://r2.sakurakat.systems/hyperv-shenanigans--no-tty.png"
title="Screenshot showing No TTY" width="1467"
alt="Screenshot of Hyper-V Manager with a VM booted up,
but the display is completely black.
This shows
that there is no TTY."/>

The dang thing doesn't even show a TTY!
Then,
I remembered [github\:nix-community/nixos-generators](https://github.com/nix-community/nixos-generators) exists.
Might as well use NixOS Generators; How hard can it be?
It can't be that bad, right?
Right???

Thus, as usual,
I proceeded to fuck around and find out the age-old lesson of:

## Software Programming Mantra

<img alt="We do this not because it is easy,
but because we thought
it would be easy" height="794"
src="https://r2.sakurakat.systems/hyperv-shenanigans--mantra.svg"
title="Software Programming Mantra" width="1058"/>

:::note
I journaled the journey on Bluesky!

Check it out here:
https://bsky.app/profile/sakurakat.systems/post/3llnz5asyms2c

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:rwi65xn77uzhgyewkfbuuziz/app.bsky.feed.post/3llnz5asyms2c" data-bluesky-cid="bafyreiglr2t5dl777thtxucftt5qlwbq6j57jftmwclktvjxjtnmanbd6e" data-bluesky-embed-color-mode="system"><p lang="en">trying to make a Hyper-V VM with NixOS
so i can rice my laptop
without turning it on</p>&mdash; Kathryn&lt;&#x27;u1f338&gt; (<a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz?ref_src=embed">@sakurakat.systems</a>) <a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz/post/3llnz5asyms2c?ref_src=embed">March 31, 2025 at 2:39 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

You can also read the skeets as an article here:
https://skywriter.blue/pages/did:plc:rwi65xn77uzhgyewkfbuuziz/post/3llnz5asyms2c
:::

# Enter [github\:nix-community/nixos-generators](https://github.com/nix-community/nixos-generators)

::github{repo="nix-community/nixos-generators"}

I started by invoking nixos-generator
and passed my NixOS config via the `--flake` option.
But it kept
saying `nixos/modules/virtualisation/disk-size-option.nix` is missing.
Even though I passed the options via CLI?

:::caution[TODO]
add various links to flakes, the libre pheonix person, vimjoyer, the rust person,
whoever i can find
:::

Now, I’m new to flakes and Nix in general,
so I couldn't figure out why it didn't find the option.

So,
I figured
the best course of action would be copying the example from website,
and then incrementally make changes.
That is, create a minimal working config,
and then adapt it to my needs.

## Getting the minimal working config to work

It worked, but then I realized I used the wrong config,
I used WSL's config instead of my laptop's config 🤦.
Well, at least I know it works now.

:::warning
I had some errors here after I changed it to my laptop's config,
but I didn't record what the errors were 🤦🤦🤦
:::

I then made a stupid mistake.
See,
NixOS allows you to have configuration for multiple...
Let's say... environments.
When you do `sudo nixos rebuild test --flake .`,
the config gets selected depending on the machine's hostname.
You can also specify
the config you want
to build by doing `sudo nixos rebuild test --flake .#<hostname>`.

My laptop's hostname is `kats-laptop`,
however, the hostname for WSL is `nixos` (default).
So,
the flake thought I wanted to build the target using `nixos`'s config,
but, there was no config for `nixos`.
So, I just had to mention the hostname.

Ideally,
I would have different hostnames for different machines,
à la `kats-laptop`, `kats-wsl`, `kats-rpi`, `kats-hyperv-vm`.
So that config flake is modular,
this allows you
to have a single config flake,
which you can push to GitHub or some other place.

Now, I do want to modularize my config,
I'm just being lazy because it works good enough.

Also, the `#<hostname>` part isn't limited to NixOS configs.
In general, it is to select a target.
If you've used the `nix shell nixpkgs#<app>` command,
you're selecting which target to build and expose to the shell.
Another place
you might've selected a target is
when you run `nix build github:<owner>/<repo>#<branch>`.

The thing after `#` is the output from the flake.

Recently,
I had
to update [github\:MarceColl/zen-browser-flake](https://github.com/MarceColl/zen-browser-flake),
so it builds the latest version of the Zen browser.
In the flake,
you can choose if you want to use the build that was optimized
for newer systems, or the compatibility one.
The way you chose which one to buld was by either using `#specific`,
or `#generic`.
If you didn't choose, the flake defaults to `specific`.
:::note[You can read the short thread about the process on Bluesky]
<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:rwi65xn77uzhgyewkfbuuziz/app.bsky.feed.post/3lm3jib32pk2s" data-bluesky-cid="bafyreiae6gdke4n6voeg5sizs5skqguxjkihcbz4jes4mxp674jecjg2zq" data-bluesky-embed-color-mode="system"><p lang="en">My pc is in quarantine rn because of some RAM issues.
I spent the whole day just lazying around and relaxed for once,
took naps, etc.

I suddenly remembered
that I have a laptop I can use instead of bedrot.

Downloaded zen using github.com/MarceColl/ze...<br><br><a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz/post/3lm3jib32pk2s?ref_src=embed">[image or embed]</a></p>&mdash; Kathryn&lt;&#x27;u1f338&gt; (<a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz?ref_src=embed">@sakurakat.systems</a>) <a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz/post/3lm3jib32pk2s?ref_src=embed">April 5, 2025 at 11:36 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>
:::

While trying to get the VM image to build, at some point, I went from
trying
to build the `hyperv` target
to trying to build the `install-iso-hyperv`.
As the name suggests, `install-iso-hyperv`
builds an ISO instead of a Hyper-V image.
I can’t just load the ISO in the Hyper-V manager.
(btw the size of the ISO was ~2.6 GB).
But I wanted the image.
So, it is time to remake it with the `hyperv` target.

I was also unsure if 20 GB would be enough for the VM,
so I bumped it up to 40 GB.

:::caution[TODO]

This should be a heading

:::

The question is; why did I want an image?
Why couldn't I use the ISO I just made?

Let's talk about the ISO first.
If you've ever installed linux on you pc,
you might've noticed that you can just *use* your pc.
You don't need to install linux to use it.
This feature is called LiveISO (or live CD,
read more on [wikipedia:Live_CD](https://en.wikipedia.org/wiki/Live_CD)).

:::note[Some distros exclusively run off a USB]

- [Tails](https://tails.net/)
    - [wikipedia:Tails_(operating_system)](https://en.wikipedia.org/wiki/Tails_(operating_system))
        - > security-focused Debian-based Linux distribution aimed at preserving privacy and anonymity against surveillance
- [PuppyLinux : HomePage](https://wikka.puppylinux.com/HomePage)
    - [wikipedia:Puppy_Linux](https://en.wikipedia.org/wiki/Puppy_Linux)
        - > light-weight Linux distributions that focus on ease of use and minimal memory footprint
- [GNOME Partition Editor](https://gparted.org/)
    - [wikipedia:GParted](https://en.wikipedia.org/wiki/GParted)
        - > used for creating, deleting, resizing, moving, checking, and copying disk partitions and their file systems

:::

The ISO I just made was a LiveISO.
I would need to install it to use it in the VM.
Installing OS in one VM? 
That's fine.
But at least for me, 
it feels like the goal of `nixos-generators` is to automate
the creation of VMs.

Creating an image means I can load the "VHDX"
file as the VM's storage, 
I would still need to allocate CPU, Memory, configure networking, etc,
but that work can be automated (see: [learn.microsoft.com: Working with Hyper-V and Windows PowerShell](https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/try-hyper-v-powershell)).

For example:
```powershell {7}
$VMName = "VMNAME"

$VM = @{
     Name = $VMName
     MemoryStartupBytes = 2147483648
     Generation = 2
     NewVHDPath = "C:\Virtual Machines\$VMName\$VMName.vhdx" # <- here 
     NewVHDSizeBytes = 53687091200
     BootDevice = "VHD"
     Path = "C:\Virtual Machines\$VMName"
     SwitchName = (Get-VMSwitch).Name
 }

New-VM @VM
```
(From [learn.microsoft.com: Working with Hyper-V and Windows PowerShell | Section: Create a new virtual machine](https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/try-hyper-v-powershell#create-a-new-virtual-machine) on 2025-04-24)

By pointing `NewVHDPath` to the created image, 
you can make a new VM with NixOS already installed.

:::important[You]

Yeah thats cool and all, but where is this useful?

:::

- Integration testing
    - Test your whole application
        - You get a litter-free environment to test your application
    - https://nix.dev/tutorials/nixos/integration-testing-using-virtual-machines.html
- Malware Analysis and pentesting
    - You can harden your image once, and then replicate it every time.
    - Don't need to worry about the malware infecting the host machine.[^vms-as-a-service]
[^vms-as-a-service]: You can turn this into a service by Sell hardened VMs for testing malware. Network Chuck has done a similar thing but he did browser instead of a full-blown VMs. <iframe width="560" height="315" src="https://www.youtube.com/embed/NDlQrK_QAzY?si=QsWZIi132ReUyAgn" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
- Different architecture
    - You can test your application for different CPU architectures
        - I have an `x86_64` cpu, I can create a VM with `aarch64` cpu to check if the application behaves as expected. 
- Different OS
    - Similar to the "Different architecture" points, you can install a different OS and check your application there.
        - I have a Windows machine (hence Hyper-V), and I can run check my application in linux. 
- Lab environments
    - Create preconfigured environments where you can't uninstall or install anything for learning purposes.
    - I required one when I was preparing for `RHCSA` and `RHCE`

## Back to failing to build

I thought that changing the image size to 40 GB was the problem,
so I changed it back to 20 GB.
I can just increase the disk size in Hyper-V Manager.

The build failed again.
I checked the logs and found this:

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:rwi65xn77uzhgyewkfbuuziz/app.bsky.feed.post/3lloeoe3ylc2o" data-bluesky-cid="bafyreicenmdklh3lqdn53du4eb5gnhrygmcflzcobt76cmyk6i5ew7ghri" data-bluesky-embed-color-mode="system"><p lang="en">Model:
(file)
Disk /build/nixos.raw: 4295MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:
Number  Start   End     Size    File system  Name     Flags
1      8389kB  269MB   261MB   fat32        ESP      boot, esp
2      269MB   4294MB  4024MB  ext4         primary</p>&mdash; Kathryn&lt;&#x27;u1f338&gt; (<a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz?ref_src=embed">@sakurakat.systems</a>) <a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz/post/3lloeoe3ylc2o?ref_src=embed">March 31, 2025 at 6:05 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

## Lead astray

Let's talk about the assumptions I made which turned out to be wrong.

### WSL's disk size

I thought WSL had a limited disk size,
and while building the 40 GB image, I was running out of space.

But that doesn't make any sense. 
WSL's disk should be big enough.
In fact,
it should be able
to expand till there's no space left on the physical disk. 

If I run `df -h`
![root partition
`/` has 49 GB used and 908 GB free.](img.png "screenshot of terminal with the command
`df -h`")

Seems like by default windows assigns 1007 GB to the disk.

### Unit for `virtualisation.diskSize`

I thought `20 * 1024` for `virtualisation.diskSize` meant 20 MB and not 20 GB. 
This feels wrong, 
why would the tutorial on `nixos-generators`' GitHub use 20 MB?

So, I changed it to `200 * 1024`, but it still failed.
So, 
I assumed wrong, and my initial understanding was correct.
It was 20 GB.

### NixOS' build sandbox ran out of space

Nope, don't know why I thought this.

### Making it easier to debug

I dug around
and changed the build directory to be in the Windows partition, 
so space would not a concern.
This also had the side effect of making it simpler for me to debug the build.

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:rwi65xn77uzhgyewkfbuuziz/app.bsky.feed.post/3llof7mnl4s2o" data-bluesky-cid="bafyreihi63fohhewonrswcy7aybspl5ncdyychz2qjq3rlcho3r2e3bln4" data-bluesky-embed-color-mode="system"><p lang="en">i can pass options to the nix build system via `--option`
nix.dev/manual/nix/2...
and then,
man.archlinux.org/man/nix.conf...<br><br><a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz/post/3llof7mnl4s2o?ref_src=embed">[image or embed]</a></p>&mdash; Kathryn&lt;&#x27;u1f338&gt; (<a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz?ref_src=embed">@sakurakat.systems</a>) <a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz/post/3llof7mnl4s2o?ref_src=embed">March 31, 2025 at 6:15 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

And I got a different error!

```
error: builder for '/nix/store/viir73fa9wxrbp4y18yad03nzp82bhjr-hwdb.bin.drv' failed with exit code 1
error: 1 dependencies of derivation '/nix/store/6g53c6j7nhs4ngy4fs1hk8sgi3hkli2i-etc.drv' failed to build
note: keeping build directory '/mnt/d/build-dir/nix-build-initrd-linux-6.12.21.drv-0/build'
error: 1 dependencies of derivation '/nix/store/xlfbh71qyiwbb00k9xg6bmimqqmip75q-nixos-system-kats-laptop-hyperv-25.05.20250330.52faf48.drv' failed to build
error: 1 dependencies of derivation '/nix/store/bk0kb7mp9kswp6kvnrlqqnmd7fxb1cvh-nixos-hyperv-hyperv-25.05.20250330.52faf48-x86_64-linux.drv' failed to build
```

### Giving up and creating an issue

I created an issue on GitHub.
Then, while trying to create the minimal reproducible configuration,
I reverted the `build-dir` option, AND THE IMAGE SUCCESSFULLY BUILD.
So the thing I did to debug easier made the build fail.

### Why was it a mistake?

Windows' permission system is different compared to linux,
and they're not intercompatible.

:::note[You can read more about the file permission stuff here]

- Windows: https://learn.microsoft.com/en-us/windows/security/identity-protection/access-control/access-control
- Linux: https://www.redhat.com/en/blog/linux-file-permissions-explained

:::

`nixos-generate` was trying to add permissions to the files, but kept failing because Windows doesn't talk the same language.

During the confusion, I also managed to fix the `diskSize` issue.

The fix was to add
```nix
{
  virtualisation.diskSize = 20 * 1024;
}
```
To the modules array,
around [here](https://github.com/pawarherschel/nixos-config/blob/7042e5c893375afcf62d4f2bea0112d874e7210e/flake.nix#L56)
<img alt="Screenshot of `flake.nix` on GitHub,
the line
where the these modifications have
to be added is highlighted in yellow"
height="1347"
src="https://r2.sakurakat.systems/hyperv-shenanigans--github-line.png"
title="Screenshot of the required file on GitHub with area
highlighted in yellow."
width="1680"/>

## Build success

I copied the successful build from the Nix store to Windows.

When I tried to load it as a VM

<img alt="An error occurred
while attempting to start the selected virtual machine(s).
New Virtual Machine&#39; failed to start.
Synthetic SCSI Controller
(Instance ID 1666945F-9962-4366-83F3-AA863F98254B):
Failed
to Power on with Error &#39;The requested operation couldn’t be completed due to a virtual disk system limitation.
Virtual hard disk files must be uncompressed and unencrypted
and mustn’t be sparse.&#39;.
Attachment &#39;D:\build-dir\nixos-image-hyperv-25.05pre-git-x86_64-linux.vhdx&#39;
failed to open because of error:
&#39;The requested operation couldn’t be completed due to a virtual disk system limitation.
Virtual hard disk files must be uncompressed and unencrypted
and must not be sparse.&#39;."
height="432"
src="https://r2.sakurakat.systems/hyperv-shenanigans--compressed-file.png"
title="Screenshot of Hyper-V Manager&#39;s error" width="702"/>

Let's read this error.
- VM failed to start.
- Something about limitations
- "disk file must be `uncompressed`
  and `unencrypted` and must not be `sparse`"
  - `uncompressed`: I compress my disks, so I know how to solve that.
  - `unencrypted`: I don't think this should be a problem. I don't have BitLocker on.
  - `sparse`: I'm not even sure how I'd solve it,
    maybe the Hyper-V Manager has some tool I can use.

OK, let's uncompress it first.\
`right click file > properties > advanced > uncheck Compress contents to save disk space`

Next error:
<img alt="Virtual Machine Boot Summary 1.
SCSI Disk (0,0)
The unsigned image&#39;s hash is not allowed (DB) 2. Network Adapter
(00155D006403) A boot image wasn’t found.
No operating system was loaded.
Your virtual machine may be configured incorrectly.
Exit and re-configure your VM or click restart to retry the current boot sequence again."
height="768"
src="https://r2.sakurakat.systems/hyperv-shenanigans--unsigned-image.png"
title="Screenshot of Hyper-V UEFI&#39;s Error" width="1024"/>
- "No operating system was loaded.
  Your virtual machine may be configured incorrectly.
  Exit and re-configure your VM or click restart to retry the current boot sequence again."
  - Hm, that doesn't tell a lot; let's read the earlier stuff.
- "The `unsigned image's hash` is not allowed (DB)"
  - Oh, I think I know what's wrong: secure boot!

`right click vm > settings > Security > uncheck 'Enable Secure Boot' `

![img_1.png](img_1.png)

:::caution[todo]
this should be a new top level heading
:::
## VM booted successfully

I checked the VHDX file NixOS Generators created and saw it was 4 GB.

Then, the realization hit me.
The error I saw in the
[#lead-astray](#lead-astray) section was telling me
that the VHDX file was 4 GB,
and not all the various things I thought it was.
:::warning
I'm gonna be honest, I forgot what I was yapping about at this point:
<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:rwi65xn77uzhgyewkfbuuziz/app.bsky.feed.post/3llqdomz7ml2g" data-bluesky-cid="bafyreie46uis7vcjglxma73ivutlnxsmbvt3dcdl2ahmpeukz6eourw2zi" data-bluesky-embed-color-mode="system"><p lang="en">i removed the sudo
and im back to this error
       error: path &#x27;/nix/store/7a2rzcz3mjaq6ni71nn3zv6v3kxk8zab-nixpkgs/nixpkgs/nixos/modules/virtualisation/disk-size-option.nix&#x27; does not exist</p>&mdash; Kathryn&lt;&#x27;u1f338&gt; (<a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz?ref_src=embed">@sakurakat.systems</a>) <a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz/post/3llqdomz7ml2g?ref_src=embed">April 1, 2025 at 12:53 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>
:::

## Struggles with logging in as `ksakura`

<img alt="&lt;&lt;&lt; Welcome to NixOS hyperv-25.05.20250330.52faf48 (x86_64) - tty1 &gt;&gt;&gt; Run &#39;nixos-help&#39; for the NixOS manual. kats-laptop login: ksakura Password: &lt;REDACTED&gt; Login incorrect kats-laptop login: ksakura Password: &lt;REDACTED&gt; Login incorrect kats-laptop login:" height="768" src="https://r2.sakurakat.systems/hyperv-shenanigans--no-user-password.png" title="Screenshot of TTY1
where I tried
to log in" width="1024"/>

A meme about NixOS is that,
everything is declarative, except the installation process.

<img alt="Extracted text:
YOU&#39;VE USED IMPERATIVE ACTIONS DURING SYSTEM DEPLOYMENT SYSADMIN CONFISCATES YOUR NIX-CHAN –999,999,999 DERIVATIONS.
Explanation: Nix aims for perfect reproducibility,
using imperative action means
the change was not recorded in the config file,
and thus, you broke the rule of perfect reproducibility,
making it an impure flake" src="https://r2.sakurakat.systems/hyperv-shenanigans--nix-chan.png" title="Meme about you
using imperative action
while deploying the system" width="1922" height="1440"/>
(src: https://youtu.be/nLwbNhSxLd4?list=TLPQMTQwNDIwMjVqtjGiwPFIvg&t=759)

Part of the answer is on [mynixos.com/nixpkgs/option/users.users.\<name\>.initialPassword](https://mynixos.com/nixpkgs/option/users.users.%3Cname%3E.initialPassword#:~:text=If%20none%20of%20the%20password%20options%20are%20set%2C%20then%20no%20password%20is%20assigned%20to%20the%20user%2C%20and%20the%20user%20will%20not%20be%20able%20to%20do%20password%2Dbased%20logins),\
"If none of the password options are set,
then no password is assigned to the user,
and the user will not be able to do password-based logins."

And the rest is on [mynixos.com/nixpkgs/option/users.users.\<name\>.hashedPassword](https://mynixos.com/nixpkgs/option/users.users.%3Cname%3E.hashedPassword#:~:text=To%20generate%20a%20hashed%20password%20run%20mkpasswd.)\
"To generate a hashed password run mkpasswd."

:::caution[TODO]

add the command i used to create the password hash and why i didnt use initialPassword

:::

## Successfully logged in

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:rwi65xn77uzhgyewkfbuuziz/app.bsky.feed.post/3llqitkdpyn2g" data-bluesky-cid="bafyreidiqtyoespfqdxfvapnwmw75cvmayqi3snlqtm6xzx6o2axqeycee" data-bluesky-embed-color-mode="system"><p lang="en">HELL YEAH<br><br><a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz/post/3llqitkdpyn2g?ref_src=embed">[image or embed]</a></p>&mdash; Kathryn&lt;&#x27;u1f338&gt; (<a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz?ref_src=embed">@sakurakat.systems</a>) <a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz/post/3llqitkdpyn2g?ref_src=embed">April 1, 2025 at 2:25 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

:::caution[todo]
this should be a new top level heading
:::
## Removing the errors

I had errors in `nushell`,
and `Hyprland` because the config files were for the older version of the programs.

See, while I was debugging, I ran `nix flake update`,
which pulled down the latest version of nixpkgs,
and thus, updated the packages.
I "just"
have
to replace the current flake lock file in the VM with the one from my laptop.

:::caution[todo]
this should be a new top level heading
:::
## No config files

<img alt="The user ran ls /etc/nixos,
where the config files are supposed to exist,
however,
the output shows
that the directory is empty" src="https://r2.sakurakat.systems/hyperv-shenanigans--no-config-files.png" title="Screenshot of TTY1,
which shows
that the config files for nixos don&#39;t exist" width="1024" height="768"/>
```
> ls /etc/nixos/
Empty List
```

Huh, that's concerning.
I guess I didn't run the installer,
so the config files weren't generated.

### Solution
1. Run `nixos-generate-config`.
2. Clone my laptop's config from GitHub.
3. Replace the `hardware-configuration.nix` from my laptop with the one \[Step
   1\] generated.
    :::caution[todo]
        check if i need to explain why i only needed `hardware-configuration.nix`
    ::: 
4. `sudo nixos-rebuild test --flake .`

### Problems, again

<img alt="The user tried to rebuild NixOS
but while building a specific package,
the process tried
to use more memory than what was allocated to it,
thus ending up in an out of memory situation."
height="768"
src="https://r2.sakurakat.systems/hyperv-shenanigans--oom.png"
title="Screenshot of TTY1 showing the process tried
to use more memory than what exists" width="1024"/>

- "building `determinate-nix`-util-3.2.1"
  - Problems with determinate nix?
- "`Out of memory`: Killed process 1316 (nix)"
  - Out of RAM...? That shouldn't be the case.

:::caution[TODO]
add whatever here, and why, ie easier to just add it later
:::
Let's just remove determinate nix for now.

<img alt="Due to the immutable nature of the nix packaging system,
it uses quite a bit of space.
Usually you&#39;d just garbage collect
to recover space,
but in this case it was easier to resize the vm&#39;s hard drive"
height="768"
src="https://r2.sakurakat.systems/hyperv-shenanigans--no-disk-space.png"
title="Screenshot of TTY1
showing the VM is out of disk space" width="1024"/>

- "mkdir: cannot create directory '<omit>': `No space left on device`"
  - Oh, OK, let's run `df -h`

`df -h` reported 100% used on `/`

Easy, just increase the disk space.\
`file > settings > hard drive > edit > expand disk`

<img alt="What size do you want to make the virtual hard disk?
Current size is 40 GB.
New size:
40 GB (Maximum: 64 TB)
Out of Bounds Specify a number between 41 and 65536."
height="839"
src="https://r2.sakurakat.systems/hyperv-shenanigans--resize-vhdx.png"
title="Screenshot of the setting,
which is required
to resize the virtual hard disk" width="1550"/>
:::note
ignore the error for Out of Bounds
I took the screenshot after resizing and checking if it works.
:::

:::caution[todo]
this should be a new top level heading
:::
## Final stretch

1. Reboot the VM
2. `sudo nixos-rebuild test --flake .`

<img alt="Screenshot of `Nushell` running in kitty terminal.
The text size in terminal is very large,
and the cursor is glitching
and leaving trails."
height="768"
src="https://r2.sakurakat.systems/hyperv-shenanigans--success.png"
title="Screenshot of `Hyprland` running in the VM" width="1024"/>

Success!

The glitchiness because `Hyperland` doesnt like being run in a VM.
:::caution[TODO]
https://wiki.hyprland.org/Getting-Started/Installation/#running-in-a-vm
:::

### Checking the number of generations

Restart the VM.

And now there are more generations!

<img alt="NixOS
(Generation 2 NixOS Warbler 25.05.20250129.9d3ae80 (Linux 6.12.11),
bu&lt;cut off&gt;     NixOS
(Generation 1 NixOS Warbler hyperv-25.05.20250330.52faf48
(Linux 6.12.&lt;cut off&gt;
Reboot Into Firmware Interface" height="768"
src="https://r2.sakurakat.systems/hyperv-shenanigans--bootloader.png"
title="Screenshot of the bootloader of the VM" width="1024"/>

Now, bring back determinate nix, and it builds successfully!

<blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:rwi65xn77uzhgyewkfbuuziz/app.bsky.feed.post/3lmmdyfqgrd22" data-bluesky-cid="bafyreiff52642twa3lzzxfh3su4fxrcgbo25arhqjs4h4d5vh66thf4whe" data-bluesky-embed-color-mode="system"><p lang="en">determinate-nix says hello 🐱<br><br><a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz/post/3lmmdyfqgrd22?ref_src=embed">[image or embed]</a></p>&mdash; Kathryn&lt;&#x27;u1f338&gt; (<a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz?ref_src=embed">@sakurakat.systems</a>) <a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz/post/3lmmdyfqgrd22?ref_src=embed">April 12, 2025 at 4:13 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>

# The End (for now)

I now have a working VM where I can experiment.

But was it worth it?
Not really.\
Do I regret going through all this effort?
Not at all.

I actually tried
to rice my laptop when I had nothing else I wanted to do.
But it just didn't feel worth it.
It takes so much time,
and while I don't like using `Hyprland` due to the author,
it is just not worth it to switch to `Niri`, at least for me.

I do eventually want to update to newer packages
but that's a thing for later.
I can also use the VM to modularize my config.

---

# The `flake.nix` File
```nix
{
  inputs = {
    # NOTE: Replace "nixos-23.11" with that which is in system.stateVersion of
    # configuration.nix. You can also use latter versions if you wish to
    # upgrade.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    nixos-generators,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    # NOTE: 'nixos' is the default hostname set by the installer
    nixosConfigurations.kats-laptop = nixpkgs.lib.nixosSystem {
      # NOTE: Change this to aarch64-linux if you are on ARM
      system = "x86_64-linux";
      # extraSpecialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix

        {
          nix.settings.experimental-features = [
            "nix-command"
            "flakes"
          ];
        }

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          # home-manager.useUserPkgs = true;
          home-manager.users.ksakura = import ./home.nix;
          home-manager.backupFileExtension = "bak";
        }

        {
          virtualisation.diskSize = 20 * 1024;
        }
      ];
    };

    formatter.${system} = pkgs.alejandra;
    devShell = with pkgs;
      mkShell {
        buildInputs = [nil self.formatter.${system}];
      };
  };
}
```

---

- Link to the first skeet:
  - https://bsky.app/profile/sakurakat.systems/post/3llnz5asyms2c
  - <blockquote class="bluesky-embed" data-bluesky-uri="at://did:plc:rwi65xn77uzhgyewkfbuuziz/app.bsky.feed.post/3llnz5asyms2c" data-bluesky-cid="bafyreiglr2t5dl777thtxucftt5qlwbq6j57jftmwclktvjxjtnmanbd6e" data-bluesky-embed-color-mode="system"><p lang="en">trying to make a hyperv VM with nixos
    so i can rice my laptop
    without turning it on</p>&mdash; Kathryn&lt;&#x27;u1f338&gt; (<a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz?ref_src=embed">@sakurakat.systems</a>) <a href="https://bsky.app/profile/did:plc:rwi65xn77uzhgyewkfbuuziz/post/3llnz5asyms2c?ref_src=embed">March 31, 2025 at 2:39 PM</a></blockquote><script async src="https://embed.bsky.app/static/embed.js" charset="utf-8"></script>
- Read the thread on Skywriter.blue:
  - https://skywriter.blue/pages/did:plc:rwi65xn77uzhgyewkfbuuziz/post/3llnz5asyms2c

---

# Footnotes