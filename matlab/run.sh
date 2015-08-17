#!/bin/bash

## run.sh
#  This script must run on the webserver. It launches a Matlab session which
#  should continue running, until the end of days or the next reboot, whatever
#  comes first.

/Applications/MATLAB_R2014b.app/bin/matlab -nodesktop -nosplash -nodisplay \
    -nojvm -r "run('file_scanner_mcmc_starter.m')"
