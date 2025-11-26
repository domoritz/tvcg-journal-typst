// Workaround for the lack of an `std` scope.
#let std-bibliography = bibliography

#let serif-font = "Times New Roman" // "Liberation Serif"
#let sans-serif-font = "Helvetica" // "Liberation Sans"
#let mono-font = "Liberation Mono" // LaTeX uses txtt. Alt: "Courier New", "Nimbus Mono"

// This function gets your whole document as its `body` and formats
// it as an article in the style of the TVCG.
#let tvcg(
  // The paper's title.
  title: [Paper Title],

  // An array of authors. For each author you can specify a name,
  // department, organization, location, and email.
  // Everything but the name is optional.
  authors: (),

  // The paper's abstract.
  abstract: none,

  // Teaser image path and caption
  teaser: (),

  // A list of index terms to display after the abstract.
  index-terms: (),

  // The article's paper size. Also affects the margins.
  paper-size: "us-letter",

  // The result of a call to the `bibliography` function or `none`.
  bibliography: none,

  // Review mode - hides authors and shows submission info
  review: false,

  // Submission ID (for review mode)
  submission-id: 0,

  // Category (for review mode)
  category: none,

  // Paper type (for review mode)
  paper-type: none,

  // Custom manuscript note (appears in footer of first page)
  manuscript-note: none,

  // The paper's content.
  body
) = {
  // Set document metadata.
  if review {
    set document(title: title, author: "Anonymous")
  } else {
    set document(title: title, author: authors.map(author => author.name))
  }

  // Set the body font.
  set text(font: serif-font, size: 9pt)

  // Configure links to use NavyBlue color and monospace font (matching LaTeX hyperref/url settings)
  show link: it => {
    set text(fill: rgb("#000080")) // NavyBlue (SVG color)
    // URLs should use monospace font like LaTeX \url{}
    if type(it.dest) == str {
      set text(font: mono-font)
      it
    } else {
      it
    }
  }

  // Configure the page.
  set page(
    paper: paper-size,
    margin: (
      top: 54pt, // 0.75in
      bottom: 45pt, // 0.625in
      inside: 54pt, // 0.75in
      outside: 45pt // 0.625in
    ),
    header: if review {
      context {
        if calc.odd(counter(page).get().first()) {
          align(center, emph([Online Submission ID: #submission-id]))
        }
      }
    }
  )

  // Configure equation numbering and spacing.
  set math.equation(numbering: "(1)")
  show math.equation: set block(spacing: 0.65em)

  // Configure appearance of all references - blue color with special equation handling
  show ref: it => {
    set text(fill: rgb("#000080")) // NavyBlue (SVG color) for all references
    if it.element != none and it.element.func() == math.equation {
      // Override equation references to show just the number
      link(it.element.location(), numbering(
        it.element.numbering,
        ..counter(math.equation).at(it.element.location())
      ))
    } else {
      // Other references as usual
      it
    }
  }

  // Configure lists.
  set enum(indent: 10pt, body-indent: 9pt)
  set list(indent: 10pt, body-indent: 9pt)

  // Configure figure captions.
  // LaTeX uses: \captionsetup{font={scriptsize,sf}} and default \abovecaptionskip (10pt)
  // scriptsize is approximately 7-8pt, sf is sans-serif
  set figure(gap: 10pt) // Space between figure and caption (LaTeX default \abovecaptionskip)
  show figure.caption: it => {
    set text(font: sans-serif-font, size: 8pt)
    it
  }

  // Configure headings.
  set heading(numbering: "1.1.1")
  show heading: it => context {
    // Find out the final number of the heading counter.
    let levels = counter(heading).get()
    let deepest = if levels != () {
      levels.last()
    } else {
      1
    }

    set text(font: sans-serif-font, size: 9pt)
    set par(first-line-indent: 0pt) // Headings themselves should not be indented

    if it.level == 1 [
      // First-level headings are centered smallcaps.
      // We don't want to number the acknowledgments section.
      #let is-ack = it.body in ([Acknowledgments], [Acknowledgements])
      #show: smallcaps
      // LaTeX uses -2ex (≈18pt) space before section headings
      #v(18pt, weak: true)
      #if it.numbering != none and not is-ack {
        numbering("1", deepest)
        h(7pt, weak: true)
      }
      #if it.body.has("text"){
        for letter in it.body.text{
          if letter == upper(letter) {
            set text(size: 9pt)
            letter
          } else {
            set text(size: 7pt)
            upper(letter)
          }
        }
      }

      // *#it.body*
      #v(7.2pt, weak: true)
    ] else if it.level == 2 [
      // Second-level headings (subsections) - bold sans-serif
      // LaTeX uses -1.8ex (≈16pt) space before subsection headings
      #v(16pt, weak: true)
      #if it.numbering != none {
        numbering("1.1", ..levels)
        h(7pt, weak: true)
      }
      *#it.body*
      // LaTeX uses 0.8ex (≈7.2pt) space after subsection headings
      #v(7.2pt, weak: true)
    ] else [
      // Third level headings are run-ins too, but different.
      #if it.level == 3 {
        numbering("1.1.1)", ..levels)
        [ ]
      }
      _#(it.body):_
    ]
  }

  // Display the paper's title.
  v(3pt, weak: true)
  align(center, text(18pt, title, font: sans-serif-font))
  v(23pt, weak: true)

  // Display the authors list or submission info (if review mode).
  if review {
    align(center, text(10pt, font: sans-serif-font, [
      Category: #category
      #v(-0.2em)
      Paper Type: #paper-type
    ]))
  } else {
    let and-comma = if authors.len() == 2 {" and "} else {", and "}

    align(center,
      text(10pt, font: sans-serif-font, authors.map(author => {
          author.name
          if "orcid" in author and author.orcid != "" {
            link("https://orcid.org/" + author.orcid)[#box(height: 1.1em, baseline: 13.5%)[#image("assets/orcid.svg")]]
          }
        } ).join(", ", last: and-comma)
      )
    )
  }

  v(6pt, weak: true)
  block(inset: (left: 24pt, right: 24pt), [
    
      // Insert teaser image
      #figure(
          teaser.image,
          caption: teaser.caption,
        ) <teaser>

      #v(10pt, weak: true)

      // Display abstract and index terms.
      // LaTeX uses \scriptsize (8pt with 9.5pt leading)
      #(if abstract != none [
          #set par(justify: true, leading: 0.65em)
          #set text(font: sans-serif-font, size: 8pt)
          #[*Abstract*---#abstract]

          #if index-terms != () [
            *Index terms*---#index-terms.join(", ")
          ]
        ]
      )
    ]
  )

  v(10pt, weak: true)
  align(center, image("assets/diamondrule.svg", width: 40%))
  v(15pt, weak: true)

  // Start two column mode and configure paragraph properties.
  show: columns.with(2, gutter: 12.24pt) // 0.17in

  // LaTeX uses 9pt font with 10pt baseline skip
  set par(justify: true, first-line-indent: 1em, leading: 0.55em, spacing: 0.65em)


  // Display the email address and manuscript info (not shown in review mode).
  if not review {
    place(left+bottom, float: true, block(
        width: 100%,[
          #align(center, line(length: 50%, stroke: 0.4pt))

          #set text(style: "italic", size: 7.5pt, font: serif-font)
          #set list(indent: 0pt, body-indent: 5pt, spacing: 0.5em)
          #for author in authors [
            - #author.name is with #author.organization. #box(if "email" in author [E-mail: #author.email.])
          ]
          #v(4pt)
          #if manuscript-note != none [
            #manuscript-note
          ] else [
            Manuscript received DD MMM. YYYY; accepted DD MMM. YYYY.
            Date of Publication DD MMM. YYYY; date of current version DD MMM. YYYY.
            For information on obtaining reprints of this article, please send e-mail to: reprints`@`ieee.org.
            Digital Object Identifier: xx.xxxx/TVCG.YYYY.xxxxxxx
          ]
        ]
      )
    )
  }

  // Set the body font.
  set text(font: serif-font, size: 9pt)

  // Display the paper's contents.
  body

  // Display bibliography.
  if bibliography != none {
    show std-bibliography: set text(8pt)
    set std-bibliography(title: text(10pt)[References], style: "ieee")
    bibliography
  }
}
