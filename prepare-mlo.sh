#!/bin/bash
set -euo pipefail

if [ ! -f MLO.pdf ]; then
    echo "Cannot find MLO.pdf at current directory. Bailing out." >&2
    exit 1
fi

mkdir -p 'source/MLO'
mv MLO.pdf 'source/MLO'
cd 'source/MLO'

pdfseparate MLO.pdf MLO-%d.pdf

for file in MLO-*.pdf; do
    pdftotext "$file"
done

rm -- *.pdf

# Strip diacritics and lowercase the text
for file in MLO-*.txt; do
    iconv -f UTF-8 -t ascii//TRANSLIT "$file" | \
    tr '[:lower:]' '[:upper:]' | sponge "$file"
done
