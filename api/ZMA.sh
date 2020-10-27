#!/bin/bash
searchterm="$(base64 -d <<<"$1")"

getPageTitle() {
    fileAddr="$(awk '{print $2}' <<<"$1")"
    #echo $fileAddr >&2
    titlesSeparatedByColon="$(tr -d '\n' <"$fileAddr" | grep -Eo '<h3>.*</h3>' | sed 's/<\/span>/\n/g' | sed 's/.*<span>(.*)/\1/' -E | grep '\w{3,}' -E  | tr '\n' ':' | sed 's/.$/\n/')"
    echo "$titlesSeparatedByColon"
}




result=$(grep "$searchterm" "../source/courses.fit.cvut.cz/BI-ZMA/textbook/"*.html | sort -k 2 | uniq --skip-fields=2 | fzf -f "$searchterm")
echo "$result"
exit 0
files="$(echo "$result" | cut -d':' -f1 | sort | uniq -c | sort -nr)"
IFS=$'\n'
for file in $files; do
    firstCol="$(awk '{print $1}' <<<"$file")"
    secondCol="$(awk '{print $2}' <<<"$file")"
    thirdCol="$(getPageTitle "$file" | base64)"
    echo "$firstCol:${secondCol##*/}:$thirdCol"
done

