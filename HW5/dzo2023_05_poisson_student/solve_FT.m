function O = solve_FT(divG)

    kernel = [
        [0, 1, 0],
        [1, -4, 1],
        [0, 1, 0]
    ]; 
    
    kernel_fft = fft2(kernel, size(divG, 1), size(divG, 2));

    % Compute the Fourier transform of divG
    divG_fft = fft2(divG);

    % Wiener filter to avoid division by zero
    wiener_filter = conj(kernel_fft) ./ (abs(kernel_fft).^2 + 1e-14);

    O_fft = divG_fft .* wiener_filter;

    O = real(ifft2(O_fft));
end