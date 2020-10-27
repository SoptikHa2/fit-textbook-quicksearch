#!/bin/bash
searchterm="$(base64 -d <<<"$1")"

result=$(grep "^" "../source/courses.fit.cvut.cz/BI-ZMA/textbook/"*.html | sort -k 2 | uniq --skip-fields=2 | fzf -f "$searchterm")
files="$(echo "$result" | cut -d':' -f1 | sort | uniq -c | sort -nr | head -15 | sed 's/^\s*([^.]*)..\/source\/(.*)$/\1\2/' -E)"
echo "$files"

