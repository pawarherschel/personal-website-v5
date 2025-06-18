#import "@preview/cetz:0.4.0"

#let thatched(bg, fg, thickness: 0.3pt) = tiling(
  size: (20pt, 20pt),
  cetz.canvas(
    background: bg,
    {
      import cetz.draw: *

      rotate(z: 45deg)
      let x = calc.sin(45deg) * 20pt
      rect(
        (-x / 2, -x / 2),
        (x / 2, x / 2),
        stroke: (
          thickness: thickness,
          paint: fg,
          dash: "dashed",
        ),
      )
    },
  ),
)

/// https://fonts.google.com/icons
///
/// Click on the icon you want,
/// in the panel on right-hand side,
/// scroll down till you see the field "Code point".
/// Use that as the codepoint
///
/// Example:
/// ```typc
/// #material(0xe91d) // for the icon "pets"
/// ```
///
/// - codepoint (int): code point obtained from google fonts
/// - variant ("outlined" | "sharp" | "rounded"): icon variant / style
/// -> text
#let material(codepoint, variant: "outlined") = {
  text(
    font: if variant == "outlined" {
      "Material Symbols Outlined"
    } else if variant == "sharp" {
      "Material Symbols Sharp"
    } else if variant == "rounded" {
      "Material Symbols Rounded"
    } else {
      panic("Unknown font variant: " + variant)
    },
    str.from-unicode(codepoint),
    // top-edge: "baseline",
    // bottom-edge: "baseline",
  )
}

#let parse-date(s) = {
  if type(s) != str {
    panic("Passed date isn't string")
  }

  if s.len() < "YYYY-MM-DD".len() or s.at(4) != "-" or s.at(7) != "-" {
    panic(
      "Passed date couldn't be parsed correctly\n"
        + "Possible errors:\n"
        + "s.len() < \"YYYY-MM-DD\".len()"
        + s.len()
        + "\n"
        + "s.at(5) != \"-\": "
        + s.at(5)
        + "\n"
        + "s.at(7) != \"-\""
        + s.at(7),
    )
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

#let row-with-equal-spaces(items, in-rect: true, col-gutter: 1em) = {
  box(
    width: 100%,
    grid(
      rows: 1,
      columns: items.len(),
      column-gutter: col-gutter,
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
  default: read("dummy_data.json"),
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

#let published = parse-date(published)
#let updated = parse-date(updated)

#let highlight-color(c, ratio: 20%) = {
  let (l, a, b, alpha) = c.oklab().components()
  let remaining_l = 100% - l
  let highlight = ratio * remaining_l

  oklab(l + highlight, a, b, alpha).rgb()
}

#let sep = line(
  length: 100%,
  stroke: (
    thickness: 5pt,
    dash: (2em, 1em),
    cap: "round",
  ),
)
