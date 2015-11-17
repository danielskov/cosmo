function mprCrossDensPlots(ms,fixed_stuff)
mprs = ms; %preallocate
for i=1:size(ms,2)
  mprs(:,i)=m2mpr(ms(:,i),fixed_stuff);
end
M = size(ms,1);

for i1=1:M
  for i2 = 1:M
    xi = mprs(i1,:); yi = mprs(i2,:);
    Nbin = 50;
    dxbin = 2*sqrt(3)/Nbin;
    dybin = 2*sqrt(3)/Nbin;
    xbins = (-sqrt(3)-dxbin):dxbin:(sqrt(3)+dxbin);% : Bin boundaries in x
    ybins = xbins;% : Bin boundaries in x
    %W = 3; %: Controls smoothing
    W = ones(2); W = conv2(W,W); W = W/sum(W(:));
    % W = cumsum(ones(3)); W = cumsum(W');
    [smoothgrid,histgrid] = smoothdens(xi,yi,xbins,ybins,W);
    subplot(M,M,(i2-1)*M+i1)
    %     plot(mprs(i1,:),mprs(i2,:),'.')
    pcolor(xbins,ybins,smoothgrid); 
    axis(sqrt(3)*[-1,1,-1,1])
    set(gca,'xtick',[-1.5:0.5:1.5],'ytick',[-1.5:0.5:1.5])
    grid on; shading flat; axis equal; axis tight; set(gca,'fontsize',8);
  end
end
for i1 = 1:M
  subplot(M,M,(M-1)*M+i1)
  xlabel(fixed_stuff.mname{i1})
  subplot(M,M,(i1-1)*M+1)
  ylabel(fixed_stuff.mname{i1})
end

for i=1:M*M; subplot(M,M,i);  end