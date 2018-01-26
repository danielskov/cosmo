function plotter2(Ss,fs,samplename)
ero_int=[];
ero_gla=[];
tdegla=[];
d18O_thres=[];
total_ero=[];
nsamples=length(Ss{1}.ms(1,:));

for ii=1:fs.Nwalkers
    ero_int=[ero_int Ss{ii}.ms(1,:)];
    ero_gla=[ero_gla Ss{ii}.ms(2,:)];
    tdegla=[tdegla Ss{ii}.ms(3,:)];
    d18O_thres=[d18O_thres Ss{ii}.ms(4,:)];
end

timelength=100;
for i=1:length(d18O_thres)
    I=[];
    I=find(fs.d18O_triang(1:timelength)>d18O_thres(i));
    time_gla(i)=length(I)/timelength;
end
time_gla;
total_ero=ero_int.*(1-time_gla)+ero_gla.*time_gla;

%figure(101)
%close
%figure(101)
title(samplename,'fontsize',30)
Nbin=50;

%%
%Crossplots
subplot(5,5,1)
dfacxbin=(Ss{1,1}.fs.ErateIntminmax(2)/Ss{1,1}.fs.ErateIntminmax(1))^(1/(Nbin));
xbins=logspace(log10(Ss{1,1}.fs.ErateIntminmax(1)/dfacxbin),log10(Ss{1,1}.fs.ErateIntminmax(2)*dfacxbin^2),Nbin+4);
dfacybin=(Ss{1,1}.fs.ErateGlaminmax(2)/Ss{1,1}.fs.ErateGlaminmax(1))^(1/(Nbin));
ybins=logspace(log10(Ss{1,1}.fs.ErateGlaminmax(1)/dfacxbin),log10(Ss{1,1}.fs.ErateGlaminmax(2)*dfacxbin^2),Nbin+4);
W = ones(2); W = conv2(W,W); W = W/sum(W(:));
xi = ero_int;yi = ero_gla;
[smoothgrid,histgrid] = smoothdens(xi,yi,xbins,ybins,W);
pcolor(xbins,ybins,smoothgrid);
grid on; shading flat; axis tight;
set(gca,'xscale','log','yscale','log','xlim',[Ss{1,1}.fs.ErateIntminmax(1) Ss{1,1}.fs.ErateIntminmax(2)],'xtick',[1e-7 1e-6 1e-5 1e-4 1e-3],'ylim',[Ss{1,1}.fs.ErateGlaminmax(1) Ss{1,1}.fs.ErateGlaminmax(2)],'ytick',[1e-7 1e-6 1e-5 1e-4 1e-3],'fontsize',20)
xlabel('\epsilon_{int} [m/yr]','fontsize',20)
ylabel('\epsilon_{gla} [m/yr]','fontsize',20)
title(fs.Sample_name)

subplot(5,5,6)
dfacxbin=(Ss{1,1}.fs.ErateIntminmax(2)/Ss{1,1}.fs.ErateIntminmax(1))^(1/(Nbin));
xbins=logspace(log10(Ss{1,1}.fs.ErateIntminmax(1)/dfacxbin),log10(Ss{1,1}.fs.ErateIntminmax(2)*dfacxbin^2),Nbin+4);
dfacybin=((Ss{1,1}.fs.ErateGlaminmax(2))/Ss{1,1}.fs.ErateGlaminmax(1))^(1/(Nbin));
ybins=logspace(log10(Ss{1,1}.fs.ErateGlaminmax(1)/dfacxbin),log10(Ss{1,1}.fs.ErateGlaminmax(2)*dfacxbin^2),Nbin+4);
W = ones(2); W = conv2(W,W); W = W/sum(W(:));
xi = ero_int;yi = total_ero;
[smoothgrid,histgrid] = smoothdens(xi,yi,xbins,ybins,W);
pcolor(xbins,ybins,smoothgrid);
grid on; shading flat; axis tight;
set(gca,'xscale','log','yscale','log','xlim',[Ss{1,1}.fs.ErateIntminmax(1) Ss{1,1}.fs.ErateIntminmax(2)],'xtick',[1e-7 1e-6 1e-5 1e-4 1e-3],'ylim',[Ss{1,1}.fs.ErateGlaminmax(1) 2*Ss{1,1}.fs.ErateGlaminmax(2)],'ytick',[1e-7 1e-6 1e-5 1e-4 1e-3],'fontsize',20)
ylabel('\epsilon_{100ka} [m/yr]','fontsize',20)
xlabel('\epsilon_{int} [m/yr]','fontsize',20)


subplot(5,5,7)
dfacxbin=(Ss{1,1}.fs.ErateGlaminmax(2)/Ss{1,1}.fs.ErateGlaminmax(1))^(1/(Nbin));
xbins=logspace(log10(Ss{1,1}.fs.ErateGlaminmax(1)/dfacxbin),log10(Ss{1,1}.fs.ErateGlaminmax(2)*dfacxbin^2),Nbin+4);
dfacybin=((Ss{1,1}.fs.ErateGlaminmax(2))/Ss{1,1}.fs.ErateGlaminmax(1))^(1/(Nbin));
ybins=logspace(log10(Ss{1,1}.fs.ErateGlaminmax(1)/dfacxbin),log10(Ss{1,1}.fs.ErateGlaminmax(2)*dfacxbin^2),Nbin+4);
W = ones(2); W = conv2(W,W); W = W/sum(W(:));
xi = ero_gla;yi = total_ero;
[smoothgrid,histgrid] = smoothdens(xi,yi,xbins,ybins,W);
pcolor(xbins,ybins,smoothgrid);
grid on; shading flat; axis tight;
set(gca,'xscale','log','yscale','log','xlim',[Ss{1,1}.fs.ErateIntminmax(1) Ss{1,1}.fs.ErateIntminmax(2)],'xtick',[1e-7 1e-6 1e-5 1e-4 1e-3],'ylim',[Ss{1,1}.fs.ErateGlaminmax(1) Ss{1,1}.fs.ErateGlaminmax(2)],'ytick',[1e-7 1e-6 1e-5 1e-4 1e-3],'fontsize',20)
ylabel('\epsilon_{100ka} [m/yr]','fontsize',20)
xlabel('\epsilon_{gla} [m/yr]','fontsize',20)

subplot(5,5,11)
dfacxbin=(Ss{1,1}.fs.ErateIntminmax(2)/Ss{1,1}.fs.ErateIntminmax(1))^(1/(Nbin));
xbins=logspace(log10(Ss{1,1}.fs.ErateIntminmax(1)/dfacxbin),log10(Ss{1,1}.fs.ErateIntminmax(2)*dfacxbin^2),Nbin+4);
dybin = diff(Ss{1,1}.fs.tDeglaminmax)/Nbin; %we want outside bins to check that we do not sample outside
ybins = linspace(Ss{1,1}.fs.tDeglaminmax(1)-dybin,Ss{1,1}.fs.tDeglaminmax(2)+2*dybin,Nbin+4);
W = ones(2); W = conv2(W,W); W = W/sum(W(:));
xi = ero_int;yi = tdegla;
[smoothgrid,histgrid] = smoothdens(xi,yi,xbins,ybins,W);
pcolor(xbins,ybins,smoothgrid);
grid on; shading flat; axis tight;
set(gca,'xscale','log','xlim',[Ss{1,1}.fs.ErateIntminmax(1) Ss{1,1}.fs.ErateIntminmax(2)],'xtick',[1e-7 1e-6 1e-5 1e-4 1e-3],'ylim',[Ss{1,1}.fs.tDeglaminmax(1) Ss{1,1}.fs.tDeglaminmax(2)],'ytick',[3000 7000 11000 15000 19000],'fontsize',20)
ylabel('t_{degla} [yr]','fontsize',20)
xlabel('\epsilon_{int} [m/yr]','fontsize',20)


subplot(5,5,12)
dfacxbin=(Ss{1,1}.fs.ErateGlaminmax(2)/Ss{1,1}.fs.ErateGlaminmax(1))^(1/(Nbin));
xbins=logspace(log10(Ss{1,1}.fs.ErateGlaminmax(1)/dfacxbin),log10(Ss{1,1}.fs.ErateGlaminmax(2)*dfacxbin^2),Nbin+4);
dybin = diff(Ss{1,1}.fs.tDeglaminmax)/Nbin; %we want outside bins to check that we do not sample outside
ybins = linspace(Ss{1,1}.fs.tDeglaminmax(1)-dybin,Ss{1,1}.fs.tDeglaminmax(2)+2*dybin,Nbin+4);
W = ones(2); W = conv2(W,W); W = W/sum(W(:));
xi = ero_gla;yi = tdegla;
[smoothgrid,histgrid] = smoothdens(xi,yi,xbins,ybins,W);
pcolor(xbins,ybins,smoothgrid);
grid on; shading flat; axis tight;

set(gca,'xscale','log','xlim',[Ss{1,1}.fs.ErateGlaminmax(1) Ss{1,1}.fs.ErateGlaminmax(2)],'xtick',[1e-7 1e-6 1e-5 1e-4 1e-3],'ylim',[Ss{1,1}.fs.tDeglaminmax(1) Ss{1,1}.fs.tDeglaminmax(2)],'ytick',[3000 7000 11000 15000 19000],'fontsize',20)
ylabel('t_{degla} [yr]','fontsize',20)
xlabel('\epsilon_{gla} [m/yr]','fontsize',20)

subplot(5,5,13)
dfacxbin=(Ss{1,1}.fs.ErateGlaminmax(2)/Ss{1,1}.fs.ErateGlaminmax(1))^(1/(Nbin));
xbins=logspace(log10(Ss{1,1}.fs.ErateGlaminmax(1)/dfacxbin),log10(Ss{1,1}.fs.ErateGlaminmax(2)*dfacxbin^2),Nbin+4);
dybin = diff(Ss{1,1}.fs.tDeglaminmax)/Nbin; %we want outside bins to check that we do not sample outside
ybins = linspace(Ss{1,1}.fs.tDeglaminmax(1)-dybin,Ss{1,1}.fs.tDeglaminmax(2)+2*dybin,Nbin+4);
W = ones(2); W = conv2(W,W); W = W/sum(W(:));
xi = total_ero;yi = tdegla;
[smoothgrid,histgrid] = smoothdens(xi,yi,xbins,ybins,W);
pcolor(xbins,ybins,smoothgrid);
grid on; shading flat; axis tight;
set(gca,'xscale','log','xlim',[Ss{1,1}.fs.ErateIntminmax(1) Ss{1,1}.fs.ErateIntminmax(2)],'xtick',[1e-7 1e-6 1e-5 1e-4 1e-3],'ylim',[Ss{1,1}.fs.tDeglaminmax(1) Ss{1,1}.fs.tDeglaminmax(2)],'ytick',[3000 7000 11000 15000 19000],'fontsize',20)
ylabel('t_{degla} [yr]','fontsize',20)
xlabel('\epsilon_{100ka} [m/yr]','fontsize',20)

subplot(5,5,16)
dfacxbin=(Ss{1,1}.fs.ErateIntminmax(2)/Ss{1,1}.fs.ErateIntminmax(1))^(1/(Nbin));
xbins=logspace(log10(Ss{1,1}.fs.ErateIntminmax(1)/dfacxbin),log10(Ss{1,1}.fs.ErateIntminmax(2)*dfacxbin^2),Nbin+4);
dybin = diff(Ss{1,1}.fs.d18Othminmax)/Nbin; %we want outside bins to check that we do not sample outside
ybins = linspace(Ss{1,1}.fs.d18Othminmax(1)-dybin,Ss{1,1}.fs.d18Othminmax(2)+2*dybin,Nbin+4);
W = ones(2); W = conv2(W,W); W = W/sum(W(:));
xi = ero_int;yi = d18O_thres;
[smoothgrid,histgrid] = smoothdens(xi,yi,xbins,ybins,W);
pcolor(xbins,ybins,smoothgrid);
grid on; shading flat; axis tight;
set(gca,'xscale','log','xlim',[Ss{1,1}.fs.ErateIntminmax(1) Ss{1,1}.fs.ErateIntminmax(2)],'xtick',[1e-7 1e-6 1e-5 1e-4 1e-3],'ylim',[Ss{1,1}.fs.d18Othminmax(1) Ss{1,1}.fs.d18Othminmax(2)],'ytick',[3 3.5 4 4.5 5],'fontsize',20)
ylabel(['\delta^{18}O_{thres} [',char(8240),']'],'fontsize',20)
xlabel('\epsilon_{int} [m/yr]','fontsize',20)

subplot(5,5,17)
dfacxbin=(Ss{1,1}.fs.ErateGlaminmax(2)/Ss{1,1}.fs.ErateGlaminmax(1))^(1/(Nbin));
xbins=logspace(log10(Ss{1,1}.fs.ErateGlaminmax(1)/dfacxbin),log10(Ss{1,1}.fs.ErateGlaminmax(2)*dfacxbin^2),Nbin+4);
dybin = diff(Ss{1,1}.fs.d18Othminmax)/Nbin; %we want outside bins to check that we do not sample outside
ybins = linspace(Ss{1,1}.fs.d18Othminmax(1)-dybin,Ss{1,1}.fs.d18Othminmax(2)+2*dybin,Nbin+4);
W = ones(2); W = conv2(W,W); W = W/sum(W(:));
xi = ero_gla;yi = d18O_thres;
[smoothgrid,histgrid] = smoothdens(xi,yi,xbins,ybins,W);
pcolor(xbins,ybins,smoothgrid);
grid on; shading flat; axis tight;
set(gca,'xscale','log','xlim',[Ss{1,1}.fs.ErateIntminmax(1) Ss{1,1}.fs.ErateIntminmax(2)],'xtick',[1e-7 1e-6 1e-5 1e-4 1e-3],'ylim',[Ss{1,1}.fs.d18Othminmax(1) Ss{1,1}.fs.d18Othminmax(2)],'ytick',[3 3.5 4 4.5 5],'fontsize',20)
ylabel(['\delta^{18}O_{thres} [',char(8240),']'],'fontsize',20)
xlabel('\epsilon_{gla} [m/yr]','fontsize',20)

subplot(5,5,18)
dfacxbin=(Ss{1,1}.fs.ErateGlaminmax(2)/Ss{1,1}.fs.ErateGlaminmax(1))^(1/(Nbin));
xbins=logspace(log10(Ss{1,1}.fs.ErateGlaminmax(1)/dfacxbin),log10(Ss{1,1}.fs.ErateGlaminmax(2)*dfacxbin^2),Nbin+4);
dybin = diff(Ss{1,1}.fs.d18Othminmax)/Nbin; %we want outside bins to check that we do not sample outside
ybins = linspace(Ss{1,1}.fs.d18Othminmax(1)-dybin,Ss{1,1}.fs.d18Othminmax(2)+2*dybin,Nbin+4);
W = ones(2); W = conv2(W,W); W = W/sum(W(:));
xi = total_ero;yi = d18O_thres;
[smoothgrid,histgrid] = smoothdens(xi,yi,xbins,ybins,W);
pcolor(xbins,ybins,smoothgrid);
grid on; shading flat; axis tight;

set(gca,'xscale','log','xlim',[Ss{1,1}.fs.ErateIntminmax(1) Ss{1,1}.fs.ErateIntminmax(2)],'xtick',[1e-7 1e-6 1e-5 1e-4 1e-3],'ylim',[Ss{1,1}.fs.d18Othminmax(1) Ss{1,1}.fs.d18Othminmax(2)],'ytick',[3 3.5 4 4.5 5],'fontsize',20)
ylabel(['\delta^{18}O_{thres} [',char(8240),']'],'fontsize',20)
xlabel('\epsilon_{100ka} [m/yr]','fontsize',20)

subplot(5,5,19)
dxbin = diff(Ss{1,1}.fs.tDeglaminmax)/Nbin; %we want outside bins to check that we do not sample outside
xbins = linspace(Ss{1,1}.fs.tDeglaminmax(1)-dxbin,Ss{1,1}.fs.tDeglaminmax(2)+2*dxbin,Nbin+4);
dybin = diff(Ss{1,1}.fs.d18Othminmax)/Nbin; %we want outside bins to check that we do not sample outside
ybins = linspace(Ss{1,1}.fs.d18Othminmax(1)-dybin,Ss{1,1}.fs.d18Othminmax(2)+2*dybin,Nbin+4);
W = ones(2); W = conv2(W,W); W = W/sum(W(:));
xi = tdegla;yi = d18O_thres;
[smoothgrid,histgrid] = smoothdens(xi,yi,xbins,ybins,W);
pcolor(xbins,ybins,smoothgrid);
grid on; shading flat; axis tight;
set(gca,'xlim',[Ss{1,1}.fs.tDeglaminmax(1) Ss{1,1}.fs.tDeglaminmax(2)],'xtick',[3000 7000 11000 15000 19000],'ylim',[Ss{1,1}.fs.d18Othminmax(1) Ss{1,1}.fs.d18Othminmax(2)],'ytick',[3 3.5 4 4.5 5],'fontsize',20)
ylabel(['\delta^{18}O_{thres} [',char(8240),']'],'fontsize',20)
xlabel('t_{degla} [yr]','fontsize',20)

%%
%Historgrams
subplot(5,5,21)
dfacxbin=(Ss{1,1}.fs.ErateIntminmax(2)/Ss{1,1}.fs.ErateIntminmax(1))^(1/(Nbin));
xbins=logspace(log10(Ss{1,1}.fs.ErateIntminmax(1)/dfacxbin),log10(Ss{1,1}.fs.ErateIntminmax(2)*dfacxbin^2),Nbin+4);
Nhistc=histc(ero_int,xbins);
bar(xbins,Nhistc./(nsamples*fs.Nwalkers),'histc')
set(gca,'xscale','log','xlim',[Ss{1,1}.fs.ErateIntminmax(1) Ss{1,1}.fs.ErateIntminmax(2)],'xtick',[1e-7 1e-6 1e-5 1e-4 1e-3],'fontsize',20)
xlabel('\epsilon_{int} [m/yr]','fontsize',20);
ylabel('Frequency','fontsize',20)

subplot(5,5,2)
dfacxbin=(Ss{1,1}.fs.ErateGlaminmax(2)/Ss{1,1}.fs.ErateGlaminmax(1))^(1/(Nbin));
xbins=logspace(log10(Ss{1,1}.fs.ErateGlaminmax(1)/dfacxbin),log10(Ss{1,1}.fs.ErateGlaminmax(2)*dfacxbin^2),Nbin+4);
Nhistc=histc(ero_gla,xbins);
barh(xbins,Nhistc./(nsamples*fs.Nwalkers),'histc')
set(gca,'yscale','log','ylim',[Ss{1,1}.fs.ErateGlaminmax(1) Ss{1,1}.fs.ErateGlaminmax(2)],'ytick',[1e-7 1e-6 1e-5 1e-4 1e-3],'fontsize',20)
ylabel('\epsilon_{gla} [m/yr]','fontsize',20);
xlabel('Frequency','fontsize',20)

subplot(5,5,22)
dfacxbin=(Ss{1,1}.fs.ErateGlaminmax(2)/Ss{1,1}.fs.ErateGlaminmax(1))^(1/(Nbin));
xbins=logspace(log10(Ss{1,1}.fs.ErateGlaminmax(1)/dfacxbin),log10(Ss{1,1}.fs.ErateGlaminmax(2)*dfacxbin^2),Nbin+4);
Nhistc=histc(ero_gla,xbins);
bar(xbins,Nhistc./(nsamples*fs.Nwalkers),'histc')
set(gca,'xscale','log','xlim',[Ss{1,1}.fs.ErateGlaminmax(1) Ss{1,1}.fs.ErateGlaminmax(2)],'xtick',[1e-7 1e-6 1e-5 1e-4 1e-3],'fontsize',20)
xlabel('\epsilon_{gla} [m/yr]','fontsize',20);

subplot(5,5,8)
lower=Ss{1,1}.fs.ErateGlaminmax(1);
upper=Ss{1,1}.fs.ErateGlaminmax(2)+Ss{1,1}.fs.ErateIntminmax(2);
dfacxbin=(upper/lower)^(1/(Nbin));
xbins=logspace(log10(lower/dfacxbin),log10(upper*dfacxbin^2),Nbin+4);
Nhistc=histc(total_ero,xbins);
barh(xbins,Nhistc./(nsamples*fs.Nwalkers),'histc')
set(gca,'yscale','log','ylim',[lower upper],'ytick',[1e-7 1e-6 1e-5 1e-4 1e-3],'fontsize',20)
ylabel('\epsilon_{100ka} [m/yr]','fontsize',20);
xlabel('Frequency','fontsize',20)

subplot(5,5,23)
lower=Ss{1,1}.fs.ErateGlaminmax(1);
upper=Ss{1,1}.fs.ErateGlaminmax(2)+Ss{1,1}.fs.ErateIntminmax(2);
dfacxbin=(upper/lower)^(1/(Nbin));
xbins=logspace(log10(lower/dfacxbin),log10(upper*dfacxbin^2),Nbin+4);
Nhistc=histc(total_ero,xbins);
bar(xbins,Nhistc./(nsamples*fs.Nwalkers),'histc')
set(gca,'xscale','log','xlim',[lower upper],'xtick',[1e-7 1e-6 1e-5 1e-4 1e-3],'fontsize',20)
xlabel('\epsilon_{100ka} [m/yr]','fontsize',20);

subplot(5,5,14)
dxbin = diff(Ss{1,1}.fs.tDeglaminmax)/Nbin; %we want outside bins to check that we do not sample outside
xbins = linspace(Ss{1,1}.fs.tDeglaminmax(1)-dxbin,Ss{1,1}.fs.tDeglaminmax(2)+2*dxbin,Nbin+4);
Nhistc=histc(tdegla,xbins);
barh(xbins,Nhistc./(nsamples*fs.Nwalkers),'histc')
set(gca,'ylim',[Ss{1,1}.fs.tDeglaminmax(1) Ss{1,1}.fs.tDeglaminmax(2)],'ytick',[3000 7000 11000 15000 19000],'fontsize',20)
ylabel('t_{degla} [yr]','fontsize',20);
xlabel('Frequency','fontsize',20)

subplot(5,5,24)
dxbin = diff(Ss{1,1}.fs.tDeglaminmax)/Nbin; %we want outside bins to check that we do not sample outside
xbins = linspace(Ss{1,1}.fs.tDeglaminmax(1)-dxbin,Ss{1,1}.fs.tDeglaminmax(2)+2*dxbin,Nbin+4);
Nhistc=histc(tdegla,xbins);
bar(xbins,Nhistc./(nsamples*fs.Nwalkers),'histc')
set(gca,'xlim',[Ss{1,1}.fs.tDeglaminmax(1) Ss{1,1}.fs.tDeglaminmax(2)],'xtick',[3000 7000 11000 15000 19000],'fontsize',20)
xlabel('t_{degla} [yr]','fontsize',20);

subplot(5,5,20)
dxbin = diff(Ss{1,1}.fs.d18Othminmax)/Nbin; %we want outside bins to check that we do not sample outside
xbins = linspace(Ss{1,1}.fs.d18Othminmax(1)-dxbin,Ss{1,1}.fs.d18Othminmax(2)+2*dxbin,Nbin+4);
Nhistc=histc(d18O_thres,xbins);
barh(xbins,Nhistc./(nsamples*fs.Nwalkers),'histc')
set(gca,'ylim',[Ss{1,1}.fs.d18Othminmax(1) Ss{1,1}.fs.d18Othminmax(2)],'ytick',[3 3.5 4 4.5 5],'fontsize',20)
ylabel(['\delta^{18}O_{thres} [',char(8240),']'],'fontsize',20)
xlabel('Frequency','fontsize',20)