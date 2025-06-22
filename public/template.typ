#import "@preview/fontawesome:0.5.0": *
#import "utils.typ": *

#let fg-color = rgb("#e1bad0")
#let bg-color = rgb("#130d13")

#let bg-color-accent = highlight-color(bg-color)
#let bg-color-accent-accent = highlight-color(bg-color-accent, ratio: 30%)

#let rect-color = {
  let bg-color-components = bg-color.oklab().components()
  let fg-color-components = fg-color.oklab().components()

  let (l, a, b, alpha) = bg-color-components
    .zip(fg-color-components)
    .map(c => {
      let (a, b) = c
      let bias = 50%
      a * (bias) + b * (100% - bias)
    })
    .map(c => c * 0.5)

  oklab(l, a, b, 70%).rgb()
}

#let page-height = 1572pt
#let page-width = 3000pt

#set page(
  height: page-height,
  width: page-width,
)

#set page(background: [
  #cetz.canvas(background: bg-color, {
    import cetz.draw: *
    grid(
      (-page-width / 2 + 3em, page-height * 90%),
      (page-width / 2 + 3em, -page-height * 10% - 1em),
      stroke: (thickness: 1pt, paint: bg-color-accent, dash: "dashed"),
      step: 0.5em,
    )
    grid(
      (-page-width / 2 + 3em, page-height * 90%),
      (page-width / 2 + 3em, -page-height * 10% - 1em),
      stroke: (
        thickness: 3pt,
        paint: bg-color-accent-accent,
      ),
      step: 2em,
    )
  })
])

#set text(
  size: page-height * 4%,
  fill: fg-color,
  font: "Jetbrains Mono",
  hyphenate: true,
)

#set rect(
  fill: thatched(
    rect-color,
    highlight-color(rect-color),
    thickness: 1.5pt,
  ),
  inset: 0.5em,
  radius: 0.5em,
  // stroke: 5pt + fg-color,
  stroke: 5pt + fg-color,
)
#set line(stroke: fg-color)
#show heading.where(depth: 1): set heading(numbering: (..n) => "=")

#show: rect.with(fill: rect-color)

#grid(
  row-gutter: 0.5em,
  columns: 100%,
  rect(width: 100%)[
    #align(left + horizon)[
      = #if title.len() == 0 {
        lorem(12)
      } else { title }
    ]
  ],

  {
    set text(size: 0.75em)
    row-with-equal-spaces((
      (0xf53e, [#category]),
      (0xe935, [#published.display()]),
      (0xe742, [#updated.display()]),
      (0xe26c, [#words words]),
      (0xe8b5, [#time #[minute]#if time != 1 { [s] }]),
    )
      .map(((codepoint, c)) => {
        box[
          #material(codepoint)
          #box(height: 1em)[#align(center + horizon, c)]
        ]
      })
      .map(it => box(width: 1fr, it)))
  },

  sep,
)

#block(breakable: false, height: 1fr, width: 100%, clip: true, above: 0.5em, below: 0.5em, par(
  justify: true,
  linebreaks: "optimized",
  if description.len() == 0 {
    lorem(100)
  } else { description },
))

#if tags.len() > 0 {
  grid(
    row-gutter: 0.5em,
    columns: 100%,
    sep,
    block(width: 100%, {
      set text(size: 0.6em)

      let tags = tags
        .map(it => (0xe9ef, it))
        .map(((codepoint, c)) => {
          box[
            #material(codepoint)
            #box(height: 1em)[#align(center + horizon, c)]
          ]
        })

      if tags.len() <= 4 {
        block(width: 100%, for tag in tags.map(it => box(rect(it))).intersperse(h(2em)) {
          tag
        })
      } else {
        row-with-equal-spaces(tags, col-gutter: 1fr)
      }
    }),
  )
}
