function im2_registered = register_full(im1, im2)
%REGISTER_FULL Register images in both translation and rotation

% TODO: use your "register_translation" and "register_rotation" functions
%       to get im2_registered close to im1

% Register images in rotation
[im2_registered, im_coor_regi] = register_rotation(im1, im2);

% Register images in translation
[im2_translated, im_corr_tran] = register_translation(im1, im2_registered);
end

