# Development

We value contributions from the community. Here are some helpful commands and guidelines.

## Set up local development

Use [typship](https://github.com/sjfhsjfh/typship) for local development and testing. You can run

```bash
typship dev
```

Then run `typst compile template/main.typ --root template/` to compile the template against the development version of the package. If you want to use the released version of the tvcg-journal package, delete the local symlink with `typship clean`.

## Alternative linking

If you don't want to use typship, you can link the current directory as a [Typst local package](https://github.com/typst/packages#local-packages) with the provided scripts.

- **Mac and Linux:** use `link.sh`.
- **Windows:** use `link.ps1`. Make sure you have the *Developer mode* in Windows set up, otherwise the symlink won't work.

## Fonts

**Mac and Linux:** Install the fallback fonts locally with `brew install font-liberation`.

**Windows:** Install the fonts `Liberation Serif` and `Liberation Sans`. you can download them from [here](https://github.com/liberationfonts/liberation-fonts).

## Creating a thumbnail

```bash
typst compile -f png --pages 1 --ppi 250 template/main.typ --root template/ thumbnail.png
oxipng -o 4 --strip safe --alpha thumbnail.png
```

You are encouraged to use [oxipng](https://github.com/oxipng/oxipng) to reduce the thumbnail's file size.

## Checking the package

Run `typst-package-check check` with [typst-package-check](https://github.com/typst/package-check). Also run `typship check`.

## Publishing a new version

Bump the version in `typst.toml` and `template/main.typ` and the Readme.

Then log in with `typship login universe` and run `typship publish universe`.
