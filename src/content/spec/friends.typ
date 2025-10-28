#import "../../../public/utils.typ": blog-post, proofreaders-list

#show: blog-post.with(
  "Friends",
  description: [
    mrow :3
  ],
  assumed-audience: (
    [People who wanna find out some of my friends :3],
  ),
  proofreaders: none,
)

This page links to websites of people I know. Think of it like a phone book.

Want me to add your website here too?

Bother me on Bluesky, Signal, or Discord.
The only requirement is that the link points to something you control.
It can be a plain HTML page that says `Hello, World!` for all I care.

I won’t add the site as soon as you send the link.
I’ll update the list when I publish a new blog post or when enough people bug me to add their websites.

Side notes:
+ If you have a Bluesky account, I can use your Bluesky profile pic as the icon. The icon will update once I build the site, and I won’t need to do anything manually in the end.
+ You don’t need an 88x31 button, but personally I think it looks cool.
+ The entries are sorted by their key in `friends.toml`.

To edit the text on this page, edit `src/content/spec/friends.typ`
To add entries to the list, edit `src/content/friends/friends.toml`
