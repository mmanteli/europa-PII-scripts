#!/bin/bash
#SBATCH --job-name=redact_hplt
#SBATCH --account=project_462000444
#SBATCH --partition=small
#SBATCH --time=00:30:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH -o logs/%x.out
#SBATCH -e logs/%x.err


# language
lang=$1
file=$2
result=$3
b="$(basename -- $file)"
new_jobname=$(basename "$file" | cut -d. -f1)



# see that the input is given correctly
if [ -f "$file" ]; then
    echo "redacting from ${file}" 
    start_time=$(date +"%T.%N")    
    echo "start time: $(date +"%T.%N")"
else
    echo "Path not found: $file"
    exit 1
fi

# Create the result path if it does not exist:
if ! [ -d "$result" ]; then
    mkdir -p "$result"
fi


output_log="logs/${new_jobname}.out"
#error_log="logs/${new_jobname}.err"
if [ -f "$output_log" ]; then
    rm $output_log
fi



module purge
# singularity setup
CONTAINER="/scratch/project_462000444/mynttiam/conda-env-config/pii_container.sif"
SING_BIND="/scratch/project_462000444/"

# save to result/{same name as input}
if [ -f "$file" ]; then
    echo "python redact.py ${lang} ${file} > ${result}/${b}"
    srun singularity exec -B "$SING_BIND" "$CONTAINER" \
            python /scratch/project_462000444/mynttiam/redact.py $lang < $file > "${result}/${b}"
fi


# This works
#srun \
#    singularity exec \
#    -B "$SING_BIND" \
#    "$CONTAINER" \
#    python /scratch/project_462000444/mynttiam/test_manager.py la	


echo $start_time > $output_log
sacct -j $SLURM_JOBID --format=JobID,Elapsed,AllocCPUS,AllocNodes >> $output_log
