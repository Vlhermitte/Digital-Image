function O = normalize_colors(I)

    % Compute minimum and maximum values for each color channel
    min_vals = min(I, [], [1, 2]);
    max_vals = max(I, [], [1, 2]);

    % Shift and scale pixel values to fit into [0, 1]
    O = (I - min_vals) ./ (max_vals - min_vals);

end
