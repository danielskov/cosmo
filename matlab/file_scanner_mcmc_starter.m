%% file_scanner_mcmc_starter.m
%  This file is started by run.sh.
%  The script watches an input folder (infolder) for input files generated
%  by the web interface. The content of the input files is used to start
%  calls to the MCMC functions.
%%

% folder of input files
infolder = '~/src/cosmo/matlab';

% infinite loop
while 1

    infile = 'testinput.txt';

    if exist([infolder, '/', infile], 'file') == 2
        disp('file exists')
        break
    end

end