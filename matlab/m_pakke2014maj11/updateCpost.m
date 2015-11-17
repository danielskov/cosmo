function [sqrtCpostpr,Cpostpr,Gestpr]=updateCpost(ms,ds,fsSampling,fixed_stuff)
m0pr = m2mpr(ms(:,1),fixed_stuff); %reference model in standardized coordinates
d0pr = d2dpr(ds(:,1),fixed_stuff); 
M=length(m0pr); N = length(d0pr);
if strcmp(fsSampling.CpostUpdateMode,'FromSamples')
  if size(ms,2)<fsSampling.StepsForPartDevEstimate
    %we cannot estimate as planned from samples, so we do the estimate
    %from numerical derivatives:
    fsSampling.CpostUpdateMode='FromPartDeriv'; %just for now
  end
end
switch fsSampling.CpostUpdateMode
    case 'FromPartDev'
        order = 2;
        steps = fsSampling.PartDevStep;
        primed = 1; %we do it in normalized coordinates
        [G2pr,lump2pr]=makeG(m0pr,fixed_stuff,order,steps,primed);
        Gestpr = G2pr;
    case 'FromSamples'
        K = fsSampling.StepsForPartDevEstimate;
        if size(ms,2)<(K+1)
            error('ms has too few samples')
        end
        dMpr = NaN(M,K);
        dDpr = NaN(N,K);
        for iK=1:K
            dMpr(:,iK) = m2mpr(ms(:,iK+1))-m0pr;
            dDpr(:,iK) = d2dpr(ds(:,iK+1))-d0pr;
        end
        Gfromsamplespr = dDpr*dMpr'*inv(dMpr*dMpr');
        Gestpr = Gfromsamplespr;
end
Cpostpr = inv(Gestpr'*Gestpr+eye(size(ms,1)));
sqrtCpostpr = chol(Cpostpr)';