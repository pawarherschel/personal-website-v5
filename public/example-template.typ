#let fg-color = rgb("#e1bad0")
#let bg-color = rgb("#130d13")

#let page-height = 1572pt
#let page-width = 3000pt

#let grid = tiling(size: (page-width / 25, page-height / 13))[
  #rect(stroke: white, radius: 0pt, fill: bg-color, height: 100%, width: 100%, inset: 0pt, outset: 0pt, {
    for i in range(1, 10) {
      place(dx: 10% * i, line(length: 100%, angle: 90deg, stroke: 0.2pt + white))
      place(dy: 10% * i, line(length: 100%, angle: 0deg, stroke: 0.2pt + white))
    }
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
      fill: grid,
      radius: 0pt,
    )
  },
  margin: 0pt,
)

#let json_str = read("dummy_post_data.json")

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
) = json(bytes(json_str))

#if title == "" {
  title = lorem(10)
}
#if description == "" {
  description = lorem(100)
}

#set text(
  size: page-height * 4%,
  fill: fg-color,
  font: "Jetbrains Mono",
  hyphenate: true,
)

#set rect(
  radius: 1em,
  stroke: white + 2pt,
  fill: bg-color.transparentize(50%),
  width: 100%,
  inset: 0.5em,
)

#let sep = box(width: 1fr, outset: 0pt, inset: 0pt, line(
  length: 100%,
  stroke: white + 2pt,
))

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

      #block(height: 1fr, above: 1em, below: 1em, {
        place(sep, dy: -0.5em)

        block(clip: true, height: 1fr)[
          // Description
          #par(justify: true, linebreaks: "optimized", description)
        ]

        place(sep, dy: 0.5em)
      })

      // Tags[
      #stack(
        dir: ltr,
        spacing: 1fr,
        ..(
          h(1fr),
          tags.map(it => rect(text(it, size: 0.7em), width: auto)),
          h(1fr),
        ).flatten(),
      )
    ]
  ]
]
