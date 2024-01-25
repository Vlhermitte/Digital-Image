function img_matched = match_hists(img, img_target, intensity_levels)
    if ~exist('intensity_levels', 'var')
        intensity_levels = 256;
    end
    
    img_size = size(img);
    
    % get both CDFs
    % TODO
    
    % create histogram matching lookup table
    matching_lut = zeros(intensity_levels, 1);
    % TODO
    
    % match the histograms    
    % img_matched = img;  % TODO: replace with a histogram matching algorithm

    img_cdf = compute_cdf(img, intensity_levels);
    img_target_cdf = compute_cdf(img_target, intensity_levels);

    for i = 1:intensity_levels
        [~,ind] = min(abs(img_cdf(i) - img_target_cdf));
        matching_lut(i) = ind - 1;
    end

    img_matched = zeros(img_size);

    for i = 1:img_size(1)
        for j = 1:img_size(2)
            img_matched(i,j) = matching_lut((img(i,j) * 255) + 1);
        end
    end
    
    img_matched = img_matched / 255;
end
