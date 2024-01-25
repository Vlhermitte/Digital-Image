function [xn, yn] = rotation(x, y, phi, cx, cy)
% ROTATION Rotates points in anticlockwise direction
% Rotates input points [x, y] around the center [cx, cy] by angle phi in
% radians in anticlockwise direction and returns their new coordinates.

%TODO
% Translate points to the origin
x = x - cx;
y = y - cy;

% Perform rotation
xn = x * cos(phi) + y * sin(phi);
yn = x * sin(phi) - y * cos(phi);

% Translate points back to the original position
xn = xn + cx;
yn = yn + cy;

end