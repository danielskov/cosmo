%file: MetHasLongstep4.m
%'cosmolongstep' changed to 'CosmoLongsteps'.

%Developed from MetHasLongstep2
%Developed from MetHasLongstep
%But now including
% - linearized inspiration proposer using partial derivatives
%      - computed either separately or
%      - computed from from previous samples
%
%Metropolis-Hastings iterations
%Inside a function call
%   d = g(m_prop,fixed_stuff)
%computes the data to be compared to the measured data, d_obs.
%Make sure to let function g be availble at run-time.
%Make sure that the paramater fixed_stuff (possibly a structure) is defined
%properly, including measurement geometry etc.
%INPUTS:
% m_start: First current model
% seed: if ~isempty(seed), setseed(seed), end Makes walks repeatable 
% fixed-stuff: A variable, possible a structure which defines non-variable
%              parameters for function g
%OUTPUTS:
% ms: Each column is a stored state. Note that only one out of N_skip
%     states were stored.
% accepts: accepts(i)=1 if this proposal was accepted, else accepts(i)=0
% Qs: Qds(i) + Qps(i)
% Qds: Qds(i) = (d_obs-g(ms(i))'*inv(C_obs)*(d_obs-g(ms(i))
% Qps: Qps(i) = (m_prior - ms(i))'*inv(C_prior)*(m_prior-ms(i))
% lump: A number of additional diagnostics

% function [ms,accepts,Qs,Qds,lump]=MetHasLongstep3(...
%              m_start,d_obs,seed,fixed_stuff);
function [ms,accepts,Qs,Qds,lump]=MetHasLongstep(...
                                  m_start,seed,isBurnIn,fixed_stuff, ...
                                  statusfile) %%%% ADDED BY ANDERS
d_obs = fixed_stuff.d_obs;
if isBurnIn
  fsSampling = fixed_stuff.BurnIn;
else
  fsSampling = fixed_stuff.Sampling;
end

%Initializations
diagCobs = fixed_stuff.ErrorStdObs.^2; %the variances
C_obs = diag(diagCobs);
iCobs = inv(C_obs);
StepFact = fsSampling.StepFactor;
sqrtCpostpr = []; %We have to bootstrap

if ~isempty(seed)
  setseed(seed);
end

%Preallocations
M = length(m_start);
N_run = fsSampling.Nsamp;
N_skip = fsSampling.Nskip;
ms = NaN*ones(M,floor(N_run/N_skip));
Qs      = NaN*ones(1,floor(N_run/N_skip));
Qds     = Qs;
% Qps     = Qs;

accepts = zeros(N_run,1);
propaccepts = accepts;

mprops  = zeros(M,N_run);
Qprops      = zeros(1,N_run);
Qdprops     = Qprops;
% Qpprops     = Qprops;

mcurs  = zeros(M,N_run);
Qcurs      = zeros(1,N_run);
Qdcurs     = Qcurs;
% Qpcurs     = Qcurs;

dprops = NaN(length(d_obs),N_run);
dcurs  = dprops;

%Initializing mcur as m_start
mcur = m_start;
mprops(:,1)=m_start; %Just to make updateCpost have something to start with
[dcur,lumpprop] = g(mcur,fixed_stuff);
dd_obs = d_obs - dcur;
Qdcur  = dd_obs'*iCobs*dd_obs;

% dm_pri = m_prior - mcur;
% Qpcur = dm_pri'*iCpri*dm_pri;

Qcur = Qdcur; %+Qpcur;
if strcmp(fixed_stuff.g_case,'CosmoLongsteps')
  zsss{1}=lumpprop.zss;
  tss{1}=lumpprop.ts;
  ExposureTimeSinceNows{1}=lumpprop.ExposureTimeSinceNow;
  c14Csss{1}=lumpprop.c14Css;
  c10Besss{1}=lumpprop.c10Bess;
  c26Alsss{1}=lumpprop.c26Alss;
  c21Nesss{1}=lumpprop.c21Ness;
  
end
i_keep = 0; %index of the so far last stored model
iCpostUpdate = 0;

%................... The main iteration loop
for it=1:N_run
    if rem(it,1000)==0,
        [ElapsedTime,RemainingTime,TotalTime,EndTime,IterationsPerSecond,PrintString] = ...
            RuntimeStatus(it,isBurnIn,fixed_stuff);
        disp([num2str(it),': ',PrintString])
    
%%% INSERTED BY ANDERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fid = fopen(statusfile, 'w');
    statusinfo = strcat(num2str(datestr(RemainingTime,13), ' remaining'));
    fprintf(fid, statusinfo);
    fclose(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end

  if rem(it,fsSampling.StepsPerFactorUpdate)==0
    %update StepFact
    acc=accepts((it-fsSampling.StepsPerFactorUpdate+1):it); %recent accepts
    StepFact = UpdateStepFact(StepFact,acc,fsSampling);
    disp(['StepFact updated to ',num2str(StepFact),'. It=',num2str(it)])
  end
  if rem(it,fsSampling.StepsPerCpostUpdate)==1
    %update sqrtCpost already at the start of the first iterations
    is = max(1,it-fsSampling.StepsPerCpostUpdate-1):it;
    [sqrtCpostpr,Cpostpr,Gestpr]=updateCpost(mprops(:,is),dprops(:,is),fsSampling,fixed_stuff);
%     disp(['sqrtCpost updated. Cond(sqrtCpost)=',num2str(cond(sqrtCpostpr)),'. It=',num2str(it)])
    iCpostUpdate = iCpostUpdate+1;
    sqrtCposts{iCpostUpdate}=sqrtCpostpr;
  end
  
  [mprop,propaccepts(it)] = propLongstep(mcur,StepFact,fsSampling,fixed_stuff,sqrtCpostpr); %Mads' proposer, takes care of hard limits
  dmpropspr(:,it) = m2mpr(mprop,fixed_stuff) - m2mpr(mcur,fixed_stuff);
  
  [dprop,lumpprop] = g(mprop,fixed_stuff);
  dd_obs = d_obs - dprop;
  Qdprop  = dd_obs'*iCobs*dd_obs;
  Qprop = Qdprop; %+Qpprop;
  
  alpha = rand;
  
  if alpha < exp(-0.5*(Qprop-Qcur))
    if propaccepts(it)
      accepts(it)=1;
    end
    mcur=mprop;
    dcur=dprop;
    Qdcur = Qdprop;
    %     Qpcur = Qpprop;
    Qcur  = Qprop;
  end
  if strcmp(fixed_stuff.g_case,'CosmoLongsteps')
    if accepts(it)
      zsss{it+1}=lumpprop.zss; %note: varying length
      tss{it+1}=lumpprop.ts;
      ExposureTimeSinceNows{it+1}=lumpprop.ExposureTimeSinceNow;
      c14Csss{it+1}=lumpprop.c14Css;
      c10Besss{it+1}=lumpprop.c10Bess;
      c26Alsss{it+1}=lumpprop.c26Alss;
      c21Nesss{it+1}=lumpprop.c21Ness;

      
    else %mcur remains; take the previous model
      zsss{it+1}=zsss{it};
      tss{it+1}=tss{it};
      ExposureTimeSinceNows{it+1}=ExposureTimeSinceNows{it};
      c14Csss{it+1}=c14Csss{it};
      c10Besss{it+1}=c10Besss{it};
      c26Alsss{it+1}=c26Alsss{it};
      c21Nesss{it+1}=c21Nesss{it};
    end
  end
  dmcurspr(:,it) = dmpropspr(:,it)*accepts(it);
  
  if mod(it,N_skip)==0
    %pick out sample to keep
    i_keep = i_keep+1;
    ms(:,i_keep)=mcur;
    Qds(i_keep)=Qdcur;
    %     Qps(i_keep)=Qpcur;
    Qs(i_keep)=Qcur;
  end
  
  mcurs(:,it)  = mcur;
  dcurs(:,it)  = dcur;
  Qcurs(it)  = Qcur;
  Qdcurs(it) = Qdcur;
  %   Qpcurs(it) = Qpcur;
  
  mprops(:,it)  = mprop;
  dprops(:,it)  = dprop;
  Qprops(:,it)  = Qprop;
  Qdprops(:,it) = Qdprop;
  %   Qpprops(:,it) = Qpprop;
  StepFacts(it) = StepFact;
end

if nargout==5
  
  lump.StepFacts = StepFacts;
  
  lump.mcurs = mcurs;
  lump.Qcurs = Qcurs;
  lump.Qdcurs = Qdcurs;
  lump.dmcurspr = dmcurspr;
  %   lump.Qpcurs = Qpcurs;
  
  lump.mprops = mprops;
  lump.Qprops = Qprops;
  lump.Qdprops = Qdprops;
  lump.dmpropspr = dmpropspr;
  %   lump.Qpprops = Qpprops;
  
  if strcmp(fixed_stuff.g_case,'CosmoLongsteps')
    lump.zsss = zsss;
    lump.tss = tss;
    lump.ExposureTimeSinceNows=ExposureTimeSinceNows;
    lump.c14Csss=c14Csss;
    lump.c10Besss=c10Besss;
    lump.c26Alsss=c26Alsss;
    lump.c21Nesss=c21Nesss;
  end
end


%{
function u = prop(proposer_type,sqrtC)
switch proposer_type
  case 1 % isotropic unit coordinate variances:
    u = randn(size(sqrtC,1),1);
  case 2 % box-shaped coordinate variances:
    u = sqrt(12)*(rand(size(sqrtC,1))-0.5);
  case {3,4} %prior proposer:
    u = sqrtC*randn(size(m));
  case 5 %proposer defined by external function
    u = prop_external;
end
%}