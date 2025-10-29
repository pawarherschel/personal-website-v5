#import "@preview/cetz:0.4.0"

#let thatched(bg, fg, thickness: 0.3pt) = tiling(
  size: (20pt, 20pt),
  cetz.canvas(background: bg, {
    import cetz.draw: *

    rotate(z: 45deg)
    let x = calc.sin(45deg) * 20pt
    rect((-x / 2, -x / 2), (x / 2, x / 2), stroke: (
      thickness: thickness,
      paint: fg,
      dash: "dashed",
    ))
  }),
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

#let data(tag) = {
  let json_tag = sys.inputs.at("tag", default: tag)
  let json_str = sys.inputs.at("data", default: read(if json_tag == "post" {
    "dummy_post_data.json"
  } else if json_tag == "other" {
    "dummy_other_data.json"
  } else { panic(repr(sys.inputs)) }))

  json(bytes(json_str))
}

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

#let stringify-by-func(it, strict) = {
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
  } else if strict {
    panic("Not sure how to handle type `" + repr(func) + "`")
  }
}

/// lossily converts the content into string
///
/// - it (any):
/// -> str
#let to-string(it, strict: false) = {
  return if type(it) == str {
    it
  } else if it == [ ] {
    " "
  } else if it.has("children") {
    it.children.map(to-string.with(strict: strict)).join()
  } else if it.has("body") {
    to-string(it.body, strict: strict)
  } else if it.has("text") {
    if type(it.text) == str {
      it.text
    } else {
      to-string(it.text, strict: strict)
    }
  } else {
    stringify-by-func(it, strict)
  }
}

#let rust-btw(
  pre: [],
  post: [],
) = [(#if pre != [] { [#pre ] }Rust btw#sym.trademark#if post != [] { [#post ] })]

#let typst(
  pre: [],
  post: [],
) = [#if pre != [] { [#pre ] }#link("https://typst.app/")[Typst]#if post != [] {
    [#post ]
  }]


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


#let script(
  script,
  data: (:),
  scoped: true,
) = {
  if not script.has("text") {
    panic()
  }
  if not script.has("lang") {
    panic()
  }
  if not (script.at("lang") == "javascript" or script.at("lang") == "js") {
    panic()
  }
  if script.text.len() == 0 {
    panic()
  }

  let data-loading = ""
  for (var, value) in data {
    if type(value) == str {
      value = "'" + value + "'"
    }
    data-loading += (
      "const " + var + " = " + value + ";"
    )
  }

  let script-text = (
    if scoped { "(function (){" } else { "" }
      + data-loading
      + script.text
      + if scoped { "})();" } else { "" }
  )

  html.elem("script", script-text)
}

#let slugify-map = state("slugify-map", (:))

#let reading-time(words, wpm: 200) = {
  return words / wpm
}

//<div class="border-[var(--line-divider)] border-dashed border-b-[1px] mb-5"></div>
#let divider = context {
  if target() == "html" {
    html.elem("div", attrs: (
      class: "border-[var(--line-divider)] border-dashed border-b-[1px] mb-5",
    ))
  } else {
    line(length: 100%)
  }
}

///
///
/// - font (text.font): font to use
/// - fallback-type: "serif" | "sans-serif" | "monospace" | "cursive" | "fantasy" | "system-ui" | "ui-serif" | "ui-sans-serif" | "ui-monospace" | "ui-rounded" | "emoji" | "math" | "fangsong"
/// - content (content): content... duh
/// -> context
#let font(
  font,
  fallback-type,
  italic: false,
  weight: "regular",
  content,
) = context {
  let c = if content == none or content == [] or content == "" {
    [#to-string(font) #if (
        weight != "regular"
      ) [weight: #weight] #if italic [(italic)]]
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
  font(
    "Jetbrains Mono Italic",
    "monospace",
    weight: weight,
    italic: italic,
    content,
  )
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



#let admonition(type, title, content) = {
  if type not in ("tip", "note", "important", "caution", "warning") {
    panic("invalid type: ", type)
  }

  context if target() != "html" {
    let color = if type == "tip" {
      oklch(70%, 0.14, 180deg)
    } else if type == "note" {
      oklch(70%, 0.14, 250deg)
    } else if type == "important" {
      oklch(70%, 0.14, 310deg)
    } else if type == "caution" {
      oklch(70%, 0.14, 60deg)
    } else if type == "warning" {
      oklch(60%, 0.2, 25deg)
    } else {
      panic(color)
    }

    block(
      above: 2em,
      stroke: 0.5pt + color,
      width: 100%,
      inset: 14pt,
    )[
      #place(
        top + left,
        dy: -6pt - 14pt, // Account for inset of block
        dx: 6pt - 14pt,
        block(fill: white, inset: 2pt)[*#text(title, fill: color)*],
      )
      #content
    ]
  } else {
    html.elem("blockquote", attrs: (class: "admonition bdm-" + type), {
      html.elem("span", attrs: (class: "bdm-title"), title)
      parbreak()
      content
    })
  }
}
#let note(title: "Note", content) = admonition("note", title, content)
#let tip(title: "Tip", content) = admonition("tip", title, content)
#let important(title: "Important", content) = admonition(
  "important",
  title,
  content,
)
#let caution(title: "Caution", content) = admonition("caution", title, content)
#let warning(title: "Warning", content) = admonition("warning", title, content)

#let completed-but-not-removed = state("completed-todo", false)

#let todo(c, completed: none, plain: false) = if completed == none {
  show figure.caption: none
  figure(
    kind: "todo",
    caption: c,
    supplement: "todo",
    if plain { c } else {
      caution(
        title: "TODO",
        c,
      )
    },
  )
} else {
  completed-but-not-removed.update(true)
  completed
}

#let pdf-rem = 12pt

#let proofreaders-list = (
  dummy: (
    name: "None TODO",
  ),
  divyesh: (
    id: "dpatil",
    name: "Divyesh Patil",
    shills: (
      link("https://www.linkedin.com/in/divyesh-patil-525808257/")[LinkedIn],
    ),
    comments: (
      [I met Divyesh during college while volunteering for out college's chapter of IEEE. Ever since then we've been collaborating and teaching each other whatever we come across.],
      [Divyesh likes to read -- at least for me -- complicated books, and is into a lot of niche music.],
    ),
  ),
  andrew: (
    name: "Andrew",
    shills: (
      link("https://codeberg.org/Andrew15-5")[Codeberg],
    ),
  ),
)

// #let friends = read("../src/content/friends/friends.toml")

#let tilslut-type = (
  blogpost: "blogpost",
  no-type: "no type",
)

#let tilslut-entry(
  title: "Title",
  by: "Author",
  type: "no type",
  url: "https://example.com/",
  comment: "No comment " + emoji.face.sad,
  image-link: none,
  image-alt: none,
  links: (),
) = {
  if not tilslut-type.values().contains(type) {
    panic("Type " + type + " has not been registered yet")
  }

  comment = comment.trim()

  links = links.map(it => (link: it.dest, text: to-string(it.body)))

  (
    title: title,
    by: by,
    type: type,
    url: url,
    comment: comment,
    imageLink: image-link,
    imageAlt: image-alt,
    links: links,
  )
}

#let blog-post(
  title,
  description: lorem(20),
  image: none,
  tags: lorem(4).split(" "),
  category: "Uncategorized",
  args: (:),
  assumed-audience: lorem(6).split(" "),
  proofreaders: (proofreaders-list.dummy,),
  draft: false,
  tilslut: (),
  content,
) = {
  let description = to-string(if description == [] { "" } else {
    description
  }).trim()
  import "@preview/wordometer:0.1.4": total-words, word-count
  set document(description: description, title: title, keywords: tags)
  set cite(form: "full")
  context [
    #let manual-words = (
      to-string(content).split(regex("\s")).filter(it => it.trim() != "").len()
    )
    #let words = if state("total-words").final() > manual-words {
      state("total-words").final()
    } else { manual-words }
    #let minutes = int(reading-time(words))
    #metadata((
      title: title,
      description: to-string(description),
      draft: draft,
      tags: tags,
      category: if category == none { "Category" } else { category },
      ..if image != none { (image: image) } else { (:) },
      words: words,
      minutes: minutes,
      headings: {
        let map = (:)
        query(heading).map(h => {
          let (slug, map) = slugify(h.body, map)
          (
            depth: h.level,
            slug: slug,
            text: to-string(h.body),
          )
        })
      },
      tilslut: tilslut,
      ..args,
    ))<frontmatter>
  ]


  show: word-count
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
      let charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"
      let hash(s, pos) = {
        let s = repr(s) + repr(pos)
        let max = repr(s).len()
        repr(s)
          .codepoints()
          .map(it => it.to-unicode())
          .map(it => int(it))
          .windows(16)
          .reduce((a, b) => a
            .zip(b)
            .map(((a, b)) => calc.rem(a + a.bit-xor(b), charset.len())))
          .map(c => charset.at(c))
          .join()
      }

      show math.equation.where(block: false): it => context {
        html.elem(
          "span",
          attrs: (
            id: hash(it, here().position()),
            style: "display: inline-block;",
            class: "math dark:invert",
          ),
          {
            html.frame(it)
          },
        )
      }
      show math.equation.where(block: true): it => context {
        html.elem(
          "div",
          attrs: (id: hash(it, here().position()), class: "math dark:invert"),
          {
            html.frame(it)
          },
        )
      }

      show sub: it => html.elem("sub", it)
      show super: it => html.elem("sup", it)

      import "typst-hypraw/src/lib.typ": html-script, html-style, hypraw
      show: hypraw
      html-script(read("typst-hypraw/examples/copy-to-clipboard.js"))
      html-style(read("typst-hypraw/examples/copy-button-styles.css"))
      // hypraw-style(read("typst-hypraw/examples/example.css"))

      show: html.elem.with("article", attrs: (
        style: "text-align: justify; hyphens: manual;",
      ))

      if description != "" or description != [] or description.len() != 0 {
        [
          Description:
          #description
          #divider
          #note(title: "Assumed Audience", list(..assumed-audience))
          #divider
          #context if query(figure.where(kind: "todo")).len() > 0 {
            caution[THIS IS A WORKING DRAFT]
            context if completed-but-not-removed.final() {
              todo[remove completed todos]
            }
            warning(title: "Todos")[
              #context enum(
                ..query(figure.where(kind: "todo")).map(it => it.caption.body),
              )
            ]
            divider
          }
        ]
      }

      show footnote: it => {
        show super: it2 => {
          html.elem(
            "span",
            attrs: (
              class: "footnote-container group",
            ),
            {
              html.elem(
                "a",
                attrs: (
                  class: "footnote-tooltip font-index text-iris cursor-pointer select-none",
                  onclick: "this.parentElement.classList.toggle('show-tooltip')",
                  role: "button",
                  aria-label: "Toggle footnote",
                ),
                [[#it2.body]],
              )
              html.elem(
                "span",
                attrs: (
                  class: "sr-only group-[.show-tooltip]:hidden",
                  aria-label: "Footnote content",
                ),
                it.body,
              )
              html.elem(
                "span",
                attrs: (
                  class: "hidden group-[.show-tooltip]:block min-w-full footnote-body",
                ),
                {
                  it.body
                },
              )
            },
          )
        }
        it
      }

      [
        #content

        #divider
        #if proofreaders != none [
          = Proofreaders
          #if (
            proofreaders == () or proofreaders == (proofreaders-list.dummy,)
          ) {
            todo[Find and add proofreaders]
          } else {
            for entry in proofreaders [
              #let name = entry.at("name")
              #let shills = entry.at("shills", default: ())
              #let comments = entry.at("comments", default: ())

              == #name
              #for comment in comments [#comment\n]
              === Links
              #for shill in shills [- #shill]
            ]
          }
        ]
        #divider
      ]
    } else {
      set page(header: [#title])
      set par(justify: true, linebreaks: "optimized")
      set text(
        font: "Fraunces 72pt",
        size: pdf-rem * 1.15,
        features: (
          "SOFT",
          "WONK",
          "opsz",
          "wght",
        ),
        fallback: false,
      )
      show link: set text(font: "Atkinson Hyperlegible Mono")
      set heading(numbering: (..nums) => if nums.pos().len() == 1 {
        "Section " + upper(numbering("I", ..nums)) + "."
      } else {
        numbering("I.1.a.१.", ..nums)
      })

      show heading.where(depth: 1): set text(size: 2.4 * pdf-rem)
      show heading.where(depth: 2): set text(size: 2 * pdf-rem)
      show heading.where(depth: 3): set text(size: 1.6 * pdf-rem)
      show heading.where(depth: 4): set text(size: 1.82 * pdf-rem)

      if description != "" or description != [] {
        [
          Description:
          #description
          #divider
          #note(title: "Assumed Audience", list(..assumed-audience))
          #divider
          #context if query(figure.where(kind: "todo")).len() > 0 {
            warning(title: "Todos")[
              #context enum(
                ..query(figure.where(kind: "todo")).map(it => it.caption.body),
              )
            ]
            divider
          }
        ]
      }


      content

      divider
      [= Proofreaders]
      if (
        proofreaders == ()
          or proofreaders == none
          or proofreaders == (proofreaders-list.dummy,)
      ) {
        todo[Find and add proofreaders]
      } else {
        for entry in proofreaders [
          #let name = entry.at("name")
          #let shills = entry.at("shills", default: ())
          #let comments = entry.at("comments", default: ())

          == #name
          #for comment in comments [#comment]
          === Links
          #for shill in shills [- #shill]
        ]
      }
    }
  }
}

#let section(content) = {
  context if target() != "html" {
    panic()
  }
  html.elem("section", content)
}

#let checkbox(completed, active: false) = context {
  if target() == "html" {
    box(html.elem("input", attrs: (
      type: "checkbox",
      ..if completed { (checked: "true") },
      ..if not active { (disabled: "true") },
    )))
  } else {
    if active { sym.checkmark } else { sym.crossmark }
  }
}

#let img(src, alt: "") = context {
  if target() == "html" {
    html.elem("img", attrs: (
      src: src,
      ..if alt != "" { (alt: alt) },
      class: "max-width: 100%; height: auto;",
      loading: "lazy",
    ))
  } else {
    [img: unimplemented, please go to #link("src") to checkout the image]
  }
}

#let video(
  src,
  width: 1920,
  height: 1080,
  type: "video/mp4",
  loop: true,
  preload: "auto",
) = context {
  if target() == "html" {
    html.elem(
      "video",
      attrs: (
        width: str(width),
        height: str(height),
        controls: "true",
        ..if loop { (loop: "true") },
        preload: preload,
      ),
      {
        html.elem("source", attrs: (
          src: src,
          type: type,
        ))
        [
          Your browser does not support the video tag or the video type(#type).

          You can use #link(src)[this link] to view the video.
        ]
      },
    )
  } else {
    [video: unimplemented, please go to #link("src") to checkout the video]
  }
}

#let bluesky-embed(
  author-did,
  post-id,
  data-bluesky-cid,
  author,
  handle,
  time,
  content,
) = {
  context {
    if target() == "html" {
      html.elem(
        "div",
        attrs: (
          class: "bluesky-embed",
          data-bluesky-uri: "at://"
            + author-did
            + "/app.bsky.feed.post/"
            + post-id,
          data-bluesky-cid: data-bluesky-cid,
          data-bluesky-embed-color-mode: "system",
        ),
        quote(
          block: true,
          attribution: [
            #author (#link("https://bsky.app/profile/" + author-did + "?ref_src=embed", handle))
            #link(
              "https://bsky.app/profile/"
                + author-did
                + "/post/"
                + post-id
                + "?ref_src=embed",
              time,
            )
          ],
          content,
        ),
      )
      html.elem("script", attrs: (
        async: "true",
        src: "https://embed.bsky.app/static/embed.js",
        charset: "utf-8",
      ))
    } else {
      link("https://bsky.app/profile/" + author-did + "/post/" + post-id, quote(
        attribution: link(
          "https://bsky.app/profile/" + author-did,
        )[#author (#handle) at #time],
        block: true,
      )[#content])
    }
  }
}

#let github-card(repo) = {
  if repo.find("/") == none {
    panic(
      "Invalid repository. 'repo' attribute must be in the format 'owner/repo'",
    )
  }

  let owner = repo.split("/").at(0)
  let repo-name = repo.split("/").at(1)
  let card-uuid = "GC-" + slugify(repo, (:)).at(0)

  let script = script(
    ```javascript
    fetch(`https://api.github.com/repos/${repo}`, { referrerPolicy: 'no-referrer' })
    .then((response) => {
      if (!response.ok) {
        return response.json().then(errorData => {
          const errorMessage = errorData.message || `HTTP Error: ${response.status} ${response.statusText || ''}`;
          throw new Error(errorMessage);
        });
      }
      return response.json();
    }).then(data => {
      document.getElementById(`${cardUuid}-description`).innerText = data.description?.replace(/:[a-zA-Z0-9_]+:/g, '') || 'Description not set';
      document.getElementById(`${cardUuid}-language`).innerText = data.language;
      document.getElementById(`${cardUuid}-forks`).innerText = Intl.NumberFormat('en-us', { notation: 'compact', maximumFractionDigits: 1 }).format(data.forks).replaceAll('\u202f', '');
      document.getElementById(`${cardUuid}-stars`).innerText = Intl.NumberFormat('en-us', { notation: 'compact', maximumFractionDigits: 1 }).format(data.stargazers_count).replaceAll('\u202f', '');
      const avatarEl = document.getElementById(`${cardUuid}-avatar`);
      avatarEl.style.backgroundImage = 'url(' + data.owner.avatar_url + ')';
      avatarEl.style.backgroundColor = 'transparent';
      document.getElementById(`${cardUuid}-license`).innerText = data.license?.spdx_id || 'no-license';
      document.getElementById(`${cardUuid}-card`).classList.remove('fetch-waiting');
      console.log(`[GITHUB-CARD] Loaded card for ${repo} | ${cardUuid}.`)
    }).catch(err => {
      const c = document.getElementById(`${cardUuid}-card`);
      c?.classList.add('fetch-error');
      c?.classList.remove('fetch-waiting');
      document.getElementById(`${cardUuid}-description`).innerText = err.message;
      /* document.getElementById(`${cardUuid}-description`).innerText = `Error: ${err.name || '?'}: ${err.message || 'Unknown error occurred'}. Repo: ${repo}`; */
      console.warn(`[GITHUB-CARD] (Error) Loading card for ${repo} | ${cardUuid}.`)
    })
    ```,
    data: (repo: repo, cardUuid: card-uuid),
  )

  context if target() != "html" {
    link("https://github.com/" + repo)[GitHub:#repo]
  } else {
    section(html.elem(
      "a",
      attrs: (
        id: card-uuid + "-card",
        class: "card-github no-styling fetch-waiting",
        href: "https://github.com/" + repo,
        target: "_blank",
        repo: repo,
        aria-label: "GitHub:" + repo,
      ),
      (
        {
          html.elem("div", attrs: (class: "gc-titlebar"), {
            html.elem("div", attrs: (class: "gc-titlebar-left"), {
              html.elem("div", attrs: (class: "gc-owner"), {
                html.elem("div", attrs: (
                  id: card-uuid + "-avatar",
                  class: "gc-avatar",
                  style: "background-image: url(\"https://github.com/"
                    + owner
                    + ".png\"); background-color: transparent;",
                ))
                html.elem("div", attrs: (class: "gc-user"), {
                  owner
                })
              })
              html.elem("div", attrs: (class: "gc-divider"), {
                [/]
              })
              html.elem("div", attrs: (class: "gc-repo"), {
                repo-name
              })
            })
            html.elem("div", attrs: (class: "github-logo"), [])
          })
          html.elem(
            "div",
            attrs: (id: card-uuid + "-description", class: "gc-description"),
            {
              [unimplemented]
            },
          )
          html.elem("div", attrs: (class: "gc-infobar"), {
            html.elem(
              "div",
              attrs: (id: card-uuid + "-stars", class: "gc-stars"),
              {
                [unimplemented]
              },
            )
            html.elem(
              "div",
              attrs: (id: card-uuid + "-forks", class: "gc-forks"),
              {
                [unimplemented]
              },
            )
            html.elem(
              "div",
              attrs: (id: card-uuid + "-license", class: "gc-license"),
              {
                [unimplemented]
              },
            )
            html.elem(
              "span",
              attrs: (id: card-uuid + "-language", class: "gc-language"),
              {
                [unimplemented]
              },
            )
          })
          script
        }
      ),
    ))
  }
}

#let github-gist(repo: "") = {
  if repo.find("/") == none {
    panic(
      "Invalid repository. 'repo' attribute must be in the format 'owner/gist'",
    )
  }

  let owner = repo.split("/").at(0)
  let gist = repo.split("/").at(1)


  context if target() != "html" {
    link("https://github.com/" + repo)[GitHubGist:#repo]
  } else {
    html.elem("script", attrs: (
      src: "https://gist.github.com/" + owner + "/" + gist + ".js",
    ))
  }
}

#let youtube-video-embed() = {
  todo()
}

#let youtube-channel(name, channel-slug) = {
  link("https://www.youtube.com/@" + channel-slug)[#name on YouTube]
}

#let tenor-gif(title, link, dims: (1, 1), width: 100%) = {
  let slug = none
  if link.starts-with("https://") {
    slug = link.split("/").last()
  } else { slug = link }

  let postid = slug.split("-").last()

  html.elem(
    "div",
    attrs: (
      class: "tenor-gif-embed",
      data-postid: str(postid),
      data-share-method: "host",
      data-aspect-ratio: str(float(dims.at(0)) / float(dims.at(1))),
      data-width: str(float(width * 100)) + "%",
    ),
    {
      html.elem(
        "a",
        attrs: (
          href: "https://tenor.com/view/" + slug,
        ),
        title,
      )
      html.elem("script", attrs: (
        type: "text/javascript",
        async: "true",
        src: "https://tenor.com/embed.js",
      ))
    },
  )
}
