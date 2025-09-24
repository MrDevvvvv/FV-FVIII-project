#!/bin/bash -l

#SBATCH --job-name=CG_prod
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --mem=200g
#SBATCH --nodes=1                    # Single node
#SBATCH --ntasks=1                   # One MPI task (thread_mpi doesn't support multiple tasks)
#SBATCH --cpus-per-task=24           # Number of threads for OpenMP
#SBATCH --gres=gpu:1                 # One GPU
#SBATCH --partition="gpu-long"
#SBATCH --time=7-00:00:00


module purge

# modules to GPU run

module load shared
module load ALICE/default
module load slurm
module load GROMACS/2023.3-foss-2023a-CUDA-12.1.1-PLUMED-2.9.0

# Set OpenMP threads
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

# Some definitions

gro="npt6.gro"
ndx="index.ndx"
top="FV_CG.top"

#####################
### CLUSTER SETUP ###
#####################

# Store the location of the job for later reference
location=$(pwd)

if [ -z $TMPDIR ]
then
        random=$(echo $RANDOM | shasum | cut -c 1-10)
        magic="/scratchdata/$random"
        mkdir $magic
else
        magic=$TMPDIR
        location=$SLURM_SUBMIT_DIR
fi

# Write some info to the slurm file
echo "== Starting run at $(date)"
echo "== Job ID     : ${SLURM_JOBID}"
echo "== Node list  : ${SLURM_NODELIST}"
echo "== Local dir. : ${location}"
echo "== Magic dir. : ${magic}"

# About GPU
echo "## Number of available CUDA devices: $CUDA_VISIBLE_DEVICES"
echo "## Checking status of CUDA device with nvidia-smi" 
nvidia-smi

# Copy all files to the working directory in scratch
cp $location/0*.mdp  $magic/
cp $location/$gro $magic/
cp $location/starting/$ndx $magic/
cp $location/starting/$top $magic/
cp $location/starting/*.itp $magic/
cp $location/martini_itps/*.itp $magic/ 


# Move to the working directory in scratch too
cd $magic
ls
####################################
### MINIMIZATION & EQUILIBRATION ###
####################################

gmx grompp -f 07.martini_prod.mdp -p $top -c $gro -r $gro -n $ndx -o prod.tpr -maxwarn 4
srun gmx_mpi mdrun -ntomp $SLURM_CPUS_PER_TASK -pin on -deffnm prod -cpt 10 -resethway

####################################
### COPY ALL FILES BACK TO DATA1 ###
####################################

cd $location
cp $magic/prod.* $magic/*.gro $magic/*.tpr $magic/*.edr $magic/*.log $magic/*.trr $magic/mdout.mdp $location && rm -R $magic

