%InspectDepthTrack.m      
clear; close all
[fn,pn]=uigetfile('*.mat')
load([pn,fn])
iwalk=input(['What iwalk?[1..',num2str(length(Ss)),']']),
lump_MetHas = Ss{iwalk}.lump_MetHas;
fixed_stuff = Ss{iwalk}.fs;
% if ~isempty(lump_MetHas.zsss{1})
figure
zsss = lump_MetHas.zsss;
tss = lump_MetHas.tss;
dtfine = -1000; tfinemax = -20e5; dzfine = 0.1; zfinemax = 100,
iz = 1;
DepthExposureTimeDens(zsss,tss,dtfine,tfinemax,dzfine,zfinemax,fixed_stuff,iz)
title('z(time)')
axis ij

figure
zsss = lump_MetHas.zsss;
tss = lump_MetHas.ExposureTimeSinceNows;
dtExposurefine = 1000; tExposurefinemax = 20e5; dzfine = 0.1; zfinemax = 100,
iz = 1;
DepthExposureTimeDens(zsss,tss,dtExposurefine,tExposurefinemax,dzfine,zfinemax,fixed_stuff,iz)
title('z(ExposureTime)')
%       end
axis ij