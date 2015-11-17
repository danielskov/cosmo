%function [G,lump]=makeG(m0,fixed_stuff,order,steps,primed) 
%INPUTS:
% m0: Model vector at which partial derivatives are computed. 
%     If "primed" is set below then m0 must be in primed coordinates. 
% fixed_stuff: Required for computations of the forward mapping, and other things
% order: 1: One sided difference, 2: symmetrical difference, 4: four-point high-accuracy
% steps: Controls the step size used in the computation of derivatives
%        Positive scalar: same step in all directons
%        Negative scalar: Same relative stepsize; careful if m0 has negative elements
%        Vector of elements: Different steps in each direction
%                            Relative steps if negative       
% primed: 0: ordinary coordinats. 1: standardized cooridnates
%OUTPUTS:
% G: Matrix of approximated partial derivatives
% lump: A collection of diagnostics
%CALL:   [G,lump]=makeG(m0,fixed_stuff,order,steps,primed)
function [G,lump]=makeG(m0,fixed_stuff,order,steps,primed)
if nargout>1
    lump.m0 = m0;
    lump.fixed_stuff = fixed_stuff;
    if nargin>2
        lump.order_in = order;
    else
        lump.order_n = [];
    end
    if nargin>3
        lump.steps_in = steps;
    else
        lump.steps_in=[];
    end
    if nargin>4
        lump.primed_in = primed;
    else
        lump.primed_in = [];
    end
end
M = length(m0);
if nargin<5
    primed = 0;
end
if nargin<4
    steps = m0/1000 + 1e-6; %wild guess
end
if nargin<3
    order = 2; %robust accuracy
end
if length(steps)==1
    steps = steps*ones(size(m0));
end

dms = NaN(size(m0));
for im=1:M
    if steps(im)<0
        dms(im)=abs(m0(im))*abs(steps(im));
    else
        dms(im)=steps(im);
    end
end
if ~((order==1)|(order==2))
    order=2;
    warning('Order reset to 2')
end

switch order
    case 1 %one-sided difference
        if primed
            d0pr = gpr(m0,fixed_stuff);
            N = length(d0pr);
            G = NaN(N,M);
            for im=1:M
               mplus = m0; mplus(im)=m0(im)+dms(im);
               G(:,im)=(gpr(mplus,fixed_stuff)-d0pr)/dms(im); 
            end
        else
            d0 = g(m0,fixed_stuff);
            N = length(d0);
            G = NaN(N,M);
            for im=1:M
                mplus = m0; mplus(im)=m0(im)+dms(im);
                G(:,im)=(g(mplus,fixed_stuff)-d0)/dms(im);
            end
        end
    case 2 %symmetrical difference
        if primed
            d0pr = gpr(m0,fixed_stuff); %expensive way of getting N
            N = length(d0pr);
            G = NaN(N,M);
            for im=1:M
                mplus = m0; mplus(im)=m0(im)+dms(im);
                mminus= m0; mminus(im)=m0(im)-dms(im);
                G(:,im)=0.5*(gpr(mplus,fixed_stuff)-gpr(mminus,fixed_stuff))/dms(im);
            end
        else
            d0 = g(m0,fixed_stuff);
            N = length(d0);
            G = NaN(N,M);
            for im=1:M
                mplus = m0; mplus(im)=m0(im)+dms(im);
                mminus= m0; mminus(im)=m0(im)-dms(im);
                G(:,im)=0.5*(g(mplus,fixed_stuff)-g(mminus,fixed_stuff))/dms(im);
            end
        end   
end

if nargout>1
    lump.M = M;
    lump.N = N;
    lump.order_used = order;
    lump.primed_used = primed;
    lump.steps_used = steps;
end