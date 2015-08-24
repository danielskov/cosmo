%  file_scanner_mcmc_starter.m
%  This file is started by run.sh.
%  The script watches an input folder (infolder) for input files generated
%  by the web interface. The content of the input files is used to start
%  calls to the MCMC functions.
%

% folder of input files
%infolder = '~/src/cosmo/matlab';
infolder = '/tmp';
prefix = 'cosmo_';

% infinite loop
while 1
    
    % detect all files in infolder starting with prefix
    infiles = dir(strcat(infolder, '/', prefix, '*'));
    
    % sort files according to modification time
    [sorteddates, sortidx] = sort([infiles.datenum]);
    infiles = infiles(sortidx);
    
    % process files sequentially
    for i = 1:length(infiles);
        infile = strcat(infolder, '/', infiles(i).name);
        disp(infile)
        import_php_file(infile);
%        delete(infile)
    end


    break

end
