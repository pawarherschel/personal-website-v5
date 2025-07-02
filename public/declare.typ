#let declare(name, target, if-html, if-paged) = {
  if target == "html" {
    if-html
  } else if target == "paged" {
    if if-paged == none {
      panic("unimplemented ", name)
    } else {
      if-paged
    }
  }
}

#let declare-paged-only(name, target, thing) = declare(name, target, panic(name, " is paged-only"), thing)
#let declare-html-only(name, target, thing) = declare(name, target, thing, panic(name, " is html-only"))

#let hr-html = html.elem("hr")
#let hr-paged = line(length: 100%)

#let checkbox-html(completed, active: false) = box(html.elem("input", attrs: (
  type: "checkbox",
  ..if completed { (checked: "true") },
  ..if not active { (disabled: "true") },
)))
#let checkbox-paged(completed, active: false) = panic("unimplemented checkbox")

#let section(content) = html.elem("section", content)

#let script(script, data: (:), i-have-read-the-panic-and-i-know-what-im-doing: false, manual-delete: false) = {
  if not type(script) == raw {
    panic("script must be raw")
  }
  if not (script.at("lang") == "javascript" or script.at("lang") == "js") {
    panic("script's language must be \"javascript\" or \"js\"")
  }
  if script.text.len() == 0 {
    panic("script must not be empty")
  }

  if script.text.contains("\"") {
    panic(
      "Script contains \" which isn't allowed, if you're sure you know what you're doing then set `i-have-read-the-panic-and-i-know-what-im-doing` to true",
    )
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


  html.elem("iframe", attrs: (
    width: "0",
    height: "0",
    class: "hidden",
    src: "about:blank",
    onload: data-loading + script.text + if not manual-delete { "this.parentNode.removeChild(this);" } else { "" },
  ))
}

#let hr(target) = declare("hr", target, hr-html, hr-paged)
#let checkbox(target) = declare("checkbox", target, checkbox-html, checkbox-paged)
#let section(target) = declare-html-only("section", target, section)
#let script(target) = declare-html-only("script", target, script)
