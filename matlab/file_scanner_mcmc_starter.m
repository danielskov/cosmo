%%  file_scanner_mcmc_starter.m
%  This file is started by run.sh.
%  The script watches an input folder (infolder) for input files generated
%  by the web interface. The content of the input files is used to start
%  calls to the MCMC functions.
%

%% folder and file configuration

% folder containing input files from web interface ("uploadhistory.php")
% and status file
infolder = '~/cosmo/input';

% outfolder: folder for generated plots
[status, hostname] = system('hostname');
if ~isempty(strfind(hostname, 'flaptop')) || ...
        ~isempty(strfind(hostname, 'adc-server')) % laptop or desktop
    infolder = '~/src/cosmo/input';
    outfolder = 'output/';
else % cosmo server
    outfolder = '/var/www/html/output/';
end

% uniquely identifying file name prefix for input files
prefix = 'cosmo_';

% archivefolder: folder where completed input files are archived. This 
% folder should be outside of the webserver document root so others cannot
% access this information
archivefolder = '~/cosmo/archive';

% folder containing matlab scripts to path
matlab_scripts_folder = 'm_pakke2014maj11/';

%% general settings
debug = true; % show debugging output to matlab console

% output graphics formats
graphics_formats = {'fig', 'png', 'pdf'};

% show figures after they are generated in addition to saving them,
% values: 'on' or 'off'
%show_figures = 'on';
show_figures = 'off';

% number of MCMC walkers
%n_walkers = 2;

%% initialization
addpath(matlab_scripts_folder);

disp('Entering main loop, waiting for input from web interface...');

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
        
        idstring = strsplit(infile, '_');
        id = idstring(2);
        statusfile = char(strcat(infolder, '/status_', id));
        diary(char(strcat(infolder, '/log_', id)));
        
        if debug
            disp(infile);
            disp(strcat('Simulation id: ', id));
        end
        
        % read file and save data to local scope
        [sample_id, name, email, lat, long, ...
            be_conc,  al_conc,  c_conc,  ne_conc, ...
            be_uncer, al_uncer, c_uncer, ne_uncer, ...
            be_zobs, al_zobs, c_zobs, ne_zobs, ...
            be_prod_spall, al_prod_spall, c_prod_spall, ne_prod_spall, ...
            be_prod_muons, al_prod_muons, c_prod_muons, ne_prod_muons, ...
            rock_density, ...
            epsilon_gla_min, epsilon_gla_max, ...
            epsilon_int_min, epsilon_int_max, ...
            t_degla_min, t_degla_max, ...
            record, ...
            record_threshold_min, record_threshold_max, ...
            nwalkers] ...
            = import_php_file(infile, 1, 1); % only read first line
        
        % run inversion
        [Ss, save_file] = mcmc_inversion(matlab_scripts_folder, debug, ...
            nwalkers, outfolder, ...
            be_conc,  al_conc,  c_conc,  ne_conc, ...
            be_uncer, al_uncer, c_uncer, ne_uncer, ...
            be_zobs, al_zobs, c_zobs, ne_zobs, ...
            be_prod_spall, al_prod_spall, c_prod_spall, ne_prod_spall, ...
            be_prod_muons, al_prod_muons, c_prod_muons, ne_prod_muons, ...
            rock_density, ...
            epsilon_gla_min, epsilon_gla_max, ...
            epsilon_int_min, epsilon_int_max, ...
            t_degla_min, t_degla_max, ...
            record, ...
            record_threshold_min, record_threshold_max, ...
            statusfile, id);
        
        fid = fopen(statusfile, 'w');
        fprintf(fid, 'Generating plots');
        fclose(fid);
        
        % generate plots
        %CompareWalks2(Ss, save_file)
        generate_plots(Ss, record, matlab_scripts_folder, ...
            save_file, graphics_formats, show_figures);
        
        % close all figures
        close all;
        
        % delete or archive the file so it is not processed again
        %delete(infile)
        movefile(infile, archivefolder);
        
        fid = fopen(statusfile, 'w');
        fprintf(fid, 'Computations complete');
        fclose(fid);
        
        disp(['Computations complete, id = ' id]);
        
        diary off;
        
        % sleep 1 second in order to reduce system load
        pause(1)
        
        %keyboard
    end

    % for debugging purposes; ends loop after first iteration
    %break

end
