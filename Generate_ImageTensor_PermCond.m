% Define floorplan boundaries
floor_min_x = 0.19;
floor_max_x = 17.57;
floor_min_y = -2.81;
floor_max_y = 7.16;

% Define the scaling factor
scale_factor = 100; % Adjust this as needed

% Calculate the size of the floorplan image
img_width = round((floor_max_x - floor_min_x) * scale_factor);
img_height = round((floor_max_y - floor_min_y) * scale_factor);

% Process each block and its material number
for i = 1:length(data_blocks)
    % Initialize the floorplan image to white
    permittivity_img =  ones(img_height, img_width);
    conductivity_img =  zeros(img_height, img_width);
    % Example data_blocks and materialNumbers
    % Assuming data_blocks and materialNumbers are already defined
    for j = 1:length(data_blocks{i})
        % Get the coordinates and material number
        coords = data_blocks{i}{j}(:, 1:2);  % Use only the first two columns
        material_index = materialNumbers{i}(j);

        % Convert material index to value
        permittivity_value = permittivity_values{1}(material_index-1) ;
        conductivity_value = conductivity_values{1}(material_index-1) ;
        % Scale and adjust coordinates
        scaled_coords = (coords - [floor_min_x, floor_min_y]) * scale_factor;
        scaled_coords(:,2) = img_height - scaled_coords(:,2);  % Flip y-axis

        % Create mask for the enclosed area
        BW = poly2mask(scaled_coords(:,1), scaled_coords(:,2), img_height, img_width);

        % Assign pixel values to the enclosed area
        permittivity_img(BW) = permittivity_value;
        conductivity_img(BW) = conductivity_value;
    end
    img_name_permittivity = sprintf('MixedPermittivity_%d.jpg', i);
    fullDestinationFileName_Permittivity = fullfile('C:\Users\zqf5070\Desktop\InXCh\Matlab\Channel_Estimation\CNN\CNN_Furniture\Mixed\Mixed_Permittivity_channel',img_name_permittivity);
    imwrite(uint8(255 * (permittivity_img - min(permittivity_img(:))) / (max(permittivity_img(:)) -min(permittivity_img(:)))), fullDestinationFileName_Permittivity, 'jpg');
    img_name_conductivity = sprintf('MixedConductivity_%d.jpg', i);
    fullDestinationFileName_Conductivity = fullfile('C:\Users\zqf5070\Desktop\InXCh\Matlab\Channel_Estimation\CNN\CNN_Furniture\Mixed\Mixed_Conductivity_channel',img_name_conductivity);
    imwrite(uint8(255 * (conductivity_img - min(conductivity_img(:))) / (max(conductivity_img(:)) -min(conductivity_img(:)))), fullDestinationFileName_Conductivity, 'jpg');
end

% Display the floorplan
imtool(permittivity_img, []);
imtool(conductivity_img, []);