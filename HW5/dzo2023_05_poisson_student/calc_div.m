function [divG] = calc_div(Gx, Gy)

    divG = zeros(size(Gx));

    for i = 1:size(Gx,1)
        for j = 1:size(Gx,2)
            if 1 < j && j < size(Gx,2) && 1 < i && i < size(Gx,1)
                div_x = Gx(i,j,:) - Gx(i-1,j,:);
                div_y = Gy(i,j,:) - Gy(i,j-1,:);
                divG(i,j,:) = div_x + div_y;
            end
        end
    end
end