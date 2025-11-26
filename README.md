# tvcg-journal-typst

A [Typst](https://typst.app) template for TVCG journals and the IEEE VIS Conference. This is work in progress and not yet ready. This project was started by Matěj Lang at https://typst.app/project/pdh8Qj4vO7tfB1oiWoHuez. Please help us finish it to look as close as possible to the [LaTeX template](https://github.com/ieeevgtc/tvcg-journal-latex).

## Development

First, link the current directory as a [Typst local package](https://github.com/typst/packages#local-packages) so that the template can be used in a local project.
- **Mac and Linux:** use `link.sh`.
- **Windows:** use `link.ps1`. Make sure you have the *Developer mode* in Windows set up, otherwise the symlink won't work.

Then run `typst compile template/main.typ --root template/` to compile the template against the development version of the package. If you want to use the released version of the tvcg-journal package, delete the local symlink.


### Fonts
**Mac and Linux:** Install the required fonts locally with `brew install font-liberation`.

**Windows:** Install the fonts `Liberation Serif` and `Liberation Sans`. you can download them from [here](https://github.com/liberationfonts/liberation-fonts).

### Creating a Thumbnail

```bash
typst compile template/main.typ --root template/ && magick -density 150 template/main.pdf[0] -quality 85 thumbnail.png
```

This compiles the template and converts the first page to a PNG thumbnail. Requires [ImageMagick](https://imagemagick.org/) to be installed.
