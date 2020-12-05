#!/bin/sh

(
cd "$(dirname "$0")" || exit 1
mkdir -p "log"
ncat -e ./server.sh -kl 9921
)
