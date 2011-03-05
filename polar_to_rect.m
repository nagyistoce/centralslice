%%
%! @file
% Map polar coordinates to rectangular coordinates
%

%%
%! @param Fourier_Radon Matrix of Fourier transformed Radon image
% @param THETA angles of Radon transform. Values of theta in each columns of Fourier_Radon
% @param axis_omega_s values of omega_s in each rows of Fourier_Radon
% @param DEBUG Debug mode. If DEBUG=1, surface of Fourier_Radon in polar coordinates and in rectangular coordinates will be saved.
% @retval Fourier_2D Matrix of the mapped Fourier space. By central slice theorem, this is equivalent to the 2D Fourier transform of the original image.
% @retval axis_omega_xy values of omega_x (or omega_y) in the columns (or rows) of Fourier_2D.
function [Fourier_2D axis_omega_xy] = polar_to_rect(Fourier_Radon,THETA,axis_omega_s,DEBUG)

