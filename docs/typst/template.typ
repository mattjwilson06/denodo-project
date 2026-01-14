/// template.typ
/// A template for API and System Design Documentation

#let project(title: "", authors: (), body) = {
  // --- Document Metadata ---
  set document(title: title, author: authors)
  
  // --- Global Styles ---
  set page(
    paper: "a4",
    margin: (x: 2cm, y: 2.5cm),
    numbering: "1",
  )
  set text(font: "Linux Libertine", size: 11pt)
  set par(justify: true)
  set list(marker: "-", indent: 1em)
  set heading(numbering: "1.1.")
  
  // Link styling
  show link: it => underline(text(blue, it))
  
  // --- Title Block ---
  if title != "" {
    align(center)[
      #block(below: 1em)[
        #text(weight: "bold", size: 28pt, title)
      ]
      #line(length: 100%, stroke: 0.5pt)
      #v(2em)
    ]
  }

  body
}

// --- Specialized Headings ---

#let major-heading(body) = {
  v(1.8em, weak: true)
  heading(level: 1, text(size: 20pt, weight: "bold", body))
  v(1em, weak: true)
}

#let section-heading(body) = {
  v(1em, weak: true)
  heading(level: 2, text(size: 16pt, weight: "bold", body))
  v(0.5em, weak: true)
}

#let sub-section-heading(body) = {
  v(0.8em, weak: true)
  heading(level: 3, text(size: 12pt, weight: "bold", body))
}

// --- UI Components ---

#let endpoint-blocker(method, path, body) = {
  let colors = (
    POST: blue,
    GET: green,
    PUT: orange,
    PATCH: orange,
    DELETE: red,
  )
  let tag-color = colors.at(method, default: gray)

  block(
    fill: luma(245),
    inset: 10pt,
    radius: 4pt,
    width: 100%,
    stroke: 0.5pt + luma(220),
    {
      grid(
        columns: (auto, 1fr),
        gutter: 1em,
        align: center + horizon,
        // Method Tag
        block(
          fill: tag-color,
          inset: (x: 8pt, y: 4pt),
          radius: 4pt,
          text(weight: "bold", white, size: 0.8em, method)
        ),
        // Path
        text(font: "Fira Mono", size: 1.1em, raw(path, lang: "txt"))
      )
      v(4pt)
      line(length: 100%, stroke: 0.5pt + luma(220))
      v(4pt)
      body
    }
  )
}

// --- Data Structure Component ---
#let data-spec(title, items) = {
  heading(level: 3, title)
  text(weight: "bold", size: 0.9em, [Data Structure])
  v(-0.5em)
  list(..items)
  v(0.5em)
  line(length: 100%, stroke: (dash: "dashed", paint: luma(200)))
  v(1em)
}

// Legacy helper for manual blocks
#let dotpoint-block(body) = {
  set list(marker: "-", indent: 1em)
  body
}