#!/bin/bash
#SBATCH --job-name=npoint
#SBATCH --output=/users/jflournoy/sea_npoint/npoint_%A_%a.out
#SBATCH --error=/users/jflournoy/sea_npoint/npoint_%A_%a.err
#SBATCH --time=2:00:00
#SBATCH --partition=ncf
#SBATCH --mail-type=END,FAIL
#SBATCH --cpus-per-task=1
#SBATCH --mem=3000M
dirnum=$SLURM_ARRAY_TASK_ID
module load gcc/7.1.0-fasrc01
module load R/3.5.1-fasrc01

cp ~/.R/Makevars.gcc ~/.R/Makevars

export R_LIBS_USER=/ncf/mclaughlin/users/jflournoy/R_3.5.1_GCC:$R_LIBS_USER

dirarray=($(cat "$1"))

thisdir=${dirarray[$dirnum]}

echo "Dir list is ${#dirarray[@]} elements long"
echo "Choosing number ${dirnum}"
echo "Changing directory to '${thisdir}'"
cd $thisdir
srun -c 1 npoint
exit
