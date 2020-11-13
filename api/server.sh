#!/bin/bash
# Shell server adapted from ynaas: https://github.com/izabera/ynaas
set -euo pipefail

host=grep.fit.soptik.tech
IFS=$' \t\n\r'

read -r request destination_and_protocol
destination=${destination_and_protocol% *}

while read -r header value; do
    [[ $header = Host: ]] && host=$value
    [[ $header = Content-Length: ]] && length=$value
    [[ $header ]] || break
done

case $request in
    GET)
        # Disallow bad destination names
        # Throw the request away if it contains dot, percent sign, dollar or a backtick
        # I don't want to validate percent-encoding in bash
        if [[ $destination == *.* ]] || [[ $destination == *%* ]] || [[ $destination == *\`* ]] || [[ $destination == *\$* ]]; then
            printf 'HTTP/1.1 400 Bad Request\r\n\r\n<img src="https://http.cat/400">Please do not use dots, dollar signs, backticks or percent encoding.'
            exit
        fi
        destinationWithoutFirstSlash="${destination#/}"
        textbookName="${destinationWithoutFirstSlash%%/*}"
        searchTermWithoutFirstSlash="${destinationWithoutFirstSlash#*/}"
        searchTerm="${searchTermWithoutFirstSlash%%/*}"

        case $textbookName in
            ZMA)
                searchResult="$(./ZMA.sh "$searchTerm")"
                printf 'HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nAccess-Control-Allow-Origin: https://fit.soptik.tech\r\n\r\n%s' "$searchResult"
            ;;
            ZMANAME)
                nameResult="$(./ZMANAME.sh "$searchTerm")"
                printf 'HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nAccess-Control-Allow-Origin: https://fit.soptik.tech\r\n\r\n%s' "$searchResult"
            ;;
            *)
                printf 'HTTP/1.1 404 Not Found\r\n\r\n%s' "<img src='https://http.cat/404'>"
            ;;
        esac
        ;;
    *)
        printf 'HTTP/1.1 405 Method Not Allowed\r\nAllow: GET, POST\r\n\r\n<img src="https://http.cat/405" />'
        exit
        ;;
esac

