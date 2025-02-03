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
### launched by: sbatch step1_heudiconv.sh ${subject} ${session_name} ${WD} ${my_study}
###
###############################
#
### The SBATCH directives (line 39 to be revised only):

### Your job name displayed by the queue
### use "squeue" command in a terminal to see it
#SBATCH --job-name=HeuDC_1

### Specify output and error files
### %A for job array's master job allocation number
### or %a for job array ID (index) number
#SBATCH --output=log/out_step1_%A.log
#SBATCH --error=log/err_step1_%A.log

### Specify the number of tasks, CPU per task and buffer size to be used 
### (up to 4 CPU/task to reach optimal power)
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=10G

### The size of the participant table to be run
###SBATCH --array=1-1

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
#
HEUDICONV_SINGULARITY_IMG="/mnt/data/soft/Images/heudiconv_1.1.6.sif"

#####heudiconv_latest.sif"
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
echo "Step 1: generation of text files using HeuDiConv"
echo "#"
echo "Subject processed:" ${subject}
echo "Session processed:" ${session_name}
echo "#"
echo "Job STARTED @ $(date)"
echo "#"
#
# STEP 1/3: generate heuristic file based on a template file + 4 other text files
# Submission to slurm and running the HeuDiConv singularity image
#
# Check the "-d" path (line 83) pointing at the dicom files
#
# Compose the command line
##### original line: -d /base/dicom/{subject}/{session}/scans/*/resources/DICOM/files/*.??? \
cmd="srun singularity run \
	--cleanenv \
	-B ${DATA_DIRECTORY}:/base \
	${HEUDICONV_SINGULARITY_IMG} \
	-d /base/dicom/{subject}/{session}/*/*.??? \
	-s ${subject} \
	--ses ${session_name} \
	-f convertall \
	-c none \
	-o /base/bids/derivatives \
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
echo "If STEP 1 successful: 5 text files were generated in" ${STUDY}"/data/bids/derivatives/.heudiconv/"$1"/info"
echo "#"
echo "Now, STEP 2: edit the empty file heuristic.py just created and copy/paste it to" ${STUDY}"/code"
echo "#"
echo "An example of heuristic file for a study@primage is provided in" ${STUDY}"/code/heuristic_templates/heuristic.py"
echo "#########################################################################"
echo "#"
# For your information about step 2:
# The heuristic file controls how information about the dicoms is used to convert to a file system layout (e.g., BIDS). 
# This is a python file that must have the function infotodict, which takes a single argument seqinfo.
#
# Output results to a table
echo "sub-$subject  ${SLURM_ARRAY_TASK_ID} $exitcode" >> ${SLURM_JOB_NAME}.step1.${SLURM_ARRAY_JOB_ID}.tsv
echo Finished tasks ${SLURM_ARRAY_TASK_ID} with exit code $exitcode
exit $exitcode
