#import "@preview/cetz:0.4.0"

#let thatched(bg, fg, thickness: 0.3pt) = tiling(size: (20pt, 20pt), cetz.canvas(background: bg, {
  import cetz.draw: *

  rotate(z: 45deg)
  let x = calc.sin(45deg) * 20pt
  rect((-x / 2, -x / 2), (x / 2, x / 2), stroke: (
    thickness: thickness,
    paint: fg,
    dash: "dashed",
  ))
}))

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
  box(width: 100%, grid(
    rows: 1,
    columns: items.len(),
    column-gutter: col-gutter,
    ..items.map(item => if in-rect {
      rect(item)
    } else {
      item
    })
  ))
}

#let json_str = sys.inputs.at("data", default: read("dummy_data.json"))

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

#let sep = line(length: 100%, stroke: (
  thickness: 5pt,
  dash: (2em, 1em),
  cap: "round",
))

#let stringify-by-func(it) = {
  let func = it.func()
  return if func in (parbreak, pagebreak, linebreak) {
    "\n"
  } else if func == smartquote {
    if it.double { "\"" } else { "'" } // "
  } else if it.fields() == (:) {
    // a fieldless element is either specially represented (and caught earlier) or doesn't have text
    ""
  } else if it.has("tag") {
    // ignore html.elem without body
    ""
  } else {
    panic("Not sure how to handle type `" + repr(func) + "`")
  }
}

#let plain-text(it) = {
  return if type(it) == str {
    it
  } else if it == [ ] {
    " "
  } else if it.has("children") {
    it.children.map(plain-text).join()
  } else if it.has("body") {
    plain-text(it.body)
  } else if it.has("text") {
    if type(it.text) == str {
      it.text
    } else {
      plain-text(it.text)
    }
  } else {
    // remove this to ignore all other non-text elements
    stringify-by-func(it)
  }
}

/// lossily converts the content into string
///
/// - it (any):
/// -> str
#let to-string(it, strict: false) = {
  if strict {
    return plain-text(it)
  }

  if type(it) == str {
    it
  } else if type(it) != content {
    str(it)
  } else if it.has("text") {
    it.text
  } else if it.has("children") {
    it.children.map(to-string).join()
  } else if it.has("body") {
    to-string(it.body)
  } else if it == [ ] {
    " "
  }
}

#let slugify(text, map) = {
  text = to-string(text, strict: true)
  text = lower(text)
  text = text.replace(regex("[^a-z0-9\\s-]"), "")
  text = text.replace(regex("\\s+"), "-")
  text = text.replace(regex("-+"), "-")
  text = text.replace(regex("^-+|-+$"), "")

  let i = map.at(text, default: 0)
  map.insert(text, i + 1)

  if i != 0 {
    text = text + "-" + str(i)
  }

  return (text, map)
}

#let slugify-map = state("slugify-map", (:))

#let reading-time(words, wpm: 200) = {
  return words / wpm
}

#let divider = {
  //<div class="border-[var(--line-divider)] border-dashed border-b-[1px] mb-5"></div>
  html.elem("div", attrs: (class: "border-[var(--line-divider)] border-dashed border-b-[1px] mb-5"))
}

///
///
/// - font (text.font): font to use
/// - fallback-type: "serif" | "sans-serif" | "monospace" | "cursive" | "fantasy" | "system-ui" | "ui-serif" | "ui-sans-serif" | "ui-monospace" | "ui-rounded" | "emoji" | "math" | "fangsong"
/// - content (content): content... duh
/// -> context
#let font(font, fallback-type, italic: false, weight: "regular", content) = context {
  let c = if content == none or content == [] or content == "" {
    [#to-string(font) #if weight != "regular" [weight: #weight] #if italic [(italic)]]
  } else {
    content
  }
  if target() == "html" {
    html.elem(
      "span",
      attrs: (
        style: "font-family: '"
          + font
          + "', "
          + fallback-type
          + if italic { "; font-style: italic" }
          + "; font-weight: "
          + str(weight)
          + ";",
      ),
      c,
    )
  } else if target() == "paged" {
    text(font: font, weight: weight, if italic {
      emph(
        c,
      )
    } else { c })
  }
}

#let fraunces(content, weight: "regular", italic: false) = font(
  "Fraunces Variable",
  "serif",
  weight: weight,
  italic: italic,
  content,
)


#let faculty-glyphic(content, weight: "regular", italic: false) = font(
  "Faculty Glyphic",
  "serif",
  weight: weight,
  italic: italic,
  content,
)

#let nanum-myeongjo(content, weight: "regular", italic: false) = font(
  "Nanum Myeongjo",
  "serif",
  weight: weight,
  italic: italic,
  content,
)

#let kalnia(content, weight: "regular", italic: false) = font(
  "Kalnia Variable",
  "serif",
  weight: weight,
  italic: italic,
  content,
)

#let atkinson-mono(content, weight: "regular", italic: false) = font(
  "Atkinson Hyperlegible Mono Variable",
  "monospace",
  weight: weight,
  italic: italic,
  content,
)
#let atkinson(content, weight: "regular", italic: false) = font(
  "Atkinson Hyperlegible Next Variable",
  "sans-serif",
  weight: weight,
  italic: italic,
  content,
)


#let jetbrains-mono(content, weight: "regular", italic: false) = if italic {
  font("Jetbrains Mono Italic", "monospace", weight: weight, italic: italic, content)
} else {
  font("Jetbrains Mono", "monospace", weight: weight, italic: italic, content)
}

#let argon(content, weight: "regular", italic: false) = font(
  "Monaspace Argon",
  "monospace",
  weight: weight,
  italic: italic,
  content,
)
#let krypton(content, weight: "regular", italic: false) = font(
  "Monaspace Krypton",
  "monospace",
  weight: weight,
  italic: italic,
  content,
)
#let neon(content, weight: "regular", italic: false) = font(
  "Monaspace Neon",
  "monospace",
  weight: weight,
  italic: italic,
  content,
)
#let radon(content, weight: "regular", italic: false) = font(
  "Monaspace Radon",
  "monospace",
  weight: weight,
  italic: italic,
  content,
)
#let xenon(content, weight: "regular", italic: false) = font(
  "Monaspace Xenon",
  "monospace",
  weight: weight,
  italic: italic,
  content,
)

#let blog-post(title, description: lorem(20), image: none, tags: (), category: none, args: (:), content) = {
  let words = to-string(content).split(" ").len()
  let minutes = int(reading-time(words))

  [
    #metadata((
      title: title,
      description: description,
      tags: tags,
      category: category,
      ..if image != none { (image: image) } else { (:) },
      words: words,
      minutes: minutes,
      ..args,
    ))<frontmatter>
  ]

  context {
    if target() == "html" {
      show heading: it => context {
        let (id, m) = slugify(it.body, slugify-map.get())
        slugify-map.update(m)

        let level = it.level
        let italic = level > 3
        let weight = (6 - level + 1) * 100

        html.elem(
          "h" + str(level),
          attrs: (
            id: id,
            style: "font-family: 'Kalnia Variable', serif"
              + if italic { "; font-style: italic" }
              + "; font-weight: "
              + str(weight)
              + ";",
          ),
          {
            it.body
            html.elem("a", attrs: (href: "#" + id, class: "anchor"), html.elem(
              "span",
              attrs: (class: "anchor-icon", data-pagefind-ignore: ""),
              "#",
            ))
          },
        )
      }

      show: html.elem.with("article", attrs: (style: "text-align: justify; hyphens: manual;"))

      if description != "" or description != [] {
        [
          Description:
          #description
          #divider
        ]
      }

      content
    } else {
      if description != "" or description != [] {
        [
          Description:
          #description
          #divider
        ]
      }

      content
    }
  }
}

#let section = html.elem.with("section")
#let checkbox(completed, active: false) = box(html.elem("input", attrs: (
  type: "checkbox",
  ..if completed { (checked: "true") },
  ..if not active { (disabled: "true") },
)))
#let img(src, alt: "") = html.elem("img", attrs: (
  src: src,
  ..if alt != "" { (alt: alt) },
  class: "max-width: 100%; height: auto;",
  loading: "lazy",
))
#let bluesky-embed(
  author-did,
  post-id,
  data-bluesky-cid,
  author,
  handle,
  time,
  content,
) = {
  html.elem(
    "div",
    attrs: (
      class: "bluesky-embed",
      data-bluesky-uri: "at://" + author-did + "/app.bsky.feed.post/" + post-id,
      data-bluesky-cid: data-bluesky-cid,
      data-bluesky-embed-color-mode: "system",
    ),
    quote(
      block: true,
      attribution: [
        #author (#link("https://bsky.app/profile/" + author-did + "?ref_src=embed", handle))
        #link(
          "https://bsky.app/profile/" + author-did + "/post/" + post-id + "?ref_src=embed",
          time,
        )
      ],
      content,
    ),
  )
  html.elem("script", attrs: (async: "true", src: "https://embed.bsky.app/static/embed.js", charset: "utf-8"))
}
