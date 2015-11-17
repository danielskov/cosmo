% xi: x values of sample points
% yi: y values of sample points
% xbins: Bin boundaries in x
% ybins: Bin boundaries in y
% W: Controls smoothing
%    Scalar W: Wfilter = ones(W)/W^2; i.e. moving average over bins
%    Vector: W1 = ones(W(1)); for i=1:W(2); W1=conv2(W1,W1); end;  Wfilter
%    = W1; %try W=[2,3];
%    Array: Wfilter = W;
%    default: W=[2,3];  
function [smoothgrid,histgrid] = smoothdens(xi,yi,xbins,ybins,W);
%Preallocate
[xbinss,ybinss]=meshgrid(xbins,ybins);
histgrid = zeros(size(xbinss));
for i=1:length(xi)
    xgt = xi(i)>xbins; %1 if sample x is right of bin edge
    ix(i) = find(diff(xgt)); %should catch the index of the xbin
    ygt = yi(i)>ybins; %1 if sample x is right of bin edge
    iy(i) = find(diff(ygt)); %should catch the index of the xbin
    histgrid(iy(i),ix(i)) = histgrid(iy(i),ix(i))+1;
end

if prod(size(W))==1 %scalar
    Wfilter = ones(W)/W^2;
elseif min(size(W))==1 %vector
    W1 = ones(W(1)); 
    for i=1:W(2); 
        W1=conv2(W1,W1); 
    end;  
    Wfilter = W1/sum(sum(W1)); %try W=[2,3];
else
    Wfilter = W;
end

smoothgrid = conv2(histgrid,Wfilter,'same');

    
