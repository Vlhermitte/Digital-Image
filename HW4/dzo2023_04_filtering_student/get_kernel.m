function [kernel_cb] = get_kernel(kernel_type, parameter)
%GET_KERNEL Returns a function generating the requested kernel
    
    switch kernel_type  % choose what to do next based on the requested kernel
        case 'identity'
            kernel_cb = @identity;
        case 'average'
            kernel_cb = @average;
        case 'sobel'
            kernel_cb = @sobel;
        case 'gauss'
            kernel_cb = @gauss;
        case 'dgauss'
            kernel_cb = @dgauss;
        case 'lgauss'
            kernel_cb = @lgauss;
        case 'average_sep'
            kernel_cb = @average_sep;
        case 'sobel_sep'
            kernel_cb = @sobel_sep;
        case 'gauss_sep'
            kernel_cb = @gauss_sep;
        otherwise
            error('Unknown kernel: %s', kernel_type)
    end
end

%% Example kernel (identity)
function kernel = identity(ker_size)
    kernel = zeros(ker_size);
    
    if mod(ker_size, 2) == 0
        kernel(ker_size/2, ker_size/2) = 1;
    else
        kernel(ceil(ker_size/2), ceil(ker_size/2)) = 1;
    end
end

%% 1b: Implement simple kernels (average, sobel, gauss, dgauss, lgauss)

% Averaging filter (all samples have the same value and sum to 1)
function kernel = average(ker_size_x, ker_size_y)
    % TODO (Done)
    kernel = ones(ker_size_y, ker_size_x)/(ker_size_x*ker_size_y);   

end

% 3x3 Sobel filter
function kernel = sobel(direction)
    switch direction
        case 'x'
            % - filter highlighting intensity changes in the x direction
            % TODO (Done)
            kernel = [-1 0 1; 
                      -2 0 2; 
                      -1 0 1];

        case 'y'
            % - filter highlighting intensity changes in the y direction
            % TODO (Done)
            kernel = [1  2  1;
                      0  0  0;
                     -1 -2  -1];
            
        otherwise
            error('Unknown direction parameter, use x or y')
    end
end

% Square Gaussian filter with given size and standard deviation
function kernel = gauss(ker_size, gauss_stddev)
    % TODO (Done)
    % Create a grid of indices centered at (0,0)
    [X, Y] = meshgrid(-(ker_size-1)/2:(ker_size-1)/2, -(ker_size-1)/2:(ker_size-1)/2);

    % Compute the Gaussian values based on the formula
    kernel = exp(-(X.^2 + Y.^2) / (gauss_stddev^2));
    
    kernel = kernel ./ sum(kernel(:));
end

% Gauss Derivation in the given direction
function kernel = dgauss(ker_size, gauss_stddev, der_var)
    
    % Create a grid of indices centered at (0,0)
    [X, Y] = meshgrid(-(ker_size-1)/2:(ker_size-1)/2, -(ker_size-1)/2:(ker_size-1)/2);

    switch der_var
        case 'x'
            % - filter highlighting intensity changes in the x direction
            % TODO (Done)
            kernel = X .* exp(-(X.^2 + Y.^2) / gauss_stddev.^2);

        case 'y'
            % - filter highlighting intensity changes in the y direction
            % TODO (Done)
            kernel = Y .* exp(-(X.^2 + Y.^2) / gauss_stddev.^2);

        otherwise
            error('Unknown derivation variable parameter, use x or y')     
    end
    % Normalize the kernel to ensure the sum is 0
    kernel = kernel - sum(kernel(:));
end

% Laplacian of Gaussian (LoG)
function kernel = lgauss(ker_size, gauss_stddev)
    % TODO (Done)
    % Create a grid of indices centered at (0,0)
    [X, Y] = meshgrid(-(ker_size-1)/2:(ker_size-1)/2, -(ker_size-1)/2:(ker_size-1)/2);

    % Compute the Laplacian of Gaussian values
    kernel = -1 / (pi * gauss_stddev^4) * (1 - (X.^2 + Y.^2) / (2 * gauss_stddev^2)) .* exp(-(X.^2 + Y.^2) / (2 * gauss_stddev^2));

    % Normalize the kernel to ensure the sum is 0
    kernel = kernel - mean(kernel(:));
    kernel = kernel / sum(abs(kernel(:)));
    
end

%% 3: Implement simple separable kernels (average, sobel, gauss)
function [kernel_x, kernel_y] = average_sep(ker_size_x, ker_size_y)
    % - return kernel_x (row vector) and kernel_y (column vector)
    % - kernel_y * kernel_x should produce the resulting 2D kernel
    % TODO
    kernel_x = ones(1, ker_size_x) / ker_size_x;
    kernel_y = ones(ker_size_y, 1) / ker_size_y;

end

% Separable 3x3 Sobel filter
function [kernel_x, kernel_y] = sobel_sep(direction)
    switch direction
        case 'x'
            % - filter highlighting intensity changes in the x direction
            % TODO
            kernel_x = [-1, 0, 1];
            kernel_y = [1;
                        2;
                        1];

        case 'y'
            % - filter highlighting intensity changes in the y direction
            % TODO
            kernel_x = [-1;
                         0;
                         1];
            kernel_y = [1, 2, 1];

        otherwise
            error('Unknown direction parameter, use x or y')
    end
end

% Separable Gauss filter
function [kernel_x, kernel_y] = gauss_sep(ker_size, gauss_stddev)
    % TODO  
    [X, Y] = meshgrid(-(ker_size-1)/2:(ker_size-1)/2, -(1-1)/2:(1-1)/2);
    kernel_x = exp(-(X.^2 + Y.^2) / (gauss_stddev^2));

    [X, Y] = meshgrid(-(1-1)/2:(1-1)/2, -(ker_size-1)/2:(ker_size-1)/2);
    kernel_y = exp(-(X.^2 + Y.^2) / (gauss_stddev^2));

    kernel_x = kernel_x ./ sum(sum(kernel_x));
    kernel_y = kernel_y ./ sum(sum(kernel_y));
end