#import "../../../public/utils.typ": (
  admonition, blog-post, github-card, img, note, todo,
)

#show: blog-post.with(
  "remote-desktop-setup",
  description: [
    #todo[]
  ],
  tags: (),
  category: "",
)

= Why this blogpost exists.

I was recently (#datetime(year: 2026, month: 02, day: 07).display()) talking to a friend about homelab stuff when they said that they're going to do a DIY NAS eventually. They mentioned that they don't want to do a homelab setup, but from what they said, the setup they wanted is literally one step away from being a homelab.

In their head, due to reddit, their image of a homelab is a rack server. They were surprised when I said told them about how they could just install #link("https://www.docker.com/")[docker] and their NAS would become a homelab.

I then proceeded to tell them about how I used to do homelab with just a #link("https://www.raspberrypi.com/products/raspberry-pi-4-model-b/")[Raspberry Pi 4 (RPI)] exposed to internet via #link("https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/")[Cloudflare Tunnel], and my weird setup where I use cloud gaming software to access my pc via laptop.

After explaining to them, I decided that I should just document setup formally on my blog, and thus, this blogpost.

But first, lemme talk about the originals setup I had to do.

= How did it start?

For college, I got a second hand #link("https://www.thinkwiki.org/wiki/Category:T480")[T480], partially for memes, partially cuz its cheap and good enough. I used windows on it for a while and then took the plunge and installed #link("https://nixos.org/")[NixOS] with Hyprland #footnote[I'm not linking to hyprland due to Vaxry and drama #link("https://drewdevault.com/2024/04/09/2024-04-09-FDO-conduct-enforcement.html")[link to drama]].
It worked pretty great even with 256gb ssd #footnote[I still have 256gb ssd 😭, someone please send replacement ssd 🥲].

There were some problems during practicals, for eg, I couldn't figure out how to use #link("https://en.wikipedia.org/wiki/QEMU")[QEMU], and just used #link("https://help.gnome.org/gnome-boxes/")[GNOME Boxes].
As for office suite, I installed #link("https://nextcloud.com/")[Nextcloud] on my RPI and used that, I would turn on my PC before leaving for college if I felt like I'd need to use it,
and then access over #link("https://en.wikipedia.org/wiki/Secure_Shell")[SSH] or #link("https://en.wikipedia.org/wiki/VNC")[VNC].

= UK Setup

But then, in #datetime(year: 2024, month: 07, day: 1).display("[year] [month repr:long]") I went to UK #footnote(link("/posts/covuni-experience/", [Link to blogpost about my experience there])).

My laptop was terribly underpowered for #link("https://unity.com/")[Unity], not to mention NixOS being a snowflake distro meant I couldn't trust it to be painless.

That's fine, I thought. I could just use #link("https://parsec.app/")[Parsec] to access my pc back at home.

But the problem was that I couldn't leave my pc on 24/7 for roughly a month.
I also can't trust the electricity to be flawless, if electricity goes out for long enough, my pc will shut down and then I'd need to bother my mom to turn it on.
Once there's no electricity or wifi, I can't shut down my pc safely.
I still had VNC, so I could access my pc via VNC in case parsec is misconfigured or whatever.
But if something else breaks, I couldn't ask my mom to fix it as she wouldn't understand what's wrong.

I had to think of a way to turn on and off my pc halfway across the world, have redundancy, resiliance, debugability, whatever.

== My solution

=== Turning the PC on and off

I needed a low powered device I could keep on 24/7, without much worry. My RPI was perfect for that.

The first two things which came to my mind were
+ Using my RPI to send the signal to my PC via the same mechanism the case uses.
+ Sending WOL packet, but my friend had told me that it can be iffy.

==== Sending electrical signal

I asked around and my friend #link("https://sakurakat.systems/friends/#:~:text=to%20write%20programs.-,mlembug,-A%20trans%20woman")[mlembug] had already tried it AND documented it in her blogpost titled #link("https://mahoushoujobu.com/mlemblog/posts/relay-operated-power-button/")[Relay operated power button (#datetime(year: 2023, month: 10, day: 2).display())].
I got the components, but ultimately decided to not do it.
I was too afraid to fuck it up.

==== WOL Packet

I did the whole WOL setup since it's minimally invasive #footnote[as in it didn't involve altering anything physically or in hardware].

I think I had to change some UEFI settings, install #link("https://github.com/jpoliv/wakeonlan")[wakeonlan #footnote[I think it was this one? Not sure tbh]], send WOL packet to the mac address.

Easy, done.

I just had to make sure my PC doesn't go to sleep, so I turned it off in windows.

As for shutting it down, I can just do it via GUI.

=== Shutting down without wifi

If there's no internet connectivity, I can't access any of my hardware.

Some downtime is fine, I was sure there'd be atleast one capable person for whatever was going to happen in UK.

I needed redundant internet for pc.
But that seemed like an overkill.

So I went with redundant internet for my RPI.

I had an old Jio internet dongle passed down from my father, and a Jio sim card...

I used them to provide wifi hotspot to my RPI.

I got a cheap Ethernet hub so I could provide ethernet to both, my PC, and the RPI.

Redundant internet done.

=== Battery Backup

The redundant internet would be useful if my ISP was having some problem, but it'd be useless in the case of no electricity.

I already had a UPS for my pc, so I just connected the ethernet hub, dongle, and rpi to it lol

=== Why Parsec?

I already had GUI access via VNC, so why did I need parsec?

Parsec is specially designed to have low latency, high bandwidth video for playing games remotely.

And since I wanted to do game dev, I needed parsec.

== Final Setup


#html.frame({
  import "@preview/fletcher:0.5.8": diagram, edge, node, shapes
  set text(fill: white)

  block(
    fill: oklch(33%, 0.035, 330deg),
    inset: 1em,
    diagram(
      node-shape: shapes.rect,
      node-stroke: white,
      edge-stroke: white,
      mark-scale: 150%,

      {
        let wall = (0, 0)
        let internet = (1, 1)

        let ups = (0, 1)

        let router = (1, 0)
        let hotspot = (1, 2)
        let hub = (2 - 1 / 10, 1 / 2)

        let rpi = (3, 1)
        let pc = (3, 0)

        let laptop = (4, 2)
        let phone = (5, 1)
        let me = (5, 2)

        let tailscale = (4, 1)

        node(wall, [Wall Socket], name: <wall>)
        node(internet, [Internet], name: <internet>)
        node(me, [Me], name: <me>)

        node(ups, [UPS], name: <ups>)
        node(router, [Router], name: <router>)
        node(hub, [Hub], name: <hub>)
        node(rpi, [RPi], name: <rpi>)
        node(hotspot, [Hotspot Dongle], name: <hotspot>)
        node(pc, [PC], name: <pc>)
        node(laptop, [Laptop], name: <laptop>)
        node(phone, [Phone], name: <phone>)

        node(tailscale, [Tailscale VPN], name: <tailscale>)

        edge(
          <wall>,
          <ups>,
          marks: "-|>",
          stroke: red,
          label: [Unreliable Power],
        )
        edge(
          <internet>,
          <router>,
          marks: "<|-|>",
          label: [Primary Internet],
          label-sep: 1em,
          label-side: left,
        )
        edge(
          <internet>,
          <hotspot>,
          marks: "<|--|>",
          label: [Backup Internet],
          label-side: right,
        )

        // Internet Connectivity
        edge(<router>, <hub>, marks: "<|-|>")
        edge(<hub>, <rpi>, marks: "<|-|>")
        edge(<hub>, <pc>, marks: "<|-|>")
        edge(<hotspot>, <rpi>, marks: "<|--|>")
        edge(
          <laptop>,
          <internet>,
          marks: "<|--|>",
          label: [WiFi],
          label-pos: 20%,
        )

        // Power
        edge(
          <wall>,
          <router>,
          marks: "-|>",
          stroke: red,
          label: [Unreliable Power],
          label-sep: 1em,
        )
        let ups-rerouting = ((0, 2.5), (2.5, 2.5), (2.5, 0.5))
        edge(<ups>, ..ups-rerouting, <rpi>, marks: "-|>", stroke: red)
        edge(<ups>, ..ups-rerouting, <pc>, marks: "-|>", stroke: red)
        edge(<ups>, ..ups-rerouting, <hub>, marks: "-|>", stroke: red)
        let ups-rerouting-2 = ((0, 2),)
        edge(<ups>, ..ups-rerouting-2, <hotspot>, marks: "-|>", stroke: red) // TODO: Add reliable power label

        // Tailscale
        edge(<tailscale>, <laptop>, stroke: fuchsia, marks: "<|--|>")
        edge(<tailscale>, <pc>, stroke: fuchsia, marks: "<|--|>")
        edge(<tailscale>, <rpi>, stroke: fuchsia, marks: "<|--|>")
        edge(<tailscale>, <phone>, stroke: fuchsia, marks: "<|--|>")
        let tailscale-reroute = ((4, -0.5), (1.5, -0.5), (1.5, 1))
        edge(<tailscale>, ..tailscale-reroute, <internet>, marks: "<|--|>")

        // Me
        edge(<me>, <laptop>, marks: "-|>")
        edge(<me>, <phone>, marks: "-|>")
      },
    ),
  )
})

#todo[add legend for the diagram]

Turning my pc on:
+ Connect to #link("https://tailscale.com/")[tailscale]
+ SSH into the RPI
+ Send WOL using a small script
+ Wait for pc to turn on
+ Connect via Parsec

== Actual Experience

Once I got to uni and tried to use my pc, I couldn't access it.

I guessed that their firewall was blocking me.

I talked to my friend again, and he just told me to use his #link("https://mullvad.net/en")[Mulvad VPN] account, and it worked lol.

= Local headless setup

Fast forward to #datetime(year: 2025, month: 12, day: 1).display("[year] [month repr:long]")
We're renting a home since our home is undergoing renovations.

I've been using my laptop as my main machine, but now I want to use my PC to do more heavy tasks.

I turn on my power my PC but there's no way to use a display, connect to wifi, completely airgapped.

My UPS' battery is dead. There's not enough plugs in my room for three devices, there's only two plugs.
I wanted to use my PC only when required.

The oven is in my room since there's no space in the kitchen, and one of the plugs is being used by it.

So if I want to cook in the oven, I'll need to turn off my pc, and as we all know, there's nothing worse than eating without youtube #footnote[/j if it wasn't clear].

I thought about using parsec again, but my pc can't connect to the wifi.

== Bootstrapping the PC's internet connection

All phones can act as a router, what if I could use my laptop to bridge internet and my pc?

I used #link("https://thekelleys.org.uk/dnsmasq/doc.html")[Dnsmasq] to create a small DHCP server on my laptop and connected my PC via ethernet.

A DHCP server is responsible for giving out IP addresses to devices. So my laptop working like a router.

#todo[nix config]

Great, now the PC has access to internet.

== Starting up #link("https://guacamole.apache.org/")[Guacamole]

Next, I wanted to spin up Guacamole in docker so I can access my PC via VNC.

This proved impossible from what I gathered.

To turn on docker, I had to start docker desktop via GUI, but I wanted to turn on docker so I could have GUI 😭.

== #link("https://en.wikipedia.org/wiki/Remote_Desktop_Protocol")[RDP]

RDP is a proprietary protocol made by Microsoft. So the experience probably won't be as good compared to windows. However, there have been mulitple times where a thing developed by Microsoft has a FOSS implementation which is easier and better on linux.

So there's a chance that RDP on linux isn't as bad as people make it out to be.

I used #link("https://apps.gnome.org/Connections/")[GNOME Connections] to access my pc via RDP and it worked!

I achieved GUI access :3

== #strike[Parsec?] #link("https://app.lizardbyte.dev/Sunshine/")[Sunshine] + #link("https://github.com/moonlight-stream/moonlight-qt")[Moonlight]

I thought about using Parsec, but that's not a FOSS app.

I wanted to use Sunshine and Moonlight since I make an effort to try out FOSS alternatives.

But what is Sunshine and Moonlight?

Nvidia used to have a local game streaming service (I think it was called gamestream?).

The beefy PC would act as a server, the client would send input data, and the server would play out those inputs, and send the resulting frames to the client.

It's not the first time something like this has existed, I think Wii U was the first time I had heard about something like this.

Wii U had a gamepad with screen, but the processing wasn't done on the gamepad, it was done on the Wii U console box.

Anyways, tangent aside.

I just followed the #link("https://docs.lizardbyte.dev/projects/sunshine/latest/md_docs_2getting__started.html")[official guide on how to install sunshine on windows] and it was painless.
And as for the client, I used #link("https://moonlight-stream.org/")[moonlight-qt].

= Tailscale

I passed over tailscale in the previous sections, but arguably, its the most important part of my setup.

I could replace a lot of things in my setup, but, so far, I haven't found anything better than tailscale for connecting my devices safely over the internet.

Ages ago I used #link("https://vpn.net/")[LogMeIn Hamachi] to connect to my friend's pc to play minecraft, and terraria.
Then we moved on to using #link("https://ngrok.com/")[ngrok], and it was better than hitachi, but it was still annoying.

Tailscale is extremely good, its easy, safe, and FOSS.

Hear more about it from someone more qualified:

https://youtu.be/UyczOQTx5Gg

