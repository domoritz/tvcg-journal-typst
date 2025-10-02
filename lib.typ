// Used for the beginnings of sentences.
#let long-ref(target) = ref(target, supplement: it => {
  if it.func() == heading {
    [Section]
  } else if it.func() == figure {
    if it.kind == image {
      [Figure]
    } else if it.kind == table {
      [Table]
    } else {
      [Listing] // fallback for other figure types
    }
  } else {
    [] // fallback for anything else
  }
})

// This function gets your whole document as its `body` and formats
// it as an article in the style of the IEEE.
#let ieeevis(
  // The paper's title.
  title: [Global Illumination for Fun and Profit],
  review: false,
  category: "n/a",
  paper-type: "please specify",
  submission-id: 0,
  // An array of authors. For each author you can specify a name,
  // department, organization, location, and email. Everything but
  // but the name is optional.
  authors: (
    (
      name: "Josiah Carberry",
      orcid: "0000-0002-1825-0097",
      affiliation: [Brown University],
      email: "jcarberry@example.com",
    ),
    (
      name: "Ed Grimley",
      affiliation: [Grimley Widgets, Inc],
      email: "ed.grimley@example.com",
    ),
    (
      name: "Martha Stewart",
      affiliation: [Martha Stewart Enterprises at Microsoft
        Research],
      email: "martha.stewart@example.com",
    ),
  ),
  teaser: image("CypressView.jpg"),
  teaser-caption: [In the Clouds: Vancouver from Cypress Mountain. Note that the teaser may not be wider than the abstract block.],
  // The paper's abstract. Can be omitted if you don't have one.
  abstract: [Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut purus elit, vestibulum ut, placerat ac, adipiscing vitae, felis.
    Curabitur dictum gravida mauris. Nam arcu libero, nonummy eget, consectetuer id, vulputate a, magna. Donec vehicula augue eu
    neque. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Mauris ut leo. Cras viverra
    metus rhoncus sem. Nulla et lectus vestibulum urna fringilla ultrices. Phasellus eu tellus sit amet tortor gravida placerat. Integer
    sapien est, iaculis in, pretium quis, viverra ac, nunc. Praesent eget sem vel leo ultrices bibendum. Aenean faucibus. Morbi dolor nulla,
    malesuada eu, pulvinar at, mollis ac, nulla. Curabitur auctor semper nulla. Donec varius orci eget risus. Duis nibh mi, congue eu,
    accumsan eleifend, sagittis quis, diam. Duis eget orci sit amet orci dignissim rutrum. A free copy of this paper and all supplemental
    materials are available at https://OSF.IO/2NBSG.],
  // A list of index terms to display after the abstract.
  index-terms: ([Radiosity], [global illumination], [constant time]),
  // The article's paper size. Also affects the margins.
  paper-size: "us-letter",
  // The result of a call to the `bibliography` function or `none`.
  bibliography: none,
  // How figures are referred to from within the text.
  // Use "Figure" instead of "Fig." for computer-related publications.
  figure-supplement: [Fig.],
  manuscript-note: "Manuscript received xx xxx. 201x; accepted xx xxx. 201x. Date of Publication xx xxx. 201x; date of current version xx xxx. 201x. For information on obtaining reprints of this article, please send  e-mail to: reprints@ieee.org. Digital Object Identifier: xx.xxxx/TVCG.201x.xxxxxxx",
  // Helvetica replacement that supports smallcaps and is open source
  display-font: "Tex Gyre Heros",
  // Times New Roman fonts are available at https://github.com/justrajdeep/fonts/tree/master
  body-font: "Times New Roman",
  code-font: "Fira Code",
  mono-font: "Fira Code",
  // The paper's content.
  body,
) = {
  // Set document metadata.
  if review == true {
    set document(title: title, author: "Anonymous")
  } else {
    set document(title: title, author: authors.map(author => author.name))
  }


  // Set the body font.
  // As of 2024-08, the IEEE LaTeX template uses wider interword spacing
  // - See e.g. the definition \def\@IEEEinterspaceratioM{0.35} in IEEEtran.cls
  // TODO: look up interword spacing...
  /*
    BODY TEXT
  9pt Times or Times New Roman, justified on 10pt leading indent all paragraphs by 1em (roughly 3mm) except the first one under a heading.
  No blank lines between paragraphs.
    */
  set text(font: body-font, size: 9pt, weight: 400)
  set par(leading: 3pt, first-line-indent: 1em, justify: true)

  // Enums numbering
  set enum(numbering: "1)a)i)")

  // Tables & figures
  show figure: set block(spacing: 15.5pt)
  show figure: set place(clearance: 15.5pt)
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: table): set text(size: 8pt)
  show figure.where(kind: table): set figure(numbering: "1")
  show figure.where(kind: image): set figure(supplement: figure-supplement, numbering: "1")
  show figure.caption: set text(size: 8pt)
  show figure.caption: set align(start)
  show figure.caption.where(kind: table): set align(center)

  // Adapt supplement in caption independently from supplement used for
  // references.
  show figure: fig => {
    let prefix = (
      if fig.kind == table [Table] else if fig.kind == image [Fig.] else [#fig.supplement]
    )
    let numbers = numbering(fig.numbering, ..fig.counter.at(fig.location()))
    show figure.caption: set text(size: 8pt, font: display-font)
    show figure.caption: it => [#prefix~#numbers: #it.body]
    // show figure.caption.where(kind: table): smallcaps
    fig
  }

  // Code blocks
  show raw: set text(
    font: code-font,
    ligatures: true,
    size: 1.07em,
    spacing: 100%,
  )

  // links
  show link: set text(fill: navy, font: mono-font, weight: 500, size: 7.5pt)

  // Configure the page and multi-column properties.
  /*
  Paper Size: 8.5 inches by 11.0 inches (21.59cm by 27.94cm)
  Top Margin: 0.75 inch (1.905 cm)
  Bottom Margin: 0.625 inch (1.5875 cm)
  Inside Margin: 0.75 inch (1.905 cm)
  Outside Margin: 0.625 inch (1.5875 cm)
  Columns: Two (2) columns, each 3.48 inches (8.8392 cm) wide
  Column Gutter: 0.17 inches (0.4318 cm) column gutter
  */
  set columns(gutter: 0.17in)
  set page(
    columns: 2,
    numbering: "1",
    paper: "us-letter",
    margin: (
      top: 0.75in,
      bottom: 0.625in,
      inside: 0.75in,
      outside: 0.625in,
    ),
    header: if review == true {
      context {
        if calc.odd(counter(page).get().first()) {
          align(center, emph([Online Submission ID: #submission-id]))
        }
      }
    },
  )

  show ref.where(
    form: "normal",
  ): set ref(supplement: it => {
    if it.func() == heading {
      [Sec.]
    } else if it.func() == figure {
      if it.kind == image {
        [Fig.]
      } else if it.kind == table {
        [Tab.]
      } else {
        [Lst.]
      }
    }
  })

  // Configure equation numbering and spacing.
  set math.equation(numbering: "(1)")
  show math.equation: set block(spacing: 0.65em)

  // Configure appearance of equation references
  show ref: it => {
    if it.element == none {
      it
    } else if it.element.func() == math.equation {
      // Override equation references.
      link(it.element.location(), numbering(
        it.element.numbering,
        ..counter(math.equation).at(it.element.location()),
      ))
    } /*  else if it.element.func() == heading {
        // Override equation references.
        it.supplement = [Section]
        link(it.element.location(), numbering(
          it.element.numbering,
          ..counter(math.equation).at(it.element.location())
        ))
      } */ else {
      // Other references as usual.
      it
    }
  }

  // Configure lists.
  set enum(indent: 10pt, body-indent: 9pt)
  set list(indent: 10pt, body-indent: 9pt)

  // Configure headings.
  /*
  HEADINGS
  Section Headings: 9pt Helvetica, bold, flush left, numbered, small caps.
  Subsection Headings: 9pt Helvetica, bold, flush left, numbered.
  Sub-subsection Headings: 9pt Helvetica, flush left, numbered.
  */
  // https://github.com/typst/typst/discussions/4574#discussioncomment-10498178
  // removes trailing period
  set heading(numbering: (..nums) => nums.pos().map(str).join("."))
  // TODO: change space between number and heading??? https://forum.typst.app/t/how-to-increase-the-spacing-between-the-number-and-the-title-of-a-heading/640/16
  show heading: set text(size: 9pt, font: display-font, weight: "bold")
  show heading.where(level: 1): set block(below: 1em)
  // TODO: Helvetica doesn't have a smallcaps mode...
  show heading.where(level: 1): smallcaps
  show heading.where(level: 3): set text(weight: "regular")

  show heading: it => {
    if it.body in ([Acknowledgment], [Acknowledgement], [Acknowledgments], [Acknowledgements]) {
      set text(size: 9pt, font: display-font, weight: "bold")
      block(smallcaps(it.body))
    } else {
      it
    }
  }

  // set heading(numbering: (..numbers) => numbers)
  // show heading.where(level: 1): it => {
  //   set text(size: 9pt, font: "Helvetica", weight: "bold")
  //   smallcaps[#it.numbering #it.body]
  // }
  // show heading: it => {
  //   if it.level == 1 {


  //   } else if it.level == 2 {
  //     set text(9pt)
  //     it.
  //     [#it.numbering #it.body]
  //   }
  //   // numbering("1.", deepest)

  // }
  // show heading: it => {
  //   // Find out the final number of the heading counter.
  //   let levels = counter(heading).get()
  //   let deepest = if levels != () {
  //     levels.last()
  //   } else {
  //     1
  //   }

  //   set text(10pt, weight: 400)
  //   if it.level == 1 {
  //     // First-level headings are centered smallcaps.
  //     // We don't want to number the acknowledgment section.
  //     let is-ack = it.body in ([Acknowledgment], [Acknowledgement], [Acknowledgments], [Acknowledgements])
  //     set align(center)
  //     set text(if is-ack { 10pt } else { 11pt })
  //     show: block.with(above: 15pt, below: 13.75pt, sticky: true)
  //     show: smallcaps
  //     if it.numbering != none and not is-ack {
  //       numbering("1.", deepest)
  //       h(7pt, weak: true)
  //     }
  //     it.body
  //   } else if it.level == 2 {
  //     // Second-level headings are run-ins.
  //     set par(first-line-indent: 0pt)
  //     set text(style: "italic")
  //     show: block.with(spacing: 10pt, sticky: true)
  //     if it.numbering != none {
  //       numbering("1.", deepest)
  //       h(7pt, weak: true)
  //     }
  //     it.body
  //   } else [
  //     // Third level headings are run-ins too, but different.
  //     #if it.level == 3 {
  //       numbering("1.", deepest)
  //       [ ]
  //     }
  //     _#(it.body):_
  //   ]
  // }

  // Style bibliography.
  show std.bibliography: set text(8pt)
  show std.bibliography: set par(spacing: 0.5em)
  set std.bibliography(title: text(9pt)[References], style: "ieee")

  /* TODO: not sure if this works in review mode */
  set footnote(numbering: (..nums) => nums.pos().map(i => str(i - 1)).join("."))
  set footnote.entry(separator: align(center, line(length: 50% + 0pt, stroke: 0.5pt)))

  // Display the paper's title and authors at the top of the page,
  // spanning all columns (hence floating at the scope of the
  // columns' parent, which is the page).
  /*
  TITLE
  Title Text: 18pt Helvetica, centered
  Capitalize the first letter of nouns, pronouns, verbs, adjectives, and adverbs; do not capitalize articles, coordinate conjunctions, or prepositions (unless the title begins with such a word).
  */
  place(
    top,
    float: true,
    scope: "parent",
    clearance: 30pt,
    {
      v(3pt, weak: true)
      align(center, par(leading: 0.5em, text(size: 18pt, font: display-font, title)))
      v(16pt, weak: true)

      // Display the authors list.
      /* TODO: author affiliation should be 10pt */
      /*
      AUTHOR INFORMATION AND AFFILIATION
      Author Names: 10pt Helvetica, centered
      Author Information is specified in a comma separated list, the last one being attached with ‘, and’. If only two authors are given simply separate them with a single ‘and’. IEEE Members should be indicated by appending ‘Member, IEEE’ or ‘Student Member, IEEE’, whichever applies.
      Author Affiliation should be 10pt Times or Times New Roman.
      Contact Information should be provided as a list in a separate footnote at the bottom of the first page in the left column.
      Please include each author’s name, affiliation, and e-mail address, in bullet form with one bullet point per author.
      Please insert punctuation at the end of each item.
      */

      if review == true {
        align(center, [
          Category: #category
          #v(-0.2em)
          Paper Type: #paper-type
        ])
      } else {
        if authors != none {
          let authorNames = authors.map(author => {
            if "orcid" in author {
              show link: set text(fill: black, size: 9pt, weight: 400, font: body-font)
              link("https://orcid.org/" + author.orcid)[#author.name
                #box(height: 8pt, baseline: 0.1em, image("ORCID-iD_icon_vector.svg"))]
            } else {
              author.name
            }
          })

          if authorNames.len() == 2 {
            align(center, par(justify: false, [
              #authorNames.slice(0, authorNames.len() - 1).join(", ")
              and #authorNames.last()
            ]))
          } else {
            align(center, par(justify: false, [
              #authorNames.slice(0, authorNames.len() - 1).join(", "),
              and #authorNames.last()
            ]))
          }
        }
      }
      if review == false { v(-4pt) }

      // set par(leading: 0.6em)
      // for i in range(calc.ceil(authors.len() / 3)) {
      //   let end = calc.min((i + 1) * 3, authors.len())
      //   let is-last = authors.len() == end
      //   let slice = authors.slice(i * 3, end)
      //   grid(
      //     columns: slice.len() * (1fr,),
      //     gutter: 12pt,
      //     ..slice.map(author => align(center, {
      //       text(size: 10pt, font: "Helvetica", author.name)
      //       if "department" in author [
      //         \ #emph(author.department)
      //       ]
      //       if "organization" in author [
      //         \ #emph(author.organization)
      //       ]
      //       if "location" in author [
      //         \ #author.location
      //       ]
      //       if "email" in author {
      //         if type(author.email) == str [
      //           \ #link("mailto:" + author.email)
      //         ] else [
      //           \ #author.email
      //         ]
      //       }
      //     }))
      //   )

      //   if not is-last {
      //     v(16pt, weak: true)
      //   }
      // }

      // TODO: can I consolidate the two boxes into one box call?
      // TODO: this figure caption must be centered (unlike the other figure captions)
      align(center, box(inset: (left: 0.33in, right: 0.33in), {
        show figure.caption: set align(center)
        [#figure(
          teaser,
          caption: teaser-caption,
        ) <teaser>]
      }))


      // Configure paragraph properties.
      // set par(spacing: 0.45em, justify: true, first-line-indent: 1em, leading: 0.45em)

      // Display abstract and index terms.
      if abstract != none [
        #set par(first-line-indent: 0pt)
        #box(inset: (left: 0.33in, right: 0.33in))[
          #set text(size: 8pt, font: display-font)
          *Abstract*---#h(weak: true, 0pt)#abstract

          #if index-terms != () [
            *Index Terms*---#h(weak: true, 0pt)#index-terms.join(", ")
          ]
          // #v(2pt)
        ]
      ]

      align(center, image("diamondrule.svg"))
    },
  )

  /* It should coalesce authors if they share an affiliation and email suffixes (see template) */
  if review == false {
    footnote(numbering: it => none)[
      #set text(style: "italic")
      #set par(justify: false)
      #set list(indent: 0pt, body-indent: 4pt)
      #list(..authors.map(author => {
        if "affiliation" in author [
          #author.name is with #author.affiliation.
        ] else [
          #author.name.
        ]
        if "email" in author {
          box(
            [E-mail:
              #if type(author.email) == str [
                #show link: set text(fill: black, size: 8pt, weight: 400, font: body-font)
                #show link: underline
                #link("mailto:" + author.email).
              ] else [#author.email.]
            ],
          )
          // #box([E-mail: #author.email]).
          // ]
        }
      }))
      #manuscript-note
    ]
  }

  // reset after we've done the page 1 footnote
  set footnote.entry(separator: line(length: 30% + 0pt, stroke: 0.5pt))

  // Display the paper's contents.
  // set par(leading: 0.5em)
  if review == true {
    v(-1.5em)
  } else {
    v(-3em)
  }
  body

  show link: set text(size: 7pt)
  // Display bibliography.
  bibliography
}
