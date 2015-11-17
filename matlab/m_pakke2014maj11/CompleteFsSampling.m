function fsSamplingOut = CompleteFsSampling(fsSamplingIn)
fsSamplingOut=fsSamplingIn;
switch fsSamplingOut.ProposerType
    case 'Native' %StepFactor scales limits specified in native units
        fsSamplingOut.StepVector = [1e-5,1e-4,100,1000,0.1];
    case 'Prior' %StepFactor scales radius of the prior intervals 
        fsSamplingOut.StepsPerCpostUpdate = Inf;
    case 'ApproxPosterior' %StepFactor scales "posterior" jumps 
        fsSamplingOut.StepsPerCpostUpdate = 50;
        fsSamplingOut.CpostUpdateMode = 'FromPartDev';%'FromPartDev' 'FromSamples'
        switch fsSamplingOut.CpostUpdateMode
            case 'FromPartDev'
                fsSamplingOut.PartDevStep = 1e-3; %Fraction of prior interval
            case 'FromSamples' %Hint from Søren Bom Nielsen
                fsSamplingOut.StepsForPartDevEstimate = 20; %Number of samples from which to estimate partdev
        end        
end
switch fsSamplingOut.StepFactorMode
    case 'Fixed'
        fsSamplingOut.StepFactor = 0.2; %Acceptance ratio may be very low or very high
        fsSamplingOut.TargetAcceptanceRatio = NaN; %StepFactor may become very small
        fsSamplingOut.StepsPerFactorUpdate = inf; 
    case 'Adaptive'
        fsSamplingOut.StepFactor = 0.3; %In case Adaptive, this StepFact is the starting value
        fsSamplingOut.TargetAcceptanceRatio = 0.4; 
        fsSamplingOut.StepsPerFactorUpdate = 499; 
end