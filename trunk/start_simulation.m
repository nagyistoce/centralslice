%%
%! @file

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DEBUG MODE

%! Debug the program.
% When DEBUG=1, extra figures will be saved in current directory which can be used for debugging process.
DEBUG = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameters

%! Shape of the phantom.
shape='dot';

%! Size of the phantom.
% This specifies the number of rows and columns in the matrix of Phantom.
% N is suggested to be an odd number.
N = 231;

%! Signal to noise ratio.
SNR = 0;

main(shape,N,SNR,DEBUG);
