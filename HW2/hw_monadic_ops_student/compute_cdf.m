function [img_cdf] = compute_cdf(img, intensity_levels)
%COMPUTE_CDF Summary of this function goes here
%   Detailed explanation goes here
    if ~exist('intensity_levels', 'var')
        intensity_levels = 256;
    end
    
    % TODO - replace the line below with computation of the image CDF:
    % img_cdf = linspace(0, 1, intensity_levels);  % <= to be replaced
    

    img_hist = compute_hist(img, intensity_levels);

    % Initialize CDF values
    img_cdf = zeros(1, intensity_levels);

    img_pdf = img_hist / sum(img_hist);

    % Accumulate histogram values to compute CDF
    cumulative_sum = 0;
    for i = 1:intensity_levels
        cumulative_sum = cumulative_sum + img_pdf(i);
        img_cdf(i) = cumulative_sum;
    end

end

