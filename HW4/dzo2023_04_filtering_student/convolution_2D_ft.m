function image_out = convolution_2D_ft(image, kernel)
%CONVOLUTION_2D_FT 2D convolution using Fourier Transform
% image:
%   the input grayscale image (2D array)
% kernel:
%   the convolutional kernel (2D array)

%% TODO 2: implement convolution using Fourier transform
image_fft = fft2(image);
kernel_fft = fft2(kernel, size(image, 1), size(image, 2));

image_out_fft = image_fft .* kernel_fft;
image_out = ifft2(image_out_fft);

end
