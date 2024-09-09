#!/bin/bash -l
#SBATCH --export=NONE
#SBATCH -p workq
#SBATCH --time=20:00:00
#SBATCH --ntasks=28
#SBATCH --mem=124GB

start=`date +%s`

module load singularity
shopt -s expand_aliases
source /scratch/mwasci/sprabu/MWA-Pipeline/aliases


set -x
{

obsnum=OBSNUM
base=BASE

cd ${base}/processing/${obsnum}

### minw shift back
#chgcentre -minw -shiftback ${obsnum}.ms

### image
wsclean -name ${obsnum}-2m -size 5000 5000 -abs-mem 120\
 -weight uniform -scale 0.1amin -niter 100000 -mgain 0.8\
    -auto-threshold 1.5 -pol xx,yy ${obsnum}.ms

### create beam model
beam -2016 -proto ${obsnum}-2m-XX-image.fits\
 -ms ${obsnum}.ms -name beam-MFS

### apply primary beam correction
pbcorrect ${obsnum}-2m image.fits beam-MFS ${obsnum}-2m-pbcorr

### TODO: make clean arguments into parsable arguments

end=`date +%s`
runtime=$((end-start))
echo "the job run time ${runtime}"

}