function mstart = WalkerStarter(iwalk,fixed_stuff);
mstart = NaN(size(fixed_stuff.mminmax,1));
setseed(fixed_stuff.WalkerSeeds(iwalk)); %makes mstart and walks repeatable
switch fixed_stuff.WalkerStartMode
    case 'PriorMean'
        mstartpr = zeros(size(fixed_stuff.mminmax,1),1);
        mstart = mpr2m(mstartpr,fixed_stuff);
    case 'PriorSample'
        mstartpr = sqrt(3)*(2*rand(size(fixed_stuff.mminmax,1),1)-1);
        mstart = mpr2m(mstartpr,fixed_stuff);
    case 'PriorCorner'
        mstartpr = sqrt(3)*sign(randn(size(fixed_stuff.mminmax,1),1));
        mstart = mpr2m(mstartpr,fixed_stuff);
    case 'PriorEdge'
        %First draw a 'PriorSample'
        mstartpr = sqrt(3)*(2*rand(size(fixed_stuff.mminmax,1),1)-1);       
        %Then make extreme with probability 0.5
        for im=1:size(fixed_stuff.mminmax,1)
            isEdge = 1+sign(randn(1,1)); %first flip coin if this parameter is on edge
            if isEdge
                mstartpr(im)=sqrt(3)*sign(randn(1,1)); %left or right extreme
            end
        end
        mstart = mpr2m(mstartpr,fixed_stuff);
end