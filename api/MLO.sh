#!/bin/bash
searchterm="$(base64 -d <<<"$1" | tr '[:lower:]' '[:upper:]')"

searchterm_regexed="(${searchterm// /)|(})"
result=$(grep "^" "../source/MLO/"*.txt | sort -k 2 | uniq --skip-fields=2 | grep -E "$searchterm_regexed")
files="$(echo "$result" | cut -d':' -f1 | sort | uniq -c | sort -nr | head -15 | sed 's/^\s*([^.]*)..\/source\/(.*)$/\1\2/' -E)"
urlified="$(echo "$files" | awk '{ sub(/.*-/, "", $2); sub(/\.txt$/, "", $2); print $1, "courses.fit.cvut.cz/BI-MLO/ucitele/trlifkat/mlo-skripta.pdf#page="$2; }')"
echo "$urlified"

