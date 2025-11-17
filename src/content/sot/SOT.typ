#let SOT = json("SOT.json")

#let SOT-keys = SOT.keys().map(it => (it, it)).to-dict()

#let get-or-none(
  dict,
  key,
  eval: false,
  mode: "markup",
  sys_inputs_override: none,
) = if dict.keys().contains(key) {
  let content = dict.at(key)
  if sys_inputs_override != none {
    if sys.inputs.keys().contains("data") {
      let data = json.decode(sys.inputs.at("data"))
      if data.keys().contains(sys_inputs_override) {
        content = data.at(sys_inputs_override)
      }
    }
  }


  if eval {
    std.eval(content, mode: mode)
  } else {
    content
  }
} else {
  none
}

#let name = get-or-none(SOT, "name")
#let bio = get-or-none(SOT, "bio", eval: true)
#let location = get-or-none(SOT, "location", eval: true)
#let location-line = get-or-none(SOT, "location_line", eval: true)
#let photo-path = get-or-none(SOT, "photo_path")
#let show-photo = get-or-none(SOT, "show_photo")
#let info = get-or-none(SOT, "info")
#let certificates = get-or-none(SOT, "certificates")
#let education = get-or-none(SOT, "education")
#let projects = get-or-none(SOT, "projects")
#let others = get-or-none(SOT, "others")
#let skills = get-or-none(SOT, "skills")
#let publications = get-or-none(SOT, "publications")

#let metaCVEntry(
  key,
  section-title,
  cvSection: (
    title: [],
    content,
  ) => {
    title
    content
  },
  cvEntry: (
    title: none,
    society: none,
    date: none,
    location: none,
    description: none,
    logo: none,
    tags: none,
  ) => {
    repr(title)
    repr(society)
    repr(date)
    repr(location)
    repr(description)
    repr(logo)
    repr(tags)
  },
  cvCertificate: it => repr(it),
  highlight-func: none,
) = {
  let arr = get-or-none(SOT, key)

  if arr != none {
    let arr = arr.filter(e => (
      get-or-none(e, "visible", sys_inputs_override: "full") != false
    ))
    if arr.len() == 0 {
      return
    }

    cvSection(
      title: section-title,
      {
        for entry in arr {
          let title = get-or-none(entry, "title")
          let society = get-or-none(entry, "society", eval: true)
          let date = get-or-none(entry, "date", eval: true)
          let location = get-or-none(entry, "location")
          let logo = get-or-none(entry, "logo")
          let description = get-or-none(entry, "description")
          let tags = get-or-none(entry, "tags")
          let preview = get-or-none(entry, "preview", eval: true)

          // preview     = "https://r2.sakurakat.systems/covuni-experience-banner.jpg"

          if location == none {} else if type(location) == dictionary {
            if location.keys().contains("github") {
              location = link("https://github.com/" + location.github)
            } else { panic("unknown location") }
          } else {
            location = eval(location, mode: "markup")
          }

          let description = if description != () {
            description
              .map(line => {
                line = eval(mode: "markup", line)
                let my-contribution-regex = regex("My contribution: ")
                show my-contribution-regex: it => {
                  if highlight-func == none {
                    highlight(it)
                  } else {
                    highlight-func(it)
                  }
                }
                [- #line]
              })
              .join()
          } else { none }

          let logo = if logo != none and logo != () {
            image(logo)
          } else { "" }

          let tags = if tags != none {
            tags
          } else { () }

          if logo == "" and preview != none {
            logo = align(center)[#link(preview.dest)[🔗]]
          }

          cvEntry(
            title: title,
            society: society,
            date: date,
            location: location,
            description: description,
            logo: logo,
            tags: tags,
          )
        }
      },
    )
  }
}
