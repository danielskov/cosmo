clear all; close all;

load Walks_20160125_192948.mat   %Test

%Extract model parameters (the two erosion rates) from burn-in phase
E_int_BurnIn_1 = Ss{1}.msBurnIn(1,:);
E_gla_BurnIn_1 = Ss{1}.msBurnIn(2,:);

E_int_BurnIn_2 = Ss{2}.msBurnIn(1,:);
E_gla_BurnIn_2 = Ss{2}.msBurnIn(2,:);

E_int_BurnIn_3 = Ss{3}.msBurnIn(1,:);
E_gla_BurnIn_3 = Ss{3}.msBurnIn(2,:);

E_int_BurnIn_4 = Ss{4}.msBurnIn(1,:);
E_gla_BurnIn_4 = Ss{4}.msBurnIn(2,:);


%Extract 10Be and 26Al concentrations from burn-in phase
%This approach assumes that the different simulations result in the same
%number of exposure/burial transitions
for i=1:length(Ss{1}.lump_MetHas_BurnIn.c10Besss)
c10Be_BurnIn_1(i) = Ss{1}.lump_MetHas_BurnIn.c10Besss{i}(end);
c26Al_BurnIn_1(i) = Ss{1}.lump_MetHas_BurnIn.c26Alsss{i}(end);
end

for i=1:length(Ss{2}.lump_MetHas_BurnIn.c10Besss)
c10Be_BurnIn_2(i) = Ss{2}.lump_MetHas_BurnIn.c10Besss{i}(end);
c26Al_BurnIn_2(i) = Ss{2}.lump_MetHas_BurnIn.c26Alsss{i}(end);
end

for i=1:length(Ss{3}.lump_MetHas_BurnIn.c10Besss)
c10Be_BurnIn_3(i) = Ss{3}.lump_MetHas_BurnIn.c10Besss{i}(end);
c26Al_BurnIn_3(i) = Ss{3}.lump_MetHas_BurnIn.c26Alsss{i}(end);
end

for i=1:length(Ss{4}.lump_MetHas_BurnIn.c10Besss)
c10Be_BurnIn_4(i) = Ss{4}.lump_MetHas_BurnIn.c10Besss{i}(end);
c26Al_BurnIn_4(i) = Ss{4}.lump_MetHas_BurnIn.c26Alsss{i}(end);
end

c26_10_BurnIn_rat_1 = c26Al_BurnIn_1./c10Be_BurnIn_1;
c26_10_BurnIn_rat_2 = c26Al_BurnIn_2./c10Be_BurnIn_2;
c26_10_BurnIn_rat_3 = c26Al_BurnIn_3./c10Be_BurnIn_3;
c26_10_BurnIn_rat_4 = c26Al_BurnIn_4./c10Be_BurnIn_4;

% Accept ratios of burn-in phase (~0.2)
k = find(Ss{1}.acceptsBurnIn == 1);
Accept_rat = length(k)/length(Ss{1}.acceptsBurnIn);

figure;
plot(E_int_BurnIn_1,E_gla_BurnIn_1,'.k');
hold on
plot(E_int_BurnIn_2,E_gla_BurnIn_2,'.b');
plot(E_int_BurnIn_3,E_gla_BurnIn_3,'.r');
plot(E_int_BurnIn_4,E_gla_BurnIn_4,'.g');

plot(E_int_BurnIn_1(1),E_gla_BurnIn_1(1),'vk');
plot(E_int_BurnIn_2(1),E_gla_BurnIn_2(1),'vb');
plot(E_int_BurnIn_3(1),E_gla_BurnIn_3(1),'vr');
plot(E_int_BurnIn_4(1),E_gla_BurnIn_4(1),'vg');

figure;
loglog(E_int_BurnIn_1,E_gla_BurnIn_1,'.k');
hold on
loglog(E_int_BurnIn_2,E_gla_BurnIn_2,'.b');
loglog(E_int_BurnIn_3,E_gla_BurnIn_3,'.r');
loglog(E_int_BurnIn_4,E_gla_BurnIn_4,'.g');

loglog(E_int_BurnIn_1(1),E_gla_BurnIn_1(1),'.k','markersize',30);
loglog(E_int_BurnIn_2(1),E_gla_BurnIn_2(1),'.b','markersize',30);
loglog(E_int_BurnIn_3(1),E_gla_BurnIn_3(1),'.r','markersize',30);
loglog(E_int_BurnIn_4(1),E_gla_BurnIn_4(1),'.g','markersize',30);
loglog(Ss{1}.fs.m_true(1),Ss{1}.fs.m_true(2),'.m','markersize',50);

figure;
plot(c10Be_BurnIn_1,c26Al_BurnIn_1,'.k');
hold on
plot(c10Be_BurnIn_2,c26Al_BurnIn_2,'.b');
plot(c10Be_BurnIn_3,c26Al_BurnIn_3,'.r');
plot(c10Be_BurnIn_4,c26Al_BurnIn_4,'.g');

plot(Ss{1}.fs.d_obs(1),Ss{1}.fs.d_obs(2),'.m','markersize',30);


figure;
plot(c10Be_BurnIn_1,c26_10_BurnIn_rat_1,'.k');
hold on
plot(c10Be_BurnIn_2,c26_10_BurnIn_rat_2,'.b');
plot(c10Be_BurnIn_3,c26_10_BurnIn_rat_3,'.r');
plot(c10Be_BurnIn_4,c26_10_BurnIn_rat_4,'.g');

plot(c10Be_BurnIn_1(1),c26_10_BurnIn_rat_1(1),'.k','markersize',30);
plot(c10Be_BurnIn_2(1),c26_10_BurnIn_rat_2(1),'.b','markersize',30);
plot(c10Be_BurnIn_3(1),c26_10_BurnIn_rat_3(1),'.r','markersize',30);
plot(c10Be_BurnIn_4(1),c26_10_BurnIn_rat_4(1),'.g','markersize',30);

plot(Ss{1}.fs.d_obs(1),Ss{1}.fs.d_obs(2)/Ss{1}.fs.d_obs(1),'.m','markersize',30);


