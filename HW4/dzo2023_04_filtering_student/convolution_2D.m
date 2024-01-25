function image_out = convolution_2D(image, kernel)
%CONVOLUTION_2D 2D convolution between an image and kernel
% image:
%   the input grayscale image (2D array)
% kernel:
%   the convolutional kernel (2D array)

%% TODO 1a: implement brute-force convolution using loops
% - implement "DC" padding
%   - for the pixels in areas, where the kernel would look outside of 
%     the original image, use the nearest image pixel (clip the coordinates)
% adding padding without using padarray
image_out = zeros(size(image));

img_size_y = size(image, 1);
img_size_x = size(image, 2);

ker_size_y = size(kernel, 1);
ker_size_x = size(kernel, 2);

% create padded image for kernel operations
padded_image = zeros(size(image) + size(kernel) - mod(size(kernel),2));
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


% make the kernel convolution on padded image
for i = 1:img_size_y
    for j = 1:img_size_x
        A = padded_image(i:i+ker_size_y-1, j:j+ker_size_x-1).*kernel;
        image_out(i, j) = sum(sum(A));
    end
end