#import "../../../public/utils.typ": blog-post, divider, img, to-string

#show: blog-post.with("Typst Showcase")

= An h1 header

Paragraphs are separated by a blank line.

2nd paragraph. _Italic_, *bold*, and `monospace`. Itemized lists
look like:

- this one
- that one
- the other one

Note that --- not considering the asterisk --- the actual text
content starts at 4-columns in.

#quote(block: true)[
  Block quotes are
  written like so.

  They can span multiple paragraphs,
  if you like.
]

Use 3 dashes for an em-dash. Use 2 dashes for ranges (ex., "it's all
in chapters 12--14"). Three dots ... will be converted to an ellipsis.
Unicode is supported. ☺

== An h2 header

Here's a numbered list:

1. first item
2. second item
3. third item

Note again how the actual text starts at 4 columns in (4 characters
from the left side). Here's a code sample:

= Let me re-iterate...
```for i in 1..10 { do-something(i) }```

As you probably guessed, indented 4 spaces. By the way, instead of
indenting the block, you can use delimited blocks, if you like:

```rust
fn main() {
  println!("Welcome to flavor country!");
}
```

(which makes copying & pasting easier). You can optionally mark the
delimited block for Pandoc to syntax highlight it:

```python
import time
# Quick, count to ten!
for i in range(10):
    # (but not *too* quick)
    time.sleep(0.5)
    print i
```

=== An h3 header

==== An h4 header

Now a nested list:

+ First, get these ingredients:
  - carrots
  - celery
  - lentils
+ Boil some water.
+ Dump everything in the pot and follow
  this algorithm:
  ```
  find wooden spoon
  uncover pot
  stir
  cover pot
  balance wooden spoon precariously on pot handle
  wait 10 minutes
  goto first step (or shut off burner when done)
  ```
  Do not bump wooden spoon or it will fall.

Notice again how text always lines up on 4-space indents (including
that last line which continues item 3 above).

Here's a link to #link("http://foo.bar")[a website], to a #link("local-doc.html")[local doc], and to a #link("#an-h2-header")[section heading in the current doc]. Here's a footnote #footnote[Footnote text goes here.].

#footnote[#lorem(2)]
#footnote[#lorem(3)]
#footnote[#lorem(4)]
#footnote[#lorem(5)]
#footnote[#lorem(6)]
#footnote[#lorem(7)]

Tables look like this:

#figure(
  table(
    columns: 3,
    table.header([size], [material], [color]),
    [9], [leather], [brown],
    [10], [hemp], [canvas natural],
    [11], [glass], [transparent],
  ),
  caption: [Shoes, their sizes, and what they're made of],
)

Typst also supports multi-line tables:

#table(
  columns: 2,
  table.header([keyword], [text]),
  [red Sunsets, apples, and
    other red or reddish
    things.],
  [green Leaves, grass, frogs
    and other things it's
    not easy being.],
)

A horizontal rule follows.

#divider

Here's a definition list:

/ apples: Good for making applesauce.
/ oranges: Citrus!
/ tomatoes: There's no "e" in tomatoe.

and images can be specified like so:

#img("https://lgtm-images.lgtmeow.com/2023/05/19/11/72fa2727-cd11-49ae-abb8-6e8c49e70f62.webp")

Inline math equations go in like so: $omega = d phi slash d t$ or $omega = frac(d phi, d t)$. Display
math should get its own line and be put in in triple-dollar signs:
$$$
  I = integral rho R^2 d V
$$$
$$$
  pi = 3.1415926535 space
  8979323846 space 2643383279 space 5028841971 space 6939937510 space 5820974944
  5923078164 space 0628620899 space 8628034825 space 3421170679 space ...
$$$
$$$
  (3x + y) / 7 & = 9        &                 & "given"      \
        3x + y & = 63       & "multiply by 7"                \
            3x & = 63 - y   &                 & "subtract y" \
             x & = 21 - y/3 &   "divide by 3"
$$$

box: #box[meow]

And note that you can backslash-escape any punctuation characters
which you wish to be displayed literally, ex.: \`foo\`, \*bar\*, etc.

```css
@counter-style devanagari {
    system: numeric;
    symbols: '\966' '\967' '\968' '\969' '\96A' '\96B' '\96C' '\96D' '\96E' '\96F';
    /* symbols: '०' '१' '२' '३' '४' '५' '६' '७' '८' '९'; */
}
```
