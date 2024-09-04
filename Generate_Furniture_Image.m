% Define the triangle vertices in a cell array
for i=1:length(extractedLinesGroups)
   furniture_plan_vertices = extractedLinesGroups{i};
   for j=1:length(furniture_plan_vertices)
       triangle_vertices_cells{j} = furniture_plan_vertices{j}(:,1:2);
   end
[image] = Plot_FurniturePlan(triangle_vertices_cells);
img_name = ['Triangle_FurniturePlan_',sprintf('%01d',i),'.JPG'];
fullDestinationFileName = fullfile('C:\Users\zqf5070\Desktop\InXCh\Matlab\Channel_Estimation\CNN\CNN_Furniture\FurniturePlan_triangle',img_name);
imwrite(image,fullDestinationFileName);
end

function [image] = Plot_FurniturePlan(triangle_vertices_cells)
% Floorplan boundaries
floor_min_x = 0.19;
floor_max_x = 17.57;
floor_min_y = -2.81;
floor_max_y = 7.16;
% Determine the scaling factor
scale_x = 100; % Scaling factor for x, can be adjusted
scale_y = 100; % Scaling factor for y, can be adjusted

% Calculate the size of the image
img_width = round((floor_max_x - floor_min_x) * scale_x);
img_height = round((floor_max_y - floor_min_y) * scale_y);

% Create a blank image with white background (255)
image = 255 * ones(img_height, img_width);

% Process each set of triangle vertices
for k = 1:length(triangle_vertices_cells)
    vertices = triangle_vertices_cells{k};
    % Scale the vertices
    vertices(:,1) = (vertices(:,1) - floor_min_x) * scale_x;
    % Invert y-axis for MATLAB image coordinates and scale
    vertices(:,2) = (floor_max_y - vertices(:,2)) * scale_y;
    % Draw the triangle on the image by setting pixels to black
    BW = poly2mask(vertices(:,1), vertices(:,2), img_height, img_width);
    image(BW) = 0; % Set the color of the triangle to black
end
end
