function val = bilinear(im, x, y, blank_val) 
% BILINEAR Bilinear interpolation with border check
% For image im and coordinates x, y, the function outputs value val using
% bilinear interpolation. If the coordinates x, y are out of image borders
% then it sets val=blank_val. 

% Get the size of the image
[rows, cols] = size(im);

% Check if coordinates are within image borders
if x >= 1 && x < rows && y >= 1 && y < cols
    % Compute the four surrounding pixel coordinates
    x1 = floor(x);
    x2 = x1 + 1;
    y1 = floor(y);
    y2 = y1 + 1;

    % Bilinear interpolation
    val = (1 - (x - x1)) * (1 - (y - y1)) * im(x1, y1) + ...
          (1 - (x - x1)) * (y - y1) * im(x1, y2) + ...
          (x - x1) * (1 - (y - y1)) * im(x2, y1) + ...
          (x - x1) * (y - y1) * im(x2, y2);
else
    % If coordinates are outside image borders, set val=blank_val
    val = blank_val;
end

end