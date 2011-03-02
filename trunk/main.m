%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%! @mainpage CentralSlice
% CT Image Reconstruction using Central Slice Theorem
% 
% Refer to the project homepage http://code.google.com/p/centralslice/

%! @file
% Main process of the simulation.

%! @callgraph

%! @example start_simulation.m
% This is an example of how to use this simulation script.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%! Main process of the simulation.
% This script generates a radon projection image from a selected phantom.
% Then 1D Fourier transform is applied to each projection angle. The result is then interpolated onto the cartesian plane according to Central slice theorem. Lastly inverse 2D Fourier transform is applied to reproduce the image.
% @param shape shape of the phantom
% @param N mininium size of the phantom image (in pixels)
% @param SNR Signal to Noise Ratio
% @DEBUG DEBUG mode. If set to 1, many more figure are printed out for debugging process.
function main(shape,N,SNR,DEBUG)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MAKE A PHANTOM AND APPLY RADON TRANSFROMATION

Phantom = make_phantom(shape,floor(N/sqrt(2)));	% Make a phantom.

axis_xy = linspace(-N/2,N/2,N);
save_figure(axis_xy,axis_xy,Phantom,...
	'Phantom','x','y');		% Save the phantom image

% Angles for Radon Projection.
% It should be from 0deg to 180deg. The last angular sample normally is  smaller than 180deg.
THETA = linspace(0,180-1/2,180*2);

Radon = radon(Phantom,THETA);		% Apply Radon transform.

Radon = add_noise(Radon,SNR);		% Add noise to the image

%% Zeropadding: expand the matrix to power of 2 before doing FFT
[size_s size_theta] = size(Radon);
next_power_of_2 = 2^ceil(log2(size_s));

size_zeropad = next_power_of_2 - size_s;
zeropad = zeros(floor(size_zeropad/2),size_theta);
Radon = vertcat(zeropad,Radon,zeropad);

if(size_zeropad & 2)	%if size of zeropad is an odd number, add one more row of zeropad to the bottom.
Radon = vertcat(Radon,zeros(1,size_theta));
end

axis_s = linspace(-next_power_of_2/2,next_power_of_2/2,next_power_of_2);
save_figure(THETA,axis_s,Radon,...
	'Radon Projection','s','theta');	% Save the radon image

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1D FOURIER TRANSFORM

Fourier_Radon = fft(Radon);		% Apply FFT to each column of the radon image

% Label the omega_s,theta axises
size_omega_s = size(Fourier_Radon,1);
axis_omega_s = [0:(size_omega_s/2-1)  (-size_omega_s/2):-1] * 2*pi;

if(DEBUG)
save_figure(THETA, fftshift(axis_omega_s), real(fftshift(Fourier_Radon,1)),...
	'Fourier transform of Radon Space, Real Part',...
	'theta','omega_s');	% Save the radon image (real part)
save_figure(THETA, fftshift(axis_omega_s), imag(fftshift(Fourier_Radon,1)),...
	'Fourier transform of Radon Space, Imaginary Part',...
	'theta','omega_s');	% Save the radon image (imaginary part)

stem(fftshift(axis_omega_s), abs(fftshift(Fourier_Radon(:,1))));
title('Slice at angle theta=0 in Fourier Space')
xlabel('omega_s'),ylabel('Absolute Value');		% save the slice at 0deg
print -dpng 'Slice at angle theta=0 in Fourier Space.png'
end

save_figure(THETA, fftshift(axis_omega_s), abs(fftshift(Fourier_Radon,1)),...
	'Fourier transform of Radon Space, Absolute Value',...
	'theta','omega_s');

