%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%! @mainpage CentralSlice
% CT Image Reconstruction using Central Slice Theorem.
% 
% Refer to the project homepage http://code.google.com/p/centralslice/

%! @file
% Main process of the simulation.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%! Main process of the simulation.
% This script generates a radon projection image from a selected phantom.
% Then 1D Fourier transform is applied to each projection angle. The result is then interpolated onto the cartesian plane according to Central slice theorem. Lastly inverse 2D Fourier transform is applied to reproduce the image.
% @param shape shape of the phantom
% @param N_image mininium size of the phantom image (in pixels)
% @param N_theta Number of slices in Radon scan from 0deg to 180deg (excluding 180deg)
% @param SNR Signal to Noise Ratio
% @param DEBUG mode. If set to 1, many more figures are printed out for debugging process.
function main(shape,N,,N_theta,SNR,DEBUG)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MAKE A PHANTOM AND APPLY RADON TRANSFROMATION

Phantom = make_phantom(shape,floor(N/sqrt(2)));	% Make a phantom.

axis_xy = linspace(-N/2,N/2,N);
save_image(axis_xy,axis_xy,Phantom,...
	'Phantom','x','y');		% Save the phantom image

% Angles for Radon Projection.
% It should be from 0deg to 180deg. The last angular sample normally is  smaller than 180deg.
d_theta = 180 / N_theta;
THETA = linspace(0,180-d_theta,N_theta);

Radon = radon(Phantom,THETA);		% Apply Radon transform.

Radon = add_noise(Radon,SNR);		% Add noise to the image

%% Zeropadding: expand the matrix to power of 2 before doing FFT
[Radon2 axis_s] = zeropad(Radon);

save_image(THETA,axis_s,Radon2,...
	'Radon Projection','theta','s');	% Save the radon image

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1D FOURIER TRANSFORM
[Fourier_Radon omega_s] = apply_fft1(Radon2,DEBUG);

save_image(THETA, omega_s, abs(Fourier_Radon),...
	'Fourier transform of Radon Space, Absolute Value',...
	'theta','omega_s');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INTERPOLATION: Map slices from polar coordinates to rectangular coordinates
[Fourier_2D omega_xy] = polar_to_rect(Fourier_Radon,THETA,omega_s,DEBUG);


