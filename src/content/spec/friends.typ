#import "../../../public/utils.typ": blog-post, img

#show: blog-post.with(
  "Friends",
  description: [
    mrow :3
  ],
  assumed-audience: (
    [People who wanna find out some of my friends :3],
  ),
)

Edit `src/content/friends/friends.toml` to add sites.

You can also edit `src/content/spec/friends.typ` to Change text here.

#let friends = toml("../friends/friends.toml")
