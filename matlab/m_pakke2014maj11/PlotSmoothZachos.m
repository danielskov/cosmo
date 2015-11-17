clear; close all

%A=load('LR04_Global_Pliocene_Pleistocene_Benthic_d18O_Stack.txt','txt');
%Age = A(:,1)/1000;
%d18O = A(:,2);
%d18O_sig = A(:,3);
%save lisiecki.mat Age_lis d18O_lis d18O_sig_lis -mat 



%[fn,pn]=uigetfile('zachos*.mat');
[fn,pn]=uigetfile('lisiecki*.mat');
load([pn,fn])
xs = ti;
dt = diff(ti(1:2));
ys = d18O_triang;
%colpos = [0.5,0.5,1];
colpos = [0,0,1];
%colneg = [0.5,1,0.5];
colneg = [1,0,0];
midvalue = 3.75;
axh(1)=subplot(3,1,1)
[h1,h2,h3,i_cross]=fill_red_blue(xs,ys,colpos,colneg,midvalue);
ylabel('\delta18O')
axis tight
axis([-0.1,2.7,3.0,5.2])
%axis([-0.05,0.3,3.0,5.2])
xlim([-0.1,2.7])
%xlim([-0.05,0.3])
hold on
%plot(A(:,1)/1000,A(:,2),'.-m')
axis ij
xs_cross = (i_cross-1)*dt;
xs_cross = [0;xs_cross];
%title([fn,'.  minrad = ',num2str(minrad),' Ma'],'interp','none')

xs_cross(2) = 0.011;

axh(2)=subplot(3,1,2)
stairs(xs_cross,(1+-1*(-1).^(1:length(xs_cross)))/2,'b','linewidth',1.5);
hold on
start1 = [xs_cross(end),2.7];
start2 = [1,1];
plot(start1,start2,'b','linewidth',1.5);
%title('Exposure. 0 = glaciated, 1 = not glaciated')
axis([-0.1,2.7,-0.5,1.5])
%axis([-0.05,0.3,-0.5,1.5])
xlabel('Age BP [Ma]')

axh(2)=subplot(3,1,3)
stairs(xs_cross,(1+-1*(-1).^(1:length(xs_cross)))/2,'r','linewidth',1.5);
hold on
plot(start1,start2,'r','linewidth',1.5);
%title('Exposure. 0 = glaciated, 1 = not glaciated')
axis([-0.1,2.7,-1,2])
%axis([-0.05,0.3,-1,2])
xlabel('Age BP [Ma]')


hold on
d18Oth = midvalue;
ErateInt=1e-6; ErateGla=1e-7;
[tStarts,relExpos] = ExtractHistory2(ti,d18O_triang,d18Oth,ErateInt,ErateGla);

linkaxes(axh,'x')
% stairs(-tStarts,relExpos+2,'r')
