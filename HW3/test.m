fig = 0;

%% Sampling theorem, aliasing 
%
% We will show what happens with the spectrum when the image is 
% sampled. Then the image will be reconstructed from the sampled spectrum
% using the Shanon reconstruction filter. 
%  
% The procedure (sampling/reconstruction) will be repeated with increasing 
% sampling factor, namely sampling by 2,4,8,16,32. You will see that it is
% possible to reconstruct the sampled image without artifacts when the
% condition of the Sampling Thorem holds. 
%  
%

% input image 
x = image_generator('Gaussian', [512,512], 10);

% FFT of the input
X = fft2(x);

fig = fig+1; figure(fig);
imagesc(real(x)); colormap gray; axis image;
title('Input image')

fig = fig+1; figure(fig); 
show_spectrum(X,'gray'); 
title('Magnitude spectrum');

x0 = x;
for i=1:5
    
    T = 2^i; %sampling factor
    
    %sampling (take every T-th pixel of the image, other pixels are zero
    x = zeros(size(x));
    x(1:T:end, 1:T:end) = x0(1:T:end,1:T:end);
    
    %spectrum of sampled image
    X = fft2(x); 
     
    fig = fig+1; figure(fig); 
    imagesc(x); colormap gray; axis image; 
    title(sprintf('Sampled image (factor %i)',T))

    fig = fig+1; figure(fig);
    show_spectrum(X,'gray'); axis image; cl = get(gca, 'clim');
    title(sprintf('Magnitude spectrum of sampled image (factor %i)',T))
    
    %TODO {
    % - Implement the Shanon reconstruction filter. It is the square filter
    %   in the frequency domain with the spatial extent depending on the 
    %   highest frequency in the signal.
    
    S = zeros(size(X)); % initialize the filter

    % Calculate the highest frequency in the signal
    Nyquist_x = floor(size(X, 1) / 2);
    Nyquist_y = floor(size(X, 2) / 2);
    
    % Define the spatial extent of the filter
    filter_extent_x = Nyquist_x / T;
    filter_extent_y = Nyquist_y / T;
    
    % Create the Shannon reconstruction filter
    S(Nyquist_x - filter_extent_x + 1:Nyquist_x + filter_extent_x, Nyquist_y - filter_extent_y + 1:Nyquist_y + filter_extent_y) = 1;

    
    figure(fig); hold on %Visualize the reconstruction filter extent
    tmp_x = find(sum(S,2)>0); 
    tmp_y = find(sum(S,1)>0); 
    plot([tmp_x(1),tmp_x(end),tmp_x(end),tmp_x(1),tmp_x(1)], ...
         [tmp_y(1),tmp_y(1),tmp_y(end),tmp_y(end),tmp_y(1)], 'r');
    hold off
    
    
    Xr = ifftshift(fftshift(X).*S); %Apply Shanon reconstruction filter to the sampled spectrum
    xr = real(ifft2(Xr)); %reconstruct the image using inverse FFT
             
    fig = fig+1; figure(fig);
    imagesc(xr); colormap gray; axis image;
    title(sprintf('Reconstructed image (factor %i)',T))
    
    fig = fig+1; figure(fig);
    show_spectrum(Xr,'gray',cl); axis image;
    title(sprintf('Reconstructed spectrum (factor %i)',T))
      
end