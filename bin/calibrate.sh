#!/bin/bash -l
#SBATCH --export=NONE
#SBATCH -p workq
#SBATCH --time=12:00:00
#SBATCH --ntasks=28
#SBATCH --mem=124GB
#SBATCH -J calibration

start=`date +%s`
module load singularity
shopt -s expand_aliases


set -x
{

obsnum=OBSNUM
base=BASE
model=

source ${myPath}/aliases

while getopts 'm:' OPTION
do
    case "$OPTION" in
        m)
            link=${OPTARG}
            ;;
    esac
done

cd ${base}/processing/

### round 1
calibrate -absmem 120 -m ../../models/model-${model}*withalpha.txt \
    -minuv 150 -ch 4 -applybeam -mwa-path /pawsey/mwa ${obsnum}.ms ${obsnum}.bin

### apply solution to ms
applysolutions ${obsnum}.ms ${obsnum}.bin

### flag the new data calibrated data column
aoflagger -column CORRECTED_DATA ${obsnum}.ms

## TOD: to implement selfcalibration

end=`date +%s`
runtime=$((end-start))
echo "the job run time ${runtime}"

}