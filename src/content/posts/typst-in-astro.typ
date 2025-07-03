#import "../../../public/utils.typ": (
  admonition, blog-post, bluesky-embed, img, note, rust-btw, section,
)

#show: blog-post.with(
  "Creating Open Graph images using Typst",
  description: [
    I recently added the ability to generate Open Graph images using Typst to my website. Here, I will tell you how I to do it for your website as well!
  ],
  assumed-audience: (
    "People who want to use Typst beyond PDF generation",
    "Developers with Astro knowledge",
    "Those wanting to programmatically generate images without Satori",
  ),
  tags: (
    "Typst",
    "Image Generation",
    "Web Development",
    "Astro",
  ),
  category: "Programming",
)

#note(
  "This guide was written with Astro in mind but, the concepts aren't exclusive to Astro",
)

I recently added open graph image generation to my website which generates thumbnails for specified routes at compile time, and also the ability to author content in Typst.

#let latex = [L#super[A]T#sub[E]X]

= What's Typst?

Typst is an alternative to #latex #rust-btw(pre: [written in]). It's faster #footnote[at the cost of more compute & memory consumption], uses an actual programming language instead of macros, and has better error messages for the most part.

Also, unlike #latex, you don't need to use macros for basic markup. Typst's markup looks pretty similar to Markdown, and you can extend it via the Typst programming language.

So, Typst has the benefits of being extendible like #latex, and simpler to write like Markdown.

Typst has multiple output formats: PDF, PNG, SVG, and they're working on HTML export. Let's see how I've used them:
#table(
  columns: 2,
  [PDF],
  [
    - Downloadable articles for offline reading (soon).
    - My Résumé
    - Slides!
  ],

  [PNG],
  [
    - I'd use it for generating the open graph images but the library I'm using doesn't seem to support it ^^;.
    - Converting SVGs #footnote[Typst suceeded when Chrome failed to open an SVG, Firefox struggled] to PNG.
  ],

  [SVG],
  [
    - Diagrams.
  ],

  [HTML],
  [
    - Authoring content (this blog post is written in Typst :3).
  ],
)

= Web-side

== Open Graph Image

Open Graph is a protocol made by Facebook (see: #link("https://developers.facebook.com/docs/sharing/webmasters/images/")).
The image you see when you post a link on Discord, Instagram, LinkedIn, etc, is given using the open graph image.

You need to add the meta tag with `property="og:image"`, and `content="url-to-image.jpeg"` to the head part of your HTML.
In my case it's:
```html
<meta
  property="og:image"
  content={`/open-graph/${pathname == "" ? "home" : pathname}.jpeg`}
/>
```

== Interfacing with Typst from TypeScript

Add these packages
- `@myriaddreamin/typst.ts`
- `@myriaddreamin/typst-ts-node-compiler`
- `sharp`

== Generating the Image

The images are served on a specific route. In my case it's `/open-graph/{slug}.jpeg`.

For Astro, you need to create `src/pages/open-graph/[...slug].jpeg.ts`.

== Getting all the routes

Astro expects a function with name `getStaticPaths` which, when called, returns a list of all the slugs you want to create a route for.

In my case I have a blog and some base pages
```ts
export enum LinkPreset {
  Home = 0,
  Archive = 1,
  About = 2,
  Portfolio = 3,
}

const others = Object.values(LinkPreset) // Get all the preset links for the NavBar
  .filter((value): value is string => typeof value === 'string')
  .map((it) => it.toLowerCase());

export const getStaticPaths = async () =>
	[
		(await getCollection("posts")).map((it) => ({ // Get all the blog posts
			data: it.slug,
		})),
		others.map((it) => ({ data: it })),
	]
		.flat()
		.map(({ data }) => ({
			params: {
				slug: data,
			},
		}));
```

The other function Astro expects is `GET`

In my case this is the prototype of the function
```ts
export async function GET({ params }: { params: { slug: string } })
```

OK, now, there are two different types of slug in which act as input for the `GET` function, the blog posts, and the normal page links.

I don't know if there's a way to pass additional data to GET. So, I'm just going to duplicate work with the assumption that if the slug isn't part of blog posts, then it's part of the normal pages.

== Creating the compiler

```ts
	const compilerArg = {
	// I want all the shared resources to be in public folder
	// relative to package.json
		workspace: "./public",
		fontArgs: [{ fontPaths: ["./public/fonts"] } satisfies NodeAddFontPaths],
	} satisfies CompileArgs;

	// Create the compiler
	const typstCompiler = NodeCompiler.create(compilerArg);

	const o = {
		// Main file content
		// The other option is to pass the path instead of the contents to `mainFilePath`
		mainFileContent: template.data,
		inputs: {
			// Additional data, accessible via sys.inputs.data
			data: JSON.stringify(inputs),
		},
	} satisfies NodeTypstDocument | CompileDocArgs;
	// create the SVG
	const svgContentResult = typstCompiler.plainSvg(o);
```

== Converting the SVG to JPEG

I'm using Sharp to convert the SVG to JPEG.
```ts
	const sharpInput: sharp.SharpInput = Buffer.from(svgContent, "utf-8");
	const sharpOpts = {} satisfies SharpOptions;
	const jpegOpts = {
		mozjpeg: true,
	} satisfies sharp.JpegOptions;

	const jpegBuffer = await sharp(sharpInput, sharpOpts)
		.jpeg(jpegOpts)
		.toBuffer();
```

== Returning the image

```ts
	return new Response(jpegBuffer, {
		headers: { "Content-Type": "image/jpeg" },
	});
```

= Typst-side

I also want the images to have a specific theme, so I'm going to save a foreground colour, and a background colour.
```typst
#let fg-color = rgb("#e1bad0")
#let bg-color = rgb("#130d13")
```

I generate the images at 3000×1572 resolution and downscale it to 1500×786. While we're at it, let's set the background colour as well, and remove the margin.
```typst
#let page-height = 1572pt
#let page-width = 3000pt

#set page(
  height: page-height,
  width: page-width,
  background: rect(height: 100%, width: 100%, fill: bg-color),
  margin: 0pt,
)
```

== Posts template

For posts, I expect `sys.inputs.data` to contain data like this:
```json
{
  "data": {
    "title": "",
    "description": "",
    "tags": [
      "tag1",
      "tag2",
      "an extremely long tag",
      "another extremely long tag"
    ],
    "category": "categoooooory"
  },
  "payload": {
    "time": 9999,
    "words": 9999,
    "published": "2025-06-15",
    "updated": "2025-06-17"
  }
}
```

Which is converted to Typst variables like:
```typst
#let (
  data: (
    title,
    description,
    tags,
    category,
  ),
  payload: (
    time,
    words,
    published,
    updated,
  ),
) = json(bytes(sys.inputs.data))
```

The font size is too small for our use, lets change that:
```typst
#set text(
  size: page-height * 4%,
  fill: fg-color,
  font: "Jetbrains Mono",
  hyphenate: true,
)
```

Let's call everything till now as `prelude`.

== V1

```typst
= #title
description: #description\
category: #category\
tags: #tags.join(", ")\
time: #time minute#if time > 1 { "s" }\
words: #words\
published: #published (#updated)\
```
#let preview-image(v) = img(
  "https://r2.sakurakat.systems/typst-in-astro--V" + str(v) + ".png",
)
#preview-image(1)

== V2

I want a card, something that looks like the YouTuber Mumbo Jumbo's transition screen.

Let's put everything in a rectangle then, centre align the rectangle, and left align the text.
```typst
#align(center + horizon)[
  #rect(height: 100% - 6em, width: 100% - 6em, stroke: white + 2pt)[
    #align(left + top)[
      = #title
      description: #description\
      category: #category\
      tags: #tags.join(", ")\
      time: #time minute#if time > 1 { "s" }\
      words: #words\
      published: #published (#updated)\
    ]
  ]
]
```
#preview-image(2)

== V3

I can't differentiate between what is what, it just looks like one big wall of text, let's add dividers.

Let's go with table for layout. I also want tags to be the last thing people see, so let's move them to the bottom.

```typst
#align(center + horizon)[
  #rect(
    height: 100% - 6em,
    width: 100% - 6em,
    stroke: white + 2pt,
  )[
    #align(left + top)[
      #table(
        columns: 1,
        stroke: white + 2pt,
        table.header([= #title]),
        [category: #category],
        [time: #time minute#if time > 1 { "s" }],
        [words: #words],
        [published: #published (#updated)],
        [description: #description],
        [tags: #tags.join(", ")],
      )
    ]
  ]
]
```
#preview-image(3)

== V4

The description looks bad with so much empty space, let's make it justified.
```typst
        ...
        [published: #published (#updated)],
        par(justify: true, linebreaks: "optimized", description),
        [tags: #tags.join(", ")],
        ...
```

I want category, time, words, and published in one row.
```typst
        ...
        table.header([= #title]),
        (
          [#category],
          [#time minute#if time > 1 { "s" }],
          [#words],
          [#published (#updated)],
        ).join([#h(1fr) | #h(1fr)]),
        par(justify: true, linebreaks: "optimized", description),
        ...
```

Let's do the same with tags.
```typst
        ...
        par(justify: true, linebreaks: "optimized", description),
        tags.join([#h(1fr) | #h(1fr)]),
      )
      ...
```

Final code:
```typst
#align(center + horizon)[
  #rect(
    height: 100% - 6em,
    width: 100% - 6em,
    stroke: white + 2pt,
  )[
    #align(left + top)[
      #table(
        columns: 1,
        stroke: white + 2pt,
        table.header([= #title]),
        (
          [#category],
          [#time minute#if time > 1 { "s" }],
          [#words],
          [#published (#updated)],
        ).join([#h(1fr) | #h(1fr)]),
        par(justify: true, linebreaks: "optimized", description),
        tags.join([#h(1fr) | #h(1fr)]),
      )
    ]
  ]
]
```
#preview-image(4)

== V5
OK, it's starting to look like _something_ now.

I think I want to get rid of the table outline.
```typst
        ...
        columns: 1,
        stroke: 0pt,
        table.header([= #title]),
        ...
```

Add some gaps
```typst
        ...
        stroke: 0pt,
        row-gutter: 1fr,
        table.header([= #title]),
        ...
```

The content sticks to the rect, let's put an inset so it's no longer sticking to the rect.
```typst
    ...
    stroke: white + 2pt,
    inset: 1em,
  )[
  ...
```

Ooooo, looking waaaay better now.
#preview-image(5)

== V6

I like rounded edges, let's add them to all the rects.

Since I want to affect all the rect, I can use a set rule.

Add this to the prelude
```typst
#set rect(radius: 5%)
```

But now, even the background is rounded, let's edit the rect in background to have radius 0
```typst
  ...
  width: page-width,
  background: rect(height: 100%, width: 100%, fill: bg-color, radius: 0pt),
  margin: 0pt,
  ...
```

You can go ahead and use this version if you want, but I feel like it's too plain, and I want to add some texture.
#preview-image(6)

== V7

Let's remove the table and instead use rects since I'm only using 1 column.
```typst
#align(center + horizon)[
  #rect(
    height: 100% - 6em,
    width: 100% - 6em,
    stroke: white + 2pt,
    inset: 1em,
  )[
    #align(left + top)[
      #rect[= #title]
      #rect((
        [#category],
        [#time minute#if time > 1 { "s" }],
        [#words],
        [#published (#updated)],
      ).join([#h(1fr) | #h(1fr)]))
      #rect(par(justify: true, linebreaks: "optimized", description))
      #rect(tags.join([#h(1fr) | #h(1fr)]))
    ]
  ]
]
```

Let's make it so all rects have a stroke of `white + 2pt`, take 100% of width, and instead of 5% radius, all the rects have a radius of `50pt`,
```typst
#set rect(
  radius: 50pt,
  stroke: white + 2pt,
  width: 100%,
  inset: 0.5em,
)
```

But now, because the description is so long, it overflows the outermost rect.
Let's make it description's rect takes the rest of the space and the overflow is cut off.

final code:
```typst
#align(center + horizon)[
  #rect(
    height: 100% - 6em,
    width: 100% - 6em,
    stroke: white + 2pt,
    inset: 1em,
  )[
    #align(left + top)[
      #rect[= #title]
      #rect((
        [#category],
        [#time minute#if time > 1 { "s" }],
        [#words],
        [#published (#updated)],
      ).join([#h(1fr) | #h(1fr)]))
      #block(clip: true, height: 1fr)[
        #rect(par(
          justify: true,
          linebreaks: "optimized",
          description,
        ))
      ]
      #rect(tags.join([#h(1fr) | #h(1fr)]))
    ]
  ]
]
```
#preview-image(7)

== V8

I want the tags and metadata to be in capsules, the easiest way would be wrap them in a rect with radius 100%.

Let's put it in a grid and set the width to auto since we don't want the rects to take the full width.
```typst
      ...
      #grid(
        columns: tags.len(),
        column-gutter: 1fr,
        ..tags.map(it => rect(it, width: auto))
      )
      ...
```

It works! But, there is a simpler way to do it using a stack.
```typst
      #stack(dir: ltr, spacing: 1fr, ..tags.map(it => rect(it, width: auto)))
```

Let's do it for the metadata as well.
#preview-image(8)

== V9

Let's work a bit on typography now.
The visual hierarchy should be Title > Description > Everything else

Let's deemphasize the rest by making them smaller.

Manually control the spacing between the rects and blocks by setting outset to 0.\
But that didn't do anything, time to go back to stack I guess.

And remove the inset from outermost rect to ensure the spacing is consistent.
```typst
#align(center + horizon)[
  #rect(
    height: 100% - 6em,
    width: 100% - 6em,
    stroke: white + 2pt,
  )[
    #align(left + top)[
      #stack(
        dir: ttb,
        spacing: 1fr,
        // Title
        rect[= #title],

        // Metadata
        block(stack(dir: ltr, spacing: 1fr, ..(
          [#category],
          [#time minute#if time > 1 { "s" }],
          [#words word#if words > 1 { "s" }],
          [started: #published],
          [updated: #updated],
        ).map(it => rect(
          text(
            it,
            size: 0.7em,
          ),
          width: auto,
        )))),

        // Description
        block(clip: true)[
          #rect(par(
            justify: true,
            linebreaks: "optimized",
            description,
          ))
        ],

        // Tags
        stack(dir: ltr, spacing: 1fr, ..tags.map(it => rect(
          text(it, size: 0.7em),
          width: auto,
        ))),
      )
    ]
  ]
]
```
#preview-image(9)

== V10

OK, so, to me the layout seems good. Let's work on the colours now.

I want the background to have a grid like graph paper.
```typst
// Create a tiling texture
// The size matters btw
// This will create an almost square, to create a perfect square the size has to be 12ptx12pt and that's too small
#let grid = tiling(size: (page-width / 25, page-height / 13))[
  #rect(stroke: white, radius: 0pt, fill: bg-color, height: 100%, width: 100%, inset: 0pt, outset: 0pt, {
    // divide the tile into subtiles
    for i in range(1, 10) {
      // create a vertical line
      place(dx: 10% * i, line(length: 100%, angle: 90deg, stroke: 0.2pt + white))
      // create a horizontal line
      place(dy: 10% * i, line(length: 100%, angle: 0deg, stroke: 0.2pt + white))
    }
    // make the halfway point lines thicker
    place(dx: 50%, line(length: 100%, angle: 90deg, stroke: 0.3pt + white))
    place(dy: 50%, line(length: 100%, angle: 0deg, stroke: 0.3pt + white))
  })
]

#set page(
  height: page-height,
  width: page-width,
  background: {
    rect(
      height: 100%,
      width: 100%,
      // set the fill to the grid
      fill: grid,
      radius: 0pt,
    )
  },
  margin: 0pt,
)
```

The background is a bit noisy, so it'd be best to add a bit of fill to the rects to make it feel less noisy.
```typst
#set rect(
  radius: 50pt,
  stroke: white + 2pt,
  // bg-color has 100% opacity, make it 50%
  fill: bg-color.transparentize(50%),
  width: 100%,
  inset: 0.5em,
)
```


OK, now that's pretty close to my template, but like, easier and cleaner lmao.

Let's change the spacing for tags,
```typst
        // Tags
        stack(dir: ltr, spacing: 1fr, ..(
          (h(1fr)),
          tags.map(it => rect(
            text(it, size: 0.7em),
            width: auto,
          )),
          (h(1fr)),
        ).flatten()),
```

Let's increase the number of lorem for description to 100 so it breaks our layout.

Let's split the rect into 3 parts: header, description, and footer.

The header contains the title, and the metadata inside the (vertical) stack.
the footer contains the tags inside the horizontal stack.
The description should just be a `block` with a paragraph since it looks weird to have a rect that's so far away from other rects.

```typst
#align(center + horizon)[
  #rect(
    height: 100% - 6em,
    width: 100% - 6em,
    stroke: white + 2pt,
  )[
    #align(left + top)[
      #stack(
        dir: ttb,
        spacing: 1em,

        // Title
        rect[= #title],

        // Metadata
        block(stack(dir: ltr, spacing: 1fr, ..(
          [#category],
          [#time minute#if time > 1 { "s" }],
          [#words word#if words > 1 { "s" }],
          [started: #published],
          [updated: #updated],
        ).map(it => rect(
          text(
            it,
            size: 0.7em,
          ),
          width: auto,
        )))),
      )

      // Description
      #block(clip: true, height: 1fr)[
        #par(justify: true, linebreaks: "optimized", description)
      ]

      // Tags
      #stack(dir: ltr, spacing: 1fr, ..(
        h(1fr),
        tags.map(it => rect(text(it, size: 0.7em), width: auto)),
        h(1fr),
      ).flatten())
    ]
  ]
]
```

Now, it looks weird to have nothing separating the description from header and footer, let's create a separator.
```typst
      #block(height: 1fr, above: 1em, below: 1em, {
        place(sep, dy: -0.5em)

        block(clip: true, height: 1fr)[
          // Description
          #par(justify: true, linebreaks: "optimized", description)
        ]

        place(sep, dy: 0.5em)
      })
```

Final code: #link("/example-template.typ")
#preview-image(10)

