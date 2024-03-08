#!/bin/bash


# language
lang=$1
source=$2

full_path="/scratch/project_462000444/europa/source-data/${lang}/${source}"
result_path="/scratch/project_462000444/europa/pii-masked/${lang}/${source}"

file_count=$(find "$full_path" -maxdepth 1 -type f | wc -l)

if [ "$file_count" -le 200 ]; then
    echo "There are $file_count files in the directory. Proceeding with execution."
else
    echo "Error: There are more than 200 files in the directory. Stopping execution, use launch2.sh."
    exit 1
fi


for file in "$full_path"/*; do
    # Check if it's a file
    if [ -f "$file" ]; then
        # Check if the filename contains either "shard" or "part" => skipping redpajama master file
        if [[ "$file" == *"shard"* || "$file" == *"part"* ]]; then
            echo "sbatch run.sh ${lang} ${file} ${result_path}"
            sbatch run.sh $lang $file $result_path
        fi
    fi
done




