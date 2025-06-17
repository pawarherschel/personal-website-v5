#let page-width = 30em

#set page(
  width: page-width,
  height: auto,
  fill: rgb("#130d13"),
)
#set text(size: 30pt, fill: rgb("#e1bad0"))

#import "@preview/cetz:0.4.0"

#let closed-envelop(ratio: 3 / 4, width: 10em, radius: 10%) = {
  cetz.canvas({
    import cetz.draw: *
    let height = width * ratio

    let line-y-min = height * (100% - 15%)
    let line-y-max = height * (100% - 70%)

    compound-path(
      {
        rect(
          (0, 0),
          (rel: (width, height)),
          radius: radius * width,
        )
        catmull(
          (0, line-y-min),
          (width * 50%, line-y-max),
          (width, line-y-min),
          radius: radius * width,
        )
      },
      join: false,
      stroke: 3pt + rgb("#e1bad0"),
    )
  })
}

#let open-envelop(ratio: 3 / 4, width: 10em, radius: 10%) = {
  cetz.canvas({
    import cetz.draw: *
    let height = width * ratio

    let line-y-min = height * (100% - 15%)
    let line-y-min = height
    let line-y-max = height * (100% - 50%)
    let line-y-max-upper = height * (100% + 70%) * 0.9

    compound-path(
      {
        rect(
          (0, 0),
          (rel: (width, height)),
          radius: (
            north-east: radius * radius * radius * width,
            north-west: radius * radius * radius * width,
            rest: radius * width,
          ),
        )
        // catmull(
        //   (0em, height),
        //   (0em + (radius * width), 0em),
        //   (width - (radius * width), 0em),
        //   (width, height),
        // )

        catmull(
          (0, line-y-min),
          (width * 50%, line-y-max),
          (width, line-y-min),
          radius: radius * width,
        )
        catmull(
          (0, line-y-min),
          (width * 50%, line-y-max-upper),
          (width, line-y-min),
          radius: radius * width,
        )
      },
      join: false,
      stroke: 3pt + rgb("#e1bad0"),
    )
  })
}

#let eye(width: 10em, angle: 0deg) = {
  cetz.canvas({
    import cetz.draw: *
    let height = width * 30%


    compound-path(
      stroke: 3pt + rgb("#e1bad0"),
      {
        merge-path({
          arc-through(
            (-width * 50%, 0),
            (0, height),
            (width * 50%, 0),
          )
          arc-through(
            (width * 50%, 0),
            (0, -height),
            (-width * 50%, 0),
          )
        })

        circle(
          (
            calc.cos(angle) * height * 40%,
            calc.sin(angle) * height * 40%,
          ),
          radius: height * 50%,
        )
      },
    )
  })
}

#cetz.canvas({
  import cetz.draw: *
  stroke(3pt + rgb("#e1bad0"))

  rect(
    (10% * page-width, 20em),
    (rel: (20% * page-width, 15em)),
    radius: 1em,
    name: "thread-1",
  )
  rect(
    ((90% - 25%) * page-width, 20em),
    (rel: (20% * page-width, 15em)),
    radius: 1em,
    name: "thread-2",
  )

  content(
    ("thread-1.north-west", 50%, "thread-1.north-east"),
    text(baseline: -1.5em)[Thread-1],
    anchor: "north",
  )
  content(
    ("thread-2.north-west", 50%, "thread-2.north-east"),
    text(baseline: -1.5em)[Thread-2],
    anchor: "north",
  )

  let send-arc-y = 32em
  arc-through(
    ((10% + 15%) * page-width, send-arc-y),
    ((10% + 55%) / 2 * page-width, send-arc-y + 1em),
    ((55% + 15%) * page-width, send-arc-y),
    name: "send",
    mark: (
      symbol: ">",
      scale: 5,
      end: "<",
    ),
  )

  content(
    "send.arc-center",
    text(baseline: -0.5em)[Send],
    anchor: "base",
  )

  content(
    "send.arc-end",
    {
      box(
        height: (3 / 4 * 2em + 0.3em),
        align(bottom, closed-envelop(width: 2em)),
      )
    },
    anchor: "north-west",
  )
  content(
    "send.arc-center",
    {
      box(
        height: (3 / 4 * 2em + 0.3em),
        align(bottom, closed-envelop(width: 2em)),
      )
    },
    anchor: "north",
  )
  content(
    "send.arc-start",
    {
      box(
        height: (3 / 4 * 2em + 0.3em),
        align(bottom, open-envelop(width: 2em)),
      )
    },
    anchor: "north-east",
  )


  let sync-arc-y = 23em
  {
    let width = 4em
    let screen-ratio = 1920 / 1080
    let screen-height = width / screen-ratio
    rect(
      name: "monitor",
      ((55% + 20%) * page-width, sync-arc-y),
      (rel: (width, screen-height)),
      anchor: "north-east",
    )
    rect(
      ((55% + 20%) * page-width, sync-arc-y),
      (rel: (width - 0.6em, screen-height - 0.6em)),
      anchor: "north-east",
    )
    content("monitor", text(spacing: 0pt)[meow])
  }
  arc-through(
    (
      (v => cetz.vector.add(v, (-0.4, +0.1))),
      "monitor.west",
    ),
    // ((55% + 15%) * page-width, sync-arc-y),
    ((10% + 55%) / 2 * page-width, sync-arc-y + 1em),
    ((10% + 15%) * page-width, sync-arc-y),
    name: "sync",
    stroke: (dash: "dashed", thickness: 3pt, paint: rgb("#e1bad0")),
    mark: (
      symbol: ">",
      scale: 5,
      end: "<",
    ),
  )


  content(
    "sync.arc-center",
    text(baseline: -0.5em)[Sync],
    anchor: "base",
  )

  content(
    "sync.arc-end",
    eye(width: 2em, angle: 15deg),
    anchor: "north-east",
  )
  let bias = 40%
  content(
    (
      (55% + 20%) * page-width,
      (sync-arc-y * bias + send-arc-y * (100% - bias)),
    ),
    eye(width: 2em, angle: -90deg),
    anchor: "center",
    name: "thread-2-eye",
  )

  line(
    (
      (v => cetz.vector.add(v, (0, 0.5))),
      "monitor.north",
    ),
    (
      (v => cetz.vector.add(v, (0, -1))),
      "thread-2-eye",
    ),
    stroke: (dash: "dashed", thickness: 3pt, paint: rgb("#e1bad0")),
    mark: (
      symbol: ">",
      scale: 5,
      end: "<",
    ),
    name: "eye-to-monitor",
  )

  content(
    ("eye-to-monitor.start", 50%, "eye-to-monitor.end"),
    angle: "eye-to-monitor.end",
    padding: .1,
    anchor: "south",
    text(baseline: -0.5em)[Sync],
  )
})
