function [img_hist] = compute_hist(img, intensity_levels)
%COMPUTE_HIST Summary of this function goes here
%   Detailed explanation goes here
    if ~exist('intensity_levels', 'var')
        intensity_levels = 256;
    end
    
    % Convert the image to a column vector
    data = img(:);

    % Calculate bin width
    bin_width = 1/intensity_levels;

    % Calculate bin centers
    bin_centers = (bin_width/2):bin_width:(1-(bin_width/2));

    % Initialize histogram values
    img_hist = zeros(1, intensity_levels);

    % Count occurrences in each bin
    for i = 1:intensity_levels
        img_hist(i) = sum(data >= (bin_centers(i) - bin_width/2) & data < (bin_centers(i) + bin_width/2));
    end

    % Normalize the histogram
    img_hist = img_hist / (bin_width * length(data));
    
    % TODO: implement histogram computation (DONE !)
end

