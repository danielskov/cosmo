%InspectDepthConcTracks.m      
addpath('..\m_pakke2014maj11')
clear; close all
[fn,pn]=uigetfile('*.mat')
load([pn,fn])
DoConfLevelTrim = 0;

figure
Nwalks = length(Ss);
for iwalk = 1:Nwalks
% iwalk=input(['What iwalk?[1..',num2str(length(Ss)),']']),
%subplot(2,2,iwalk)
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
dtfine = -1000; tfinemax = -20e5; 
    %Bo og Mads 12 dec 2014: Udv?lge de 84 % bedst fittende, f.eks.
if DoConfLevelTrim==1
    ConfLevel = 0.84;
    [Qdssort,I]=sort(Ss{1}.Qds);
    Iwithinconflevel = I(1:ConfLevel*length(lump_MetHas.tss));
    lump_MetHas.Iwithinconflevel=Iwithinconflevel;
    tss = lump_MetHas.tss{Iwithinconflevel};

    Xxsss=lump_MetHas.zsss{Iwithinconflevel};
    
else
Xxsss = lump_MetHas.zsss;
    tss = lump_MetHas.tss;
end
dXxfine = 0.1; Xxfinemax = 50; iz=1; %Xx may be depth or nucleide concentration or ...
dzfine = dXxfine; zfinemax = Xxfinemax; 
[smoothgrid,histgrid,tsfine,Xxfine]=XxTimeDens(Xxsss,tss,dtfine,tfinemax,dXxfine,Xxfinemax,fixed_stuff,iz);
pcolor(tsfine,Xxfine,sqrt(smoothgrid));
hold on


%plot a selection of depth histories
%for i=1:ceil(length(tss)/50):length(tss)
%  plot(tss{i},Xxsss{i},'.-w')
%end
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

colormap(1-copper)


N=25;

X=-1+2*(tsfine-tsfine(1))/(tsfine(end)-tsfine(1));

Data_25 = quants(1,:,1);
Data_50 = quants(2,:,1);
Data_75 = quants(3,:,1);
P_25 = polyfit(X,Data_25,N);
P_50 = polyfit(X,Data_50,N);
P_75 = polyfit(X,Data_75,N);

Data_trend_25 = polyval(P_25,X);
Data_trend_50 = polyval(P_50,X);
Data_trend_75 = polyval(P_75,X);
track_handle=AddTrueModelDepthTrack(Ss{iwalk}.fs,'-m'); %<<< BHJ: added 2014 dec 0
axis([-2e6 0 0 15]);
end

grid on; shading flat; axis tight; set(gca,'fontsize',8); hold on
lh(1)=plot(tsfine,quants(1,:,iwalk),'r','linewidth',2);
lh(2)=plot(tsfine,quants(2,:,iwalk),'k','linewidth',2);
lh(3)=plot(tsfine,quants(3,:,iwalk),'r','linewidth',2);
legend(lh,'25%','median','75%','location','southeast');
%axis([-0.3e6 0 0 5])
axis([-2e6 0 0 50])
axis ij

%lh(1) = plot(tsfine,Data_trend_25,'r','linewidth',3); hold on
%lh(2) = plot(tsfine,Data_trend_50,'k','linewidth',3);
%lh(3) = plot(tsfine,Data_trend_75,'g','linewidth',3);
%legend(lh,'25%','median','75%','location','northwest')
%subplot(2,2,1); 
title(fn,'interpreter','none')


break



menu_choice = menu('What more?','exit','CompareWalks2 and exit','CompareWalks2 and nucleide tracks');
if menu_choice <2
  return
end

figure

for iwalk = 1:Nwalks
plot(tsfine,quants(1,:,iwalk),'r','linewidth',3); hold on
plot(tsfine,quants(2,:,iwalk),'k','linewidth',3)
plot(tsfine,quants(3,:,iwalk),'g','linewidth',3)
end
axis ij

break

CompareWalks2(Ss,[pn,fn])

if menu_choice < 3
  return
end

load handel; sound(y(1:5000))
iwalk=input(['What iwalk?[1..',num2str(length(Ss)),']']),
lump_MetHas = Ss{iwalk}.lump_MetHas;
fixed_stuff = Ss{iwalk}.fs;
% if ~isempty(lump_MetHas.zsss{1})
figure
zsss = lump_MetHas.zsss;
tss = lump_MetHas.tss;
dtfine = -1000; tfinemax = -20e5; dzfine = 0.1; zfinemax = 20,
iz = 1;
DepthExposureTimeDens(zsss,tss,dtfine,tfinemax,dzfine,zfinemax,fixed_stuff,iz)
title('z(time)')
axis ij
hold on

%making quantiles to plot ontop of exhumation densities:
Xxsss = lump_MetHas.zsss;
dXxfine = 0.1; Xxfinemax = 30; 
[smoothgrid,histgrid,tsfine,Xxfine]=XxTimeDens(Xxsss,tss,dtfine,tfinemax,dXxfine,Xxfinemax,fixed_stuff,iz);
%plot a selection of depth histories
for i=1:ceil(length(tss)/50):length(tss)
  plot(tss{i},zsss{i},'.-w')
end

%Compute and plot quantiles
N = sum(histgrid(:,1));
fractions = [0.25,0.5,0.75]; %quartiles
tsfine = 0:dtfine:tfinemax; %bin boundaries
Ntfine = length(tsfine);
zsfine = 0:dzfine:zfinemax; %bin boundaries
quants = GetHistgridQuantiles(histgrid,N,fractions,tsfine,zsfine);
plot(tsfine,quants(1,:),'r','linewidth',3)
plot(tsfine,quants(2,:),'k','linewidth',3)
plot(tsfine,quants(3,:),'g','linewidth',3)

figure
zsss = lump_MetHas.zsss;
tss = lump_MetHas.ExposureTimeSinceNows;
dtExposurefine = 1000; tExposurefinemax = 20e5; dzfine = 0.1; zfinemax = 20,
iz = 1;
DepthExposureTimeDens(zsss,tss,dtExposurefine,tExposurefinemax,dzfine,zfinemax,fixed_stuff,iz)
title('z(ExposureTime)')
%       end
axis ij
hold on
for i=1:ceil(length(tss)/50):length(tss)
  plot(tss{i},zsss{i},'.-w')
end

figure %five subplots:
tss = lump_MetHas.tss;
dtfine = -1000; tfinemax = -20e5; 
iz = 1;

axh(1)=subplot(5,1,1) %depth track
Xxsss = lump_MetHas.zsss;
dXxfine = 0.1; Xxfinemax = 10; 
[smoothgrid,histgrid,tsfine,Xxfine]=XxTimeDens(Xxsss,tss,dtfine,tfinemax,dXxfine,Xxfinemax,fixed_stuff,iz);
pcolor(tsfine,Xxfine,sqrt(smoothgrid));
% axis(sqrt(3)*[-1,1,-1,1])
% set(gca,'xtick',[-1.5:0.5:1.5],'ytick',[-1.5:0.5:1.5])
grid on; shading flat; axis tight; set(gca,'fontsize',8); hold on
lh(1)=plot(tsfine,quants(1,:),'r','linewidth',2)
lh(2)=plot(tsfine,quants(2,:),'k','linewidth',2)
lh(3)=plot(tsfine,quants(3,:),'g','linewidth',2)
legend(lh,'25%','median','75%','location','northwest')
axis ij




Xxsss{2}=lump_MetHas.c14Csss;
Xxsss{3}=lump_MetHas.c10Besss;
Xxsss{4}=lump_MetHas.c26Alsss;
Xxsss{5}=lump_MetHas.c21Nesss;

for ic=2:5
  axh(ic)=subplot(5,1,ic) %10Be track
dXxfine = 0.01*Xxsss{ic}{end}(1,end); Xxfinemax = 1.3*Xxsss{ic}{end}(1,end); 
[smoothgrid,histgrid,tsfine,Xxfine]=XxTimeDens(Xxsss{ic},tss,dtfine,tfinemax,dXxfine,Xxfinemax,fixed_stuff,iz);
pcolor(tsfine,Xxfine,sqrt(smoothgrid));
% axis(sqrt(3)*[-1,1,-1,1])
% set(gca,'xtick',[-1.5:0.5:1.5],'ytick',[-1.5:0.5:1.5])
grid on; shading flat; axis tight; set(gca,'fontsize',8,'tickdir','out');
hold on
end
for ic=1:4
  set(axh(ic),'xticklabel',[])
end
subplot(5,1,1); title(['Depth track:',fn],'interpreter','none'); set(gca,'layer','top')
subplot(5,1,2); title('^{14}C'); set(gca,'layer','top')
subplot(5,1,3); title('^{10}Be'); set(gca,'layer','top')
subplot(5,1,4); title('^{26}Al'); set(gca,'layer','top')
subplot(5,1,5); title('^{21}Ne'); set(gca,'layer','top')
linkaxes(axh,'x')
colormap(flipud(gray))



  