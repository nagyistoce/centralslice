%%
%! @file
% Program Initiation.
% Defines several important variables before starting the main process.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DEBUG MODE

%! Debug the program.
% When DEBUG=1, extra figures will be saved in current directory which can be used for debugging process.
DEBUG = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameters

%! Shape of the phantom. Can be 'Shepp-Logan', 'Modified Shepp-Logan', 'dot', 'square', 'stripe' or 'offcentre dot'.
shape='Modified Shepp-Logan'

%! Size of the phantom.
% This specifies the number of rows and columns in the matrix of Phantom.
% N_image is suggested to be an odd number.
N_image = 361

%! Number of slices in Radon scan from 0deg to 180deg (excluding 180deg)
N_theta = 180*4

%number of sensors damaged, damage_ratio varies from 0 to 1
damage_ratio = 0

%! Signal to noise ratio, in deciBell (dB)
SNRdB = inf

%! Interpolation method
interp_m = 'linear'

%! Oversampling_ratio oversampling ratio. Increase the Nyquist frequency to reduce aliasing. =1, none; >1 oversampling.
oversampling_ratio=4

%! Zeropadding ratio. Avoid overlapping of artefacts to the phantom after applying inverse Fourier transform. 1 ~ mininal; >1 ~ zeropadding.
%zeropadding_ratio=1;

main(shape,N_image,N_theta,SNRdB,interp_m,oversampling_ratio,damage_ratio,DEBUG);
