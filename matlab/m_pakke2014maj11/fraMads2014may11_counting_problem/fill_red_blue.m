function [h1,h2,h3,i_cross]=fill_red_blue(xs,ys,colpos,colneg,midvalue,nudge_factor)
if nargin<6
  %samples at the midvalue are nudged by this 
  %in order to force all samples to be either above or below the midvalue
  nudge_factor = 1e-10; 
end
if nargin<5
  midvalue=0;
end
if nargin<3
  colpos = 'r';
  colneg = 'b';
end
if nargin<2
  ys = xs;
  xs = 1:length(ys);
end
xs = double(xs(:)); ys = double(ys(:)); %to prevent problems with data types like single and int32

%nudge samples equal to mid-value:
izero = find(ys==midvalue);
if midvalue == 0 % take scale from ys
  nudge_step = nudge_factor*std(ys)+nudge_factor*mean(abs(ys));
else
  nudge_step=nudge_factor*midvalue;
end
ys(izero)=ys(izero)+nudge_step;
%now find the zero crossings
i_cross = find(abs(diff(sign(ys-midvalue)))==2); %zero crossing between ys(i_cross) and ys(i_cross+1)
if isempty(i_cross)
  xs_fill=xs;
  ys_fill = ys;
else %we have crossings to interpolate
  N_cross = length(i_cross);
  di_cross = (midvalue-ys(i_cross))./(ys(i_cross+1)-ys(i_cross));
  xs_fill = NaN*ones(length(xs)+N_cross,1);
  ys_fill = xs_fill;
  is = 1:i_cross(1);
  xs_fill(is) = xs(1:i_cross(1)); %before first zero
  ys_fill(is) = ys(is);
  for ic=1:N_cross-1 %between zeros
    is = [(i_cross(ic)+1):i_cross(ic+1)];
    xs_fill(ic + is) = xs(is);
    ys_fill(ic+is) = ys(is);
  end
  %after last zero
  is = [(i_cross(N_cross)+1):length(xs)];
  xs_fill(N_cross + is) = xs(is);
  ys_fill(N_cross + is) = ys(is);
  %fill in interpolated zero crossings
  xs_fill(i_cross+ (1:N_cross)') = xs(i_cross) + (xs(i_cross+1)-xs(i_cross)) .* di_cross;
  ys_fill(i_cross + (1:N_cross)') = midvalue*ones(N_cross,1);
end %else
%    fill(max(ys_fill,0)+xs(ix),xs_fill-xs(ix)/Vred, 'k','edgecolor','w');
%    %fill(max((s(:,ix)),0)+xs(ix),ts_fill-xs(ix)/Vred, 'k','edgecolor','w');
%    %fill(max((s(:,ix)),0)+xs(ix),ts-xs(ix)/Vred, 'k','edgecolor','w');
% hold on
%    plot(    (ys(:,ix))   +xs(ix),xs-xs(ix)/Vred,'-k');
% %   fill(ts-xs(ix)/Vred,max((s(:,ix)),0)+xs(ix), 'k');
% %   plot(ts-xs(ix)/Vred,    (s(:,ix))   +xs(ix),'-k');
% %keyboard


h1 = fill([xs_fill;xs_fill(end);xs_fill(1)],[max(ys_fill,midvalue);midvalue;midvalue],colpos);
hold on
h2 = fill([xs_fill;xs_fill(end);xs_fill(1)],[min(ys_fill,midvalue);midvalue;midvalue],colneg);
h3 = plot(xs,ys,'k-');
i_cross = i_cross + di_cross;
