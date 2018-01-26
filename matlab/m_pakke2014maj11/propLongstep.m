function [mprop,propaccept] = propLongstep(mcur,StepFact,fsSampling,fixed_stuff,sqrtCpostpr);
M = length(mcur);
switch fsSampling.ProposerType
  case 'Native'
    dm = fsSampling.StepVector; 
    mprop = mcur + StepFact.*dm;
    mproppr = m2mpr(mprop,fixed_stuff);
  case 'Prior'
    mcurpr = m2mpr(mcur,fixed_stuff);
    dmpr = sqrt(3)*(2*rand(M,1)-1);
    mproppr = mcurpr + StepFact*dmpr;
    mprop = mpr2m(mproppr,fixed_stuff);
  case 'ApproxPosterior'
    mcurpr = m2mpr(mcur,fixed_stuff);
    dmpr = sqrtCpostpr*randn(M,1);
    mproppr = mcurpr + StepFact*dmpr;    
    mprop = mpr2m(mproppr,fixed_stuff);
end
if any(abs(mproppr)>sqrt(3)) %executing the hard constraints
  mprop=mcur;
  propaccept=0;
else
  propaccept=1;
end