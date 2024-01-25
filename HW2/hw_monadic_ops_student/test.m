image_name = 'images/gantrycrane.png';

% img = get_image(image_name);
img = imread(image_name);


[img_hist] = compute_hist(img, 256);



img_cdf = compute_cdf(img, 3);



