#!/bin/bash
#SBATCH -c 8
#SBATCH --mem=2G
#SBATCH -p fasse
#SBATCH -t 60
#SBATCH -o logs/%x-%A_%a.log

export OMP_NUM_THREADS="${SLURM_CPUS_ON_NODE}"
echo "Using threads: $OMP_NUM_THREADS"
module load afni/18.3.05-fasrc01
ROI=$SLURM_ARRAY_TASK_ID

outdir="smoothness_cntrl"
outfile="${ROI}-smoothness_estimates.txt"
if [ ! -d "${outdir}" ]; then
  echo "No dir: ${outdir}, creating it..."
  mkdir -p "${outdir}"
fi
cd "${outdir}"
if [ -f "${outfile}" ]; then
  echo "removing previous output..."
  rm -v "${outfile}"
fi

echo "${ROI}" > ${outfile}

files=($(cat /mnt/stressdevlab/stress_pipeline/Group/FaceReactivity/NewNeuropoint/datafiles/setfilenames_fearGTcalm.txt))
for file in ${files[@]}; do
  #file=${files[0]}
  ID=$(echo $file|sed -e "s#.*/\(10[[:digit:]]\{2\}\)/.*#\1#")
  sess=$(echo $file|sed -e "s#.*/month\([[:digit:]]\{2\}\)/.*#\1#")
  residfile="/ncf/mclaughlin/stressdevlab/stress_pipeline/Group/ClustSim/${ID}_${sess}_FaceReactivity1_res4d.nii.gz"
  roifile=$(echo $file|sed -e "s#FaceReactivity1.feat/reg_standard/stats/cope4.nii.gz#cntrl_regions_FaceReactivity1.nii.gz#")
  
  maskfile="${ID}_${sess}_H${ROI}.nii.gz"
  3dcalc -a "${roifile}" -expr "equals(a, ${ROI})" -prefix "${maskfile}"
  smoothness=($(3dFWHMx -mask "${maskfile}" -input "${residfile}" -acf NULL))
  echo "${smoothness[-1]}" >> "${outfile}"
  rm -v "${maskfile}"
done
