function eq_img = hist_equalization(img)
    intensity_levels = 256;
    img_size = size(img);

    % compute the image CDF
    img_cdf = compute_cdf(img, intensity_levels);  % <= this function needs to be also implemented!
    
    % equalize the image
    eq_img = zeros(img_size);

    cdf_size = size(img_cdf);

    out = zeros(intensity_levels, 1);
    for i = 1:cdf_size(2)
        out(i) = round(img_cdf(i) * 255);
    end

    for i = 1:img_size(1)
        for j = 1:img_size(2)
            eq_img(i,j) = out(img(i,j) * 255 + 1);
        end
    end

    eq_img = eq_img / 255;
    
    % TODO: implement the histogram equalization algorithm here (DONE !)
end