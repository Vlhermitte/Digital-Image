function [im_transformed, r, phi] = polar_transform(im, cx, cy, H)
% POLAR_TRANSFORM  Convert given image to polar coordinates
% cx, cy = center of transformation 
% H = radius (max distance from center of transformation) for which
% transformation should be computed
%
% im_transformed: transformed image. 
% r: 1-by-M vector specifying radius values along x coordinate.
% phi: 1-by-N vector specifying phi values along y coordinates. 

[ys, xs] = size(im);

% you can try to adjust the default sampling values:
M = min(ys/2, xs/2);
N = 2*360;

blank_val = 128;

% TODO: for each pixel in im_transformed, compute the coordinates in 
%       the source image im, then use the "bilinear" function to get 
%       the output pixel value, create the radius and angle vectors
im_transformed = blank_val * ones(N, M);

% Compute step sizes for r and phi
dr = H / M;
dphi = 2 * pi / N;

% Compute radius and angle vectors
r = 0:dr:(H-dr);
phi = 0:dphi:(2*pi-dphi);

for i = 1:N
    for j = 1:M
        src_x = cx + r(j) * cos(phi(i));
        src_y = cy + r(j) * sin(phi(i));

        % Bilinear interpolation
        im_transformed(i, j) = bilinear(im, src_y, src_x, blank_val);
    end
end

end