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
        [sampleid, name, email, lat, long, ...
            be_conc,  al_conc,  c_conc,  ne_conc, ...
            be_uncer, al_uncer, c_uncer, ne_uncer, ...
            be_prod,  al_prod,  c_prod,  ne_prod, ...
            rock_density, ...
            epsilon_gla_min, epsilon_gla_max, ...
            epsilon_int_min, epsilon_int_max, ...
            t_degla, t_degla_uncer, ...
            record, ...
            record_threshold_min, record_threshold_max] ...
            = import_php_file(infile, 1, 1);
%        delete(infile)
    end


    % for debugging purposes; ends loop after first iteration
    break

end
