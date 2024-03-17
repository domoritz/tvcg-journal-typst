#!/usr/bin/env bash

version_line=$(grep -E "^version\s*=" "typst.toml")
version=$(echo "$version_line" | cut -d '"' -f 2)

target=~/Library/Application\ Support/typst/packages/preview/tvcg-journal/$version
mkdir -p "$target"

rm -f "$target"
ln -s $(pwd)/ "$target"

echo Created lib.typ symlink in \""$target"\". To unlink, delete the symlink.
