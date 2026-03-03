#!/bin/bash
# Меняет бекап и файл местами

file="$1"

if [[ -z "$file" ]]; then
    echo "Error: enter file name"
    exit 1
fi

if [[ ! -f "$file" ]]; then
    echo "No file.bak specified"
    exit 1
fi

file_bak="${file}.bak"

if [[ ! -f "$file_bak" ]]; then
    echo "No file specified"
    exit 1
fi

set -e # Exit on error

temp=$(mktemp)

mv "$file" "$temp"
mv "$file_bak" "$file"
mv "$temp" "$file_bak"
# rm "$temp"
