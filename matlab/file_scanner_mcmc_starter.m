% folder of input files
infolder = '~/src/cosmo/matlab';

% infinite loop
while 1

    infile = 'testinput.txt';

    if exist([infolder, '/', infile], 'file') == 2
        disp('file exists')
        break
    end

end