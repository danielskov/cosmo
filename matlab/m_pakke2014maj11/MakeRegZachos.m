%MakeRegZachos.m
% rand('seed',3);
% randn('seed',1);
clear; close all;

mincatch=5, %Adjust how many point you want at least in your means and medians
minrad = 1.6, %Adjust the minimum seach radius

% example = menu('Pick case',...
%     'Jump and impulse, regular',...
%     'Jump and impulse, irregular', ...
%     'Smooth in even irregular with outlier',...
%     'Smooth with gap',...
%     'Smooth with gap and noise and outlier',...
%     'd18O Paleocene Eocene Thermal Maximum')
% 
example = 7;
switch example
%     case 1
%     in = zeros(30,1); in(1:6)=1; in(22)=2;
%     ts = 1:length(in);
%     ti = ts(1):0.1:ts(end);
%     
%     case 2
%     in = zeros(30,1); in(1:6)=1; in(22)=2;
%     dt = 2*rand(size(in)); %distances between data points
%     ts = cumsum(dt);
%     ti = ts(1):0.1:ts(end);
%     
%     case 3
%     in = zeros(30,1); %to be modified
%     dt = 2*rand(size(in)); %distances between data points
%     ts = cumsum(dt);
%     in = exp(-(ts-mean(ts)).^2/(mean(ts)/2)^2);
%     in(23) = in(23) + 1;
%     ti = ts(1):0.1:ts(end);
%     
%     case 4
%     in = zeros(30,1); %to be modified
%     dt = 2*rand(size(in)); %distances between data points
%     dt(10) = 5;
%     ts = cumsum(dt);
%     in = exp(-(ts-mean(ts)).^2/(mean(ts)/2)^2);
%     ti = ts(1):0.1:ts(end);
%     
%     case 5
%     in = zeros(30,1); %to be modified
%     dt = 2*rand(size(in)); %distances between data points
%     dt(10) = 5;
%     ts = cumsum(dt);
%     in = exp(-(ts-mean(ts)).^2/(mean(ts)/2)^2) + 0.1*randn(size(in));
%     in(23) = in(23) + 1;
%     ti = ts(1):0.1:ts(end);
%     
    case 6
        load zachos
%         notNaN = find(~isnan(Age));
%         Age = Age(notNaN);
%         d18O = d18O(notNaN);
%         d13C= d13C(notNaN);
%         %then fix that some ages are equal
%         Age = Age + 0.01*rand(size(Age));
%         Age = sort(Age);
        in = d18O;
        ts = Age;
        ti = 54:0.05:56;
        minrad = 0.02;
    case 7
        load zachos
%         notNaN = find(~isnan(Age));
%         Age = Age(notNaN);
%         d18O = d18O(notNaN);
%         d13C= d13C(notNaN);
%         %then fix that some ages are equal
%         Age = Age + 0.01*rand(size(Age));
%         Age = sort(Age);
        in = d18O;
        ts = Age;
        ti = 0:0.001:2.6;
        minrad = 0.03;        
    case 8
        load zachos
        in = d18O;
        ts = Age;
        ti = 0:0.001:1.6;
        minrad = 0.001;        
end

% [outrunav,outmed,ti,radi] = InterpFiltIrreg(in,ts,ti,mincatch,minrad,'runav')
% [outtriang,outmed,ti,radi] = InterpFiltIrreg(in,ts,ti,mincatch,minrad,'triang')
[d18O_runav,d18O_med,ti,radi] = InterpFiltIrreg(d18O,ts,ti,mincatch,minrad,'triang');
[d13C_runav,d13C_med,ti,radi] = InterpFiltIrreg(d13C,ts,ti,mincatch,minrad,'triang');
[d18O_triang,d18O_med,ti,radi] = InterpFiltIrreg(d18O,ts,ti,mincatch,minrad,'triang');
[d13C_triang,d13C_med,ti,radi] = InterpFiltIrreg(d13C,ts,ti,mincatch,minrad,'triang');

% subplot(3,1,1)
% plot(ti,outcubic,'g')
% hold on
% plot(ti,outspline,'r')
% plot(ts,in,'b')
% plot(ts,in,'ok')
% legend('cubic','spline','linear')
% title(['mincatch=',num2str(mincatch),'. minrad=',num2str(minrad)])

subplot(2,1,1)
plot(ti,d18O_runav,'.-b')
hold on
plot(ti,d18O_med,'x-g')
plot(ti,d18O_triang,'x-r')
plot(ts,d18O,'ok')
plot(ts,d18O5pt,'*-c')
legend('Running average','Median filter','Triangle filter','Data')

subplot(2,1,2)
plot(ti,radi,'.-b')
legend('Actual radius used')

switch example 
  case 6
    for isub = 1:2
        subplot(2,1,isub)
        xlim([53.9,56.1])
    end
    save zachos_triinterp_55Ma ti d18O_triang d13C_triang d18O_runav d13C_runav 

  case 7
    for isub = 1:2
        subplot(2,1,isub)
        xlim([min(ti),max(ti)])
    end
    save zachos_triinterp_2p6Ma ti d18O_triang d13C_triang d18O_runav d13C_runav 
  case 8
    for isub = 1:2
        subplot(2,1,isub)
        xlim([min(ti),max(ti)])
    end
    save zachos_triinterp_1p6Ma ti d18O_triang d13C_triang d18O_runav d13C_runav 
end