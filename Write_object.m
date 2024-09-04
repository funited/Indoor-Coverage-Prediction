%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script is to generate the coordinates of the furniture in the room,
% with the output of the rectangle furniture: [x y width height]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
iFile = 1;
while iFile < 2
% Define the room and constraints
CompactCoef = 0.1; % Make sure the objects do not appear outside of the rx grid
xMin = 0.11+CompactCoef; yMin = -2.81+CompactCoef;
xMax = 17.59-CompactCoef; yMax = 7.2-CompactCoef;
NoflyZoneLength = 1.5; % A smalle area in the middle of the room where no objects allowed to appear
middleSquare = [(xMax+xMin)/2 - NoflyZoneLength/2, (yMax+yMin)/2 - NoflyZoneLength/2, NoflyZoneLength, NoflyZoneLength]; % Middle area to avoid
gap = 0.5; % Minimum gap between objects

% Define parameters for rectangles and squares
numRectangles = 8;
minEdgeRect = 0.8; maxEdgeRect = 2;
numSquares = 3;
minEdgeSquare = 1; maxEdgeSquare = 1.6;
numVertexSqr = 22;

% Initialize arrays to store the positions and sizes of rectangles and squares
rectangles = zeros(numRectangles, 4); % [x, y, width, height]
boundingBox = zeros(numSquares, 4); % [x, y, edge, edge] for uniformity

% Define the height and thickness of objects 
rctngl.height = 0.2;
rctngl.thickness = 1.0;
sqr_height = 0.2;
sqr_thickness = 1.0;

% Function to place rectangles and squares
% Ensures no overlap, maintains gap, avoids the central area, and fits within boundaries
for i = 1:numRectangles
    placed = false;
    while ~placed
        width = minEdgeRect + (maxEdgeRect - minEdgeRect) * rand();
        height = minEdgeRect + (maxEdgeRect - minEdgeRect) * rand();
        [rect, success] = placeObject(xMin, yMin, xMax, yMax, width, height, [rectangles(1:i-1,:); boundingBox], middleSquare, gap);
        if success
            rectangles(i,:) = rect;
            placed = true;
        end
    end
end

for i = 1:numSquares
    placed = false;
    while ~placed
        edge = minEdgeSquare + (maxEdgeSquare - minEdgeSquare) * rand();
        [boundingbox, success] = placeObject(xMin, yMin, xMax, yMax, edge, edge, [rectangles; boundingBox(1:i-1,:)], middleSquare, gap);
        if success
            boundingBox(i,:) = boundingbox;
            placed = true;
        end
    end
end

% % Visualization
% figure; hold on; axis equal;
% xlim([xMin, xMax]); ylim([yMin, yMax]);
% rectangle('Position', [xMin, yMin, xMax-xMin, yMax-yMin], 'EdgeColor', 'k'); % Room boundary
% rectangle('Position', middleSquare, 'EdgeColor', 'r', 'LineStyle', '--'); % Middle area to avoid
% for i = 1:numRectangles
%     rectangle('Position', rectangles(i,:), 'EdgeColor', 'b');
% end
% for i = 1:numSquares
%     rectangle('Position', [boundingBox(i,1), boundingBox(i,2), boundingBox(i,3), boundingBox(i,4)], 'EdgeColor', 'g');
% end
% hold off;

%% write the coordinates of the rectangles
for i = 1:numRectangles
    % rectangle('Position', rectangles(i, :), 'EdgeColor', 'r');
    % The 1st face of the rectangle
    Coor.rectangle{i}(:,1,1) = [rectangles(i,1) rectangles(i,2)+ rectangles(i,4) rctngl.height+rctngl.thickness];
    Coor.rectangle{i}(:,2,1) = [rectangles(i,1) + rectangles(i,3) rectangles(i,2)+ rectangles(i,4) rctngl.height+rctngl.thickness];
    Coor.rectangle{i}(:,3,1) = [rectangles(i,1) + rectangles(i,3) rectangles(i,2)+ rectangles(i,4) rctngl.height];
    Coor.rectangle{i}(:,4,1) = [rectangles(i,1) rectangles(i,2)+ rectangles(i,4) rctngl.height];
    % The 2nd face of the rectangle
    Coor.rectangle{i}(:,1,2) = [rectangles(i,1) rectangles(i,2) rctngl.height+rctngl.thickness];
    Coor.rectangle{i}(:,2,2) = [rectangles(i,1) rectangles(i,2) + rectangles(i,4) rctngl.height+rctngl.thickness];
    Coor.rectangle{i}(:,3,2) = [rectangles(i,1) rectangles(i,2) + rectangles(i,4) rctngl.height];
    Coor.rectangle{i}(:,4,2) = [rectangles(i,1) rectangles(i,2) rctngl.height];
    % The 3rd face of the rectangle
    Coor.rectangle{i}(:,1,3) = [rectangles(i,1) + rectangles(i,3) rectangles(i,2) rctngl.height+rctngl.thickness];
    Coor.rectangle{i}(:,2,3) = [rectangles(i,1) rectangles(i,2) rctngl.height+rctngl.thickness];
    Coor.rectangle{i}(:,3,3) = [rectangles(i,1) rectangles(i,2) rctngl.height];
    Coor.rectangle{i}(:,4,3) = [rectangles(i,1) + rectangles(i,3) rectangles(i,2) rctngl.height];
    % The 4th face of the rectangle
    Coor.rectangle{i}(:,1,4) = [rectangles(i,1) + rectangles(i,3) rectangles(i,2) + rectangles(i,4) rctngl.height+rctngl.thickness];
    Coor.rectangle{i}(:,2,4) = [rectangles(i,1) + rectangles(i,3) rectangles(i,2) rctngl.height+rctngl.thickness];
    Coor.rectangle{i}(:,3,4) = [rectangles(i,1) + rectangles(i,3) rectangles(i,2) rctngl.height];
    Coor.rectangle{i}(:,4,4) = [rectangles(i,1) + rectangles(i,3) rectangles(i,2) + rectangles(i,4) rctngl.height];
    % The 5th face of the rectangle
    Coor.rectangle{i}(:,1,5) = [rectangles(i,1) rectangles(i,2) + rectangles(i,4) rctngl.height+rctngl.thickness];
    Coor.rectangle{i}(:,2,5) = [rectangles(i,1) rectangles(i,2) rctngl.height+rctngl.thickness];
    Coor.rectangle{i}(:,3,5) = [rectangles(i,1) + rectangles(i,3) rectangles(i,2) rctngl.height+rctngl.thickness];
    Coor.rectangle{i}(:,4,5) = [rectangles(i,1) + rectangles(i,3) rectangles(i,2) + rectangles(i,4) rctngl.height+rctngl.thickness];
    % The 6th face of the rectangle
    Coor.rectangle{i}(:,1,6) = [rectangles(i,1) + rectangles(i,3) rectangles(i,2) + rectangles(i,4) rctngl.height];
    Coor.rectangle{i}(:,2,6) = [rectangles(i,1) + rectangles(i,3) rectangles(i,2) rctngl.height];
    Coor.rectangle{i}(:,3,6) = [rectangles(i,1) rectangles(i,2) rctngl.height];
    Coor.rectangle{i}(:,4,6) = [rectangles(i,1) rectangles(i,2) + rectangles(i,4) rctngl.height];
end

% rectangle('Position', [middle_x, middle_y, middle_width, middle_height], 'EdgeColor', 'b', 'LineWidth', 2); % Draw the middle area
% axis([x_min x_max y_min y_max]);
% grid on;

%% Write the coordinates of the squares
for iSqr = 1:numSquares
    coordinates_sqaure = Square2Circle(boundingBox(iSqr,1),boundingBox(iSqr,2),boundingBox(iSqr,3)/2,numVertexSqr);
    Coor.sqaureside{iSqr}(:,1,1) = [coordinates_sqaure(1,1) coordinates_sqaure(1,2) sqr_height+sqr_thickness];
    Coor.sqaureside{iSqr}(:,2,1) = [coordinates_sqaure(numVertexSqr,1) coordinates_sqaure(numVertexSqr,2) sqr_height+sqr_thickness];
    Coor.sqaureside{iSqr}(:,3,1) = [coordinates_sqaure(numVertexSqr,1) coordinates_sqaure(numVertexSqr,2) sqr_height];
    Coor.sqaureside{iSqr}(:,4,1) = [coordinates_sqaure(1,1) coordinates_sqaure(1,2) sqr_height];
    for jSqrSide = 2:numVertexSqr
        Coor.sqaureside{iSqr}(:,1,jSqrSide) = [coordinates_sqaure(jSqrSide,1) coordinates_sqaure(jSqrSide,2) sqr_height+sqr_thickness];
        Coor.sqaureside{iSqr}(:,2,jSqrSide) = [coordinates_sqaure(jSqrSide-1,1) coordinates_sqaure(jSqrSide-1,2) sqr_height+sqr_thickness];
        Coor.sqaureside{iSqr}(:,3,jSqrSide) = [coordinates_sqaure(jSqrSide-1,1) coordinates_sqaure(jSqrSide-1,2) sqr_height];
        Coor.sqaureside{iSqr}(:,4,jSqrSide) = [coordinates_sqaure(jSqrSide,1) coordinates_sqaure(jSqrSide,2) sqr_height];
    end
    for isqrvtx=1:numVertexSqr
        Coor.squaretop{iSqr}(:,isqrvtx) = [coordinates_sqaure(isqrvtx,1) coordinates_sqaure(isqrvtx,2) sqr_height+sqr_thickness];
        Coor.squarebtm{iSqr}(:,isqrvtx) = [coordinates_sqaure(numVertexSqr-isqrvtx+1,1) coordinates_sqaure(numVertexSqr-isqrvtx+1,2) sqr_height];
    end
end

% Identify whether the coordinaters of the faces correspond to walls,
% doors or windows
faceType        = fields(Coor);
% Initiate floorplan name and filename
% cd 'C:\Users\zqf5070\Desktop\InXCh\Matlab\Channel_Estimation\CNN\CNN_Furniture\GenerateFurniturePlan\FurniturePlans_1.0';
cd 'C:\Users\zqf5070\Desktop\InXCh\Matlab\Channel_Estimation\CNN\CNN_Furniture\GenerateFurniturePlan';
floorplanName   = sprintf('Mixed Furniture_%03d',iFile);
filename        = [floorplanName,'.object'];
iFile = iFile+1;
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

% Write Material information
getMaterialdefinitions(0,fid)
getMaterialdefinitions(1,fid)
getMaterialdefinitions(2,fid)

% Face location information
getFaces_rectangle(Coor,fid);
getfaces_square(Coor,fid)

% Object footer
fprintf(fid,'%s\r\n','begin_<ControlVectors>');
fprintf(fid,'%s\r\n','CVsVisible no');
fprintf(fid,'%s\r\n','Stippled yes');
fprintf(fid,'%s\r\n','CVsThickness 3');
fprintf(fid,'%s\r\n','CVxLength 10.0000000000');
fprintf(fid,'%s\r\n','CVyLength 10.0000000000');
fprintf(fid,'%s\r\n','CVzLength 10.0000000000');
fprintf(fid,'%s\r\n','CVsXaxis 1.0000000000 0.0000000000 0.0000000000');
fprintf(fid,'%s\r\n','CVsZaxis 0.0000000000 0.0000000000 1.0000000000');
fprintf(fid,'%s\r\n','end_<ControlVectors>');
fprintf(fid,'%s\r\n','end_<object>');

fclose(fid);
cd ..
end


%% All the Functions to be used
% Write Face Vertex Locations of rectangles 
function getFaces_rectangle(Coor,fid)

faces = Coor.rectangle;
for iFace = 1:length(faces)
    materialFlag = randi([0, 2]);
    faceCoordinates = faces{1,iFace};
    fprintf(fid,'%s\r\n','begin_<structure_group>');
    fprintf(fid,'%s\r\n','begin_<structure>');
    fprintf(fid,'%s\r\n','begin_<sub_structure>');
    for iEdge = 1:length(faceCoordinates)
        fprintf(fid,'%s\r\n','begin_<face>');
        % fprintf(fid,'%s\r\n','double_sided');
        fprintf(fid,'%s\r\n',['Material ',num2str(materialFlag)]);
        fprintf(fid,'%s\r\n',['nVertices ',num2str(length(faceCoordinates(:,:,iEdge)))]);
        fprintf(fid,'%f %f %f\r\n',faceCoordinates(:,:,iEdge));
        fprintf(fid,'%s\r\n','end_<face>');
    end
    fprintf(fid,'%s\r\n','end_<sub_structure>');
    fprintf(fid,'%s\r\n','end_<structure>');
    fprintf(fid,'%s\r\n','end_<structure_group>');
end

% fprintf(fid,'%s\r\n','end_<floorplan>');
end

% Write Face Vertex Locations of squares
function getfaces_square(Coor,fid)

sqrsidefaces = Coor.sqaureside;
sqrtopfaces = Coor.squaretop;
sqrbtmfaces = Coor.squarebtm;

for iFace = 1:length(sqrsidefaces)
    materialFlag = randi([0, 1]);
    faceCoordinates = sqrsidefaces{1,iFace};
    fprintf(fid,'%s\r\n','begin_<structure_group>');
    fprintf(fid,'%s\r\n','begin_<structure>');
    fprintf(fid,'%s\r\n','begin_<sub_structure>');
    for iEdge = 1:length(faceCoordinates)
        fprintf(fid,'%s\r\n','begin_<face>');
        % fprintf(fid,'%s\r\n','double_sided');
        fprintf(fid,'%s\r\n',['Material ',num2str(materialFlag)]);
        fprintf(fid,'%s\r\n',['nVertices ','4']);
        fprintf(fid,'%f %f %f\r\n',faceCoordinates(:,:,iEdge));
        fprintf(fid,'%s\r\n','end_<face>');
    end
    fprintf(fid,'%s\r\n','begin_<face>');
    % fprintf(fid,'%s\r\n','double_sided');
    fprintf(fid,'%s\r\n',['Material ',num2str(materialFlag)]);
    fprintf(fid,'%s\r\n',['nVertices ',num2str(length(sqrtopfaces{1}))]);
    for itop = 1:length(sqrtopfaces{1})
        fprintf(fid,'%f %f %f\r\n',sqrtopfaces{iFace}(:,itop));
    end
    fprintf(fid,'%s\r\n','end_<face>');
    fprintf(fid,'%s\r\n','begin_<face>');
    % fprintf(fid,'%s\r\n','double_sided');
    fprintf(fid,'%s\r\n',['Material ',num2str(materialFlag)]);
    fprintf(fid,'%s\r\n',['nVertices ',num2str(length(sqrbtmfaces{1}))]);
    for ibtm = 1:length(sqrbtmfaces{1})
        fprintf(fid,'%f %f %f\r\n',sqrbtmfaces{iFace}(:,ibtm));
    end
    fprintf(fid,'%s\r\n','end_<face>');
    fprintf(fid,'%s\r\n','end_<sub_structure>');
    fprintf(fid,'%s\r\n','end_<structure>');
    fprintf(fid,'%s\r\n','end_<structure_group>');
end

% fprintf(fid,'%s\r\n','end_<floorplan>');
end

% Material Property Definitions
% function getMaterialdefinitions(materialFlag,fid)
% 
% if materialFlag == 0
%     materialName        = 'ITU Plasterboard 5 GHz';
%     materialIndex       = '0';
%     colorMaterial       = [0.7529,0.7529,0.7529,1,50];
%     diffuseScattering   = 0.2;
% 
%     % Conductivity, Permittivity, Roughness, Thickness
%     dielectricProperty  = [1.226e-1,2.94,0,3e-2];
% 
%     % Write the material properties to the floorplan file
%     writeMaterial(materialName,materialIndex,colorMaterial,diffuseScattering,dielectricProperty,fid);
% 
% elseif materialFlag == 1
%     materialName        = 'ITU Wood 5 GHz';
%     materialIndex       = '1';
%     colorMaterial       = [0.73,0.38,0.17,1,50];
%     diffuseScattering   = 0.03;
% 
%     % Conductivity, Permittivity, Roughness, Thickness
%     dielectricProperty  = [1.672e-1,1.99,0,3e-2];
% 
%     % Write the material properties to the floorplan file
%     writeMaterial(materialName,materialIndex,colorMaterial,diffuseScattering,dielectricProperty,fid);
% 
% elseif materialFlag == 2
%     materialName        = 'ITU Chipboard  5 GHz';
%     materialIndex       = '2';
%     colorMaterial       = [1,0.50,0,1.0,50];
%     diffuseScattering   = 0;
% 
%     % Conductivity, Permittivity, Roughness, Thickness
%     dielectricProperty  = [2.919e-1,2.58,0,3e-3];
% 
%     % Write the material properties to the floorplan file
%     writeMaterial(materialName,materialIndex,colorMaterial,diffuseScattering,dielectricProperty,fid);
% end
% end
function getMaterialdefinitions(materialFlag,fid)

if materialFlag == 0
    materialName        = 'ITU Plasterboard 28 GHz';
    materialIndex       = '0';
    colorMaterial       = [0.7529,0.7529,0.7529,1,50];
    diffuseScattering   = 0.2;

    % Conductivity, Permittivity, Roughness, Thickness
    dielectricProperty  = [1.226e-1,2.94,0,3e-2];

    % Write the material properties to the floorplan file
    writeMaterial(materialName,materialIndex,colorMaterial,diffuseScattering,dielectricProperty,fid);

elseif materialFlag == 1
    materialName        = 'ITU Wood 28 GHz';
    materialIndex       = '1';
    colorMaterial       = [0.73,0.38,0.17,1,50];
    diffuseScattering   = 0.03;

    % Conductivity, Permittivity, Roughness, Thickness
    dielectricProperty  = [1.672e-1,1.99,0,3e-2];

    % Write the material properties to the floorplan file
    writeMaterial(materialName,materialIndex,colorMaterial,diffuseScattering,dielectricProperty,fid);

elseif materialFlag == 2
    materialName        = 'ITU Chipboard  28 GHz';
    materialIndex       = '2';
    colorMaterial       = [1,0.50,0,1.0,50];
    diffuseScattering   = 0;

    % Conductivity, Permittivity, Roughness, Thickness
    dielectricProperty  = [2.919e-1,2.58,0,3e-3];

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

%% Helper functions
function [object, isPlaced] = placeObject(xMin, yMin, xMax, yMax, objWidth, objHeight, existingObjects, middleSquare, gap)
    maxAttempts = 1000;
    for attempt = 1:maxAttempts
        x = xMin + (xMax - xMin - objWidth) * rand();
        y = yMin + (yMax - yMin - objHeight) * rand();
        newObj = [x, y, objWidth, objHeight];
        if ~isInMiddleArea(newObj, middleSquare) && all(isSeparated(newObj, existingObjects, gap))
            object = newObj;
            isPlaced = true;
            return;
        end
    end
    object = [0, 0, 0, 0];
    isPlaced = false;
end

function isInMiddle = isInMiddleArea(obj, middleSquare)
    isInMiddle = ~(obj(1) + obj(3) < middleSquare(1) || obj(1) > middleSquare(1) + middleSquare(3) || ...
                   obj(2) + obj(4) < middleSquare(2) || obj(2) > middleSquare(2) + middleSquare(4));
end

function isSeparated = isSeparated(newObj, existingObjects, gap)
    isSeparated = true;
    for i = 1:size(existingObjects,1)
        existingObj = existingObjects(i,:);
        if ~(newObj(1) + newObj(3) + gap <= existingObj(1) || newObj(1) >= existingObj(1) + existingObj(3) + gap || ...
             newObj(2) + newObj(4) + gap <= existingObj(2) || newObj(2) >= existingObj(2) + existingObj(4) + gap)
            isSeparated = false;
            return;
        end
    end
end

function Coor_Square = Square2Circle(x_leftbtm,y_leftbtm,r,n)
% Parameters
x_center = x_leftbtm+r; % x coordinate of the circle's center
y_center = y_leftbtm+r; % y coordinate of the circle's center
radius = r; % Radius of the circle.
total_angle = 360; % Total angle for a full circle
delta_angle = total_angle/(n); % Sampling angle in degrees


% Convert angles from degrees to radians for MATLAB functions
delta_angle_rad = deg2rad(delta_angle);
total_angle_rad = deg2rad(total_angle);

% Initialize the array to store the coordinates
Coor_Square = [];

% Loop through angles from 0 to 360 degrees (in radians)
for angle_rad = 0:delta_angle_rad:total_angle_rad-delta_angle_rad
    % Calculate the coordinates
    x = x_center + radius * cos(angle_rad);
    y = y_center + radius * sin(angle_rad);

    % Append the coordinates to the array
    Coor_Square = [Coor_Square; [x, y]];
end
end

