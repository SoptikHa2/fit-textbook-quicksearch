#!/bin/sh
for file in $(find source -iname '*.html'); do
    iconv -f UTF-8 -t ascii//TRANSLIT "$file" | sponge "$file"
done
