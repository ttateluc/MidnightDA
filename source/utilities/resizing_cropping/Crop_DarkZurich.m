% Licensed under the CC BY-NC 4.0 license (https://creativecommons.org/licenses/by-nc/4.0/)
function Crop_DarkZurich(task_id, dataset_split, crop_coords,...
    crop_attributes_suffix, output_root_directory, images_per_task)
%CROP_DARKZURICH  Crop a batch of images from Dark Zurich
%and write the results. Structured for execution on a cluster.
%   INPUTS:
%
%   -|task_id|: ID of the task. Used to determine which images out of the entire
%    dataset will form the batch that will be processed by this task.
%
%   -|dataset_split|: string that indicates which subset of Dark Zurich is used
%    for taking the crops, e.g. 'train', 'test'.
%
%   -|crop_coords|: 1-by-4 matrix with crop coordinates in image coordinate
%   system and in format [top, left, bottom, right]. Common for all processed
%   images in the batch.
%
%   -|crop_attributes_suffix|: string containing attribute of taken crop, e.g.,
%   'center', 'left'.
%
%   -|output_root_directory|: full path to directory under which the results of 
%    the simulation are written.
%
%   -|images_per_task|: maximum number of images for which fog simulation is run
%    in each task.
%    8377 train Dark Zurich images -> 200 images per task * 42 tasks.
%    8377 train Dark Zurich images -> 400 images per task * 21 tasks.
%    302 test Dark Zurich images -> 30 images per task * 11 tasks.

if ischar(task_id)
    task_id = str2double(task_id);
end

% ------------------------------------------------------------------------------

% Add paths.

current_script_full_name = mfilename('fullpath');
current_script_directory = fileparts(current_script_full_name);
% Add path to |utilities| directory.
addpath(fullfile(current_script_directory, '..'));

% ------------------------------------------------------------------------------

% Create lists of input files for specified split.

Dark_Zurich_root_directory = fullfile(current_script_directory, '..',...
    '..', '..', 'data', 'Dark_Zurich');
Dark_Zurich_file_lists_directory = fullfile(Dark_Zurich_root_directory,...
    'lists_file_names');

% Base relative path components.
switch dataset_split
    case 'train'
        % Define list files.
        list_of_day_images_file = 'train_day_filenames.txt';
        list_of_twilight_images_file = 'train_twilight_filenames.txt';
        list_of_night_images_file = 'train_night_filenames.txt';
        % Read list files.
        fid = fopen(fullfile(Dark_Zurich_file_lists_directory,...
            list_of_day_images_file));
        day_image_base_rel_paths = textscan(fid, '%s');
        fclose(fid);
        day_image_base_rel_paths = day_image_base_rel_paths{1};
        fid = fopen(fullfile(Dark_Zurich_file_lists_directory,...
            list_of_twilight_images_file));
        twilight_image_base_rel_paths = textscan(fid, '%s');
        fclose(fid);
        twilight_image_base_rel_paths = twilight_image_base_rel_paths{1};
        fid = fopen(fullfile(Dark_Zurich_file_lists_directory,...
            list_of_night_images_file));
        night_image_base_rel_paths = textscan(fid, '%s');
        fclose(fid);
        night_image_base_rel_paths = night_image_base_rel_paths{1};
        % Concatenate all lists into one global list.
        image_base_rel_paths = [day_image_base_rel_paths;
                                twilight_image_base_rel_paths;
                                night_image_base_rel_paths];
    case 'test'
        % Define list files.
        list_of_test_images_file = 'test_filenames.txt';
        list_of_test_ref_images_file = 'test_ref_filenames.txt';
        % Read list files.
        fid = fopen(fullfile(Dark_Zurich_file_lists_directory,...
            list_of_test_images_file));
        test_image_base_rel_paths = textscan(fid, '%s');
        fclose(fid);
        test_image_base_rel_paths = test_image_base_rel_paths{1};
        fid = fopen(fullfile(Dark_Zurich_file_lists_directory,...
            list_of_test_ref_images_file));
        test_ref_image_base_rel_paths = textscan(fid, '%s');
        fclose(fid);
        test_ref_image_base_rel_paths = test_ref_image_base_rel_paths{1};
        % Concatenate all lists into one global list.
        image_base_rel_paths = [test_image_base_rel_paths;
                                test_ref_image_base_rel_paths];
end

image_file_names =...
    fullfile(Dark_Zurich_root_directory, 'rgb_anon',...
    strcat(image_base_rel_paths, '_rgb_anon.png'));

number_of_images = length(image_file_names);

% ------------------------------------------------------------------------------

% Determine current batch.

% Determine the set of images that are to be processed in the current task.
batch_ind = (task_id - 1) * images_per_task + 1:task_id * images_per_task; 
if batch_ind(1) > number_of_images
    return;
end
if batch_ind(end) > number_of_images
    % Truncate for last task.
    batch_ind = batch_ind(1:number_of_images - batch_ind(1) + 1);
end

% ------------------------------------------------------------------------------

% Output specifications.

% Specify output format for cropped images.
output_format = '.png';

% Determine initial part of the path of output files.

output_directories_basename = strcat('rgb_anon_crop_', crop_attributes_suffix);
output_crop_directory =...
    fullfile(output_root_directory, output_directories_basename);

% ------------------------------------------------------------------------------

% Run cropping on current batch using the specified settings.

crop_DarkZurich_batch(image_file_names(batch_ind), crop_coords,...
    output_crop_directory, crop_attributes_suffix, output_format);

end

