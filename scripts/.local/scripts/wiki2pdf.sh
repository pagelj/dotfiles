#!/bin/sh

export WIKIPATH="$XDG_DATA_HOME/vimwiki/"
mkdir -p "$WIKIPATH"/pdf
find "$WIKIPATH" -iname "*.wiki" -type f -exec sh -c 'pandoc -f markdown -t pdf --pdf-engine=xelatex -V "geometry:margin=1in" "${0}" -o "$WIKIPATH/pdf/$(basename ${0%.wiki}.pdf)"' {} \;
