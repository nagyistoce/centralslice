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

%! Shape of the phantom. Can be 'Shepp-Logan', 'Modified Shepp-Logan', 'dot', 'square', or 'stripe'.
shape='dot';

%! Size of the phantom.
% This specifies the number of rows and columns in the matrix of Phantom.
% N_image is suggested to be an odd number.
N_image = 231;

%! Number of slices in Radon scan from 0deg to 180deg (excluding 180deg)
N_theta = 180;

%! Signal to noise ratio.
SNR = 0;

%! Interpolation method
interp_m = 'nearest';

main(shape,N_image,N_theta,SNR,interp_m,DEBUG);
