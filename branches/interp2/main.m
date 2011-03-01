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
DEBUG = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MAKE A PHANTOM

%! Shape of the phantom.
shape='dot';

%! Size of the phantom.
% It should be the power of 2 if FFT was to be used efficiently.
N = 128;

Phantom = make_phantom(shape,N);	% Make a phantom.

save_figure(Phantom,'Phantom');		% Save the phantom image

%! Angles for Radon Projection.
% It should be from 0deg to 180deg. The last angular sample normally is  smaller than 180deg.
THETA = linspace(0,180-1/2,180*2);

Radon = radon(Phantom,THETA);		% Apply Radon transform.

%! Signal to noise ratio.
SNR = 0;

Radon = add_noise(Radon,SNR);		% Add noise to the image

save_figure(Radon,'Radon Projection');	% Save the radon image

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% 1D FOURIER TRANSFORM

Fourier_Radon = fft(Radon);		% Apply FFT to the radon image

if(DEBUG)
save_figure(real(Fourier_Radon),'Fourier transform of Radon Space, Real Part');	% Save the radon image
save_figure(imag(Fourier_Radon),'Fourier transform of Radon Space, Imaginary Part');	% Save the radon image
end

save_figure(abs(Fourier_Radon),'Fourier transform of Radon Space, Absolute Value');

