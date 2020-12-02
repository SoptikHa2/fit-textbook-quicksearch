#!/bin/bash
searchterm="$(base64 -d <<<"$1")"

searchterm_regexed="(${searchterm// /)|(})"
result=$(grep "^" "../source/kam.fit.cvut.cz/deploy/bi-zma/mirror/textbook/"*.html | sort -k 2 | uniq --skip-fields=2 | grep -iE "$searchterm_regexed")
files="$(echo "$result" | cut -d':' -f1 | sort | uniq -c | sort -nr | head -15 | sed 's/^\s*([^.]*)..\/source\/(.*)$/\1\2/' -E)"
echo "$files"

