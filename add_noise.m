%%
%! @file
% Add noise to the image.
%

%! Add noise to the image.
%
% @param image matrix of the image
% @param SNR signal to noise ratio (0~1)
% @retval new_image new image loaded with noise

function new_image = add_noise(image,SNR)

[height width] = size(image);

noise = rand(height,width) * SNR *2 -1;

new_image = image + noise;

