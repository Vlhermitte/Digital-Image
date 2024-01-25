function image_out = bilateral_filt( image, ksize, space_stddev, intensity_stddev )
%BILATERAL Implementation of a bilateral filter using Gaussian functions
% image:
%   the input (noisy) grayscale image (2D array)
% ksize:
%   size of the filtering window (1x2 matrix)
% space_stddev:
%   standard deviation of the Gaussian over pixel distances
% intensity_stddev:
%   standard deviation of the Gaussian over pixel value distances

%% TODO 5: implement Bilateral filter
% - go through all image (x,y) and filter window (s,t) coordinates
%   - do the DC padding as in your convolution_2D implementation
% - for each coordinate quadruple (x,y,s,t) compute the space weight
%   - Gaussian "G" over the distance of the current pixel (defined by 
%     (x,y,s,t)) from the window center pixel (x,y)
% - for each coordinate quadruple (x,y,s,t) compute the intensity weight
%   - Gaussian "b" over the difference of the pixel values at the current
%     pixel (defined by (x,y,s,t)) and the pixel at the window center (x,y)
% - multiply the weights and the current pixel and sum these over
%   the window
% - normalize each output pixel by the sum of the corresponding weights

img_size_y = size(image, 1);
img_size_x = size(image, 2);

ker_size_y = ksize(1);
ker_size_x = ksize(2);

% create padded image for kernel operations (same as convolution_2D.m)
padded_image = zeros(size(image) + ksize - mod(ksize, 2));
for i = 1:size(padded_image,1)
    for j = 1:size(padded_image,2)
        img_coord_y = i-floor(ker_size_y/2);
        img_coord_x = j-floor(ker_size_x/2);
        if img_coord_y < 1
            if img_coord_x < 1
                padded_image(i, j) = image(1, 1);
            elseif img_coord_x > img_size_x
                padded_image(i, j) = image(1,end);
            else
                padded_image(i, j) = image(1, img_coord_x);
            end
        elseif img_coord_y > img_size_y
            if img_coord_x < 1
                padded_image(i, j) = image(end, 1);
            elseif img_coord_x > img_size_x
                padded_image(i, j) = image(end, end);
            else
                padded_image(i, j) = image(end, img_coord_x);
            end
        elseif img_coord_x < 1
            padded_image(i, j) = image(img_coord_y, 1);
        elseif img_coord_x > img_size_x
                padded_image(i, j) = image(img_coord_y, end);
        else
            padded_image(i, j) = image(img_coord_y, img_coord_x);
        end
    end
end

ker_center_y = ceil(ker_size_y/2);
ker_center_x = ceil(ker_size_x/2);

% make the kernel convolution on padded image
image_out = zeros(size(image));
for i = 1:img_size_y
    for j = 1:img_size_x
        sum_pix_val = 0;
        sum_w = 0;
        for k = 0:ker_size_y-1
            for l = 0:ker_size_x-1              
                dist = sqrt((k+1 - ker_center_y)^2 + (l+1 - ker_center_x)^2);
                contrast = padded_image(i + ker_center_y-1, j + ker_center_x-1) - padded_image(i + k, j + l);
                
                gauss_space_val = 1/sqrt(2*pi*space_stddev)*exp(-dist^2/(2*space_stddev));
                gauss_intensity_val = 1/sqrt(2*pi*intensity_stddev)*exp(-contrast^2/(2*intensity_stddev));
                                           
                sum_pix_val = sum_pix_val + padded_image(i+k, j+l)*gauss_space_val*gauss_intensity_val;     
                sum_w = sum_w + gauss_space_val*gauss_intensity_val; 
            end
        end      
        image_out(i, j) = sum_pix_val/sum_w;
    end
end


end

