#!/bin/bash -l
#SBATCH --export=NONE
#SBATCH -p workq
#SBATCH --time=8:00:00
#SBATCH --ntasks=6
#SBATCH --mem=64GB

start=`date +%s`

module load singularity
shopt -s expand_aliases

set -x
{

obsnum=OBSNUM
base=BASE
link=

source ${myPath}/aliases

while getopts 'l:' OPTION
do
    case "$OPTION" in
        l)
            link=${OPTARG}
            ;;
    esac
done


cd ${base}/processing/
mkdir ${obsnum}
cd ${obsnum}

## download file
outfile="${obsnum}_ms.tar"
if [[ -e "${outfile}" ]]; then
    echo "${outfile} exists, not downloading again"
else
    wget -O ${obsnum}_ms.tar "${link}"
fi

## untar file
tar -xvf ${obsnum}_ms.tar

## do autonomous flagging of data
aoflagger ${obsnum}.ms

end=`date +%s`
runtime=$((end-start))
echo "the job run time ${runtime}"

}