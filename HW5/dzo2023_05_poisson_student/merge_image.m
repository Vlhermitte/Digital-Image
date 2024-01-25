function O = merge_image(A, B, M)

    O = zeros(size(A));
    
    for i = 1:size(O,1)
        for j = 1:size(O,2)
            if M(i,j) == 0
                O(i,j,:) = A(i,j,:);
            else
                O(i,j,:) = B(i,j,:);
            end
        end
    end