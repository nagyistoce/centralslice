%%
%! @file

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DEBUG MODE

%! Debug the program.
% When DEBUG=1, extra figures will be saved in current directory which can be used for debugging process.
global DEBUG = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameters

%! Shape of the phantom.
global shape='dot';

%! Size of the phantom.
% This specifies the number of rows and columns in the matrix of Phantom.
global N = 80;

%! Signal to noise ratio.
global SNR = 0;

main(shape,N,SNR,DEBUG);
