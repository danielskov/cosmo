function tile_figs(fhs,NNx,NNy,W,H)
if nargin <5
    scr=get(0,'screensize');
    W=scr(3);
    H=scr(4);
end
if nargin == 0
    fhs = sort(get(0,'children'));
end

Np=length(fhs);
if nargin<3
   NN=ceil(sqrt(Np));
   if (Np==5|Np==6), 
      NNx=2; NNy=3;
   else 
      NNx=NN; NNy=NN; 
   end;
end

% Wframe = ceil(10*W/1920);
% Hframe = ceil(100*H/1080);
Wframe = 10; %adjust to fit your graphics card
Hframe = 100; %adjust to fit your graphics card
Wwindow = W/NNx;
Hwindow = H/NNy;
Wfig = Wwindow-Wframe;
Hfig = Hwindow-Hframe;

for nx=0:NNx-1, 
   for ny=NNy-1:-1:0, 
      n=1+nx+(NNy-ny-1)*NNx; 
      if (n<=Np)
         %set(fhs(n),'position',[10+nx/NNx*W,3+ny/NNy*H,W/NNx,H/NNy-50]);
         set(fhs(n),'position',[nx*Wwindow,ny*Hwindow,Wfig,Hfig]);
         figure(fhs(n))
      end; 
   end; 
end
   