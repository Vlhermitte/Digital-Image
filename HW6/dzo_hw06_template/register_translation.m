function [im2_registered, im_corr] = register_translation(im1, im2)
%REGISTER_TRANSLATION Translate im2 such that it becomes close to im1.
% First estimate the relative translation between the two images. Then 
% apply translation function with estimated translation vector on im2.
[M, N] = size(im2);
blank_val = 128;

% TODO: use "phase_corr" function to get relative translation between
%       the two input images, keep the correlation map from 
%       "phase_corr" in im_corr variable for visualization

[dx, dy, im_corr] = phase_corr(im1, im2);


% TODO: use "translation" and "bilinear" functions and translate im2 by 
%       the computed values
im2_registered = uint8(zeros(M,N));

tx = dy;
ty = dx;

for i = 1:M
    for j = 1:N
        % Compute the coordinates in the source image
        src_x = i - tx;
        src_y = j - ty;
        
        % Check if the coordinates are within the image borders
        if src_x >= 1 && src_x <= size(im1, 1) && src_y >= 1 && src_y <= size(im1, 2)
            % If within borders, use bilinear interpolation
            im2_registered(i, j) = bilinear(im1, src_x, src_y, blank_val);
        else
            % If outside borders, set the pixel value to blank_val
            im2_registered(i, j) = blank_val;
        end
    end
end

end