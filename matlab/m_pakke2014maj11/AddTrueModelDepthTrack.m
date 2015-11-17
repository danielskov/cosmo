%Call, typically
%track_handle=AddTrueModelDepthTrack(Ss{iwalk}.fs,linsty)
function track_handle=AddTrueModelDepthTrack(fs,linsty)
if nargin==1
  linsty = '.-b';
end
disp('message from AddTrueModelDepthTrack:')
disp(['True model plotted; timestamp = ',datestr(fs.StartTime)])
m_true = fs.m_true;
[d,lump] = g(m_true,fs);
zs = lump.zss(1,:);
ts = lump.ts;
track_handle=plot(ts,zs,linsty)
end
