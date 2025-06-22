#import "@preview/vanilla:0.1.1": vanilla
#import "@preview/lilaq:0.3.0" as lq

#let colors = lq.color.map.okabe-ito

#let epsillon = calc.pow(2, -53)

#let float-and-unit(s) = {
  if s.contains(" ") {
    let (a, b) = s.split(" ")
    let a = float(a)

    let (prefix, ..unit) = b.clusters()

    if prefix == "n" {
      a /= 10e9
    } else if prefix == "µ" {
      a /= 10e6
    } else if prefix == "m" {
      a /= 10e3
    } else {
      panic("unknown prefix: ", prefix)
    }

    if a == 0 {
      a = epsillon
    }

    (a, unit.join())
  } else {
    panic(s)
  }
}

#let is-stats(it, panic: true) = {
  if type(it) != dictionary {
    if panic {
      panic(it, parents, stuff, root)
    } else { return false }
  }

  it.keys().contains("sample_count") and it.keys().contains("iter_count") and it.keys().contains("time")
}

#let is-n-1(it) = (
  type(it) == dictionary
    and it
      .keys()
      .map(k => it.at(k))
      .map(it => (
        is-stats(it, panic: false)
      ))
      .all(it => it)
)

#let extract-thing(stats, parents) = {
  assert(type(parents) == array)
  assert(parents.len() != 0)
  let arg = if parents.len() > 1 { parents.pop() } else { "🌸" }

  let sample_count = stats.sample_count
  let iter_count = stats.iter_count
  let time = stats.time

  let (fastest, fastest-unit) = float-and-unit(time.fastest)
  let (slowest, slowest-unit) = float-and-unit(time.slowest)
  let (mean, mean-unit) = float-and-unit(time.mean)
  let (median, median-unit) = float-and-unit(time.median)

  let unit = if fastest-unit == slowest-unit and slowest-unit == mean-unit and mean-unit == median-unit {
    fastest-unit
  } else {
    panic("different units not supported yet")
  }

  (
    name: arg,
    type: "time",
    path: parents,
    rect: (min: fastest, max: slowest),
    mean: mean,
    median: median,
    unit: unit,
    fastest: time.fastest,
    slowest: time.slowest,
  )
}

#let init-or-push(dict, key, val) = {
  assert(type(dict) == dictionary)
  assert(type(key) == str)
  assert(type(val) == dictionary)

  if dict.keys().contains(key) {
    let arr = dict.at(key)

    assert((type(arr) == array))

    if dict.at(key).contains(val) {} else {
      dict.at(key).push(val)
    }
  } else {
    dict.insert(key, (val,))
  }

  return dict
}

#let get_stuff(root, parents, stuff) = {
  if root == none {
    return stuff
  }

  if type(root) != dictionary {
    panic()
  }

  if is-stats(root) {
    let r = extract-thing(root, parents)

    let key = r.path.join(".")

    stuff = init-or-push(stuff, key, r)
  } else {
    for (parent, dict) in root {
      if dict == none {
        continue
      }

      if is-n-1(dict) {
        for (function-name, stats) in dict {
          let r = extract-thing(stats, (..parents, parent, function-name))

          let key = r.path.join(".")

          stuff = init-or-push(stuff, key, r)
        }
      } else if is-stats(dict) {
        let r = extract-thing(dict, (..parents, parent))
        let key = r.path.join(".")

        stuff = init-or-push(stuff, key, r)
      } else {
        for (parent, dict) in dict {
          let ss = get_stuff(dict, (..parents, parent), stuff)

          for (key, vals) in ss {
            for val in vals {
              stuff = init-or-push(stuff, key, val)
            }
          }
        }
      }
    }
  }

  return stuff
}

#let remap_single(value, low1, high1, low2, high2) = {
  let denominator = (high1 - low1)

  (
    low2
      + (value - low1)
        * (high2 - low2)
        / if denominator != 0 {
          denominator
        } else { epsillon }
  )
}

#let remap((min: value1, max: value2), (min: start1, max: stop1), (min: start2, max: stop2)) = {
  (
    min: remap_single(value1, start1, stop1, start2, stop2),
    max: remap_single(value2, start1, stop1, start2, stop2),
  )
}

#let normalize-stuff(stuff) = {
  let min = stuff.map(it => it.rect.min).reduce((a, b) => calc.min(a, b))
  let max = stuff.map(it => it.rect.max).reduce((a, b) => calc.max(a, b))

  let from = (min: min, max: max)
  let to = (min: epsillon, max: 100.0 - 1.42109e-14)

  stuff.map(it => {
    it.rect = if min != max {
      remap(it.rect, from, to)
    } else { to }
    it.mean = if max != min {
      remap_single(it.mean, from.min, from.max, to.min, to.max)
    } else { 0.5 }
    it.median = if max != min { remap_single(it.median, from.min, from.max, to.min, to.max) } else { 0.5 }

    it
  })
}

#show: vanilla.with(
  justified: true,
  body-font-family: "Jetbrains Mono",
)

#show figure: it => it.body

#outline(target: figure)

#for file in (
  "atomic_362-lines.json",
  "attr_options_42-lines.json",
  "attr_options_680-lines.json",
  "collections_2986-lines.json",
  "divan_100-lines.json",
  "divan_103-lines.json",
  "divan_105-lines.json",
  "divan_106-lines.json",
  "divan_110-lines.json",
  "divan_112-lines.json",
  "divan_135-lines.json",
  "hash_1360-lines.json",
  "image_36-lines.json",
  "main_94-lines.json",
  "math_297-lines.json",
  "memcpy_392-lines.json",
  "panic_162-lines.json",
  "search_1074-lines.json",
  "sort_284-lines.json",
  "string_2608-lines.json",
  "threads_796-lines.json",
  "time_68-lines.json",
) {
  let json = json(file)
  let root = json.keys().first()
  let yscale = (
    lq.scale.linear(),
    lq.scale.symlog(base: 10, threshold: 1, linscale: 1),
    lq.scale.log(base: 10),
  ).at(0)

  set page(
    header: {
      block(width: 100%, height: 1fr, align(center + horizon, {
        place(bottom, box(inset: (y: 4pt), line(length: 100%, stroke: (
          thickness: 5pt,
          paint: gradient.linear(..colors).sharp(colors.len()),
        ))))
        box(text(size: 3em, root))
      }))
    },
    footer: [#file | scale = #yscale.name | typst version = #sys.version],
  )


  let stuff = get_stuff(json, (root,), (:))

  if stuff == () {
    continue
  }

  let unit = {
    let units = stuff.keys().map(it => stuff.at(it)).map(it => it.map(it => it.unit)).flatten().dedup()

    if units.len() == 0 {
      units = (none,)
    }

    if (units.len() != 1) {
      panic("different units: ", repr(units))
    }

    units.at(0)
  }

  for (i, (name, stuff)) in stuff
    .keys()
    .map(it => (
      it,
      stuff.at(it),
    ))
    .enumerate() {
    [
      #figure(caption: name, lq.diagram(
        title: lq.title(name),
        yscale: yscale,
        width: 15cm,
        height: 15cm,
        legend: none,
        margin: (x: 1%, y: 6%),
        yaxis: (
          label: lq.tick-label("time%"),
        ),
        xaxis: (
          subticks: none,
          tick-distance: 1,
          ticks: stuff
            .map(it => {
              let x = it.name
              lq.label(align(right, text(x, hyphenate: false)), angle: -90deg)
            })
            .enumerate(),
        ),


        ..for (i, (name, rect, mean, median, fastest, slowest)) in normalize-stuff(stuff)
          .map(it => {
            if it.rect.max > 100 + 1.42109e-14 { panic(100 + 1.42109e-14, it) }
            if it.rect.min < epsillon { panic(it) }

            it
          })
          .enumerate() {
          (
            //
            lq.rect(i, rect.min, height: rect.max - rect.min, width: 1, stroke: (dash: "dashed"), fill: colors.at(
              calc.rem(i, colors.len()),
            )),
            //
            lq.line((i, mean), (i + 1, mean), stroke: black),
            lq.line((i, median), (i + 1, median), stroke: (dash: "dashed")),
            //
            lq.place(i + 1 / 2, rect.min, align: top + center, fastest),
            lq.place(i + 1 / 2, rect.max, align: bottom + center, slowest),
          )
        },
      ))
      #label(name)
    ]
  }

  // [#stuff]
  pagebreak(weak: true)
}
