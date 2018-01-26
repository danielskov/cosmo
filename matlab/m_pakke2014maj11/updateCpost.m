function [sqrtCpostpr,Cpostpr,Gestpr]=updateCpost(ms,ds,fsSampling,fixed_stuff)
m0pr = m2mpr(ms(:,end-1),fixed_stuff); %reference model in standardized coordinates
d0pr = d2dpr(ds(:,end-1),fixed_stuff);
M=length(m0pr); N = length(d0pr);

order = 2;
steps = fsSampling.PartDevStep;
primed = 1; %we do it in normalized coordinates
[G2pr,lump2pr]=makeG(m0pr,fixed_stuff,order,steps,primed);
Gestpr = G2pr;

Cpostpr = inv(Gestpr'*Gestpr+eye(size(ms,1)));
sqrtCpostpr = chol(Cpostpr)';