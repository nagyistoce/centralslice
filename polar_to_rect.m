%%
%! @file
% Map polar coordinates to rectangular coordinates
%

%%
%! 
% @param theta angles of Radon transform. Values of theta in each columns of Fourier_Radon
% @param axis_omega_s values of omega_s in each rows of Fourier_Radon
% @param Fourier_Radon Matrix of Fourier transformed Radon image
% @param N_image minimium size of the image
% @param DEBUG Debug mode. If DEBUG=1, surface of Fourier_Radon in polar coordinates and in rectangular coordinates will be saved.
% @retval Fourier_2D Matrix of the mapped Fourier space. By central slice theorem, this is equivalent to the 2D Fourier transform of the original image.
% @retval axis_omega_xy values of omega_x (or omega_y) in the columns (or rows) of Fourier_2D.
function [Fourier_2D axis_omega_xy] = polar_to_rect(theta,axis_omega_s,Fourier_Radon,DEBUG)

% Label each elements in the matrix Fourier_Radon with the corresponding theta and omega_s:
[THETA OMEGA_S] = meshgrid(theta,omega_s);

%Define the desired scale of the rectangular coordinates
% [OMEGA_X OMEGA_Y] = meshgrid(...);
