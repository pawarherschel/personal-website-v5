#let page-height = 1572pt
#let page-width = 3000pt
#import "./public/utils.typ": data

#set page(
  height: page-height,
  width: page-width,
)

#let (data: slug) = data("other")

#set page(background: [#image(
    "./public/bg.svg",
    fit: "cover",
    height: 1fr,
    width: 100%,
  )])

#let fit-text(body, err: 10, max-attempts: 20) = context {
  layout(size => {
    let measured_width = measure(body).width
    let measured_height = measure(body).height

    let maximum_width = size.width
    let maximum_height = size.height
    let font_size = text.size

    let attempts = 0

    while true and attempts < max-attempts {
      let width_diff = calc.abs((measured_width.cm() - maximum_width.cm()))
      let width_satisfied = width_diff < err

      let is_width_diff_pos = (measured_width.cm() - maximum_width.cm()) >= 0
      let width_satisfied = width_satisfied and not is_width_diff_pos

      let height_diff = calc.abs((measured_height.cm() - maximum_height.cm()))
      let height_satisfied = height_diff < err

      let is_height_diff_pos = (measured_height.cm() - maximum_height.cm()) >= 0
      let height_satisfied = height_satisfied and not is_height_diff_pos

      if width_satisfied and height_satisfied {
        break
      }

      if not width_satisfied {
        let diff = ((measured_width.cm() - maximum_width.cm()) / 100.0)

        font_size = font_size - diff * font_size
      } else if not height_satisfied {
        let diff = ((measured_height.cm() - maximum_height.cm()) / 100.0)
        font_size = font_size - diff * font_size
      }

      measured_width = measure(text(size: font_size)[#body]).width
      measured_height = measure(text(size: font_size)[#body]).height

      attempts += 1
    }

    let measured_width = measure(text(size: font_size)[#body]).width
    let measured_height = measure(text(size: font_size)[#body]).height
    let attempts = attempts

    text(size: font_size)[#body]
  })
}

#align(center + horizon, box(height: 50%, width: 50%, fit-text(text(
  upper(slug),
))))
