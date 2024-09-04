% Change the onj files to txt

% files = dir('*.object');
% for k = 1:length(files)
%     originalFileName = files(k).name;
%     newFileName = strrep(originalFileName, '.object', '.txt');
%     movefile(originalFileName, newFileName);
% end

cd Object_Files\
files = dir('*.txt');
for i=1:length(files)
    [conductivity_values{i},permittivity_values{i},materialNumbers{i},data_blocks{i}] = Readfile(i);
end
cd ..

function [conductivity_values,permittivity_values,materialNumbers,data_blocks] = Readfile(i)
filename = ['Mixed Furniture(',sprintf('%01d',i),').txt'];
fileID = fopen(filename, 'r');fileID = fopen(filename, 'r');
% Read the entire file into a cell array of strings
fileContents = fileread(filename);
lines = strsplit(fileContents, '\n');
conductivity_values = [];
permittivity_values = [];
% Read the file line by line
while ~feof(fileID)
    line = fgetl(fileID);
    % Check if the line contains the word 'conductivity'
    if contains(line, 'conductivity')
        % Extract the numerical value following 'conductivity'
        tokens_conductivity = textscan(line, 'conductivity %f');
        value_temp = tokens_conductivity{1};
        % Append the value to the matrix
        conductivity_values = [conductivity_values; value_temp];
        clear value_temp
    else if contains(line, 'permittivity')
            % Extract the numerical value following 'conductivity'
            tokens_permittivity = textscan(line, 'permittivity %f');
            value_temp = tokens_permittivity{1};
            % Append the value to the matrix
            permittivity_values = [permittivity_values; value_temp];
            clear value_temp
    end
    end
end
% Check if the line contains 'end_<structure_group>'
% Find the indices of the lines that contain "end_<structure_group>"
endIndices = find(contains(lines, 'end_<structure_group>'));

% Initialize variables to store data_blocks and material numbers
data_blocks = {};
materialNumbers = [];

% Process each occurrence of "end_<structure_group>"
for i = 1:length(endIndices)
    endIndex = endIndices(i);

    % Find the "nVertices" line
    nVerticesLine = '';
    materialLine = '';
    for j = endIndex:-1:1
        if contains(lines{j}, 'nVertices')
            nVerticesLine = lines{j};
            materialLine = lines{j-1};  % Material line is one line before nVertices line
            break;
        end
    end

    % Extract the number of vertices and material number
    if ~isempty(nVerticesLine) && ~isempty(materialLine)
        nVertices = sscanf(nVerticesLine, 'nVertices %d');
        materialNumber = sscanf(materialLine, 'Material %d');

        % Store the material number
        materialNumbers = [materialNumbers; materialNumber];

        % Collect the required lines and convert to a matrix
        dataLines = lines(endIndex-nVertices-3:endIndex-4);
        matrix = zeros(nVertices, 3);
        for k = 1:nVertices
            matrix(k, :) = sscanf(dataLines{k}, '%f %f %f');
        end

        % Store the matrix
        data_blocks{end+1} = matrix;
    end
end
fclose('all');
end

