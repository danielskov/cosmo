function generate_plots(Ss, save_file, formats, show_figures)

%% Copied from m_pakke2014maj11/CompareWalks2.m
% Generates and saves all relevant figures

S = Ss{1};
fixed_stuff = S.fs;
Nwalkers = fixed_stuff.Nwalkers;
M = size(fixed_stuff.mminmax,1);

%Compare BurnIn

fh(1) = figure('visible', show_figures);
    
for iwalk=1:min(4,Nwalkers) %only up to the first four walks
  QsBurnIns(:,iwalk)=Ss{iwalk}.QsBurnIn;
  Qss(:,iwalk)       =Ss{iwalk}.Qs;
  acceptss(:,iwalk)=Ss{iwalk}.accepts;
  normdmpropspr(:,iwalk) = sqrt(sum(Ss{iwalk}.lump_MetHas.dmpropspr.^2)/M);
  normdmcurspr(:,iwalk) = sqrt(sum(Ss{iwalk}.lump_MetHas.dmcurspr.^2)/M);
end
subplot(2,4,1)
semilogy((1:size(QsBurnIns,1)),QsBurnIns,'-');
ylim([0.1,1e4])
ylabel('St. sum of sq.')
title('Burn in')
grid on

subplot(2,4,2:4)
semilogy(size(QsBurnIns,1)+(1:size(Qss,1)),Qss,'.')
legend('1','2','3','4','5','6','7','8','9','10','location','NorthEast')
ylim([0.1,1e4])
% ylabel('St. sum of sq.')
title(['Sampling. Result file =',save_file],'interp','none')
grid on

subplot(2,4,6)
hist(normdmcurspr)
xlabel('||dm_{cur}||')
ylimit = ylim;
title('Cur2cur step lengths (Stdz)')

subplot(2,4,5)
hist(normdmpropspr)
xlabel('||dm_{prop}||')
ylim(ylimit)
title('Proposed step lengths (Stdz)')

subplot(2,4,7)
textfontsize=8;
fs = Ss{1}.fs;
title('Data and Model')
%text out nucleides, RelError, depths
axis([-0.03,1,-1,9])
str = ['Nucleides'];
for i=1:length(fs.Nucleides)
  str = [str,' - ',fs.Nucleides{i}];
end
str = {str,['>>    Rel.Error=',num2str(fs.RelErrorObs)],...
           ['>>    zobs = ',sprintf('%g, ',fs.zobs)]};
text(0,1,str,'fontsize',textfontsize,'interp','none')
%text out prior intervals
for im=1:size(fs.mminmax,1)
  %str=[fs.mname{im},'_minmax=[',sprintf('%g,%g]. True=%g',fs.mminmax(im,:),fs.m_true(im))];
  text(0,im+2,str,'fontsize',textfontsize,'interp','none')
end

axis ij
box on

subplot(2,4,8)
title('MCMC-analysis')
str = ['Nwalkers:',num2str(fs.Nwalkers),'. ',fs.WalkerStartMode];
text(0,1,str,'fontsize',textfontsize,'interp','none')

fsamp = fs.BurnIn;
str = {['BurnIn: ',num2str(fsamp.Nsamp),' skip ',num2str(fsamp.Nskip),' of ',fsamp.ProposerType],...
  ['>>    StepFactor ',fsamp.StepFactorMode]},
switch fsamp.StepFactorMode
  case 'Fixed', str{2} = [str{2},'=',num2str(fsamp.StepFactor)];
  case 'Adaptive', str{2} = [str{2},', AccRat=',num2str(fsamp.TargetAcceptanceRatio)];    
end
text(0,2,str,'fontsize',textfontsize,'interp','none')

fsamp = fs.Sampling;
str = {['Sampling: ',num2str(fsamp.Nsamp),' skip ',num2str(fsamp.Nskip),' of ',fsamp.ProposerType],...
  ['>>    StepFactor ',fsamp.StepFactorMode]},
switch fsamp.StepFactorMode
  case 'Fixed', str{2} = [str{2},'=',num2str(fsamp.StepFactor)];
  case 'Adaptive', str{2} = [str{2},', AccRat=',num2str(fsamp.TargetAcceptanceRatio)];    
end
text(0,3.5,str,'fontsize',textfontsize,'interp','none')

axis([-0.03,1,0,10])
axis ij
box on

%Compare sampling cross-plots
fh = [fh;figure('visible', show_figures)];
Nbin = 50;

mminmax = fixed_stuff.mminmax; %bounds of uniform prior intervals
mDistr = fixed_stuff.mDistr;   %'uniform' or 'logunif' for each coordinate
% M = size(ms,1);

isub1 = 0;
for i1=1:M
  mminmax_i1 = mminmax(i1,:);
  %   mDistr_i1 = mDistr(i1,:);
  %   xi = ms(i1,:);
  switch mDistr(i1,:)
    case 'uniform',
      dxbin = diff(mminmax_i1)/Nbin; %we want outside bins to check that we do not sample outside
      xbins{i1} = linspace(mminmax_i1(1)-dxbin,mminmax_i1(2)+2*dxbin,Nbin+4); %one extra to make pcolor work
    case 'logunif'
      dfacxbin = (mminmax_i1(2)/mminmax_i1(1))^(1/(Nbin)); %we want outside bins to check that we do not sample outside
      xbins{i1} = logspace(log10(mminmax_i1(1)/dfacxbin),log10(mminmax_i1(2)*dfacxbin^2),Nbin+4);
  end
  
  %   for i2 = 1:M
  for i2 = (i1+1):M
    %     yi = ms(i2,:);
    
    mminmax_i2 = mminmax(i2,:);
    switch mDistr(i2,:)
      case 'uniform',
        dybin = diff(mminmax_i2)/Nbin; %we want outside bins to check that we do not sample outside
        ybins = linspace(mminmax_i2(1)-dybin,mminmax_i2(2)+2*dybin,Nbin+4);
      case 'logunif'
        dfacybin = (mminmax_i2(2)/mminmax_i2(1))^(1/Nbin); %we want outside bins to check that we do not sample outside
        ybins = logspace(log10(mminmax_i2(1)/dfacybin),log10(mminmax_i2(2)*dfacybin^2),Nbin+4);
    end
    W = ones(2); W = conv2(W,W); W = W/sum(W(:));
    %loop over walks
    isub1 = isub1+1;
    for iwalk = 1:min(4,Nwalkers)
      xi = Ss{iwalk}.ms(i1,:);yi = Ss{iwalk}.ms(i2,:);
      [smoothgrid,histgrid] = smoothdens(xi,yi,xbins{i1},ybins,W);
      isub2 = iwalk; isub = isub2 + (isub1-1)*4;
      if isub>4*5
        isub1 = 1; isub=1;
        fh = [fh;figure('visible', show_figures)];
      end
      subplot(5,4,isub)
      pcolor(xbins{i1},ybins,smoothgrid);
      xlabel(fixed_stuff.mname{i1})
      ylabel(fixed_stuff.mname{i2})
      grid on; shading flat; axis tight; set(gca,'fontsize',8);
      switch mDistr(i1,:)
        case 'uniform', set(gca,'xscale','lin')
        case 'logunif', set(gca,'xscale','log')
      end
      switch mDistr(i2,:)
        case 'uniform', set(gca,'yscale','lin')
        case 'logunif', set(gca,'yscale','log')
      end
      axis([mminmax_i1,mminmax_i2])
    end
  end
end

fh = [fh;figure('visible', show_figures)];
for i1 = 1:M
  for iwalk=1:min(4,Nwalkers)
    isub = (i1-1)*4 + iwalk;
    subplot(5,4,isub)
    Nhistc=histc(Ss{iwalk}.ms(i1,:),xbins{i1});
    bar(xbins{i1},Nhistc,'histc')
    xlabel(fixed_stuff.mname{i1})
    %set (gca,'xtick',[1e-7:1e-3]);
    
    switch mDistr(i1,:)
      case 'uniform', set(gca,'xscale','lin','xlim',mminmax(i1,:))
      case 'logunif', set(gca,'xscale','log','xlim',mminmax(i1,:))
    end
  end
end



%Putting in titles over figure 2:4

figure(fh(2)); set(fh(2), 'Visible', show_figures)
subplot(5,4,2)
title(['Density cross-plots A. Result file =',save_file],'interp','none')

figure(fh(3)); set(fh(3), 'Visible', show_figures)
subplot(5,4,2)
title(['Density cross-plots B. Result file =',save_file],'interp','none')

figure(fh(4)); set(fh(4), 'Visible', show_figures)
subplot(5,4,2)
title(['Histograms. Result file =',save_file],'interp','none')

if strcmp(show_figures, 'on')
    figpos1 = [6         474        1910         504];
    figpos2 =[    12 94 645 887];
    figpos3 =[   610 94 645 887];
    figpos4 =[  1207 94 740 887];
    set(fh(2),'pos',figpos2)
    set(fh(3),'pos',figpos3)
    set(fh(4),'pos',figpos4)
    set(fh(1),'pos',figpos1)
    figure(fh(1))
end

for i=1:4
    figure_save_multiformat(fh(i), ...
        strcat(save_file, '-', num2str(i)), ...
        formats);
end


% for i1 = 1:M
%   hold off
%   subplot(M,M,(M-1)*M+i1)
%   xlabel(fixed_stuff.mname{i1})
%   subplot(M,M,(i1-1)*M+1)
%   ylabel(fixed_stuff.mname{i1})
% end
% i=1;

