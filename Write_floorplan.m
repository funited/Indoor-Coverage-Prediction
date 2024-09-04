%%%%%%%%%%%%%%%%%%
% This script is to generate a .FLP file for the furniture to be placed
%%%%%%%%%%%%%%%%%%

% Define the range of the room
RoomCoor_x = [0.11 17.59];
RoomCoor_y = [-2.81 7.2];
Room_height = 3;
Room_base = 0;
% Generate the coordinates of the wall
n_wall = 4;
% The 1st face of the wall
Coor.wall{1}(:,1) = [RoomCoor_x(2) RoomCoor_y(2) Room_base];
Coor.wall{1}(:,2) = [RoomCoor_x(1) RoomCoor_y(2) Room_base];
Coor.wall{1}(:,3) = [RoomCoor_x(1) RoomCoor_y(2) Room_base+Room_height];
Coor.wall{1}(:,4) = [RoomCoor_x(2) RoomCoor_y(2) Room_base+Room_height];
% The 2nd face of the wall
Coor.wall{2}(:,1) = [RoomCoor_x(1) RoomCoor_y(2) Room_base];
Coor.wall{2}(:,2) = [RoomCoor_x(1) RoomCoor_y(1) Room_base];
Coor.wall{2}(:,3) = [RoomCoor_x(1) RoomCoor_y(1) Room_base+Room_height];
Coor.wall{2}(:,4) = [RoomCoor_x(1) RoomCoor_y(2) Room_base+Room_height];
% The 3rd face of the wall
Coor.wall{3}(:,1) = [RoomCoor_x(1) RoomCoor_y(1) Room_base];
Coor.wall{3}(:,2) = [RoomCoor_x(2) RoomCoor_y(1) Room_base];
Coor.wall{3}(:,3) = [RoomCoor_x(2) RoomCoor_y(1) Room_base+Room_height];
Coor.wall{3}(:,4) = [RoomCoor_x(1) RoomCoor_y(1) Room_base+Room_height];
% The 4th face of the wall
Coor.wall{4}(:,1) = [RoomCoor_x(2) RoomCoor_y(1) Room_base];
Coor.wall{4}(:,2) = [RoomCoor_x(2) RoomCoor_y(2) Room_base];
Coor.wall{4}(:,3) = [RoomCoor_x(2) RoomCoor_y(2) Room_base+Room_height];
Coor.wall{4}(:,4) = [RoomCoor_x(2) RoomCoor_y(1) Room_base+Room_height];
% Generate the coordinates of the floor
Coor.floor(:,1) = [RoomCoor_x(1) RoomCoor_y(2) Room_base];
Coor.floor(:,2) = [RoomCoor_x(2) RoomCoor_y(2) Room_base];
Coor.floor(:,3) = [RoomCoor_x(2) RoomCoor_y(1) Room_base];
Coor.floor(:,4) = [RoomCoor_x(1) RoomCoor_y(1) Room_base];
% Generate the coordinates of the ceiling
Coor.ceiling(:,1) = [RoomCoor_x(1) RoomCoor_y(2) Room_base+Room_height];
Coor.ceiling(:,2) = [RoomCoor_x(2) RoomCoor_y(2) Room_base+Room_height];
Coor.ceiling(:,3) = [RoomCoor_x(2) RoomCoor_y(1) Room_base+Room_height];
Coor.ceiling(:,4) = [RoomCoor_x(1) RoomCoor_y(1) Room_base+Room_height];

% Identify whether the coordinaters of the faces correspond to walls,
% doors or windows
faceType        = fields(Coor);

% Faces which correspond to walls will be assigned materialIndex=0, windows
% will be materialIndex=1, and doors will be materialIndex=2.
materialFlag    = zeros(length(faceType),1);

% Check for the existence of walls and ceilings
wallFlag      = 0;
ceilingFlag   = 0;

for iField = 1:length(faceType)
    if strcmp(faceType{iField},'wall') || strcmp(faceType{iField},'floor')
        materialFlag(iField) = 3;
        wallFlag = 1;
    elseif strcmp(faceType{iField},'ceiling')
        materialFlag(iField) = 4;
        ceilingFlag = 1;
    end
end

% Initiate floorplan name and filename
floorplanName   = 'FloorPlan_1';
filename        = [floorplanName,'.flp'];

% Open a text file to write floorplan information
fid     = fopen(filename,'w');

% Floorplan header
fprintf(fid,'%s\r\n','Format type:keyword version: 1.1.0');
fprintf(fid,'%s\r\n',['begin_<floorplan>',floorplanName]);

% Floorplan location Information
fprintf(fid,'%s\r\n','begin_<reference>');
fprintf(fid,'%s\r\n','cartesian');
fprintf(fid,'%s\r\n','longitude 0.000000000000000');
fprintf(fid,'%s\r\n','latitude 0.000000000000000');
fprintf(fid,'%s\r\n','visible no');
fprintf(fid,'%s\r\n','sealevel');
fprintf(fid,'%s\r\n','end_<reference>');

% Wall material properties
getMaterialdefinitions('wall',fid);
getMaterialdefinitions('ceiling',fid);

% Write walls in the floorplan
getFaces(Coor,faceType,materialFlag,fid);

fclose(fid);

% Function to write the wall
function getFaces(Coor,faceType,materialFlag,fid)
fprintf(fid,'%s\r\n','begin_<structure_group>');
fprintf(fid,'%s\r\n','begin_<structure>');
fprintf(fid,'%s\r\n','begin_<sub_structure>');
for iField = 1:length(materialFlag)
    if strcmp(faceType{iField},'wall')
        faceCoordinates = Coor.(faceType{iField});
        for iEdge = 1:length(faceCoordinates)
            fprintf(fid,'%s\r\n','begin_<face>');
            fprintf(fid,'%s\r\n','double_sided');
            fprintf(fid,'%s\r\n',['Material ',num2str(materialFlag(iField))]);
            fprintf(fid,'%s\r\n',['nVertices ',num2str(length(faceCoordinates{iEdge}))]);
            fprintf(fid,'%f %f %f\r\n',faceCoordinates{iEdge});
            fprintf(fid,'%s\r\n','end_<face>');
        end
    else if strcmp(faceType{iField},'floor')
            faceCoordinates = Coor.(faceType{iField});
            fprintf(fid,'%s\r\n','begin_<face>');
            fprintf(fid,'%s\r\n','double_sided');
            fprintf(fid,'%s\r\n',['Material ',num2str(materialFlag(iField))]);
            fprintf(fid,'%s\r\n',['nVertices ','4']);
            fprintf(fid,'%f %f %f\r\n',faceCoordinates);
            fprintf(fid,'%s\r\n','end_<face>');
    else if strcmp(faceType{iField},'ceiling')
            faceCoordinates = Coor.(faceType{iField});
            fprintf(fid,'%s\r\n','begin_<face>');
            fprintf(fid,'%s\r\n','invisible');
            fprintf(fid,'%s\r\n','double_sided');
            fprintf(fid,'%s\r\n',['Material ',num2str(materialFlag(iField))]);
            fprintf(fid,'%s\r\n',['nVertices ','4']);
            fprintf(fid,'%f %f %f\r\n',faceCoordinates);
            fprintf(fid,'%s\r\n','end_<face>');
    end
    end
    end
end

fprintf(fid,'%s\r\n','end_<sub_structure>');
fprintf(fid,'%s\r\n','end_<structure>');
fprintf(fid,'%s\r\n','end_<structure_group>');
fprintf(fid,'%s\r\n','begin_<editorSettings>');
fprintf(fid,'%s\r\n','floor_height 0.0000000000');
fprintf(fid,'%s\r\n','ceiling_height 3.0000000000');
fprintf(fid,'%s\r\n','heights_set 0');
fprintf(fid,'%s\r\n','end_<editorSettings>');
fprintf(fid,'%s\r\n','end_<floorplan>');
end

% Material Property Definitions
function getMaterialdefinitions(materialType,fid)
if strcmp(materialType,'wall') || strcmp(materialType,'floor')
    materialName        = 'ITU Concrete 28 GHz';
    materialIndex       = '3';
    colorMaterial       = [0.75,0.82,0.81,1,5];
    diffuseScattering   = 0.2;

    % Conductivity, Permittivity, Roughness, Thickness
    dielectricProperty  = [4.838e-01,5.31,0,3e-1];

    % Write the material properties to the floorplan file
    writeMaterial(materialName,materialIndex,colorMaterial,diffuseScattering,dielectricProperty,fid);
elseif strcmp(materialType,'ceiling')
    materialName        = 'ITU Ceiling borad 28 GHz';
    materialIndex       = '4';
    colorMaterial       = [0.89,0.89,0.89,1,5];
    diffuseScattering   = 0;

    % Conductivity, Permittivity, Roughness, Thickness
    dielectricProperty  = [2.413e-2,1.5,0,9.5e-3];

    % Write the material properties to the floorplan file
    writeMaterial(materialName,materialIndex,colorMaterial,diffuseScattering,dielectricProperty,fid);
end
end

% Write Material Properties
function writeMaterial(materialName,materialIndex,colorMaterial,diffuseScattering,dielectricProperty,fid)
fprintf(fid,'%s\r\n',['begin_<Material> ',materialName]);
fprintf(fid,'%s\r\n',['Material ',materialIndex]);
fprintf(fid,'%s\r\n','LayeredDielectric');
fprintf(fid,'%s\r\n','begin_<Color>');
fprintf(fid,'%s\r\n',['ambient ',num2str(colorMaterial(1)),' ',num2str(colorMaterial(2)),...
    ' ',num2str(colorMaterial(3)),' ',num2str(colorMaterial(4))]);
fprintf(fid,'%s\r\n',['diffuse ',num2str(colorMaterial(1)),' ',num2str(colorMaterial(2)),...
    ' ',num2str(colorMaterial(3)),' ',num2str(colorMaterial(4))]);
fprintf(fid,'%s\r\n',['specular ',num2str(colorMaterial(1)),' ',num2str(colorMaterial(2)),...
    ' ',num2str(colorMaterial(3)),' ',num2str(colorMaterial(4))]);
fprintf(fid,'%s\r\n','emission 0.000000 0.000000 0.000000 0.000000');
fprintf(fid,'%s\r\n',['shininess ',num2str(colorMaterial(5))]);
fprintf(fid,'%s\r\n','end_<Color>');
fprintf(fid,'%s\r\n','diffuse_scattering_model none');
fprintf(fid,'%s\r\n',['fields_diffusively_scattered ',num2str(diffuseScattering)]);
fprintf(fid,'%s\r\n','cross_polarized_power 0.400000');
fprintf(fid,'%s\r\n','directive_alpha 4');
fprintf(fid,'%s\r\n','directive_beta 4');
fprintf(fid,'%s\r\n','directive_lambda 0.750000');
fprintf(fid,'%s\r\n','subdivide_facets yes');
fprintf(fid,'%s\r\n','reflection_coefficient_options do_not_use');
fprintf(fid,'%s\r\n','nLayers 1');
fprintf(fid,'%s\r\n','begin_<DielectricLayer>');
fprintf(fid,'%s\r\n',['conductivity ',num2str(dielectricProperty(1))]);
fprintf(fid,'%s\r\n',['permittivity ',num2str(dielectricProperty(2))]);
fprintf(fid,'%s\r\n',['roughness ',num2str(dielectricProperty(3))]);
fprintf(fid,'%s\r\n',['thickness ',num2str(dielectricProperty(4))]);
fprintf(fid,'%s\r\n','end_<DielectricLayer>');
fprintf(fid,'%s\r\n','end_<Material>');
end