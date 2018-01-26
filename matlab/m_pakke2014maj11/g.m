function [d,lump] = g(m,fixed_stuff,iwalk)
switch fixed_stuff.g_case
  case 'cosmo_advec'
    %         fixed_stuff.dt = 500;
    %         fixed_stuff.erosion_gla = [0,1e-6,1e-5,1e-4];
    %         fixed_stuff.erosion_int = logspace(-6,-2);
    %         fixed_stuff.P_gla = [1e3:fixed_stuff.dt:5e3];
    %         fixed_stuff.P_int = [1e3:fixed_stuff.dt:2e3];
    %         fixed_stuff.C10_start = load('C10_ero_1em4.dat');
    %         fixed_stuff.C26_start = load('C26_ero_1em4.dat');
    %         fixed_stuff.C21_start = load('C21_ero_1em4.dat');
    %         fixed_stuff.C14_start = load('C14_ero_1em4.dat');
    erate_gla = m(1);
    erate_int = m(2);
    Period_gla   = m(3);
    Period_int   = m(4);
    [cNe,cC,cAl,cBe] = ...
      gcosmo_advec(erate_gla,erate_int,Period_gla,Period_int,fixed_stuff);
    d = [cBe(:);cAl(:);cNe(:);cC(:)];
  case 'cosmo_analyt'
    %         fixed_stuff.dt = 500;
    %         fixed_stuff.erosion_gla = [0,1e-6,1e-5,1e-4];
    %         fixed_stuff.erosion_int = logspace(-6,-2);
    %         fixed_stuff.P_gla = [1e3:fixed_stuff.dt:5e3];
    %         fixed_stuff.P_int = [1e3:fixed_stuff.dt:2e3];
    %         fixed_stuff.C10_start = load('C10_ero_1em4.dat');
    %         fixed_stuff.C26_start = load('C26_ero_1em4.dat');
    %         fixed_stuff.C21_start = load('C21_ero_1em4.dat');
    %         fixed_stuff.C14_start = load('C14_ero_1em4.dat');
    erate_gla = m(1);
    erate_int = m(2);
    Period_gla   = m(3);
    Period_int   = m(4);
    [cNe,cC,cAl,cBe] = ...
      gcosmo_analyt(erate_gla,erate_int,Period_gla,Period_int,fixed_stuff);
    %         [cNe,cC,cAl,cBe] = ...
    %             gcosmo_analyt_fm_only(erate_gla,erate_int,Period_gla,Period_int,fixed_stuff);
    d = [cBe(:);cAl(:);cNe(:);cC(:)];
  case 'cosmoLongsteps_HoloceneEqEemEtc'
    %         fixed_stuff.dt = 500;
    %         fixed_stuff.erosion_gla = [0,1e-6,1e-5,1e-4];
    %         fixed_stuff.erosion_int = logspace(-6,-2);
    %         fixed_stuff.P_gla = [1e3:fixed_stuff.dt:5e3];
    %         fixed_stuff.P_int = [1e3:fixed_stuff.dt:2e3];
    %         fixed_stuff.C10_start = load('C10_ero_1em4.dat');
    %         fixed_stuff.C26_start = load('C26_ero_1em4.dat');
    %         fixed_stuff.C21_start = load('C21_ero_1em4.dat');
    %         fixed_stuff.C14_start = load('C14_ero_1em4.dat');
    erate_gla = m(1);
    erate_int = m(2);
    Period_gla   = m(3);
    Period_int   = m(4);
    [cBes,cAls,cNes,cCs,lump] = ...
      gCosmoLongsteps_HoloceneEqEemEtc(erate_gla,erate_int,Period_gla,Period_int,fixed_stuff);
    %         [cNe,cC,cAl,cBe] = ...
    %             gcosmo_analyt_fm_only(erate_gla,erate_int,Period_gla,Period_int,fixed_stuff);
    d = [cBes(:);cAls(:);cNes(:);cCs(:)];
  case 'CosmoLongsteps',
    if length(m)==5 %very clumsy way of selecting!
      ErateInt = m(1);
      ErateGla = m(2);
      tDegla   = m(3);
      dtGla    = m(4);
      dtIdtG   = m(5);
    else
      ErateInt = m(1);
      ErateGla = m(2);
      tDegla   = m(3);
      d18Oth   = m(4);
      dtGla    = [];
      dtIdtG   = [];
      d18Ofn = fixed_stuff.d18O_filename;
      %load(d18Ofn); %must contain a variable d18O_triang, sampled in steps of 0.001 Ma
      %if ~exist('d18O_triang','var')
      %  error(['the filename ',d18Ofn,' did not contain the variable d18O_triang'])
      %end
%       [tStarts,relExpos] = ExtractHistory(ti*1e6,d18O_triang,d18Oth,ErateInt,ErateGla); %has a
%       problem if d18O_triang == d18Oth at one or more samples.
      i_t_trunc = find(fixed_stuff.ti*1e6>20e3);
      tExtract = fixed_stuff.ti(i_t_trunc)*1e6;
      [tStarts,relExpos] = ExtractHistory2(tExtract,fixed_stuff.d18O_triang(i_t_trunc),d18Oth,ErateInt,ErateGla); %should fix the ys=midvalue problem
       %[tStarts,relExpos] = ExtractHistory2(ti*1e6,d18O_triang,d18Oth,ErateInt,ErateGla); %should fix the ys=midvalue problem
      fixed_stuff.tStarts = tStarts;
      fixed_stuff.relExpos = relExpos;
      if ~strcmp(fixed_stuff.CycleMode,'d18OTimes')
        error([fixed_stuff.CycleMode,'~= d18OTimes'])
      end
    end      
    [cBes,cAls,cNes,cCs,lump] = ...
      gCosmoLongsteps(ErateInt,ErateGla,tDegla,dtGla,dtIdtG,fixed_stuff);
    %         [cNe,cC,cAl,cBe] = ...
    %             gcosmo_analyt_fm_only(erate_gla,erate_int,Period_gla,Period_int,fixed_stuff);
    %Now pack the four concentrations as specified in
    %fixed_stuff.Nucleides
    d = [];
    for iNucl = 1:length(fixed_stuff.Nucleides)
      switch fixed_stuff.Nucleides{iNucl}
        case '10Be', d=[d;cBes(:)];
        case '26Al', d=[d;cAls(:)];
        case '21Ne', d=[d;cNes(:)];
        case '14C', d=[d;cCs(:)];
        case '26Al/10Be',d=[d;cAls(:)./cBes(:)]; 
        case '21Ne/10Be',d=[d;cNes(:)./cBes(:)]; 
        otherwise
          error([fixed_stuff.Nucleides{iNucl},' not implemented'])
      end
    end
  case 'Gravity2LineSource'
    d(1,1)= 1/m(1) + m(2)/(1+m(2)^2);
    d(2,1)= 1/m(2) + m(1)/(1+m(1)^2);
    lump.G = [-1/m(1)^2            , (1-m(2)^2)/(1+m(2)^2)^2;...
      (1-m(1)^2)/(1+m(1)^2)^2 , -1/m(2)^2             ];
    lump.sqrtCpost = chol(lump.G'*lump.G)';
    
end
