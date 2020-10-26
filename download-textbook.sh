#!/bin/sh
# $1 = url
# $2 = access token
cd source || exit 1
wget -r --tries=0 "$1" --show-progress --no-cache -r -l 20 -k -p --no-cookies --header "Cookie: oauth_access_token=$2"
