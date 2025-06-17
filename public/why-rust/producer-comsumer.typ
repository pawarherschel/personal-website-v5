#import "@preview/cetz:0.4.0"

#let page-width = 30em
#let page-height = 21em

#set page(
  width: auto,
  height: auto,
  margin: 0em,
  fill: rgb("#130d13"),
)
#let foreground-color = rgb("#e1bad0")
#set text(size: 30pt, fill: foreground-color)
#let thatched = tiling(
  size: (20pt, 20pt),
  cetz.canvas({
    import cetz.draw: *

    rotate(z: 45deg)
    let x = calc.sin(45deg) * 20pt
    rect(
      (-x / 2, -x / 2),
      (x / 2, x / 2),
      stroke: (
        thickness: 0.3pt,
        paint: foreground-color,
        dash: "dashed",
      ),
    )
  }),
)

#let thatched-dense = tiling(
  size: (5pt, 5pt),
  cetz.canvas({
    import cetz.draw: *

    rotate(z: 45deg)
    let x = calc.sin(45deg) * 5pt
    rect(
      (-x / 2, -x / 2),
      (x / 2, x / 2),
      stroke: (
        thickness: 1pt,
        paint: foreground-color,
      ),
    )
  }),
)

#cetz.canvas({
  import cetz.draw: *
  stroke(3pt + foreground-color)


  grid(
    (-page-width / 2 + 3em, page-height * 90%),
    (page-width / 2 + 3em, -page-height * 10% - 1em),
    stroke: (thickness: 0.1pt, paint: foreground-color, dash: "dashed"),
    step: 0.5em,
  )
  grid(
    (-page-width / 2 + 3em, page-height * 90%),
    (page-width / 2 + 3em, -page-height * 10% - 1em),
    stroke: (
      thickness: 0.3pt,
      paint: foreground-color,
    ),
    step: 2em,
  )

  let rect-width = 8em
  let rect-ratio = 1920 / 1080
  let rect-height = 10em
  let rect-radius = 0.5em

  let content-padding = 0.5em

  // PRODUCER
  rect(
    (-11em, 0em),
    (rel: (rect-width, rect-height)),
    name: "producer",
    radius: rect-radius,
  )
  content(
    ("producer.south-west", 50%, "producer.south-east"),
    [Producer],
    padding: content-padding,
    anchor: "north",
    name: "producer-text",
  )
  circle(
    (
      v => cetz.vector.add(v, (0.7, 0.7)),
      "producer.south-west",
    ),
    radius: 0.4em,
    name: "producer-queue",
  )
  content(
    (
      v => cetz.vector.add(v, (1, 0)),
      "producer-queue",
    ),
    [queue],
    anchor: "mid-west",
  )


  // MAIN
  rect(
    (-1em, 0em),
    (rel: (rect-width, rect-height)),
    name: "main",
    radius: rect-radius,
  )
  content(
    ("main.south-west", 50%, "main.south-east"),
    [Main],
    padding: content-padding,
    anchor: "north",
  )
  circle(
    (
      v => cetz.vector.add(v, (0.7, 0.7)),
      "main.south-west",
    ),
    radius: 0.4em,
    name: "main-queue",
  )
  content(
    (
      v => cetz.vector.add(v, (1, 0)),
      "main-queue",
    ),
    [queue],
    anchor: "mid-west",
  )
  circle(
    (
      v => cetz.vector.add(v, (0, 1.2)),
      "main-queue",
    ),
    radius: 0.4em,
    name: "main-handles-0",
  )
  content(
    (
      v => cetz.vector.add(v, (1, 0)),
      "main-handles-0",
    ),
    [handles[0]],
    anchor: "mid-west",
  )
  circle(
    (
      v => cetz.vector.add(v, (0, 1.2)),
      "main-handles-0",
    ),
    radius: 0.4em,
    name: "main-handles-1",
  )
  content(
    (
      v => cetz.vector.add(v, (1, 0)),
      "main-handles-1",
    ),
    [handles[1]],
    anchor: "mid-west",
  )
  circle(
    (
      v => cetz.vector.add(v, (0, 1.2)),
      "main-handles-1",
    ),
    radius: 0.4em,
    name: "main-prev",
    fill: thatched-dense,
  )
  content(
    (
      v => cetz.vector.add(v, (1, 0)),
      "main-prev",
    ),
    [prev],
    anchor: "mid-west",
  )
  circle(
    (
      v => cetz.vector.add(v, (0, 1.2)),
      "main-prev",
    ),
    radius: 0.4em,
    name: "main-curr",
    fill: thatched-dense,
  )
  content(
    (
      v => cetz.vector.add(v, (1, 0)),
      "main-curr",
    ),
    [curr],
    anchor: "mid-west",
  )

  // CONSUMER
  rect(
    (9em, 0em),
    (rel: (rect-width, rect-height)),
    name: "consumer",
    radius: rect-radius,
  )
  content(
    ("consumer.south-west", 50%, "consumer.south-east"),
    [Consumer],
    padding: content-padding,
    anchor: "north",
    name: "consumer-text",
  )
  circle(
    (
      v => cetz.vector.add(v, (0.7, 0.7)),
      "consumer.south-west",
    ),
    radius: 0.4em,
    name: "consumer-queue",
  )
  content(
    (
      v => cetz.vector.add(v, (1, 0)),
      "consumer-queue",
    ),
    [queue],
    anchor: "mid-west",
  )
  circle(
    (
      v => cetz.vector.add(v, (0, 1.2)),
      "consumer-queue",
    ),
    radius: 0.4em,
    name: "consumer-data",
    fill: thatched-dense,
  )
  content(
    (
      v => cetz.vector.add(v, (1, 0)),
      "consumer-data",
    ),
    [data],
    anchor: "mid-west",
  )


  // HEAP
  rect(
    (-11em, 12em),
    (rel: (28em, 4em)),
    name: "heap",
    radius: rect-radius,
  )
  content(
    ("heap.north-west", 50%, "heap.north-east"),
    [Heap],
    padding: content-padding,
    anchor: "south",
  )
  // QUEUE
  rect(
    (
      v => cetz.vector.add(v, (0.5, 0.5)),
      "heap.south-west",
    ),
    (
      v => cetz.vector.add(v, (-0.5, -0.5)),
      "heap.north-east",
    ),
    radius: rect-radius,
    name: "queue",
    fill: thatched,
  )
  content(
    "heap",
    [Queue],
  )
  circle(
    (
      (v => cetz.vector.add(v, (1, 0))),
      "queue.west",
    ),
    radius: 0.5em,
    stroke: none,
    fill: foreground-color,
    name: "queue-start",
  )
  content(
    (
      name: "queue-start",
      anchor: 0deg,
    ),
    [ptr],
    anchor: "west",
  )

  line(
    "producer-queue.center",
    (rel: (-1.5, 0)),
    (rel: (0, 10.67)),
    (rel: (2.4, 0)),
    "queue-start",
    mark: (
      start: (
        symbol: "o",
        fill: thatched-dense,
        anchor: "center",
      ),
      end: (
        symbol: ">",
        fill: foreground-color,
        anchor: "tip",
      ),
      scale: 3,
    ),
    name: "producer-queue-to-queue",
  )
  line(
    "main-queue.center",
    (rel: (0, -2.3)),
    (rel: (8.4, 0)),
    (rel: (0, 13)),
    (
      name: "producer-queue-to-queue",
      anchor: 84%,
    ),
    mark: (
      start: (
        symbol: "o",
        fill: thatched-dense,
        anchor: "center",
      ),
      scale: 3,
    ),
    name: "main-queue-to-queue",
  )
  line(
    "consumer-queue.center",
    (rel: (0, -1.4)),
    (
      name: "main-queue-to-queue",
      anchor: 27.8%,
    ),
    mark: (
      start: (
        symbol: "o",
        fill: thatched-dense,
        anchor: "center",
      ),
      scale: 3,
    ),
  )

  line(
    "main-handles-0.center",
    (rel: (-1.2, 0)),
    (
      v => (
        -1.4,
        v.at(1),
      ),
      "producer-text.mid-east",
    ),
    (
      v => cetz.vector.add(v, (-0.5, 0)),
      "producer-text.mid-east",
    ),
    mark: (
      start: (
        symbol: "o",
        fill: thatched-dense,
        anchor: "center",
      ),
      end: (
        symbol: ">",
        fill: foreground-color,
        anchor: "tip",
      ),
      scale: 3,
    ),
  )
  line(
    "main-handles-1.center",
    (rel: (-2, 0)),
    (rel: (0, -6)),
    (rel: (14, 0)),
    (
      (v => cetz.vector.add(v, (-0.1, -0.2))),
      ("consumer-text.base-west", 16%, "consumer-text.base-east"),
    ),
    mark: (
      start: (
        symbol: "o",
        fill: thatched-dense,
        anchor: "center",
      ),
      end: (
        symbol: ">",
        fill: foreground-color,
        anchor: "tip",
      ),
      scale: 3,
    ),
  )
})
