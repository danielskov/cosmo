function a=plotter(Ss,rows,rowNo,fs,elevation,accep_ratio)
ero_int=[];
ero_gla=[];
tdegla=[];
d18O_thres=[];
total_ero=[];
Qs=[];
nsamples=length(Ss{1}.ms(1,:));

for ii=1:fs.Nwalkers
    ero_int=[ero_int Ss{ii}.ms(1,:)];
    ero_gla=[ero_gla Ss{ii}.ms(2,:)];
    tdegla=[tdegla Ss{ii}.ms(3,:)];
    d18O_thres=[d18O_thres Ss{ii}.ms(4,:)];
    Qs=[Qs Ss{ii}.Qs(:)];
end

timelength=100;
for i=1:length(d18O_thres)
    I=[];
    I=find(fs.d18O_triang(1:timelength)>d18O_thres(i)); %If the d18O value is above the threshold, the site is covered by ice
    time_gla(i)=length(I)/timelength; %Finding the fraction of time that the site was covered by ice
end
total_ero=ero_int.*(1-time_gla)+ero_gla.*time_gla; %Calculating the average erosion rate over the past 100kyr

a=[];
a(1)=10^(mean(log10(ero_int)));
a(2)=quantile(ero_int,0.05);
a(3)=quantile(ero_int,0.95);
a(4)=10^(mean(log10(ero_gla)));
a(5)=quantile(ero_gla,0.05);
a(6)=quantile(ero_gla,0.95);
a(7)=10^(mean(log10(total_ero)));
a(8)=quantile(total_ero,0.05);
a(9)=quantile(total_ero,0.95);
a(10)=mean(tdegla);
a(11)=quantile(tdegla,0.05);
a(12)=quantile(tdegla,0.95);
a(13)=mean(d18O_thres);
a(14)=quantile(d18O_thres,0.05);
a(15)=quantile(d18O_thres,0.95);


figure(101212)
Nbin=50; %Making a histogram with 50 bars
subplot(rows,5,(rowNo-1)*5+1)
dfacxbin=(Ss{1,1}.fs.ErateIntminmax(2)/Ss{1,1}.fs.ErateIntminmax(1))^(1/(Nbin)); %The width of the bars is calculated, here in logspace to accomodate lognormal parameters
xbins=logspace(log10(Ss{1,1}.fs.ErateIntminmax(1)/dfacxbin),log10(Ss{1,1}.fs.ErateIntminmax(2)*dfacxbin^2),Nbin+4); %The width of the bars is calculated, here in logspace to accomodate lognormal parameters
Nhistc=histc(ero_int,xbins); 
bar(xbins,Nhistc./(nsamples*fs.Nwalkers),'histc')
set(gca,'xscale','log','xlim',[Ss{1,1}.fs.ErateIntminmax(1) Ss{1,1}.fs.ErateIntminmax(2)],'xtick',[1e-7 1e-6 1e-5 1e-4 1e-3],'fontsize',20)
if(rowNo==rows)
    xlabel('\epsilon_{int} [m/yr]','fontsize',20);
end
ylabel('Frequency','fontsize',20)

subplot(rows,5,(rowNo-1)*5+2)
dfacxbin=(Ss{1,1}.fs.ErateGlaminmax(2)/Ss{1,1}.fs.ErateGlaminmax(1))^(1/(Nbin));
xbins=logspace(log10(Ss{1,1}.fs.ErateGlaminmax(1)/dfacxbin),log10(Ss{1,1}.fs.ErateGlaminmax(2)*dfacxbin^2),Nbin+4);
Nhistc=histc(ero_gla,xbins);
bar(xbins,Nhistc./(nsamples*fs.Nwalkers),'histc')
set(gca,'xscale','log','xlim',[Ss{1,1}.fs.ErateGlaminmax(1) Ss{1,1}.fs.ErateGlaminmax(2)],'xtick',[1e-7 1e-6 1e-5 1e-4 1e-3],'fontsize',20)
if(rowNo==rows)
    xlabel('\epsilon_{gla} [m/yr]','fontsize',20);
end

subplot(rows,5,(rowNo-1)*5+3)
lower=Ss{1,1}.fs.ErateGlaminmax(1);
upper=Ss{1,1}.fs.ErateGlaminmax(2)+Ss{1,1}.fs.ErateGlaminmax(2);
dfacxbin=(upper/lower)^(1/(Nbin));
xbins=logspace(log10(lower/dfacxbin),log10(upper*dfacxbin^2),Nbin+4);
Nhistc=histc(total_ero,xbins);
bar(xbins,Nhistc./(nsamples*fs.Nwalkers),'histc')
set(gca,'xscale','log','xlim',[lower upper],'xtick',[1e-7 1e-6 1e-5 1e-4 1e-3],'fontsize',20)
if(rowNo==rows)
    xlabel('\epsilon_{100ka} [m/yr]','fontsize',20);
end
title([fs.Sample_name,', elevation= ',num2str(elevation),'m',', acc rat= ',num2str(accep_ratio)],'fontsize',20)

subplot(rows,5,(rowNo-1)*5+4)
dxbin = diff(Ss{1,1}.fs.tDeglaminmax)/Nbin; %we want outside bins to check that we do not sample outside
xbins = linspace(Ss{1,1}.fs.tDeglaminmax(1)-dxbin,Ss{1,1}.fs.tDeglaminmax(2)+2*dxbin,Nbin+4); %one extra to make pcolor work
Nhistc=histc(tdegla,xbins);
bar(xbins,Nhistc./(nsamples*fs.Nwalkers),'histc')
xlim([min(tdegla) max(tdegla)])
set(gca,'xlim',[Ss{1,1}.fs.tDeglaminmax(1) Ss{1,1}.fs.tDeglaminmax(2)],'xtick',[3000 7000 11000 15000 19000],'fontsize',20)
if(rowNo==rows)
    xlabel('t_{degla} [yr]','fontsize',20);
end

subplot(rows,5,(rowNo-1)*5+5)
dxbin = diff(Ss{1,1}.fs.d18Othminmax)/Nbin; %we want outside bins to check that we do not sample outside
xbins = linspace(Ss{1,1}.fs.d18Othminmax(1)-dxbin,Ss{1,1}.fs.d18Othminmax(2)+2*dxbin,Nbin+4); %one extra to make pcolor work
Nhistc=histc(d18O_thres,xbins);
bar(xbins,Nhistc./(nsamples*fs.Nwalkers),'histc')
xlim([min(d18O_thres) max(d18O_thres)])
set(gca,'xscale','log','xlim',[Ss{1,1}.fs.d18Othminmax(1) Ss{1,1}.fs.d18Othminmax(2)],'xtick',[3 3.5 4 4.5 5],'fontsize',20)
if(rowNo==rows)
    xlabel(['\delta18O_{thres} [',char(8240),']'],'fontsize',20);
end