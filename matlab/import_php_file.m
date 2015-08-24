function [sampleid,name,email,lat,long,be_conc,al_conc,c_conc,ne_conc,be_uncer,al_uncer,c_uncer,ne_uncer,be_prod,al_prod,c_prod,ne_prod,rock_density,epsilon_gla_min,epsilon_gla_max,epsilon_int_min,epsilon_int_max,t_degla,t_degla_uncer,record,record_threshold_min,record_threshold_max] = import_php_file(filename, startRow, endRow)

% import_php_file.m
% Automatically generated using the `uiimport` tool in Matlab.
% If the output format in "uploadhistory.php" is changed, update this file
% accordingly.

%IMPORTFILE Import numeric data from a text file as column vectors.
%   [SAMPLEID,NAME,EMAIL,LAT,LONG,BE_CONC,AL_CONC,C_CONC,NE_CONC,BE_UNCER,AL_UNCER,C_UNCER,NE_UNCER,BE_PROD,AL_PROD,C_PROD,NE_PROD,ROCK_DENSITY,EPSILON_GLA_MIN,EPSILON_GLA_MAX,EPSILON_INT_MIN,EPSILON_INT_MAX,T_DEGLA,T_DEGLA_UNCER,RECORD,RECORD_THRESHOLD_MIN,RECORD_THRESHOLD_MAX]
%   = IMPORTFILE(FILENAME) Reads data from text file FILENAME for the
%   default selection.
%
%   [SAMPLEID,NAME,EMAIL,LAT,LONG,BE_CONC,AL_CONC,C_CONC,NE_CONC,BE_UNCER,AL_UNCER,C_UNCER,NE_UNCER,BE_PROD,AL_PROD,C_PROD,NE_PROD,ROCK_DENSITY,EPSILON_GLA_MIN,EPSILON_GLA_MAX,EPSILON_INT_MIN,EPSILON_INT_MAX,T_DEGLA,T_DEGLA_UNCER,RECORD,RECORD_THRESHOLD_MIN,RECORD_THRESHOLD_MAX]
%   = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from rows STARTROW
%   through ENDROW of text file FILENAME.
%
% Example:
%   [sampleid,name,email,lat,long,be_conc,al_conc,c_conc,ne_conc,be_uncer,al_uncer,c_uncer,ne_uncer,be_prod,al_prod,c_prod,ne_prod,rock_density,epsilon_gla_min,epsilon_gla_max,epsilon_int_min,epsilon_int_max,t_degla,t_degla_uncer,record,record_threshold_min,record_threshold_max]
%   = importfile('cosmo_pgpzvt',1, 1);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2015/08/24 12:47:00

%% Initialize variables.
delimiter = '\t';
if nargin<=2
    startRow = 1;
    endRow = inf;
end

%% Read columns of data as strings:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric strings to numbers.
% Replace non-numeric strings with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[6,7,8,9,10,11,12,13,18,19,20,21,22,23,24,25,26,27]
    % Converts strings in the input cell array to numbers. Replaced non-numeric
    % strings with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(thousandsRegExp, ',', 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric strings to numbers.
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end


%% Split data into numeric and cell columns.
rawNumericColumns = raw(:, [6,7,8,9,10,11,12,13,18,19,20,21,22,23,24,25,26,27]);
rawCellColumns = raw(:, [1,2,3,4,5,14,15,16,17]);


%% Allocate imported array to column variable names
sampleid = rawCellColumns(:, 1);
name = rawCellColumns(:, 2);
email = rawCellColumns(:, 3);
lat = rawCellColumns(:, 4);
long = rawCellColumns(:, 5);
be_conc = cell2mat(rawNumericColumns(:, 1));
al_conc = cell2mat(rawNumericColumns(:, 2));
c_conc = cell2mat(rawNumericColumns(:, 3));
ne_conc = cell2mat(rawNumericColumns(:, 4));
be_uncer = cell2mat(rawNumericColumns(:, 5));
al_uncer = cell2mat(rawNumericColumns(:, 6));
c_uncer = cell2mat(rawNumericColumns(:, 7));
ne_uncer = cell2mat(rawNumericColumns(:, 8));
be_prod = rawCellColumns(:, 6);
al_prod = rawCellColumns(:, 7);
c_prod = rawCellColumns(:, 8);
ne_prod = rawCellColumns(:, 9);
rock_density = cell2mat(rawNumericColumns(:, 9));
epsilon_gla_min = cell2mat(rawNumericColumns(:, 10));
epsilon_gla_max = cell2mat(rawNumericColumns(:, 11));
epsilon_int_min = cell2mat(rawNumericColumns(:, 12));
epsilon_int_max = cell2mat(rawNumericColumns(:, 13));
t_degla = cell2mat(rawNumericColumns(:, 14));
t_degla_uncer = cell2mat(rawNumericColumns(:, 15));
record = cell2mat(rawNumericColumns(:, 16));
record_threshold_min = cell2mat(rawNumericColumns(:, 17));
record_threshold_max = cell2mat(rawNumericColumns(:, 18));


