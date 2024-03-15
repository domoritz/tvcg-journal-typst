// This function gets your whole document as its `body` and formats
// it as an article in the style of the IEEE.
#let ieee(
  // The paper's title.
  title: [Paper Title],

  // An array of authors. For each author you can specify a name,
  // department, organization, location, and email. Everything but
  // but the name is optional.
  authors: (),

  // The paper's abstract. Can be omitted if you don't have one.
  abstract: none,

  // Teaser image path and caption
  teaser: (),

  // A list of index terms to display after the abstract.
  index-terms: (),

  // The article's paper size. Also affects the margins.
  paper-size: "us-letter",

  // The path to a bibliography file if you want to cite some external
  // works.
  bibliography-file: none,

  // The paper's content.
  body
) = {
  // Set document metadata.
  set document(title: title, author: authors.map(author => author.name))

  // Set the body font.
  set text(font: "Liberation Sans", size: 9pt)

  // Configure the page.
  set page(
    paper: paper-size,
    // The margins depend on the paper size.
    margin: (
      x: (50pt / 216mm) * 100%,
      // top: (55pt / 279mm) * 100%,
      top: 54pt,
      // bottom: (64pt / 279mm) * 100%,
      bottom: 45pt
    )
  )

  // Configure equation numbering and spacing.
  set math.equation(numbering: "(1)")
  show math.equation: set block(spacing: 0.65em)

  // Configure appearance of equation references
  show ref: it => {
    if it.element != none and it.element.func() == math.equation {
      // Override equation references.
      link(it.element.location(), numbering(
        it.element.numbering,
        ..counter(math.equation).at(it.element.location())
      ))
    } else {
      // Other references as usual.
      it
    }
  }

  // Configure lists.
  set enum(indent: 10pt, body-indent: 9pt)
  set list(indent: 10pt, body-indent: 9pt)

  // Configure headings.
  set heading(numbering: "1.1.1.")
  show heading: it => locate(loc => {
    // Find out the final number of the heading counter.
    let levels = counter(heading).at(loc)
    let deepest = if levels != () {
      levels.last()
    } else {
      1
    }

    set text(font: "Liberation Sans", size: 9pt)
    if it.level == 1 [
      // First-level headings are centered smallcaps.
      // We don't want to number of the acknowledgment section.
      #let is-ack = it.body in ([Acknowledgment], [Acknowledgement])
      #show: smallcaps
      #v(20pt, weak: true)
      #if it.numbering != none and not is-ack {
        numbering("1.", deepest)
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
      #v(13.75pt, weak: true)
    ] else if it.level == 2 [
      // Second-level headings are run-ins.
      #set par(first-line-indent: 0pt)
      #set text(style: "italic")
      #v(10pt, weak: true)
      #if it.numbering != none {
        numbering("1.", deepest)
        h(7pt, weak: true)
      }
      *#it.body*
      #v(10pt, weak: true)
    ] else [
      // Third level headings are run-ins too, but different.
      #if it.level == 3 {
        numbering("1)", deepest)
        [ ]
      }
      _#(it.body):_
    ]
  })

  // Display the paper's title.
  v(3pt, weak: true)
  align(center, text(18pt, title, font: "Liberation Sans"))
  v(23pt, weak: true)

  // Display the authors list.
  let and-comma = if authors.len() == 2 {" and "} else {", and "}
  
  align(center,
    text(10pt, font: "Liberation Sans", authors.map(author => {
        author.name
        if "orcid" in author and author.orcid != "" {
          link("https://orcid.org/" + author.orcid)[#box(height: 1.1em, baseline: 13.5%)[#image("fig/orcid.svg")]]
        }
      } ).join(", ", last: and-comma)
    )
  )
  
  v(20pt, weak: true)

  // Insert teaser image
  [#figure(
      image(teaser.path),
      caption: teaser.caption,
    ) <teaser>
  ]

  v(20pt, weak: true)

  // Display abstract and index terms.
  if abstract != none {
    block(inset: (left: 24pt, right: 24pt), [
        #set par(justify: true)
        *Abstract*---#abstract
    
        #if index-terms != () [
          *Index terms*---#index-terms.join(", ")
        ]
      ]
    )
  }

  v(10pt, weak: true)
  align(center, box(width: 40%)[#image("fig/diamondrule.svg")])
  v(15pt, weak: true)

  // Start two column mode and configure paragraph properties.
  show: columns.with(2, gutter: 12pt)
  set par(justify: true, first-line-indent: 1em)
  show par: set block(spacing: 0.65em)

  // Display the email address and manuscript info.
  place(left+bottom, float: true, block(
      width: 100%,[
        #align(center, line(length: 50%))

        #set text(style: "italic", size: 7.5pt, font: "Liberation Serif")
        #set list(indent: 0pt, body-indent: 5pt)
        #for author in authors [
          - #author.name is with #author.organization. #box(if "email" in author [E-mail: #author.email.])
        ]
        Manuscript received DD MMM. YYYY; accepted DD MMM. YYYY.
        Date of Publication DD MMM. YYYY; date of current version DD MMM. YYYY.
        For information on obtaining reprints of this article, please send e-mail to: reprints`@`ieee.org.
        Digital Object Identifier: xx.xxxx/TVCG.YYYY.xxxxxxx
      ]
    )
  )

  // Set the body font.
  set text(font: "Liberation Serif", size: 9pt)

  // Display the paper's contents.
  body

  // Display bibliography.
  if bibliography-file != none {
    show bibliography: set text(8pt)
    bibliography(bibliography-file, title: text(10pt)[References], style: "ieee")
  }
}
