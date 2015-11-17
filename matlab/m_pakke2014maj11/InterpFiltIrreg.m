%InterpFiltIrreg.m
%INPUTS:
% in: Data to be interpolated and filtered
%     If data is missing at some ts, the data value is NaN (code for Not a Number)
% ts: Location in time or space of datapoints
% ti: Locations where interpolated and filtered data are computed (default ti = ts)
% mincatch: The minimum number of points which we must catchinside radius
%           Default: mincatch = 5
% minrad: For each ti(n) we average in-values for which abs(ts-ti(n))<minrad
%         But if we catch less than mincatch datavalues we expand the radius recursively.
%         Default: minrad = 1.5*mean(diff(ts)).
% meanmode: 'runav': Equal weights within radius (default)
%           'triang': Gradually reduced weights towards edge of radius
%OUTPUTS:
% outmean: Interpolated and filtered data, using meanmode
% outmed: Simple median computed from data within radius
% ti: Locations where interpolated values belong. Useful if ti was not input
% radi: The actual radii used at each ti. May be larger than minrad.
%CALL:
%        [outmean,outmed,ti,radi] = InterpFiltIrreg(in,ts,ti,mincatch,minrad,meanmode)
function [outmean,outmed,ti,radi] = ...
    InterpFiltIrreg(in,ts,ti,mincatch,minrad,meanmode)
if nargin<2
    ts = 1:length(in);
end
if nargin<3
    ti = ts;
end
if nargin<4
    mincatch = 5;
end
if nargin<5
    minrad = 1.5*mean(diff(ti));
end
if nargin<6
    weightshape = 'runav';
end

%force all to be columns
in = in(:); ts = ts(:); ti = ti(:); 
out = NaN*ones(size(ti)); %preallocation for speed

for ii=1:length(ti)
    %Compute the interpolated and filtered value at ti(ii)
    ifac = 1; %the factor we apply to minrad to get the radius to search
    is_inside = abs(ts-ti(ii))<minrad*ifac; % =1 if inside radius, =0 if outside
    inside = find(is_inside); %The indices where is_inside is true = 1
    insidenotNaN = inside(find(~isnan(in(inside)))); %Complicated. Also NaN are excluded
    %insidenotNaN are indices inside radius and not NaN. We are ready to compute out(ii) 
    while length(insidenotNaN)<mincatch
        ifac=ifac*2; %we expand the radius by a factor of 2
        inside = find(abs(ts-ti(ii))<minrad*ifac);
        insidenotNaN = inside(find(~isnan(in(inside))));
    end
    switch meanmode
        case 'triang'
            W = 1 - abs(ts(insidenotNaN(:))-ti(ii))/(minrad*ifac);
            W = W(:)/sum(W); 
            outmean(ii) = sum(W.*in(insidenotNaN));
        otherwise %'runav' and other misspellings
            outmean(ii) = mean(in(insidenotNaN));
    end            
    outmed(ii) = median(in(insidenotNaN));
    radi(ii) = minrad*ifac;
    if mod(ii,1000)==0
        disp(ii)
    end
end

end %function InterpFiltIrreg
