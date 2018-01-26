function quants = GetHistgridQuantiles(histgrid,N,fractions,tsfine,Xxfine)
%dimension checks, lost
[NXx,Nt]=size(histgrid);
relcumsumhistgrid=cumsum(histgrid)/N;
Nfracs = length(fractions);
quants = NaN(Nfracs,Nt);
for ifrac=1:Nfracs;
  frac = fractions(ifrac);
  iquants = NaN(1,Nt);
  for it=1:Nt
    try
      iquant=find(relcumsumhistgrid(:,it)>frac,1);
      if ~isempty(iquant)
        iquants(it) = iquant;
      end
    catch
      keyboard
    end
  end
  inotNaN = find(~isnan(iquants));
  quants(ifrac,inotNaN)=Xxfine(iquants(inotNaN));
end
end

