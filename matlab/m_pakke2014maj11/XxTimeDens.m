%Built from DepthExposureTimeDens.m 
function [smoothgrid,histgrid,tsfine,zsfine]=XxTimeDens(Xxsss,tss,dtfine,tfinemax,dXxfine,Xxfinemax,fixed_stuff,iz)
dzfine = dXxfine; zfinemax = Xxfinemax; zsss = Xxsss;
if nargin<4
  iz = 1; %track first layer
end
tsfine = 0:dtfine:tfinemax; %bin boundaries
Ntfine = length(tsfine);
zsfine = 0:dzfine:zfinemax; %bin boundaries
Nz = length(zsfine);

% Nxbin = 50;
% dxbin = 5e5/Nxbin;
[xbinss,ybinss]=meshgrid(tsfine,zsfine);
histgrid = zeros(size(xbinss));

for icurve=1:length(tss)

  zinterp = interp1(tss{icurve}(2:end),zsss{icurve}(iz,2:end),tsfine);
  izs = 1+floor(zinterp/dzfine); %bin index at each tsfine
  for itsfine=1:Ntfine
    if izs(itsfine)<=Nz
      histgrid(izs(itsfine),itsfine)=histgrid(izs(itsfine),itsfine)+ 1;
    end
  end
end

%W = 3; %: Controls smoothing
W = ones(2); W = conv2(W,W); W = W/sum(W(:));
smoothgrid = conv2(histgrid,W,'same');
%     plot(mprs(i1,:),mprs(i2,:),'.')
% % pcolor(tsfine,zsfine,log(smoothgrid));
% % % axis(sqrt(3)*[-1,1,-1,1])
% % % set(gca,'xtick',[-1.5:0.5:1.5],'ytick',[-1.5:0.5:1.5])
% % grid on; shading flat; axis tight; set(gca,'fontsize',8);
% % hold on
% for icurve = 1:20:length(tss)
%   plot(tss{icurve}(1,:),zsss{icurve}(1,:),'.-')
% end
