function C = update_profile(C,z,S,erate,dt)

% Updates an isotope concentration profile 
%
% C - isotope concentration array
% z - nodal depth array
% S - source array integrated over dt (production + decay)
% erate - erosion rate (scalar - m/yr)
% dt - time step (yr)
%
% DLE 5/9-2013

%ensure column arrays
C = C(:);
S = S(:);

%specify time integration
% theta = 0 - explicit
% theta = .5 - chrank-nicolson
% thera = 1 - implicit
theta = .5;

%number of nodes
N = length(z);

%Element topology
TOPO = [1:N-1;2:N]';

%Element lengths
dl = diff(z);

Ne = N - 1; %Number of elements

%useful matrices for FEM
M1 = [-1,1;-1,1]/2;
M2 = [2,1;1,2]/6;

%%%%%%% Transient solution %%%%%%%%%%%%

%initiate matrices
K = zeros(N,N);
f = zeros(N,1);

%loop elements
for i=1:Ne,

  %add to stiffness matrix
  Ke = M2*dl(i)/dt-erate*M1*theta;
  K(TOPO(i,:),TOPO(i,:)) = K(TOPO(i,:),TOPO(i,:)) + Ke;
  
  %add to Load vector
  fe = M2*(C(TOPO(i,:))/dt+S(TOPO(i,:))/dt)*dl(i)+erate*M1*C(TOPO(i,:))*(1-theta);
  f(TOPO(i,:)) = f(TOPO(i,:)) + fe;

end;

  
%Lower boundary condition
[K,f] = ebc(K,f,N,0);

%update profile
C = K\f;
  
