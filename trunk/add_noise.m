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

% support linear noise only.
noise = (rand(height,width) *2 -1)*SNR;

new_image = image .* (1 + noise);

