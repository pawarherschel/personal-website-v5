#import "@preview/tiaoma:0.3.0": barcode
#import "@preview/catppuccin:1.0.1": catppuccin, flavors
#import "@preview/one-liner:0.2.0": fit-to-width
#import "@preview/biceps:0.0.1": flexwrap
#import "@preview/fontawesome:0.6.0": *

#import "SOT.typ": *

#let flavor = flavors.latte
// #let flavor = flavors.frappe
// #let flavor = flavors.macchiato
// #let flavor = flavors.mocha
#let light-mode = flavor.colors.text.rgb.oklch().components().at(0) < 50%
#let dark-mode = not light-mode
#let palette = flavor.colors
#let themes = palette.pairs().filter(((_, it)) => it.accent).to-dict().keys()
#let non-accent = palette.pairs().filter(((_, it)) => not it.accent).to-dict()
#let (mauve, pink, ..) = palette

#let accent-color = mauve.rgb
#let highlight-color = pink.rgb


#let container-header-color = {
  if dark-mode {
    accent-color.oklab().darken(50%)
  } else {
    accent-color.oklab().lighten(50%)
  }
}
#let container-border-color = {
  if dark-mode {
    accent-color.oklab().darken(20%)
  } else {
    accent-color.oklab().lighten(20%)
  }
}

#let icon(icon) = {
  let dict = (
    email: fa-envelope(),
    github: fa-github(),
    homepage: fa-house(),
    linkedin: fa-linkedin(),
    orcid: fa-orcid(),
    phone: fa-phone(),
  )

  return if dict.at(icon, default: none) != none {
    dict.at(icon)
  } else {
    icon
  }
}

#let format-link(format, link) = {
  let dict = (
    email: std.link("mailto:" + link),
    github: std.link("https://github.com/" + link, link),
    homepage: std.link("https://" + link, link),
    linkedin: std.link("https://www.linkedin.com/in/" + link, link),
    orcid: std.link("https://orcid.org/" + link, link),
    phone: std.link("tel:" + link),
  )

  return if dict.at(format, default: none) != none {
    dict.at(format)
  } else {
    link
  }
}


#let fake-smallcaps(str) = {
  str
    .split(" ")
    .map(it => {
      let head = it.first()
      let rest = it.slice(1)

      let head = upper[#head]
      let rest = text(size: 0.8em, upper[#rest])

      head + rest
    })
    .intersperse(" ")
    .join()
}

#let container(title: "", content) = {
  title = text(size: 2em, fill: highlight-color)[#fake-smallcaps(title)]
  block(
    above: 2em,
    stroke: container-border-color,
    width: 100%,
    inset: 14pt,
    {
      context {
        let (height, ..) = measure(title)
        place(
          top + left,
          dy: -height
            * 1.5, // height so it aligns the top of the title with the top of the box, multiplied by 1.5 so halfway up
          block(
            fill: palette.base.rgb,
            title,
          ),
        )
      }
      content
    },
  )
}

#let name-content = text(
  fill: highlight-color,
  fit-to-width(
    name,
  ),
)

#let contact-methods = flexwrap(
  cross-spacing: 2%,
  main-spacing: 2%,

  ..info
    .pairs()
    .map(((k, v)) => {
      [/ #icon(k): #format-link(k, v)]
    }),
)

#let qrcode = barcode(
  format-link("homepage", info.homepage).dest,
  "QRCode",
  options: (
    scale: 10.0,
    option-1: 3,
    fg-color: highlight-color,
  ),
)

#let qrcode-cta = figure(
  supplement: none,
  image(
    qrcode.source,
    fit: "contain",
    height: 1fr,
    alt: format-link("homepage", info.homepage).dest,
  ),
  caption: {
    set text(fill: highlight-color)
    fake-smallcaps("visit my website")
  },
)

#let bio = {
  bio
  par[
    Currently based in #location\
    #location-line
  ]
  block(
    width: 99%,
    contact-methods,
  )
}

#let cvSection(
  title: [],
  content,
) = container(title: title, content)

#let cvEntry(
  title: none,
  society: none,
  date: none,
  location: none,
  description: none,
  logo: none,
  tags: none,
) = {
  let rows = (
    1 //
      + if description != none { 1 } else { 0 }
      + if tags != () { 1 } else { 0 }
  )

  let arr = ()

  let top = grid(
    columns: 2,
    column-gutter: 1%,
    block(height: 2em, logo),
    [
      #text(size: 1.5em, box[=== #title]) #h(1fr) _#text(fill: highlight-color, date)_\
      #text(fill: highlight-color, society) #h(1fr) _#text(size: 0.9em, fill: palette.subtext1.rgb, location)_
    ],
  )

  let mid = description
  let bottom = tags
    .map(it => context {
      let (height, width) = measure(text([W]))
      box(
        stroke: 1pt + highlight-color,
        outset: (y: height / 2),
        inset: (x: width),
        {
          it
        },
      )
    })
    .join(" ")

  arr.push(top)
  if mid != none and mid != () {
    arr.push(mid)
  }
  if bottom != none and bottom != () {
    arr.push(bottom)
  }

  grid(
    columns: 1,
    rows: rows,
    row-gutter: 1%,
    ..arr,
  )
}

#let metaCVCertificates(highlight-func: none) = if certificates != none {
  cvSection(title: "Certificates", {
    grid(
      columns: (18%, 1fr, 20%),
      align: (right + horizon, left, left),
      column-gutter: 2%,
      row-gutter: 2%,
      ..certificates
        .map(((date, issuer, location, title, url)) => {
          (
            date,
            {
              strong(title)
              [, ]
              issuer
            },
            if highlight-func == none { highlight(location) } else {
              highlight-func(location)
            },
          ).map(it => link(url, it))
        })
        .flatten(),
    )
  })
}

#let metaCVSkills = if skills != none {
  cvSection(title: "Skills", {
    grid(
      columns: (auto, 1fr),
      align: (right, left),
      column-gutter: 2%,
      row-gutter: 1%,
      ..skills
        .filter(it => get-or-none(it, "visible", sys_inputs_override: "full"))
        .map(((info, type, ..)) => {
          (
            strong(type),
            info.map(it => it).join([ | ]),
          )
        })
        .flatten(),
    )
  })
}
#let metaCVEntry = metaCVEntry.with(
  cvEntry: cvEntry,
  cvSection: cvSection,
  highlight-func: it => {
    text(it, fill: highlight-color)
  },
)

#let cv(
  content,
) = {
  show: catppuccin.with(flavor)
  set page(
    header: none,
    footer: {
      set text(fill: palette.subtext0.rgb, size: 0.9em)
      [#name #h(1fr) Résumé]
    },
    margin: (x: 1%, top: 1%, bottom: 2em),
    paper: "a4",
  )
  set text(font: "JetBrains Mono NL", size: 9pt, hyphenate: true)
  set par(
    justify: true,
    // justification-limits: (
    //   tracking: (min: -0.02em, max: 0.02em),
    // ),
    linebreaks: "optimized",
  )
  set highlight(fill: highlight-color)
  block(
    height: 20%,
    grid(
      columns: (3fr, ..if show-photo { (1fr,) }),
      column-gutter: 1%,
      {
        name-content
        block(
          height: 1fr,
          grid(
            columns: (1fr, auto),
            column-gutter: 2%,
            bio, link(format-link("homepage", info.homepage).dest, qrcode-cta),
          ),
        )
      },
      if show-photo {
        image(
          photo-path,
          fit: "cover",
          height: 100%,
          width: 100%,
          alt: "Image of " + name,
        )
      },
    ),
  )
  content

  metaCVCertificates(highlight-func: it => {
    text(it, fill: highlight-color)
  })
  metaCVSkills
}
