# MWA-Pipeline
A simplified pipeline that makes continumm images of MWA observations

## Structure
The overall structure of the git repo is inspired by the MWA-fast-image-transients (https://github.com/PaulHancock/MWA-fast-image-transients) pipeline by Paul Hancock.

bin: contains the pipeline scripts

processing: contains a folder with the observation ID within which resides the measurement sets and other related files

queue/logs: log files of the slurm job

### obs_wget.sh
    obs_wget.sh [-o obsnum] [-l wget link] 
      -o  obsnum      : the observation id
      -l  wget link   : wget link for the obs from asvo

### obs_calibrate.sh
    obs_calibrate.sh [-o obsnum] [-m model] [-d dependancy]
      -o obsnum	: observation id
      -m model	: the calibrator model
      -d dependancy   : dependant job id

### obs_image.sh
    obs_image.sh [-o obsnum] [-d dependancy]
      -o  obsnum  : the observation id
      -d dependancy   : dependant job id
