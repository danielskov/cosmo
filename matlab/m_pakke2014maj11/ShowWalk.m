%ShowWalk.m
function ShowWalk(S)

msBurnIn = S.msBurnIn;
acceptsBurnIn = S.acceptsBurnIn;
QsBurnIn = S.QsBurnIn;
QdsBurnIn = S.QdsBurnIn;
ms = S.ms;
accepts = S.accepts;
Qs = S.Qs;
Qds = S.Qds;
fixed_stuff = S.fs;
m_start = S.m_start;
d_start = S.d_start;

lump_MetHas = S.lump_MetHas; 
StepFacts = S.lump_MetHas.StepFacts;
mcurs = S.lump_MetHas.mcurs
Qcurs = S.lump_MetHas.Qcurs;
Qdcurs = S.lump_MetHas.Qdcurs;
dmcurspr = S.lump_MetHas.dmcurspr;
mprops = S.lump_MetHas.mprops;
Qprops = S.lump_MetHas.Qprops;
Qdprops = S.lump_MetHas.Qdprops;
dmpropspr = S.lump_MetHas.dmpropspr;

iwalk = fixed_stuff.iwalk;

%Find the maximum likelihood estimate
i_MLE = find(Qs==min(Qs));
m_MLE = ms(:,i_MLE(1));
Q_MLE = Qs(i_MLE(1));
d_MLE = g(m_MLE,fixed_stuff);
accept_rate = sum(accepts)/length(accepts);

disp(['Maximum likelihood value:',num2str(Q_MLE)]);
disp('True model, Start model, and Maximum likelihood model:');
disp([fixed_stuff.m_true, m_start, m_MLE])

figure
subplot(2,2,4)
plot(fixed_stuff.d_obs,'o'), hold on
plot(d_start,'-.k')
plot(d_MLE,'.g')
plot(fixed_stuff.d_true,'r:')

legend('obs','start','MLE','true')
title(['Walker number ',num2str(i)])

subplot(2,2,3)
cols = jet(5);
ms = [m_start,ms];
for im=1:length(fixed_stuff.m_true)
  plot((ms(im,:)/fixed_stuff.m_true(im))*100,'color',cols(im,:))
  hold on
end
ylabel('Estimation error, %')
legendstr = ['legend(''',fixed_stuff.mname{1},''''];
for im=2:length(fixed_stuff.mname)
  legendstr = [legendstr,',''',fixed_stuff.mname{im},''''];
end
legendstr = [legendstr,')'];
eval(legendstr)

subplot(2,2,2)
semilogy(QsBurnIn,'r')
hold on
plot(Qds,'b')
%   plot(Qps,'g')
legend('QsBurnIn','Qs')
ylim([1e-2,1e4])
%   subplot(2,2,4)
%   plot(lump.mcurs'); hold on
%   plot(lump.mprops','.')
%   plot([0;N_run],[xcs_true,xcs_true]')
figure
mprCrossDensPlots(mcurs,fixed_stuff)

figure
mNativeCrossDensPlots(ms,fixed_stuff)
%plot in true model in each frame:
M = size(fixed_stuff.mminmax,1);
for i1=1:M
  for i2=1:M
    subplot(M,M,M*(i2-1)+i1)
    hold on
    if i1==i2 %histogram
      plot(fixed_stuff.m_true(i1),0,'om')
    else
      plot(fixed_stuff.m_true(i1),fixed_stuff.m_true(i2),'om')
    end
  end
end
figure
subplot(3,1,1)
normdmpropspr = sqrt(sum(dmpropspr.^2)/M);
normdmcurspr = sqrt(sum(dmcurspr.^2)/M);
plot(normdmpropspr,'.'); hold on
plot(normdmcurspr,'.r');
title('Norm of step length in normalized coordinates, +/- sqrt(3)')
legend('||\Deltam_{proposed}||','||\Deltam_{accepted}||')
subplot(3,1,2)
plot(lump_MetHas.StepFacts)
title('StepFacts: Factor on basic proposed step')
subplot(3,1,3)
W=ones(1,5); W = W/sum(W); W = conv(W,W); W = conv(W,W);
plot(conv(accepts,W,'same'))
title(['Smoothed acceptance ratio. TargetAcceptanceRatio = ',num2str(fixed_stuff.BurnIn.TargetAcceptanceRatio)])

if strcmp(fixed_stuff.g_case,'cosmoLongstep')
  if isfield(S.lump_MetHas,'zsss')
    if ~isempty(lump_MetHas.zsss)
      figure
      zsss = lump_MetHas.zsss;
      tss = lump_MetHas.tss;
      dtfine = -1000; tfinemax = -5e5; dzfine = 1; zfinemax = 100,
      iz = 1;
      DepthExposureTimeDens(zsss,tss,dtfine,tfinemax,dzfine,zfinemax,fixed_stuff,iz)
      title('z(time)')
      
      figure
      zsss = lump_MetHas.zsss;
      tss = lump_MetHas.ExposureTimeSinceNows;
      dtExposurefine = 1000; tExposurefinemax = 3e5; dzfine = 0.1; zfinemax = 100,
      iz = 1;
      DepthExposureTimeDens(zsss,tss,dtExposurefine,tExposurefinemax,dzfine,zfinemax,fixed_stuff,iz)
      title('z(ExposureTime)')
    end
  end
end
end