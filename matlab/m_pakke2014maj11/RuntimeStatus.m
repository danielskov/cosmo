function [ElapsedTime,RemainingTime,TotalTime,EndTime,IterationsPerSecond,PrintString] = ...
    RuntimeStatus(it,isBurnIn,fs)
TotalIterations = fs.Nwalkers*(fs.BurnIn.Nsamp+fs.Sampling.Nsamp);
if isBurnIn
    IterationsSoFar = it + (fs.iwalk-1)*(fs.BurnIn.Nsamp+fs.Sampling.Nsamp);
else %Sampling
    IterationsSoFar = it + ...
         fs.BurnIn.Nsamp + (fs.iwalk-1)*(fs.BurnIn.Nsamp+fs.Sampling.Nsamp);
end
ElapsedTime = (now - fs.StartTime); %in days
TimePerIteration = ElapsedTime/IterationsSoFar;
RemainingTime = (TotalIterations-IterationsSoFar)*TimePerIteration;
TotalTime = TotalIterations*TimePerIteration;
EndTime = fs.StartTime + TotalTime;
IterationsPerSecond = 3600*24/TimePerIteration;

PrintString = ['Elaps=',datestr(ElapsedTime,13),...
    '. Remain=',datestr(RemainingTime,13),...
    '. EndTime=',datestr(EndTime,0)];


    
