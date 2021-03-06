function generate_plots(Ss, matlab_scripts_folder,...
    save_file, formats, show_figures, ...
    sample_id, name, email, lat, long, ...
    be_conc,  al_conc,  c_conc,  ne_conc, ...
    be_uncer, al_uncer, c_uncer, ne_uncer, ...
    zobs, ...
    be_prod_spall, al_prod_spall, c_prod_spall, ne_prod_spall, ...
    be_prod_muons, al_prod_muons, c_prod_muons, ne_prod_muons, ...
    rock_density, ...
    epsilon_gla_min, epsilon_gla_max, ...
    epsilon_int_min, epsilon_int_max, ...
    t_degla_min, t_degla_max, ...
    record, ...
    record_threshold_min, record_threshold_max, ...
    nwalkers)

%% Copied from m_pakke2014maj11/CompareWalks2.m
% Generates and saves all relevant figures

S = Ss{1};
fixed_stuff = S.fs;
Nwalkers = fixed_stuff.Nwalkers;
M = size(fixed_stuff.mminmax,1);

% put titles on figures?
titles = 0;

% Burn-in and convergence overview MCMC plot, fh(1)
fh(1) = figure('visible', show_figures);

% generate matrices for percentiles
epsilon_int_25 = zeros(Nwalkers,1);
epsilon_int_50 = zeros(Nwalkers,1);
epsilon_int_75 = zeros(Nwalkers,1);
epsilon_gla_25 = zeros(Nwalkers,1);
epsilon_gla_50 = zeros(Nwalkers,1);
epsilon_gla_75 = zeros(Nwalkers,1);
record_threshold_25 = zeros(Nwalkers,1);
record_threshold_50 = zeros(Nwalkers,1);
record_threshold_75 = zeros(Nwalkers,1);
E_25 = zeros(Nwalkers,1);
E_50 = zeros(Nwalkers,1);
E_75 = zeros(Nwalkers,1);

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

% Compare sampling cross-plots, fh(2) and fh(3)
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

%% Histogram plots for all four parameters, one subplot per walker, fh(4)
disp('Histogram plots for all four parameters, one subplot per walker')
fh = [fh;figure('visible', show_figures)];
for i1 = 1:M
  for iwalk=1:min(4,Nwalkers)
    isub = (i1-1)*4 + iwalk;
    %subplot(5,4,isub)
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

%% Titles for Mads' plots
if titles
    %Putting in titles over figure 2:4
    figure(fh(2)); set(fh(2), 'Visible', show_figures)
    subplot(5,4,1)
    title(['Density cross-plots A. Result file = ',save_file])

    figure(fh(3)); set(fh(3), 'Visible', show_figures)
    subplot(5,4,1)
    title(['Density cross-plots B. Result file = ',save_file])

    figure(fh(4)); set(fh(4), 'Visible', show_figures)
    subplot(M,Nwalkers,1)
    %title(['Histograms. Result file =',save_file],'interp','none')
    title('Distribution of model parameter values')
end

%% Plot one histogram per model parameter per walker
epsilon_int_data_w = cell(1, Nwalkers);
epsilon_gla_data_w = cell(1, Nwalkers);
t_degla_data_w = cell(1, Nwalkers);
record_threshold_data_w = cell(1, Nwalkers);

disp('One histogram per model parameter per walker')
fh = [fh;figure('visible', show_figures)];
for i1 = 1:M % for each model parameter
  for iwalk=1:min(4,Nwalkers) % for each walker
    %isub = (i1-1)*4 + iwalk;
    %isub = (iwalk-1)*M + i1;
    isub = (i1-1)*Nwalkers + iwalk;
    %i1, M, iwalk, Nwalkers, isub
    %subplot(5,2,isub)
    subplot(M,Nwalkers,isub)
    %Nhistc=histc(Ss{iwalk}.ms(i1,:),xbins{i1});
    %bar(xbins{i1},Nhistc,'histc')
    
    if i1 == 1 || i1 == 2
        % change units from m/yr to m/Myr
        histogram(Ss{iwalk}.ms(i1,:)*1.0e6, xbins{i1}*1.0e6);
    else
        histogram(Ss{iwalk}.ms(i1,:), xbins{i1});
    end
    
    if i1 == 1
        title(['MCMC walker ' num2str(iwalk)])
        %xlabel('Interglacial erosion rate [m/yr]')
        %xlabel('Interglacial erosion rate [m/Myr]')
        xlabel('\epsilon_{int} [m/Myr]')
        text(0.02,0.98,'a', 'Units', ...
            'Normalized', 'VerticalAlignment', 'Top')
        epsilon_int_25(iwalk) = prctile(Ss{iwalk}.ms(i1,:)*1.0e6, 25);
        epsilon_int_50(iwalk) = prctile(Ss{iwalk}.ms(i1,:)*1.0e6, 50);
        epsilon_int_75(iwalk) = prctile(Ss{iwalk}.ms(i1,:)*1.0e6, 75);
        epsilon_int_data_w{iwalk} = Ss{iwalk}.ms(i1,:)*1.0e6;
        
    elseif i1 == 2
        %xlabel('Glacial erosion rate [m/yr]')
        %xlabel('Glacial erosion rate [m/Myr]')
        xlabel('\epsilon_{gla} [m/Myr]')
        text(0.02,0.98,'b', 'Units', ...
            'Normalized', 'VerticalAlignment', 'Top')
        epsilon_gla_25(iwalk) = prctile(Ss{iwalk}.ms(i1,:)*1.0e6, 25);
        epsilon_gla_50(iwalk) = prctile(Ss{iwalk}.ms(i1,:)*1.0e6, 50);
        epsilon_gla_75(iwalk) = prctile(Ss{iwalk}.ms(i1,:)*1.0e6, 75);
        epsilon_gla_data_w{iwalk} = Ss{iwalk}.ms(i1,:)*1.0e6;
        
    elseif i1 == 3
        %xlabel('Timing of last deglaciation [yr]')
        xlabel('t_{degla} [yr]')
        text(0.02,0.98,'c', 'Units', ...
            'Normalized', 'VerticalAlignment', 'Top')
        t_degla_data_w{iwalk} = Ss{iwalk}.ms(i1,:);
        
    elseif i1 == 4
        %xlabel('$\delta^{18}$O$_\mathrm{threshold}$ [$^o/_{oo}$]', ...
            %'Interpreter', 'LaTeX')
        xlabel(['\delta^{18}O_{threshold} [' char(8240) ']'])
        text(0.02,0.98,'d','Units', ...
            'Normalized', 'VerticalAlignment', 'Top')
        record_threshold_25(iwalk) = prctile(Ss{iwalk}.ms(i1,:), 25);
        record_threshold_50(iwalk) = prctile(Ss{iwalk}.ms(i1,:), 50);
        record_threshold_75(iwalk) = prctile(Ss{iwalk}.ms(i1,:), 75);
        record_threshold_data_w{iwalk} = Ss{iwalk}.ms(i1,:);
        
    else
        disp(['Using mname for i1 = ' i1])
        xlabel(fixed_stuff.mname{i1})
    end
    %set (gca,'xtick',[1e-7:1e-3]);
    
    if i1 == 1 || i1 == 2 % shift axes for new units
        switch mDistr(i1,:)
            case 'uniform', set(gca,'xscale','lin','xlim',mminmax(i1,:)*1.0e6)
            case 'logunif', set(gca,'xscale','log','xlim',mminmax(i1,:)*1.0e6)
        end
    else
        switch mDistr(i1,:)
            case 'uniform', set(gca,'xscale','lin','xlim',mminmax(i1,:))
            case 'logunif', set(gca,'xscale','log','xlim',mminmax(i1,:))
        end
    end
  end
end




%% Plot one histogram per model parameter, including data from all walkers
disp('One histogram per model parameter')
fh = [fh;figure('visible', show_figures)];
for i1 = 1:M % for each model parameter

    subplot(M,1,i1)
    
    data = [];
    for iwalker=1:Nwalkers
        if i1 == 1 || i1 == 2
            data = [data, Ss{iwalker}.ms(i1,:)*1.0e6];
        else
            data = [data, Ss{iwalker}.ms(i1,:)];
        end
    end
    
    hold on
    %Nhistc=histc(data, xbins{i1});
    %bar(xbins{i1},Nhistc,'histc')
    if i1 == 1 || i1 == 2
        xbins{i1} = xbins{i1}*1.0e6; % change to m/Myr
    end
    histogram(data, xbins{i1});
    
    % 2nd quartile = median = 50th percentile
    med = median(data);
    plot([med, med], get(gca,'YLim'), 'm-')
    
    % save median values for later
    if i1 == 1
        epsilon_int_med = med;
        epsilon_int_data = data;
    elseif i1 == 2
        epsilon_gla_med = med;
        epsilon_gla_data = data;
    elseif i1 == 3
        t_degla_med = med;
        t_degla_data = data;
    elseif i1 == 4
        record_threshold_med = med;
        record_threshold_data = data;
    else
        error('Unknown parameter');
    end
    %ylims = get(gca,'YLim');
    %text(med, ylims(1) + (ylims(2) - ylims(1))*0.9, ...
        %['\leftarrow' num2str(med)]);
    
    % 1st quartile = 25th percentile
    prctile25 = prctile(data, 25);
    plot([prctile25, prctile25], get(gca,'YLim'), 'm--')
    
    % 3rd quartile = 75th percentile
    prctile75 = prctile(data, 75); 
    plot([prctile75, prctile75], get(gca,'YLim'), 'm--')
    
    hold off
    
    if i1 == 1
        %xlabel(['Interglacial erosion rate [m/yr], median = ' ...
        %xlabel(['Interglacial erosion rate [m/Myr], median = ' ...
        xlabel(['\epsilon_{int} [m/Myr], median = ' ...
            num2str(med, 4) ' m/Myr'])
            %num2str(med, 4) ' m/yr'])
        text(0.02,0.98,'a', 'Units', ...
            'Normalized', 'VerticalAlignment', 'Top')
    elseif i1 == 2
        %xlabel(['Glacial erosion rate [m/yr], median = ' ...
        %xlabel(['Glacial erosion rate [m/Myr], median = ' ...
        xlabel(['\epsilon_{gla} [m/Myr], median = ' ...
            num2str(med, 4) ' m/Myr'])
            %num2str(med, 4) ' m/yr'])
        text(0.02,0.98,'b', 'Units', ...
            'Normalized', 'VerticalAlignment', 'Top')
    elseif i1 == 3
        %xlabel(['Timing of last deglaciation [yr], median = ' ...
        xlabel(['t_{degla} [yr], median = ' ...
            num2str(med, 4) ' yr'])
        text(0.02,0.98,'c', 'Units', ...
            'Normalized', 'VerticalAlignment', 'Top')
    elseif i1 == 4
        %xlabel(['$\delta^{18}$O$_\mathrm{threshold}$ [$^o/_{oo}$]'...
            %', median = ' num2str(med) ' $^o/_{oo}$'], ...
            %'Interpreter', 'LaTeX')
        xlabel(['\delta^{18}O_{threshold} [' char(8240) '], median = '...
            num2str(med, 4) ' ' char(8240)])
        text(0.02,0.98,'d','Units', ...
            'Normalized', 'VerticalAlignment', 'Top')
    else
        disp(['Using mname for i1 = ' i1])
        xlabel(fixed_stuff.mname{i1})
    end
    %set (gca,'xtick',[1e-7:1e-3]);
    
    if i1 == 1 || i1 == 2 % shift axes for new units
        switch mDistr(i1,:)
            case 'uniform', set(gca,'xscale','lin','xlim',mminmax(i1,:)*1.0e6)
            case 'logunif', set(gca,'xscale','log','xlim',mminmax(i1,:)*1.0e6)
        end
    else
        switch mDistr(i1,:)
            case 'uniform', set(gca,'xscale','lin','xlim',mminmax(i1,:))
            case 'logunif', set(gca,'xscale','log','xlim',mminmax(i1,:))
        end
    end
end




%% Plot d18O curve, from PlotSmoothZachos.m
disp('d18O curve, exposure, and erosion history')
fh = [fh;figure('visible', show_figures)];

if strcmp(record, 'rec_5kyr')
    d18O_filename = 'lisiecki_triinterp_2p6Ma_5ky.mat'; %  zachos_triinterp_2p6Ma
elseif strcmp(record, 'rec_20kyr')
    d18O_filename = 'lisiecki_triinterp_2p6Ma_20ky.mat'; %  zachos_triinterp_2p6Ma
elseif strcmp(record, 'rec_30kyr')
    d18O_filename = 'lisiecki_triinterp_2p6Ma_30ky.mat'; %  zachos_triinterp_2p6Ma
else
    error(['record ' record ' not understood']);
end

load([matlab_scripts_folder, d18O_filename])
xs = ti;
dt = diff(ti(1:2));
ys = d18O_triang;
%colpos = [0.5,0.5,1];
colpos = [0,0,1];
%colneg = [0.5,1,0.5];
colneg = [1,0,0];
%midvalue = 3.75;  %%% THIS IS THE THRESHOLD
midvalue = record_threshold_med;
axh(1)=subplot(3,1,1);
[~,~,~,i_cross]=fill_red_blue(xs,ys,colpos,colneg,midvalue);
text(0.02,0.98,'a', 'Units', 'Normalized', 'VerticalAlignment', 'Top')
xlabel('Age BP [Ma]')
ylabel('\delta^{18}O')
axis tight
xlim([min(xs), max(xs)])
%axis([-0.1,2.7,3.0,5.2])
%axis([-0.05,0.3,3.0,5.2])
%xlim([-0.1,2.7])
%xlim([-0.05,0.3])

hold on
%plot(A(:,1)/1000,A(:,2),'.-m')
axis ij
xs_cross = (i_cross-1)*dt;
xs_cross = [0;xs_cross];
%title([fn,'.  minrad = ',num2str(minrad),' Ma'],'interp','none')

% deglaciation timing
plot([t_degla_med, t_degla_med], get(gca,'YLim'), 'k--');

xs_cross(2) = 0.011;

% Exposure
axh(2)=subplot(3,1,2);
%stairs(xs_cross,(1+-1*(-1).^(1:length(xs_cross)))/2,'b','linewidth',1.5);
exposure = (1+-1*(-1).^(1:length(xs_cross)))/2 * 100;
stairs(xs_cross, exposure, ...
    'b','linewidth',1.5);
hold on
start1 = [xs_cross(end), xs(end)];
start2 = [exposure(end), exposure(end)];
plot(start1,start2,'b','linewidth',1.5);
%plot(start1,start2,'b','linewidth',1.5);
%title('Exposure. 0 = glaciated, 1 = not glaciated')
%axis([-0.1,2.7,-0.5,1.5])
%axis([-0.05,0.3,-0.5,1.5])
text(0.02,0.98,'b', 'Units', 'Normalized', 'VerticalAlignment', 'Top')
xlabel('Age BP [Ma]')
ylabel('Exposure [%]')
axis tight
xlim([min(xs), max(xs)])
ylim([-30, 130])
% deglaciation timing
plot([t_degla_med, t_degla_med], get(gca,'YLim'), 'k--');

% Erosion rate
axh(2)=subplot(3,1,3);
%stairs(xs_cross,(1+-1*(-1).^(1:length(xs_cross)))/2 ,'r','linewidth',1.5);
erosionrate = epsilon_gla_med + ...
    -epsilon_gla_med*(1+-1*(-1).^(1:length(xs_cross)))/2 + ...
    epsilon_int_med*(1+-1*(-1).^(1:length(xs_cross)))/2;
stairs(xs_cross, erosionrate, 'r','linewidth',1.5);
hold on
start1 = [xs_cross(end), xs(end)];
start2 = [erosionrate(end), erosionrate(end)];
plot(start1,start2,'r','linewidth',1.5);
%title('Exposure. 0 = glaciated, 1 = not glaciated')
%axis([-0.1,2.7,-1,2])
%axis([-0.05,0.3,-1,2])
text(0.02,0.98,'c', 'Units', 'Normalized', 'VerticalAlignment', 'Top')
xlabel('Age BP [Ma]')
%ylabel('Erosion rate [m/yr]')
ylabel('Erosion rate [m/Myr]')
axis tight
xlim([min(xs), max(xs)])
ylims = get(gca,'YLim');
dy = ylims(2)-ylims(1);
ylim([ylims(1) - 0.2*dy, ylims(2) + 0.2*dy])

% deglaciation timing
plot([t_degla_med, t_degla_med], get(gca,'YLim'), 'k--');

hold on
d18Oth = midvalue;
%ErateInt=1e-6; ErateGla=1e-7;
ErateInt = epsilon_int_med;
ErateGla = epsilon_gla_med;
[~,~] = ExtractHistory2(ti,d18O_triang,d18Oth,ErateInt,ErateGla);

linkaxes(axh,'x')
% stairs(-tStarts,relExpos+2,'r')


%% Exhumation history from InspectDepthConcTracks_True_plot.m
disp('Exhumation history');
fh = [fh;figure('visible', show_figures)];
for iwalk = 1:Nwalkers
    % iwalk=input(['What iwalk?[1..',num2str(length(Ss)),']']),
    
    % if all walker results are written to a single figure, it exceeds
    % system memory limits
    subplot(Nwalkers,1,iwalk)
    %fh = [fh;figure('visible', show_figures)];
    
    lump_MetHas = Ss{iwalk}.lump_MetHas;
    fixed_stuff = Ss{iwalk}.fs;
    % if ~isempty(lump_MetHas.zsss{1})
    % % % % zsss = lump_MetHas.zsss;
    % % % % tss = lump_MetHas.tss;
    % % % % dtfine = -1000; tfinemax = -20e5; dzfine = 0.1; zfinemax = 20,
    % % % % iz = 1;
    % % % % DepthExposureTimeDens(zsss,tss,dtfine,tfinemax,dzfine,zfinemax,fixed_stuff,iz)
    % % % % title('z(time)')
    % % % % axis ij
    % % % % hold on
    
    %making quantiles to plot ontop of exhumation densities:
    tss = lump_MetHas.tss;
    dtfine = -500; tfinemax = -20e5;
    Xxsss = lump_MetHas.zsss;
    % dXxfine = 0.05; Xxfinemax = 50; iz=1; %Xx may be depth or nucleide concentration or ...
    dXxfine = 0.01; Xxfinemax = 50; iz=1; %Xx may be depth or nucleide concentration or ...
    dzfine = dXxfine; zfinemax = Xxfinemax;
    [smoothgrid,histgrid,tsfine,Xxfine]=XxTimeDens(Xxsss,tss,dtfine,tfinemax,dXxfine,Xxfinemax,fixed_stuff,iz);
    %pcolor(-tsfine,Xxfine,sqrt(smoothgrid));
    %pcolor(tsfine,Xxfine,sqrt(histgrid)); %<<<BHJ: v?lge mellem glattet og r? farvel?gning
    hold on
    %plot a selection of depth histories
    for i=1:ceil(length(tss)/50):length(tss)
        %   plot(tss{i},Xxsss{i},'.-c')
    end
    %Compute and plot quantiles
    N = sum(histgrid(:,1));
    fractions = [0.25,0.5,0.75]; %quartiles
    tsfine = 0:dtfine:tfinemax; %bin boundaries
    Ntfine = length(tsfine);
    zsfine = 0:dzfine:zfinemax; %bin boundaries
    % quants{iwalk} = GetHistgridQuantiles(histgrid,N,fractions,tsfine,zsfine);
    % plot(tsfine,quants{iwalk}(1,:),'r','linewidth',3)
    % plot(tsfine,quants{iwalk}(2,:),'k','linewidth',3)
    % plot(tsfine,quants{iwalk}(3,:),'b','linewidth',3)
    quants(:,:,iwalk) = GetHistgridQuantiles(histgrid,N,fractions,tsfine,zsfine);
    quants2(:,:,iwalk) = GetHistgridQuantiles2(histgrid,N,fractions,tsfine,zsfine);
    
    grid on; shading flat; axis tight; 
    %set(gca,'fontsize',8); 
    hold on
    % lh(1)=plot(tsfine,quants(1,:,iwalk),'r','linewidth',2)
    % lh(2)=plot(tsfine,quants(2,:,iwalk),'k','linewidth',2)
    % lh(3)=plot(tsfine,quants(3,:,iwalk),'g','linewidth',2)
    
    lh2(1)=plot(-tsfine,quants2(1,:,iwalk),'r','linewidth',1); % 25%
    lh2(2)=plot(-tsfine,quants2(2,:,iwalk),'k','linewidth',1); % 50%
    lh2(3)=plot(-tsfine,quants2(3,:,iwalk),'r','linewidth',1); % 75%
    
    %legend(lh2,'25%','median','75%','location','northwest')
    axis ij
    %track_handle=AddTrueModelDepthTrack(Ss{iwalk}.fs,'-m'); %<<< BHJ: added 2014 dec 09
    %set(track_handle,'linewidth',2);
    
    % Save erosion magnitudes over the last 1 Myr
    E_25(iwalk) = quants2(1, 2001, iwalk);
    E_50(iwalk) = quants2(2, 2001, iwalk);
    E_75(iwalk) = quants2(3, 2001, iwalk);
    
    %axis([0 1e6 0 25])
    %caxis([0 25])
    %set (gca,'xtick',[0:0.1e5:1e6]);
    xlim([0, 1e6]);
    %set (gca,'ytick',[0:3:12]);
    
    title(['MCMC walker ' num2str(iwalk)])
    xlabel('Time BP [yr]')
    ylabel('Depth [m]')
end
colormap(1-copper(15))
%subplot(2,2,1);
%title(fn,'interpreter','none')
%axis([-2e6 0 0 40])

%colorbar
%set (gca,'xtick',[-2e6:0.2e6:0]);

%XTicksAt = ([-2e6:0.2e6:0]);



%% position figure windows at certain coordinates on the screen
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

%% save all figures
disp('Saving figures')
for i=1:length(fh)
    disp(['Saving figure ' num2str(i) ' of ' num2str(length(fh))])
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

%% generate html table of results
filename = [save_file, '.html'];
disp('Saving html table of results')

% header
html = [...
    '\n'...
    '<table class="highlight">\n'...
    '    <thead>\n'...
    '        <tr>\n'...
    '            <th data-field="param">Parameter</th>\n'...
    '            <th data-field="param">Percentile</th>\n'];

for i=1:Nwalkers
    html = [html, ...
        '            <th data-field="w1">Walker ', num2str(i), '</th>\n'];
end

% epsilon_int
html = [html, ...
    '            <th data-field="avg">Average</th>\n'...
    '        </tr>\n'...
    '    </thead>\n'...
    '    <tbody>\n'...
    '        <tr>\n'...
    '            <td>&nbsp;</td>\n'...
    '            <td align="center">25%%</td>\n'];
for i=1:Nwalkers
    html = [html, '            <td>',...
        num2str(epsilon_int_25(i),3),'</td>\n'];
end
    
html = [html, '            <td>',...
    num2str(sum(epsilon_int_25)/Nwalkers,3),'</td>\n'...
    '        </tr>\n'...
    '        <tr>\n'...
    '            <td align="center">&epsilon;<sub>int</sub> [m/Myr]</td>\n'...
    '            <td align="center">50%%</td>\n'];

for i=1:Nwalkers
    html = [html, '            <td>',...
        num2str(epsilon_int_50(i),3),'</td>\n'];
end


html = [html, '            <td>',...
    num2str(sum(epsilon_int_50)/Nwalkers,3),'</td>\n'...
    '        </tr>\n'...
    '        <tr style="border-bottom:1px solid #D0D0D0">\n'...
    '            <td>&nbsp;</td>\n'...
    '            <td align="center">75%%</td>\n'];

for i=1:Nwalkers
    html = [html, '            <td>',...
        num2str(epsilon_int_75(i),3),'</td>\n'];
end

html = [html, '            <td>',...
    num2str(sum(epsilon_int_75)/Nwalkers,3),'</td>\n'...
    '        </tr>\n'];


% epsilon_gla
html = [html, ...
    '        <tr>\n'...
    '            <td>&nbsp;</td>\n'...
    '            <td align="center">25%%</td>\n'];
for i=1:Nwalkers
    html = [html, '            <td>',...
        num2str(epsilon_gla_25(i),3),'</td>\n'];
end
    
html = [html, '            <td>',...
    num2str(sum(epsilon_gla_25)/Nwalkers,3),'</td>\n'...
    '        </tr>\n'...
    '        <tr>\n'...
    '            <td align="center">&epsilon;<sub>gla</sub> [m/Myr]</td>\n'...
    '            <td align="center">50%%</td>\n'];

for i=1:Nwalkers
    html = [html, '            <td>',...
        num2str(epsilon_gla_50(i),3),'</td>\n'];
end


html = [html, '            <td>',...
    num2str(sum(epsilon_gla_50)/Nwalkers,3),'</td>\n'...
    '        </tr>\n'...
    '        <tr style="border-bottom:1px solid #D0D0D0">\n'...
    '            <td>&nbsp;</td>\n'...
    '            <td align="center">75%%</td>\n'];

for i=1:Nwalkers
    html = [html, '            <td>',...
        num2str(epsilon_gla_75(i),3),'</td>\n'];
end

html = [html, '            <td>',...
    num2str(sum(epsilon_gla_75)/Nwalkers,3),'</td>\n'...
    '        </tr>\n'];


% record_threshold
html = [html, ...
    '        <tr>\n'...
    '            <td>&nbsp;</td>\n'...
    '            <td align="center">25%%</td>\n'];
for i=1:Nwalkers
    html = [html, '            <td>',...
        num2str(record_threshold_25(i),3),'</td>\n'];
end
    
html = [html, '            <td>',...
    num2str(sum(record_threshold_25)/Nwalkers,3),'</td>\n'...
    '        </tr>\n'...
    '        <tr>\n'...
    '            <td align="center">&delta;<sup>18</sup>O<sub>threshold</sub> [&permil;]</td>\n'...
    '            <td align="center">50%%</td>\n'];

for i=1:Nwalkers
    html = [html, '            <td>',...
        num2str(record_threshold_50(i),3),'</td>\n'];
end


html = [html, '            <td>',...
    num2str(sum(record_threshold_50)/Nwalkers,3),'</td>\n'...
    '        </tr>\n'...
    '        <tr style="border-bottom:1px solid #D0D0D0">\n'...
    '            <td>&nbsp;</td>\n'...
    '            <td align="center">75%%</td>\n'];

for i=1:Nwalkers
    html = [html, '            <td>',...
        num2str(record_threshold_75(i),3),'</td>\n'];
end

html = [html, '            <td>',...
    num2str(sum(record_threshold_75)/Nwalkers,3),'</td>\n'...
    '        </tr>\n'];

% E
html = [html, ...
    '        <tr>\n'...
    '            <td>&nbsp;</td>\n'...
    '            <td align="center">25%%</td>\n'];
for i=1:Nwalkers
    html = [html, '            <td>',...
        num2str(E_25(i),3),'</td>\n'];
end
    
html = [html, '            <td>',...
    num2str(sum(E_25)/Nwalkers,3),'</td>\n'...
    '        </tr>\n'...
    '        <tr>\n'...
    '            <td align="center">E [m/Myr]</td>\n'...
    '            <td align="center">50%%</td>\n'];

for i=1:Nwalkers
    html = [html, '            <td>',...
        num2str(E_50(i),3),'</td>\n'];
end


html = [html, '            <td>',...
    num2str(sum(E_50)/Nwalkers,3),'</td>\n'...
    '        </tr>\n'...
    '        <tr style="border-bottom:1px solid #D0D0D0">\n'...
    '            <td>&nbsp;</td>\n'...
    '            <td align="center">75%%</td>\n'];

for i=1:Nwalkers
    html = [html, '            <td>',...
        num2str(E_75(i),3),'</td>\n'];
end

html = [html, '            <td>',...
    num2str(sum(E_75)/Nwalkers,3),'</td>\n'...
    '        </tr>\n'];


% footer
html = [html, '    </tbody>\n'...
    '</table>\n'...
    ];
fileID = fopen(filename,'w');
fprintf(fileID, html);
fclose(fileID);

%% generate csv table of results
filename = [save_file, '.csv'];
disp('Saving CSV table of results')
% header
csv = [...
    'Parameter;Percentile;'];

for i=1:Nwalkers
    csv = [csv, ...
        'Walker ', num2str(i), ';'];
end

% epsilon_int
csv = [csv, ...
    'Average\n'...
    ';25%%;'];
for i=1:Nwalkers
    csv = [csv, num2str(epsilon_int_25(i),3),';'];
end
    
csv = [csv, num2str(sum(epsilon_int_25)/Nwalkers,3),'\n'...
    'epsilon_int [m/Myr];50%%;'];

for i=1:Nwalkers
    csv = [csv, num2str(epsilon_int_50(i),3),';'];
end


csv = [csv, num2str(sum(epsilon_int_50)/Nwalkers,3),'\n'...
    ';75%%;'];

for i=1:Nwalkers
    csv = [csv, num2str(epsilon_int_75(i),3),';'];
end

csv = [csv, num2str(sum(epsilon_int_75)/Nwalkers,3),'\n'];


% epsilon_gla
csv = [csv, ...
    ';25%%;'];
for i=1:Nwalkers
    csv = [csv, num2str(epsilon_gla_25(i),3),';'];
end
    
csv = [csv, num2str(sum(epsilon_gla_25)/Nwalkers,3),'\n'...
    'epsilon_gla [m/Myr];50%%;'];

for i=1:Nwalkers
    csv = [csv, num2str(epsilon_gla_50(i),3),';'];
end


csv = [csv, num2str(sum(epsilon_gla_50)/Nwalkers,3),'\n'...
    ';75%%;'];

for i=1:Nwalkers
    csv = [csv, num2str(epsilon_gla_75(i),3),';'];
end

csv = [csv, num2str(sum(epsilon_gla_75)/Nwalkers,3),'\n'];

% record_threshold
csv = [csv, ...
    ';25%%;'];
for i=1:Nwalkers
    csv = [csv, num2str(record_threshold_25(i),3),';'];
end
    
csv = [csv, num2str(sum(record_threshold_25)/Nwalkers,3),'\n'...
    'd18O_threshold [permille];50%%;'];

for i=1:Nwalkers
    csv = [csv, num2str(record_threshold_50(i),3),';'];
end


csv = [csv, num2str(sum(record_threshold_50)/Nwalkers,3),'\n'...
    ';75%%;'];

for i=1:Nwalkers
    csv = [csv, num2str(record_threshold_75(i),3),';'];
end

csv = [csv, num2str(sum(record_threshold_75)/Nwalkers,3),'\n'];


% E
csv = [csv, ...
    ';25%%;'];
for i=1:Nwalkers
    csv = [csv, num2str(E_25(i),3),';'];
end
    
csv = [csv, num2str(sum(E_25)/Nwalkers,3),'\n'...
    'E [m/Myr];50%%;'];

for i=1:Nwalkers
    csv = [csv, num2str(E_50(i),3),';'];
end


csv = [csv, num2str(sum(E_50)/Nwalkers,3),'\n'...
    ';75%%;'];

for i=1:Nwalkers
    csv = [csv, num2str(E_75(i),3),';'];
end

csv = [csv, num2str(sum(E_75)/Nwalkers,3),'\n'];


fileID = fopen(filename,'w');
fprintf(fileID, csv);
fclose(fileID);


%% generate html table of input parameters
filename = [save_file, '-input.html'];
disp('Saving html table of input values')

% header
html = ['\n' ...
    '<table class="highlight">\n'...
    '    <thead>\n'...
    '        <tr>\n'...
    '            <th data-field="param">Parameter</th>\n'...
    '            <th data-field="val">Value</th>\n'...
    '        </tr>\n'...
    '    </thead>\n'...
    '    <tbody>\n'...
    '        <tr>\n'...
    '            <td>Sample ID</td>\n'...
    '            <td>' sample_id{1} '</td>\n'...
    '        </tr>\n'...
    '            <td>Name</td>\n'...
    '            <td>' name{1} '</td>\n'...
    '        </tr>\n'...
    '            <td>Email</td>\n'...
    '            <td>' email{1} '</td>\n'...
    '        </tr>\n'...
    '        <tr>\n'...
    '            <td>Latitude</td>\n'...
    '            <td>' lat{1} '</td>\n'...
    '        </tr>\n'...
    '        <tr>\n'...
    '            <td>Longitude</td>\n'...
    '            <td>' long{1} '</td>\n'...
    '        </tr>\n'...
    '        <tr>\n'...
    '            <td><sup>10</sup>Be concentration</td>\n'...
    '            <td>' num2str(be_conc/1000.) ' atoms/g</td>\n'...
    '        </tr>\n'...
    '        <tr>\n'...
    '            <td><sup>26</sup>Al concentration</td>\n'...
    '            <td>' num2str(al_conc/1000.) ' atoms/g</td>\n'...
    '        </tr>\n'...
    '        <tr>\n'...
    '            <td><sup>14</sup>C concentration</td>\n'...
    '            <td>' num2str(c_conc/1000.) ' atoms/g</td>\n'...
    '        </tr>\n'...
    '        <tr>\n'...
    '            <td><sup>21</sup>Ne concentration</td>\n'...
    '            <td>' num2str(ne_conc/1000.) ' atoms/g</td>\n'...
    '        </tr>\n'...
    '        <tr>\n'...
    '            <td><sup>10</sup>Be conc. uncertainty</td>\n'...
    '            <td>' num2str(be_uncer*100.) ' %%</td>\n'...
    '        </tr>\n'...
    '        <tr>\n'...
    '            <td><sup>26</sup>Al conc. uncertainty</td>\n'...
    '            <td>' num2str(al_uncer*100.) ' %%</td>\n'...
    '        </tr>\n'...
    '        <tr>\n'...
    '            <td><sup>14</sup>C conc. uncertainty</td>\n'...
    '            <td>' num2str(c_uncer*100.) ' %%</td>\n'...
    '        </tr>\n'...
    '        <tr>\n'...
    '            <td><sup>21</sup>Ne conc. uncertainty</td>\n'...
    '            <td>' num2str(ne_uncer*100.) ' %%</td>\n'...
    '        </tr>\n'...
    '        <tr>\n'...
    '            <td>Observation depth</td>\n'...
    '            <td>' num2str(zobs) ' m</td>\n'...
    '        </tr>\n'...
    '        <tr>\n'...
    '            <td><sup>10</sup>Be production (spallation)</td>\n'...
    '            <td>' num2str(be_prod_spall/1000.) ' atoms/g/yr</td>\n'...
    '        </tr>\n'...
    '        <tr>\n'...
    '            <td><sup>26</sup>Al production (spallation)</td>\n'...
    '            <td>' num2str(al_prod_spall/1000.) ' atoms/g/yr</td>\n'...
    '        </tr>\n'...
    '        <tr>\n'...
    '            <td><sup>14</sup>C production (spallation)</td>\n'...
    '            <td>' num2str(c_prod_spall/1000.) ' atoms/g/yr</td>\n'...
    '        </tr>\n'...
    '        <tr>\n'...
    '            <td><sup>21</sup>Ne production (spallation)</td>\n'...
    '            <td>' num2str(ne_prod_spall/1000.) ' atoms/g/yr</td>\n'...
    '        </tr>\n'...
    '        <tr>\n'...
    '            <td><sup>10</sup>Be production (muons)</td>\n'...
    '            <td>' num2str(be_prod_muons/1000.) ' atoms/g/yr</td>\n'...
    '        </tr>\n'...
    '        <tr>\n'...
    '            <td><sup>26</sup>Al production (muons)</td>\n'...
    '            <td>' num2str(al_prod_muons/1000.) ' atoms/g/yr</td>\n'...
    '        </tr>\n'...
    '        <tr>\n'...
    '            <td><sup>14</sup>C production (muons)</td>\n'...
    '            <td>' num2str(c_prod_muons/1000.) ' atoms/g/yr</td>\n'...
    '        </tr>\n'...
    '        <tr>\n'...
    '            <td><sup>21</sup>Ne production (muons)</td>\n'...
    '            <td>' num2str(ne_prod_muons/1000.) ' atoms/g/yr</td>\n'...
    '        </tr>\n'...
    '        <tr>\n'...
    '            <td>Rock density</td>\n'...
    '            <td>' num2str(rock_density) ' kg/m<sup>3</sup></td>\n'...
    '        </tr>\n'...
    '        <tr>\n'...
    '            <td>&epsilon;<sub>gla</sub></td>\n'...
    '            <td>' num2str(epsilon_gla_min*1.0e6) ...
    ' to ' num2str(epsilon_gla_max*1.0e6) ' m/Myr</td>\n'...
    '        </tr>\n'...
    '        <tr>\n'...
    '            <td>&epsilon;<sub>int</sub></td>\n'...
    '            <td>' num2str(epsilon_int_min*1.0e6) ...
    ' to ' num2str(epsilon_int_max*1.0e6) ' m/Myr</td>\n'...
    '        </tr>\n'...
    '        <tr>\n'...
    '            <td><i>t</i><sub>degla</sub></td>\n'...
    '            <td>' num2str(t_degla_min) ...
    ' to ' num2str(t_degla_max) ' yr</td>\n'...
    '        </tr>\n'...
    '        <tr>\n'...
    '            <td>Climate record</td>\n'...
    '            <td>' record{1} '</td>\n'...
    '        </tr>\n'...
    '        <tr>\n'...
    '            <td>&delta;<sup>18</sup>O<sub>threshold</sub></td>\n'...
    '            <td>' num2str(record_threshold_min) ...
    ' to ' num2str(record_threshold_max) ' &permil;</td>\n'...
    '        </tr>\n'...
    '        <tr>\n'...
    '            <td>MCMC walkers</td>\n'...
    '            <td>' num2str(nwalkers) '</td>\n'...
    '        </tr>\n'...
    '    </tbody>\n'...
    '</table>\n'];
fileID = fopen(filename,'w');
fprintf(fileID, html);
fclose(fileID);

%% Save general data
disp('Saving general data files');
dlmwrite([save_file, '-eps_int.txt'], epsilon_int_data);
dlmwrite([save_file, '-eps_gla.txt'], epsilon_gla_data);
dlmwrite([save_file, '-t_degla.txt'], t_degla_data);
dlmwrite([save_file, '-d18O_threshold.txt'], record_threshold_data);

%% Save per-walker data
for i=1:Nwalkers
    dlmwrite([save_file, '-eps_int-w' num2str(i) '.txt'],...
        epsilon_int_data_w{i});
    dlmwrite([save_file, '-eps_gla-w' num2str(i) '.txt'],...
        epsilon_gla_data_w{i});
    dlmwrite([save_file, '-t_degla-w' num2str(i) '.txt'],...
        t_degla_data_w{i});
    dlmwrite([save_file, '-d18O_threshold-w' num2str(i) '.txt'],...
        record_threshold_data_w{i});
end

% create HTML snippet with results
disp('Creating html snippet for per-walker data file links')
idstring = strsplit(save_file, '/');
id = idstring(end);

html = '\n';
for i=1:Nwalkers
    html = [html, ...
        '                  <br><a href="output/', id{1}, '-eps_int-w', ...
        num2str(i), '.txt"\n', ...
        '                     target="_blank">Walker ', num2str(i), ...
        ' &epsilon;<sub>int</sub> ',...
        'data</a>\n'];
    html = [html, ...
        '                  <a href="output/', id{1}, '-eps_gla-w', ...
        num2str(i), '.txt"\n', ...
        '                     target="_blank">Walker ', num2str(i), ...
        ' &epsilon;<sub>gla</sub> ',...
        'data</a>\n'];
    html = [html, ...
        '                  <a href="output/', id{1}, '-t_degla-w', ...
        num2str(i), '.txt"\n', ...
        '                     target="_blank">Walker ', num2str(i), ...
        ' <i>t</i><sub>degla</sub> ',...
        'data</a>\n'];
    html = [html, ...
        '                  <a href="output/', id{1}, '-eps_int-w', ...
        num2str(i), '.txt"\n', ...
        '                     target="_blank">Walker ', num2str(i), ...
        ' &delta;<sup>18</sup>O', ...
        '<sub>threshold</sub> data</a>\n'];
end
fileID = fopen([save_file, '-walker-data.html'],'w');
fprintf(fileID, html);
fclose(fileID);
