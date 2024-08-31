#!/bin/bash

usage()
{
    echo "obs_wget.sh [-o obsnum] [-l wget link] 
    -o  obsnum      : the observation id
    -l  wget link   : wget link for the obs from asvo" 1>&2;
exit 1;
}

obsnum=
link=

while getopts 'o:l:' OPTION
do
    case "$OPTION" in
        o)
            obsnum=${OPTARG}
            ;;
        l)
            link=${OPTARG}
            ;;
        ? | : | h)
            usage
            ;;
    esac
done


# if obsid or link is empty then just pring help
if [[ -z ${obsnum} ]]
then
    usage
fi
if [[ -z ${link} ]]
then
    usage
fi


## load configurations
source config.txt

## run template script
script="${MYBASE}/queue/wget_${obsnum}.sh"
cat ${base}bin/wget.sh | sed -e "s:OBSNUM:${obsnum}:g" \
                                -e "s:BASE:${MYBASE}:g"> ${script}

output="${base}queue/logs/wget_${obsnum}.o%A"
error="${base}queue/logs/wget_${obsnum}.e%A"
sub="sbatch --begin=now+15 --output=${output} --error=${error} -J wget_${obsnum} -M ${MYCLUSTER} ${script} -l ${link}"
jobid=($(${sub}))
jobid=${jobid[3]}

# rename the err/output files as we now know the jobid
error=`echo ${error} | sed "s/%A/${jobid}/"`
output=`echo ${output} | sed "s/%A/${jobid}/"`

echo "Submitted wget job as ${jobid}"