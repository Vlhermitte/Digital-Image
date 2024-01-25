function O = match_colors(A, M, I)

    shiftVector = zeros(1, 1, 3);

    for channel = 1:3
        maskedInput = I(:,:,channel) .* M;
        maskedReference = A(:,:,channel) .* M;
        
        % Compute average pixel differences within the masked region
        diff = mean(maskedReference(M > 0) - maskedInput(M > 0));
        
        % Store the shift vector for each color channel
        shiftVector(channel) = diff;
    end

    % Apply the shift vector to the entire input image
    shiftedImage = I + shiftVector;

    % Ensure pixel values are in the valid range [0, 1]
    O = max(0, min(1, shiftedImage));

end
