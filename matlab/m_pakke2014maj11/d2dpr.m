%Transform ordinary concentration data to standardized concentrations
%We assume normal distribution with relative error defined like
%fixed_stuff.RelErrorObs = 0.02; %0.02 means 2% observational error
%Thus, dpr is measured in the unit of concentration standard deviations
function dpr = d2dpr(d,fixed_stuff)
dpr = d./fixed_stuff.ErrorStdObs;
