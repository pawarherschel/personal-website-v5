#let parse-iso-datetime(s) = {
  if type(s) != str {
    return datetime.today()
  }

  if s.len() < "YYYY-MM-DD".len() or s.at(5) != "-" or s.at(8) != "-" {
    return datetime.today()
  }

  let year-str = s.slice(0, 4)
  let month-str = s.slice(5, 7)
  let day-str = s.slice(8, 10)

  let year = int(year-str)
  let month = int(month-str)
  let day = int(day-str)

  datetime(
    year: year,
    month: month,
    day: day,
  )
}

#let row-with-equal-spaces(items, in-rect: true) = {
  box(
    width: 100%,
    grid(
      rows: 1,
      columns: items.len(),
      column-gutter: 1fr,
      ..items.map(item => if in-rect {
        rect(item)
      } else {
        item
      })
    ),
  )
}

#let json_str = sys.inputs.at(
  "data",
  default: "{
	\"data\": {
		\"title\": \"title\",
		\"description\": \"description\",
		\"tags\": [\"tag1\", \"tag2\", \"tag3\"],
		\"category\": \"category\"
	},
	\"payload\": {
		\"time\": 1,
		\"words\": 5,
		\"published\": \"2025-06-15\",
		\"updated\": \"2025-06-17\"
	}
}",
)

#let data = json(bytes(json_str))

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
) = data

#let published = parse-iso-datetime(published)
#let updated = parse-iso-datetime(updated)

#let page-height = 1572pt
#let page-width = 3000pt

#set page(
  height: page-height,
  width: page-width,
)

#let highlight-color(c, ratio: 20%) = {
  let (l, a, b, alpha) = c.oklab().components()
  let remaining_l = 100% - l
  let highlight = ratio * remaining_l

  oklab(l + highlight, a, b, alpha)
}

#let highlighted-pair(content, display, color) = {
  highlight(
    extent: 0.2em,
    radius: 0.3em,
    fill: highlight-color(color),
  )[#content]
  [ ]
  display
}

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

  oklab(l, a, b, 70%)
}

#set page(
  background: [
    #rect(
      stroke: none,
      radius: 0%,
      width: 100%,
      height: 100%,
      fill: tiling(
        size: {
          let x = 5%
          (page-width * x, page-height * x)
        },
      )[
        // Background Color
        #place[
          #rect(
            width: 100%,
            height: 100%,
            fill: bg-color,
          )
        ]

        // Subgrid
        #place[
          #let thresholds = (25%, 50%, 75%)
          #let s = (
            thickness: 1pt,
            paint: bg-color-accent,
            dash: "dashed",
          )

          #for x in thresholds {
            place[
              #line(
                start: (0%, x),
                end: (100%, x),
                stroke: s,
              )
            ]
          }
          #for y in thresholds {
            place[
              #line(
                start: (y, 0%),
                end: (y, 100%),
                stroke: s,
              )
            ]
          }
        ]

        // Grid
        #place[
          #rect(
            width: 100%,
            height: 100%,
            stroke: (
              thickness: 2pt,
              paint: bg-color-accent-accent,
            ),
            fill: none,
          )
        ]

      ],
    )
  ],
)

#set text(
  size: page-height * 4%,
  fill: fg-color,
  stroke: fg-color,
)
#set rect(
  fill: rect-color,
  inset: 0.5em,
  radius: 0.5em,
  stroke: 5pt + fg-color,
)
#set line(stroke: fg-color)
#show heading.where(depth: 1): set heading(numbering: (..n) => "=" * 1)

#let sep = rect(
  height: 0.01em,
  width: 100%,
)

#rect(height: 100%, width: 100%)[
  #grid(
    row-gutter: 0.5em,
    rect[
      #box(width: 1fr)[
        #align(left + horizon)[= #title]
      ]
    ]
    , row-with-equal-spaces((
      box[Published #box[#published.display()]],
      box[Updated #box[#updated.display()]],
      box[Words #box[#words]],
      box[Time #box[#time #[minute]#if time != 1 { [s] }]],
      [[#category]],
    ))
  )

  #sep

  #par(justify: true, linebreaks: "optimized")[
    #{
      description
    }
  ]

  #{
    if tags.len() > 0 {
      align(bottom + center)[
        #let total_tags_width = tags.map(t => t.len()).sum()

        #sep

        #if tags.len() > 4 {
          row-with-equal-spaces(tags)
        } else {
          align(
            left + horizon,

            for c in tags.map(tag => box(rect(tag))).intersperse(h(1em)) {
              c
            },
          )
        }
      ]
    }
  }
]
