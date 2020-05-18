#!/bin/bash

ftp -inv $1 <<EOT
quote USER $2
quote PASS $3
bin
get config "$1.txt"
EOT

if [ -f "$1.txt" ]; then
    exit 0
else
    exit 1
fi
