function [operation_cb] = get_monadic_operation(operation, parameter)
%SIMPLE_MONADIC Summary of this function goes here
%   Detailed explanation goes here
    switch operation  % choose what to do next based on the requested operation
        case 'negative'
            operation_cb = @negative;
        case 'threshold'
            operation_cb = package_function_w_param(@threshold, parameter);
        case 'brightness_adj'
            operation_cb = package_function_w_param(@brightness_adj, parameter);
        case 'gamma_correction'
            operation_cb = package_function_w_param(@gamma_correction, parameter);
        case 'contrast'
            operation_cb = package_function_w_param(@contrast, parameter);
        case 'non_linear_contrast'
            operation_cb = package_function_w_param(@non_linear_contrast, parameter);
        case 'log_scale'
            operation_cb = package_function_w_param(@log_scale, parameter);
        case 'quantization'
            operation_cb = package_function_w_param(@quantization, parameter);
        otherwise
            error('Unknown operation: %s', operation)
    end
end

%% Implement all of the following functions:
function [lt] = negative(l)
    lt = 1 - l; % Done
end

function [lt] = threshold(l, th)
    if th < min(l(:)) || th > max(l(:))
        error("Theta parameter of threshold operation is outside of the allowed range!")
    end
    lt = l >= th; % Done
end

function [lt] = brightness_adj(l, b)
    if b < -1 || b > 1
        error("The parameter of brightness adjustment is outside of the allowed range!")
    end
    lt = l + b; % Done
end

function [lt] = gamma_correction(l, gamma)
    if gamma <= 0
        error("The parameter of gamma correction is outside of the allowed range!")
    end
    lt = l.^gamma; % Done
end

function [lt] = contrast(l, c)
    if c < 0
        error("The parameter of contrast enhancement is outside of the allowed range!")
    end
    lt = l * c; % Done
end

function [lt] = non_linear_contrast(l, alpha)
    if alpha < 0
        error("The parameter of non-linear contrast enhancement is outside of the allowed range!")
    end

    gamma = 1/(1-alpha);
    img_size = size(l);
    lt = zeros(img_size);

    for i = 1:img_size(1)
        for j = 1:img_size(2)
            if l(i,j) < 1/2
                lt(i,j) = 1/2 * (2*l(i,j)).^gamma;
            else
                lt(i,j) = 1 - 1/2 * (2 - 2*l(i,j)).^gamma;
            end
        end
    end

    % TODO : Correct this 
end

function [lt] = log_scale(l, scale)
    if scale <= -1
        error("The parameter of logarithmic scaling is outside of the allowed range!")
    end
    lt = log(1+l*scale)/log(1+scale); % Done
end

function [lt] = quantization(l, q_levels)
    q_levels = round(q_levels);
    if q_levels < 2
        error("The number of quantization levels is outside of the allowed range!")
    end
    % Calculate the range of intensity values in the image
    intensityRange = double(max(l(:))) - double(min(l(:)));
    
    % Calculate the width of each quantization level
    levelWidth = intensityRange / q_levels;
    
    % Initialize the quantized image
    lt = zeros(size(l));
    
    % Quantize each pixel
    for i = 1:q_levels
        % Define the intensity range for the current level
        lowerBound = double(min(l(:))) + (i - 1) * levelWidth;
        upperBound = double(min(l(:))) + i * levelWidth;
        
        % Find pixels within the current intensity range
        pixelsInRange = (l >= lowerBound) & (l < upperBound);
        
        % Assign the mean intensity of the current range to the quantized image
        lt(pixelsInRange) = (lowerBound + upperBound) / 2;
    end
    % Done
end

%% End of "TO BE IMPLEMENTED" functions. Don't change the function below.
function [ref_w_param] = package_function_w_param(op_ref, param)
% This function puts the extra operation parameter "into" the operation
% reference via a lambda function. Thus, the resulting operation only
% requires the input image.
    if ~exist('param', 'var')
        error("The function '%s' requires a parameter but none was provided!", strip(evalc('disp(op_ref)')));
    end
    ref_w_param = @(img) op_ref(img, param);
end
