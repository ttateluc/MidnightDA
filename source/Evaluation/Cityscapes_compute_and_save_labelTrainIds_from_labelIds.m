% Licensed under the CC BY-NC 4.0 license (https://creativecommons.org/licenses/by-nc/4.0/)
function Cityscapes_compute_and_save_labelTrainIds_from_labelIds(...
    labelIds_directory, labelTrainIds_directory)

output_format = '.png';

current_script_full_name = mfilename('fullpath');
current_script_directory = fileparts(current_script_full_name);
addpath(fullfile(current_script_directory, '..', 'utilities'));
file_names = file_full_names_in_directory(strcat(labelIds_directory,...
    filesep));
number_of_images = length(file_names);

% Create output directory where modified ground truth images will be saved, if
% it does not already exist.
if exist(labelTrainIds_directory) ~= 7
    mkdir(labelTrainIds_directory);
end

% Loop over all input ground truth images to compute and save the modified
% ground truth images in Cityscapes format.
for i = 1:number_of_images
    % Transform the labels.
    image_labelIds = imread(file_names{i});
    image_labelTrainIds = cityscapes_labelIds2labelTrainIds(image_labelIds);
    
    % Save the label image with label IDs in the output directory.
    [~, image_labelTrainIds_name] = fileparts(file_names{i});
    imwrite(image_labelTrainIds, fullfile(labelTrainIds_directory,...
        strcat(image_labelTrainIds_name, output_format)));
end

end
