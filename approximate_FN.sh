#!/bin/bash


source=$1
lang=$2
number=$3

path1="/scratch/project_462000444/europa/pii-masked/${lang}/${source}"

files=("$path1"/*)
# Select a random file from the list
selected_files="${files[RANDOM % ${#files[@]}]}"

#selected_files1=$(shuf -n 3 -e $path1/*)
echo $selected_files


masked=$(cat $selected_files | grep "+0 0000000" | wc -l)
unmasked=$(cat $selected_files | grep $number | grep -v "+0 0000000" | wc -l)


echo "unmasked, masked"
echo $unmasked "; "  $masked