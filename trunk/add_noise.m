%%
%! @file
% Add noise to the image.
%

%! Add gaussian noise to the image. Assumes the exposure is long enough that central limit theorem is valid. (Short exposure is currently not supported)
% 
% Signal-to-noise ratio is estimated by the ratio ( @f$\frac{\mu}{\sigma} @f$ ), where @f$ \mu @f$ is the expected (perfect) measurement result, @f$ \sigma @f$ is the variance of the noise. In dB scale it is @f$ 20log_{10}(\frac{A_\textrm{noise}}{A_\textrm{noise}}) @f$ 
%
% @param image matrix of the image
% @param SNRdB signal to noise ratio (1~inf)
% @retval new_image new image loaded with noise

function new_image = add_noise(image,SNRdB)

[height width] = size(image);

% estimate the variance of noise in each measurement of each sensor.
SNR = 10^(SNRdB/20);
signal_amplitude = mean(mean(image));
variance = signal_amplitude / SNR;

noise = randn(height,width) * variance;

new_image = image + noise;

