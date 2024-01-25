function O = solve_GS(A, divG)

    % Get the size of the matrix A
    [h, w, channels] = size(A);

    % Set the maximum number of iterations
    O = A;
    iterations = 1000;
    for a = 1:iterations
        for x = 2:h-1
            for y = 2:w-1
                for c = 1:channels
                    O(x, y, c) = 0.25 * (O(x+1, y, c) + O(x-1, y, c) + O(x, y+1, c) + O(x, y-1, c) - divG(x, y, c));
                end
            end
        end
    end

end