function [Ss, save_file] = mcmc_inversion(matlab_scripts_folder, debug, ...
    n_walkers, outfolder, ...
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
    statusfile, sim_id)

%% mcmc_inversion.m
% function is called from `file_scanner_mcmc_starter.m`

beeps = false;

%clear; close all;
format compact;

%Set path so that we can find other required m-files
addpath(matlab_scripts_folder)

% save density for later use in subfunctions
fs.rho = rock_density;

% save production rates for later use in subfunctions
fs.be_prod_spall = be_prod_spall;
fs.al_prod_spall = al_prod_spall;
fs.c_prod_spall  =  c_prod_spall;
fs.ne_prod_spall = ne_prod_spall;

fs.be_prod_muons = be_prod_muons;
fs.al_prod_muons = al_prod_muons;
fs.c_prod_muons  =  c_prod_muons;
fs.ne_prod_muons = ne_prod_muons;

fs.g_case = 'CosmoLongsteps'; %must match a case in function gz = linspace(0,10,100);

switch fs.g_case
    case 'CosmoLongsteps'
        %>......... The observations and observation errors:
        %fs.Nucleides = {'10Be','26Al','14C','21Ne'}; %We may switch nucleides on and off
        %fs.Nucleides = {'10Be','26Al'}; %We may switch nucleides on and off
        fs.Nucleides = {};
        fs.RelErrorObs = [];
        concentrations = [];
        if be_conc > 0.
            fs.Nucleides = [fs.Nucleides '10Be'];
            fs.RelErrorObs = [fs.RelErrorObs be_uncer];
            concentrations = [concentrations be_conc];
        end
        if al_conc > 0.
            fs.Nucleides = [fs.Nucleides '26Al'];
            fs.RelErrorObs = [fs.RelErrorObs al_uncer];
            concentrations = [concentrations al_conc];
        end
        if c_conc > 0.
            fs.Nucleides = [fs.Nucleides '14C'];
            fs.RelErrorObs = [fs.RelErrorObs c_uncer];
            concentrations = [concentrations c_conc];
        end
        if ne_conc > 0.
            fs.Nucleides = [fs.Nucleides '21Ne'];
            fs.RelErrorObs = [fs.RelErrorObs ne_uncer];
            concentrations = [concentrations ne_conc];
        end
        
        
        %     fs.RelErrorObs = 0.02;%0.02; %0.02 means 2% observational error
        %    fs.RelErrorObs = 0.01*[2.0;2.04]';%0.02; %0.02 means 2% observational error
        
        % one depth per nuclide or not?
        %fs.zobs = [0]; %Depths where nucleides are observed
        fs.zobs = [be_zobs, al_zobs, c_zobs, ne_zobs];
        %    fs.zobs = [0,0.3,1,3,10]; %Depths where nucleides are observed
        
        if debug
            disp(fs.Nucleides)
        end
        
        %fs.dobsMode = 'SyntheticNoNoise'; %'SyntheticNoNoise','SyntheticAndNoise','ObservedData'
        fs.dobsMode = 'ObservedData'; %'SyntheticNoNoise','SyntheticAndNoise','ObservedData'
        if strcmp(fs.dobsMode,'ObservedData')
            fs.d_obs = [];
            %fs.d_obs = repmat([5.3e8;3.7e9]',length(fs.zobs),1); %<<<<<< put in values as best you can
            fs.d_obs = repmat(concentrations',length(fs.zobs),1);
            fs.d_obs = fs.d_obs(:);
        end
        if length(fs.RelErrorObs) == 1
            fs.RelErrorObs = fs.RelErrorObs*ones(size(fs.Nucleides)); %extend to vector
        elseif length(fs.RelErrorObs) == length(fs.Nucleides) %ok
        else error('fs.RelErrorObs must have length 1 or length of fs.Nucleides')
        end
        
        %>........ For advec-solution
        fs.testmode = 'fast'; %Means "Skip advective model". may change to 'linearized' below
        % fs.testmode = 'run_advec'; %Means "Run advective model for comparisson"
        D =100;
        z = linspace(0,10,100); %Note! modified below
        fs.D = D;
        fs.z = D*z.^3/1000;
        fs.dt = 100;
        
        %>........ Structure of glacial cycles
        fs.CycleMode = 'd18OTimes'; %'FixedC','FixedQuaternary','FixedTimes', 'd18OTimes'
        switch fs.CycleMode
            case 'FixedC'
                fs.C = 20; %If isempty, C=round(2.6e6/(round(dtGla*(1+dtIdtG))));
            case 'FixedQuaternary'
                fs.tQuaternary = 2.6e6; %time of first glaciation, adjust as desired
                %First glaciation and first interglacial adjusted accordingly
            case 'FixedTimes'
                fs.tStarts = NaN; %load or compute fixed times of more or less glaciated periods
                fs.relExpos = NaN; %load or compute degree of exposure in periods
            case 'd18OTimes'
                %fs.d18Ofn = 'lisiecki_triinterp_2p6Ma_5ky.mat';
                %fs.d18O_filename = 'lisiecki_triinterp_2p6Ma_30ky.mat'; %  zachos_triinterp_2p6Ma
                if strcmp(record, 'rec_5kyr')
                    fs.d18O_filename = 'lisiecki_triinterp_2p6Ma_5ky.mat'; %  zachos_triinterp_2p6Ma
                elseif strcmp(record, 'rec_20kyr')
                    fs.d18O_filename = 'lisiecki_triinterp_2p6Ma_20ky.mat'; %  zachos_triinterp_2p6Ma
                elseif strcmp(record, 'rec_30kyr')
                    fs.d18O_filename = 'lisiecki_triinterp_2p6Ma_30ky.mat'; %  zachos_triinterp_2p6Ma
                else
                    error(['record ' record ' not understood']);
                end
                fs.tStarts = NaN; %load or compute fixed times of more or less glaciated periods
                fs.relExpos = NaN; %load or compute degree of exposure in periods
        end
        
        %>........ Starting condition
        fs.Cstart = 'extend interglacial';
        %         fs.Cstart = 'zeros';
        
        %>........ Model parameters.
        fs.mname{1} = 'ErateInt';
        fs.mname{2} = 'ErateGla';
        fs.mname{3} = 'tDegla';
        %     fs.mname{4} = 'dtGla';
        %     fs.mname{5} = 'dtIdtG';
        fs.mname{4} = 'd18Oth';
        %>........ Prior information
        % m = [ErateInt,ErateGla,tDegla,dtGla,dtIdtG];
        %fs.ErateIntminmax = [1e-7,1e-3]; %0.26m to 2600 m pr. Quaternary
        %fs.ErateGlaminmax = [1e-7,1e-3];
        fs.ErateIntminmax = [epsilon_int_min, epsilon_int_max]; %0.26m to 2600 m pr. Quaternary
        fs.ErateGlaminmax = [epsilon_gla_min, epsilon_gla_max];
        %fs.tDeglaminmax   = [10e3,12e3]; %8000 to 10000 yr Holocene
        fs.tDeglaminmax   = [t_degla_min, t_degla_max];
        %     fs.dtGlaminmax    = [40e3,200e3];
        %     fs.dtIdtGminmax   = [0,0.5];
        %fs.d18Othminmax = [3.6,4.4];
        fs.d18Othminmax = [record_threshold_min, record_threshold_max];
        
        fs.ErateIntDistr = 'logunif';
        fs.ErateGlaDistr = 'logunif';
        fs.tDeglaDistr   = 'uniform';
        %     fs.dtGlaDistr    = 'uniform';
        %     fs.dtIdtGDistr   = 'uniform';
        fs.d18OthDistr   = 'uniform';
        
        for im=1:length(fs.mname)
            fs.mminmax(im,:) = eval(['fs.',fs.mname{im},'minmax']);
            fs.mDistr(im,:) = eval(['fs.',fs.mname{im},'Distr']);
        end
        switch fs.dobsMode %'SyntheticNoNoise','SyntheticAndNoise','ObservedData'
            case 'ObservedData'
                %print out for checking:
                disp('>>>>>> Check that values match nucleides and depths:')
                id = 0;
                for iNucl=1:length(fs.Nucleides)
                    disp(fs.Nucleides{iNucl})
                    for iz=1:length(fs.zobs)
                        id = id+1;
                        disp(['>>> z=',num2str(fs.zobs(iz)),' m:',sprintf('%10g',fs.d_obs(id))])
                    end
                end
            case {'SyntheticNoNoise','SyntheticAndNoise'}
                %         fs.m_true = [...
                %           1e-5;...
                %           1e-6;...
                %           10e3;...
                %           100e3;...
                %           10/100];
                %fs.m_true = [...
                %1e-6;...
                %1e-4;...
                %12e3;...
                %4.0];
                fs.m_true = [...  % ANDERS: This is eps_int, eps_gla, t_degla, d180O_threshold
                    5e-5;...
                    1e-6;...
                    11e3;...
                    3.8];
                fs.d_true= g(fs.m_true,fs);
                fs.d_obs = fs.d_true + 0; %no noise, updated if dobsMode=='SyntheticAndNoise'
        end
        % >>>> finalizeing fixed_stuff with the observational error stds
        % We compute errors relative to the larger surface value
        % Otherwise the small concentrations at depth may be deemed too accurate.
        Nz = length(fs.zobs);
        Nnucl = length(fs.Nucleides);
        for iNucl = 1:Nnucl
            dtop = fs.d_obs(1+(iNucl-1)*Nz),
            fs.ErrorStdObs((1:Nz) + (iNucl-1)*Nz,1) = ...
                ones(Nz,1)*dtop*fs.RelErrorObs(iNucl);
        end
        if strcmp(fs.dobsMode,'SyntheticAndNoise')
            fs.d_obs = fs.d_true + fs.ErrorStdObs.*randn(size(fs.d_true));
        end
end %switch fs.g_case
% keyboard
%>........ For the MetHas algorithm
fs.Nwalkers = n_walkers; %Number of random walks
%fs.Nwalkers = 4; %Number of random walks
fs.WalkerStartMode = 'PriorEdge';%'PriorSample'; 'PriorMean';'PriorCorner';'PriorEdge'
fs.WalkerSeeds = 1:fs.Nwalkers; %must be at least fs.Nwalkers!

%%>... fs.BurnIn: Controlling the BurnIn phase:
fs.BurnIn.Nsamp = 1000; %number of samples in burn in
fs.BurnIn.Nskip = 1; %number of samples between samples kept
fs.BurnIn.ProposerType = 'Prior'; %'Native';'Prior';'ApproxPosterior'
fs.BurnIn.StepFactorMode = 'Fixed'; %'Fixed', 'Adaptive'
fs.BurnIn = CompleteFsSampling(fs.BurnIn);

%%>... fs.Sampling: Copy of fs.BurnIn but with different values set
fs.Sampling = fs.BurnIn;
fs.Sampling.Nsamp = 1e4;
fs.Sampling.Nskip = 1;
fs.Sampling.ProposerType = 'ApproxPosterior';
fs.Sampling.StepFactorMode = 'Adaptive';
fs.Sampling = CompleteFsSampling(fs.Sampling);

fixed_stuff = fs;

fixed_stuff.StartTime = now; %This should allow the program to predict time of finish
% ANDERS: consider parfor for parallel computing. However, fixed_stuff and
% S structures are incompatible with parfor.
for iwalk=1:fixed_stuff.Nwalkers
    
    disp(' ')
    disp(['#### iwalk = ' num2str(iwalk) '/' ...
        num2str(fixed_stuff.Nwalkers) ' ####'])

    fixed_stuff.iwalk = iwalk; %Helps program keep user updated on progress.
    m_starts(:,iwalk) = WalkerStarter(iwalk,fixed_stuff);
    d_starts(:,iwalk) = g(m_starts(:,iwalk),fixed_stuff);
    
    %>>>>> ......Burn in:
    seed = fixed_stuff.WalkerSeeds(iwalk);
    isBurnIn=1;
    [S.msBurnIn,S.acceptsBurnIn,S.QsBurnIn,S.QdsBurnIn,S.lump_MetHas_BurnIn]=MetHasLongstep4(...
        m_starts(:,iwalk),seed,isBurnIn,fixed_stuff, ...
        statusfile); %%%% ADDED BY ANDERS
    mStartSampling = S.msBurnIn(:,end);
    %<<<<< ... End Burn in
    
    %>>>>> ......Sampling the posterior:
    seed = fixed_stuff.WalkerSeeds(iwalk);
    isBurnIn=0; %<<<<<<<<<<<<<<<<<< ------------------- must be changed when Sampling
    [S.ms,S.accepts,S.Qs,S.Qds,S.lump_MetHas]=MetHasLongstep4(...
        mStartSampling,seed,isBurnIn,fixed_stuff,  ...
        statusfile); %%%% ADDED BY ANDERS
    %<<<<< ... End Sampling the posterior
    S.fs = fixed_stuff;
    S.m_start = m_starts(:,iwalk);
    S.d_start = d_starts(:,iwalk);
    Ss{iwalk}=S;
    %     S.ms{iwalk}=ms
    %     S.lump_MetHass{iwalk}=lump_MetHas;
    if beeps
        sound(sin(1:0.5:500))
    end
end

if beeps
    sound(0.5*sin(1:0.5:500));pause(0.3);sound(0.5*sin(1:0.75:750))
    pause(0.6)
    sound(0.5*sin(1:0.5:500));pause(0.3);sound(0.5*sin(1:0.75:750))
end

%save_file = [outfolder, '/', id, '_Walks_',datestr(now,'yyyymmdd_HHMMSS')];
save_file = strcat(outfolder, '/', char(sim_id), '_Walks');
save(save_file,'Ss','save_file')
