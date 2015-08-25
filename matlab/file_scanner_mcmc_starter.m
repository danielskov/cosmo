%%  file_scanner_mcmc_starter.m
%  This file is started by run.sh.
%  The script watches an input folder (infolder) for input files generated
%  by the web interface. The content of the input files is used to start
%  calls to the MCMC functions.
%

%% folder and file configuration

% folder containing input files from web interface ("uploadhistory.php")
infolder = '/tmp';

% uniquely identifying file name prefix for input files
prefix = 'cosmo_';

% folder where completed input files are archived. This folder should be
% outside of the webserver document root so others cannot acces this
% information
archivefolder = '/Users/ad/tmp/cosmo-archive';


%% general settings
debug = true; % show debugging output to matlab console

%% main loop
while 1
    
    % detect all files in infolder starting with prefix
    infiles = dir(strcat(infolder, '/', prefix, '*'));
    
    % sort files according to modification time
    [sorteddates, sortidx] = sort([infiles.datenum]);
    infiles = infiles(sortidx);
    
    % process files sequentially
    for i = 1:length(infiles);
        
        % read full file name and path
        infile = strcat(infolder, '/', infiles(i).name);
        
        if debug
            disp(infile);
        end
        
        % read file and save data to local scope
        [sample_id, name, email, lat, long, ...
            be_conc,  al_conc,  c_conc,  ne_conc, ...
            be_uncer, al_uncer, c_uncer, ne_uncer, ...
            be_prod,  al_prod,  c_prod,  ne_prod, ...
            rock_density, ...
            epsilon_gla_min, epsilon_gla_max, ...
            epsilon_int_min, epsilon_int_max, ...
            t_degla, t_degla_uncer, ...
            record, ...
            record_threshold_min, record_threshold_max] ...
            = import_php_file(infile, 1, 1); % only read first line
        
        % delete or archive the file so it is not processed again
        %delete(infile)
        %movefile(infile, archivefolder);


    end


    % for debugging purposes; ends loop after first iteration
    break

end
