%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%! @mainpage CentralSlice
% CT Image Reconstruction using Central Slice Theorem
% 
% Refer to the project homepage http://code.google.com/p/centralslice/

%! @file
% Main process of the simulation.
% This script generates a radon projection image from a selected phantom.
% Then 1D Fourier transform is applied to each projection angle. The result is then interpolated onto the cartesian plane according to Central slice theorem. Lastly inverse 2D Fourier transform is applied to reproduce the image.
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
global N = 128;

%! Signal to noise ratio.
global SNR = 0;

function main()
global DEBUG,shape,N,SNR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MAKE A PHANTOM

Phantom = make_phantom(shape,N);	% Make a phantom.

save_figure(Phantom,'Phantom');		% Save the phantom image

% Angles for Radon Projection.
% It should be from 0deg to 180deg. The last angular sample normally is  smaller than 180deg.
THETA = linspace(0,180-1/2,180*2);

Radon = radon(Phantom,THETA);		% Apply Radon transform.

Radon = add_noise(Radon,SNR);		% Add noise to the image

save_figure(Radon,'Radon Projection');	% Save the radon image

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1D FOURIER TRANSFORM

% Zeropadding: expand the matrix to power of 2 before doing FFT
%size_s = 
%next_power_of_2 = 2^ceil(
size_omega=size(FRf,1);
size_zeropad = round(size_omega/2 * zeropad_ratio);
zeropad = zeros(size_zeropad,size_theta);
FRf = vertcat(zeropad,FRf,zeropad);

Fourier_Radon = fft(Radon);		% Apply FFT to the radon image

if(DEBUG)
save_figure(real(Fourier_Radon),'Fourier transform of Radon Space, Real Part');	% Save the radon image
save_figure(imag(Fourier_Radon),'Fourier transform of Radon Space, Imaginary Part');	% Save the radon image
end

save_figure(abs(Fourier_Radon),'Fourier transform of Radon Space, Absolute Value');


