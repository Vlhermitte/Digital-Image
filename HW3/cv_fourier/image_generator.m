function [I] = image_generator(sig_type, imsize, varargin)
%IMAGE_GENERATOR - generates 2d signals
%
% [I] = image_generator(sig_type, params)
%   
%   sig_type - string {'constant','harmonic','square','circ','Gaussian','Gabor'}
%   params - list of parameters depending on signal type    
%       'constant':  a (dc component)
%       'harmonic':  u,v,phi (horizontal and vertical frequency in range 0..pi, pi is the Nyquist frequency, phase 0..pi)
%       'square':  s (half-side of the square in pixels)
%       'circ':    r (radius of the circle in pixels)
%       'Gaussian': sigma (standard deviation in pixels)
%       'Gabor': u0,v0,sigma (normalized horizontal,vertical frequency 0..pi, standard deviation)
%
% Example: 
%   I = image_genrator('Gaussian',[512,512],20);
%

I = zeros(imsize); %init (in case something is not implemented)
switch sig_type
    case 'constant'  %a
        a = varargin{1};
        %TODO (Done)
        I = a;

    case 'harmonic'  %u, v
        u = varargin{1}; v = varargin{2}; phi = varargin{3}; % cos(ux + vy) + phi
        %TODO (Done)
        for x = 1:imsize(1)
            for y = 1:imsize(2)
                I(y,x) = cos(u * x + v * y) + phi;
            end
        end

    case 'square'    %s
        s = varargin{1};
        %TODO (Done)
        I(imsize/2-s:imsize/2+s, imsize/2-s:imsize/2+s) = 255;

    case 'circ'      %r
        r = varargin{1};
        %TODO (Done)
        [X, Y] = meshgrid(1:imsize(2), 1:imsize(1));
        center = [imsize(2) / 2, imsize(1) / 2];
        I = sqrt((X - center(1)).^2 + (Y - center(2)).^2) <= r;

    case 'Gaussian'  %sigma
        sigma = varargin{1};
        %TODO
        [X, Y] = meshgrid(1:imsize(2), 1:imsize(1));
        center = [imsize(2) / 2, imsize(1) / 2];
        I = exp(-((X - center(1)).^2 + (Y - center(2)).^2) / (2 * sigma^2));

    case 'Gabor'     %u0,v0,sigma  (OPTIONAL)
        u0 = varargin{1}; v0 = varargin{2}; sigma = varargin{3};
        %TODO
        [X, Y] = meshgrid(1:imsize(2), 1:imsize(1));
        center = [imsize(2) / 2, imsize(1) / 2];
        X = X - center(1);
        Y = Y - center(2);
        I = exp(-(X.^2 + Y.^2) / (2 * sigma^2)) .* cos(2 * pi * u0 * X / imsize(2) + 2 * pi * v0 * Y / imsize(1));

    otherwise
        error('Unknown signal type.')
end



