function [ElapsedTime,RemainingTime,TotalTime,EndTime,IterationsPerSecond,PrintString] = ...
    RuntimeStatus(it,isBurnIn,fs)
runs_per_processor=ceil(fs.Nwalkers/1);
%TotalIterations = runs_per_processor*(fs.BurnIn.Nsamp+fs.Sampling.Nsamp);
TotalIterations = fs.Nwalkers*(fs.BurnIn.Nsamp+fs.Sampling.Nsamp);

if isBurnIn
    IterationsSoFar = it;
else %Sampling
    IterationsSoFar = it + ...
         fs.BurnIn.Nsamp;
end
ElapsedTime = (now - fs.StartTime); %in days
%ElapsedTimeWalker=(now-walker_start_time);
TimePerIteration = ElapsedTime/IterationsSoFar;
RemainingTime = (TotalIterations-IterationsSoFar)*TimePerIteration;
TotalTime = TotalIterations*TimePerIteration;
EndTime = fs.StartTime + TotalTime;
IterationsPerSecond = 3600*24/TimePerIteration;

PrintString = ['Elaps=',datestr(ElapsedTime,13),...
    '. Remaining time walker=',datestr(RemainingTime,13)];


    
