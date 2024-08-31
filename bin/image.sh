#!/bin/bash -l
#SBATCH --export=NONE
#SBATCH -p workq
#SBATCH --time=12:00:00
#SBATCH --ntasks=28
#SBATCH --mem=124GB

start=`date +%s`

module load singularity
shopt -s expand_aliases

set -x
{

source ${myPath}/aliases

obsnum=OBSNUM
base=BASE

cd ${base}/processing/${obsnum}

### minw shift back
chgcentre -minw -shiftback ${obsnum}.ms

### image
wsclean -name ${obsnum}-img -size 5000 5000 -abs-mem 120\
 -weight uniform -scale 0.1amin -niter 100000 -mgain 0.8\
    -auto-threshold 1.5 -apply-primary-beam \
    -mwa-path /pawsey/mwa ${obsnum}.ms

### TODO: make clean arguments into parsable arguments

end=`date +%s`
runtime=$((end-start))
echo "the job run time ${runtime}"

}