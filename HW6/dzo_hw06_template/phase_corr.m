function [dx, dy, im_corr] = phase_corr(im1, im2)
% PHASE CORRELATION Get relative shift of two arrays with phase correlation

% transform both images to frequency domain:
f1 = fft2(im1);
f2 = fft2(im2);

% compute the dirac pulse:
cc = f1.*conj(f2);
ncc = cc./(1e-7 + abs(cc));
im_corr = fftshift(ifft2(ncc));

% find max:
[~, idx] = max(abs(im_corr(:)));
% position of max:
[y, x] = ind2sub(size(im_corr), idx);
% compute shift:
[cx, cy] = ffcenter(im_corr);
dx = x - cx;
dy = y - cy;

end