#!/bin/bash

###############################
### Original script from Arnaud Fournel, PhD, NeuroPop team, CRNL, Lyon
### arnaud.fournel @ inserm.fr
### 
### Adapted for the CRNL study
### by Gaelle Leroux, PhD
### and Isabelle Faillenot, PhD
###
### Autumn 2020, Lyon
### gaelle.leroux @ cnrs.fr
###
### launched by: sbatch step3_heudiconv.sh ${subject} ${session_name} ${WD} ${my_study}
###
###############################
#
### The SBATCH directives (line 39 to be revised only):

### Your job name displayed by the queue
### use "squeue" command in a terminal to see it
#SBATCH --job-name=HeuDC_3

### Specify output and error files
### %A for job array's master job allocation number.
### or %a for job array ID (index) number
#SBATCH --output=log/out_step3_%A.log
#SBATCH --error=log/err_step3_%A.log

### Specify the number of tasks, CPU per task and buffer size to be used
### (up to 4 CPU/task to reach optimal power)
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=10G

### Send email for which step: NONE, BEGIN, END, FAIL, REQUEUE, ALL
#SBATCH --mail-type=ALL
#SBATCH --mail-user=${firstName}.${lastName}@univ-lyon1.fr

### The size of the participant table to be run
### SBATCH --array=1-1

### If you want to launch your script on a specific node of the cluser
### If yes, uncomment the appropirate line(s) 
###SBATCH --exclude=node9
###SBATCH --nodelist=node10

# End of the SBATCH directives
###############################
#
# Paths of the study
subject=$1
session_name=$2
WD=$3
my_study=$4
STUDY=${WD}/${my_study}
DATA_DIRECTORY="${STUDY}/data"
rm ${STUDY}/data/bids/${subject}/${session_name}/.heudiconv/*.edit.txt
#
HEUDICONV_SINGULARITY_IMG="/mnt/data/soft/Images/heudiconv_1.1.0.sif"
#
## Comment: Parse the participants.tsv file and extract one subject ID from the line corresponding to this SLURM task.
## Comment: 1 line below to uncomment if you want to launch the script for all the subjects listed in ${DATA_DIRECTORY}/participants.tsv
#subject=$( sed -n -E "$((${SLURM_ARRAY_TASK_ID} + 1))s/sub-(\S*)\>.*/\1/gp" ${DATA_DIRECTORY}/participants.tsv )
#
# To be printed in the out_*.log file :
echo "#########################################################################"
echo "User:" $USER
echo "#"
echo "SLURM_SUBMITING_DIRECTORY:" $SLURM_SUBMIT_DIR
echo "SLURM_JOB_NODELIST:" $SLURM_NODELIST
echo "SLURM_JOB_NAME:" $SLURM_JOB_NAME
echo "SLURM_JOB_ID:" $SLURM_JOBID
echo "SLURM_ARRAY_TASK_ID:" $SLURM_ARRAY_TASK_ID
echo "SLURM_NTASKS:" $SLURM_NTASKS
echo "#"
echo "Step 3: conversion of DICOM to NIFTI with BIDS standards using HeuDiConv"
echo "#"
echo "Subject processed:" ${subject}
echo "Session processed:" ${session_name}
echo "#"
echo "Job STARTED @ $(date)"heuristic.py
echo "#"
#
# STEP 3/3: conversion of DICOM to NIFTII using dcm2niix and to a BIDS standard organisation
# submission to slurm and running the HeuDiCon singularity image
#
# Check the "-d" path (line 87) pointing at the dicom files
#
# Compose the command line
## original: -d /base/dicom/{subject}/{session}/scans/*/resources/DICOM/files/*.??? \
cmd="srun singularity run \
	--cleanenv \
	-B ${DATA_DIRECTORY}:/base -B ${STUDY}:/study \
	${HEUDICONV_SINGULARITY_IMG} \
	-d /base/dicom/{subject}/{session}/*/*.??? \
	-s ${subject} \
	--ses ${session_name} \
	-f /study/code/heuristic.py \
	-c dcm2niix -b \
	-o /base/bids \
	--minmeta \
	--overwrite"
#
# Setup done, run the command
echo Running task ${SLURM_ARRAY_TASK_ID}
echo "Command line used (example of the last subject processed)"
echo $cmd
#
echo "#"
#
eval $cmd
exitcode=$?
#
echo "#"
echo "Job STOPPED @ $(date)"
echo "#"
echo "If STEP 3 successful: check the text files & folders (.heudiconv and sub-{$1}) in" 
echo ${DATA_DIRECTORY}"/bids"
echo "Edit the file" ${DATA_DIRECTORY}"/dataset_description.json"
echo "Create events.tsv file for each func/*.json file"
echo "#"
echo "Then, validate your nifti folder using online BIDS VALIDATOR: https://bids-standard.github.io/bids-validator/"
echo "############################################################################################"
echo "#"
# Output results to a table
echo "sub-${subject}	${SLURM_ARRAY_TASK_ID}	$exitcode" >> ${SLURM_JOB_NAME}.step3.${SLURM_ARRAY_JOB_ID}.tsv
echo Finished tasks ${SLURM_ARRAY_TASK_ID} with exit code $exitcode
exit $exitcode
