%Transform standardized parameters to ordinary parameters
%fixed_stuff.xxxxDistr ='logunif' signals that mpr is also logarithmic
% in the prior distribution mpr has zero mean and unit variance.
function m = mpr2m(mpr,fixed_stuff)
sqrt12 = sqrt(12);
mminmax = fixed_stuff.mminmax;
mDistr = fixed_stuff.mDistr;
m = NaN(size(mpr)); %preallocation
for im=1:size(mminmax,1)
    if strcmp(mDistr(im,:),'uniform')
        lims = mminmax(im,:);
%         mpr(im) = sqrt12*(m(im)-(lims(1)+lims(2))/2)/(lims(2)-lims(1));
        m(im) = mpr(im)*(lims(2)-lims(1))/sqrt12 + (lims(1)+lims(2))/2;
    elseif strcmp(mDistr(im,:),'logunif')
        lims = log(mminmax(im,:));
%         mpr(im) = sqrt12*(log(m(im))-(lims(1)+lims(2))/2)/(lims(2)-lims(1));
        m(im) = exp(mpr(im)*(lims(2)-lims(1))/sqrt12 + (lims(1)+lims(2))/2);
    end
end

