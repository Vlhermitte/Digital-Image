function [Gx, Gy] = calc_grad(I)

 w = size(I,1);
 h = size(I,2);

 % Initialize gradients
 Gx = zeros(size(I));
 Gy = zeros(size(I));

 for y=1:h
     for x=1:w-1
         for c=1:3
             Gx(x, y, c) = I(x+1, y, c) - I(x, y, c);
         end % c
     end % x
 end % y 

 % Compute gradients in Y direction
for x = 1:w
    for y = 1:h-1
        for c = 1:3
            Gy(x, y, c) = I(x, y+1, c) - I(x, y, c);
        end
    end
end

% Handle boundaries by setting gradients to zero
%Gx(w, :, :) = 0;
%Gy(:, h, :) = 0;