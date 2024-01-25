function M = get_mask(GxA, GyA, GxB, GyB)
    
    M = zeros(size(GxA,1:2));

    for i = 1:size(M,1)
        for j = 1:size(M,2)   
            % compute the mask based on grad len from RGB/3 average
            %grad_len_a = sqrt(sum(GxA(i,j,:)/3)^2 + sum(GyA(i,j,:)/3)^2);
            %grad_len_b = sqrt(sum(GxB(i,j,:)/3)^2 + sum(GyB(i,j,:)/3)^2);

            % squared norm of squared norms of gradients
            grad_len_a = sqrt(sum(GxA(i,j,:).^2) + sum(GyA(i,j,:).^2));
            grad_len_b = sqrt(sum(GxB(i,j,:).^2) + sum(GyB(i,j,:).^2));
            if grad_len_a < grad_len_b
                M(i,j) = 255;
            end          
        end
    end