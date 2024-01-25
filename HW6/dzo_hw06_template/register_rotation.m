function [im2_registered, im_corr] = register_rotation(im1, im2)
%REGISTER_ROTATION Rotate im2 so its orientation becomes close to im1.
% First estimate the relative rotation between the two images. Then apply 
% rotation function with estimated rotation angle on im2.
[M,N,~] = size(im2);
cy = M/2;
cx = N/2;
H = min(cx, cy);
blank_val = 128;

% TODO: transform both images into frequency domain (in absolute values), 
%       then use fftshift and apply your "polar_transform" function
im1_fft = fftshift(abs(fft2(im1)));
im2_fft = fftshift(abs(fft2(im2)));

% Apply polar transform
[im1_fft_polar, ~, ~] = polar_transform(im1_fft, cx, cy, H);
[im2_fft_polar, ~, ~] = polar_transform(im2_fft, cx, cy, H);


% visualize the fequency images for debugging
compare_fft_polar(im1_fft, im2_fft, im1_fft_polar, im2_fft_polar);

% TODO: apply the "phase_corr" function on im1_fft_polar and im2_fft_polar
%       and compute the corresponding angle shift (shift along y axis),
%       convert the shift to angle in <-90 deg, 90 deg> interval,
%       keep the correlation map from "phase_corr" in im_corr variable for 
%       later visualization

[dx, dy, im_corr] = phase_corr(im1_fft_polar, im2_fft_polar);

% Convert the shift along y-axis to angle in <-90 deg, 90 deg> interval
angle = atand(dy / dx);

if angle >= 90
    angle = angle - 60;
elseif angle <= -90
    angle = angle + 60;
end

% Ensure the angle is within the specified interval

phi = angle / 180 * pi; % radians

% TODO: use "rotation" and "bilinear" functions and rotate im2 by 
%       the computed angle
im2_registered = uint8(zeros(M, N));

for i = 1:M
    for j = 1:N
        % Compute the coordinates in the source image after rotation
        [src_x, src_y] = rotation(i, j, phi, cx, cy);
        
        % Use bilinear interpolation to get the pixel value in the source image
        im2_registered(i, j) = bilinear(im2, src_x, src_y, blank_val);
    end
end

end