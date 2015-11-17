%MakeRegZachos.m

clear; close all;

mincatch=5, %Adjust how many point you want at least in your means and medians
minrad = 1.6, %Adjust the minimum seach radius
% 
example = 10;
switch example
    case 6 %Interpolate near Paleocene-Eocene thermal maximum
        load zachos
        ts = Age;
        ti = 54:0.05:56;
        minrad = 0.02;
        fn = 'zachos_triinterp_55Ma_20ky';
        
    case 7 %All quaternary, smoothing +/- 30ky
        load zachos
        ts = Age;
        ti = 0:0.001:2.6;
        minrad = 0.03;
        fn = 'zachos_triinterp_2p6Ma_30ky';

    case 8 %latest 1.6 Ma, smoothing +/- 1ky
        load zachos
        ts = Age;
        ti = 0:0.001:2.6;
        minrad = 0.001;        
        fn = 'zachos_triinterp_2p6Ma_1ky';
        
    case 9 %all Quaternary, smoothing +/- 5ky
        load lisiecki
        ts = Age;
        ti = 0:0.001:2.6;
        minrad = 0.005; %Ma        
        fn = 'lisiecki_triinterp_2p6Ma_5ky';
        
    case 10 %all Quaternary, smoothing +/- 10ky
        load lisiecki
        ts = Age;
        ti = 0:0.001:2.6;
        minrad = 0.030; %Ma        
        fn = 'lisiecki_triinterp_2p6Ma_30ky';
        
    case 11 %all Quaternary, smoothing +/- 10ky
        load lisiecki
        ts = Age;
        ti = 0:0.001:2.6;
        minrad = 0.020; %Ma        
        fn = 'lisiecki_triinterp_2p6Ma_20ky';
end

% [outrunav,outmed,ti,radi] = InterpFiltIrreg(in,ts,ti,mincatch,minrad,'runav')
% [outtriang,outmed,ti,radi] = InterpFiltIrreg(in,ts,ti,mincatch,minrad,'triang')

%[d18O_runav,d18O_med,ti,radi] = InterpFiltIrreg(d18O,ts,ti,mincatch,minrad,'runav');
%[d13C_runav,d13C_med,ti,radi] = InterpFiltIrreg(d13C,ts,ti,mincatch,minrad,'runav');
%[d18O_triang,d18O_med,ti,radi] = InterpFiltIrreg(d18O,ts,ti,mincatch,minrad,'triang');
%[d13C_triang,d13C_med,ti,radi] = InterpFiltIrreg(d13C,ts,ti,mincatch,minrad,'triang');

%load lisiecki

[d18O_runav,d18O_med,ti,radi] = InterpFiltIrreg(d18O,ts,ti,mincatch,minrad,'runav');

[d18O_triang,d18O_med,ti,radi] = InterpFiltIrreg(d18O,ts,ti,mincatch,minrad,'triang');

% subplot(3,1,1)
% plot(ti,outcubic,'g')
% hold on
% plot(ti,outspline,'r')
% plot(ts,in,'b')
% plot(ts,in,'ok')
% legend('cubic','spline','linear')
% title(['mincatch=',num2str(mincatch),'. minrad=',num2str(minrad)])

subplot(2,1,1)
plot(ts,d18O,'ok')
hold on
%plot(ts,d18O5pt,'*-c')
plot(ti,d18O_med,'x-g')
plot(ti,d18O_runav,'o-b')
plot(ti,d18O_triang,'x-r')
A=load('LR04_Global_Pliocene_Pleistocene_Benthic_d18O_Stack.txt','txt');
plot(A(:,1)/1000,A(:,2),'.-m')

legend('Data','5pt','Median filter','Running average','Triangle filter','LR04')
title(['Minimum averaging radius = ',num2str(minrad),' Ma'])

subplot(2,1,2)
plot(ti,radi,'.-b')
legend('Actual radius used')
ylabel('Ma')
ylim([min(radi)*0.9,max(radi)*1.1])

for isub = 1:2
  subplot(2,1,isub)
  xlim([min(ti),max(ti)])
end

%save(fn,'ti','minrad','d18O_triang','d13C_triang','d18O_runav','d13C_runav') 

save(fn,'ti','minrad','d18O_triang','d18O_runav')


% switch example 
%   case 6
%     for isub = 1:2
%         subplot(2,1,isub)
%         xlim([53.9,56.1])
%     end
%     save(fn,'ti','minrad','d18O_triang','d13C_triang','d18O_runav','d13C_runav') 
% 
%   case 7
%     for isub = 1:2
%         subplot(2,1,isub)
%         xlim([min(ti),max(ti)])
%     end
%     save zachos_triinterp_2p6Ma_30ky ti minrad d18O_triang d13C_triang d18O_runav d13C_runav 
%   case 8
%     for isub = 1:2
%         subplot(2,1,isub)
%         xlim([min(ti),max(ti)])
%     end
%     save zachos_triinterp_2p6Ma_1ky ti minrad d18O_triang d13C_triang d18O_runav d13C_runav 
%   case 9
%     for isub = 1:2
%         subplot(2,1,isub)
%         xlim([min(ti),max(ti)])
%     end
%     save zachos_triinterp_2p6Ma_5ky ti minrad d18O_triang d13C_triang d18O_runav d13C_runav   
%   case 10
%     for isub = 1:2
%         subplot(2,1,isub)
%         xlim([min(ti),max(ti)])
%     end
%     save zachos_triinterp_2p6Ma_10ky ti minrad d18O_triang d13C_triang d18O_runav d13C_runav 
% end