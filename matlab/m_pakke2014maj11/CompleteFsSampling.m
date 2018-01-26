function fsSamplingOut = CompleteFsSampling(fsSamplingIn)
fsSamplingOut=fsSamplingIn;
switch fsSamplingOut.ProposerType
    case 'Native' %StepFactor scales limits specified in native units
        fsSamplingOut.StepVector = [1e-5,1e-4,100,1000,0.1];
    case 'Prior' %StepFactor scales radius of the prior intervals 
        fsSamplingOut.StepsPerCpostUpdate = Inf; %i.e. the covariance matrix will never be updated
    case 'ApproxPosterior' %StepFactor scales "posterior" jumps 
        fsSamplingOut.StepsPerCpostUpdate = 50;
        fsSamplingOut.CpostUpdateMode = 'FromPartDev';%'FromPartDev' 'FromSamples'
        fsSamplingOut.PartDevStep = 1e-3; %Fraction of prior interval
end
switch fsSamplingOut.StepFactorMode
    case 'Fixed'
        fsSamplingOut.StepFactor = 0.2; %Acceptance ratio may be very low or very high
        fsSamplingOut.StepFactor = 2.4/sqrt(4); %Acceptance ratio may be very low or very high
        fsSamplingOut.TargetAcceptanceRatio = NaN; %StepFactor may become very small
        fsSamplingOut.StepsPerFactorUpdate = inf; 
    case 'Adaptive'
        fsSamplingOut.StepFactor = 0.3; %In case Adaptive, this StepFact is the starting value
        %fsSamplingOut.StepFactor = 2.4/sqrt(4); %Tested, but resulted in acceptance ratio markedly under the target acceptance ratio
        fsSamplingOut.TargetAcceptanceRatio = 0.4; 
        fsSamplingOut.StepsPerFactorUpdate = 499; 
end