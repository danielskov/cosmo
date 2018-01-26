#!/bin/bash

## run.sh
#  This script must run on the webserver. It launches a Matlab session which
#  should continue running, until the end of days or the next reboot, whatever
#  comes first.

UNAMESTR=`uname`
if [[ "$UNAMESTR" == 'Darwin' ]]; then # OS X
    matlabbin=/Applications/MATLAB_R2014b.app/bin/matlab
else # Linux
    matlabbin=/usr/local/MATLAB/R2015a/bin/matlab
fi

$matlabbin -nodesktop -nosplash -nodisplay \
    -r "run('file_scanner_mcmc_starter.m')"
    #-nojvm -r "run('file_scanner_mcmc_starter.m')"
