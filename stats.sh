#!/bin/bash
#SBATCH --job-name=stats_hplt
#SBATCH --account=project_462000353
#SBATCH --partition=small
#SBATCH --time=01:50:00
#SBATCH --ntasks=2
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH -o logs/current.out
#SBATCH -e logs/current.err


# language
lang=$1
source=$2
path1="/scratch/project_462000444/europa/pii-masked/${lang}/${source}"
#path2="/scratch/project_462000444/europa/pii-masked/${lang}/culturax"
result1="/scratch/project_462000444/europa/stats/pii-masked/${lang}/${source}"
#result2="/scratch/project_462000444/europa/stats/pii-masked/${lang}/culturax"

if [ ! -e "$path1" ]; then
    echo "Error: File not found at $path1"
    exit 1  # You can choose a different exit code if needed
fi

# Create the result path if it does not exist:
if ! [ -d "$result1" ]; then
    mkdir -p "$result1"
fi

output_log="logs/stats_${lang}.out"
if [ -f "$output_log" ]; then
    rm $output_log
fi

start_time=$(date +"%T")

selected_files1=$(shuf -n 8 -e $path1/*)
#selected_files2=$(shuf -n 8 -e $path2/*)
#echo "Sampled files: " > "${result1}/stats.txt"
#echo "Sampled files: " > "${result2}/stats.txt"
#echo $selected_files1 >> "${result1}/stats.txt"
#echo $selected_files2 >> "${result2}/stats.txt"

srun cat $selected_files1 | python3 stats.py > "${result1}/stats.txt" #&
#srun cat $selected_files2 | python3 stats.py > "${result2}/stats.txt" 



#selected_files1=$(ls $path1/* | shuf | head -n 1)
#selected_files2=$(ls $path2/* | shuf | head -n 1)
#echo "Sampled files: " > "${result1}/stats.txt"
#echo "Sampled files: " > "${result2}/stats.txt"
#echo $selected_files1 >> "${result1}/stats.txt"
#echo $selected_files2 >> "${result2}/stats.txt"
#srun ls $selected_files1 | xargs cat | python3 stats.py >> "${result1}/stats.txt" &
#srun ls $selected_files2 | xargs cat | python3 stats.py >> "${result2}/stats.txt"


echo $start_time > $output_log
sacct -j $SLURM_JOBID --format=JobID,Elapsed,AllocCPUS,AllocNodes >> $output_log
