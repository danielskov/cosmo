%Transform standardized concentration data to ordinary concentrations
%We assume normal distribution with relative error defined like
%fixed_stuff.RelErrorObs = 0.02; %0.02 means 2% observational error
%Thus, dpr is measured in the unit of concentration standard deviations
function d = dpr2d(dpr,fixed_stuff)
d = dpr.*fixed_stuff.ErrorStdObs;
