#!/usr/bin/env bash

cmd="$1"
desc="$2"
caution="$3"

# Colors
green_bold="\033[32;1m"
red_bold="\033[31;1m"
dim_italic="\033[2;3m"
reset="\033[0m"

# Column width
indent="              "   # 14 spaces
wrap_width=60

wrap() {
    fold -s -w "$wrap_width"
}

# Command + description
printf "${green_bold}%-14s${reset}" "$cmd"
echo "$desc" | wrap | {
    read -r first || true
    printf "%s\n" "$first"
    while read -r line; do
        printf "%s%s\n" "$indent" "$line"
    done
}

# Caution
if [ -n "$caution" ]; then
    printf "%s${red_bold}Caution:${reset} " "$indent"

    count=1
    echo "$caution" | wrap | while read -r line; do
        if [ $count -eq 1 ]; then
            printf "${dim_italic}%s${reset}\n" "$line"
        else
            printf "%s${dim_italic}%s${reset}\n" "$indent" "$line"
        fi
        ((count++))
    done
fi

printf "\n"