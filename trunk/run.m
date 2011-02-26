%% Debug flag: print out everything when DEBUG==1
DEBUG=1;

%% Signal to noise ratio
%SNR=0.1;

%% Size of phantom and reconstructed image
% N is the number of rows and columns in P, which is 256 respectively
N=128;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create Phantom P
%P = phantom('Shepp-Logan',N);

%Modified Shepp-Logan' gives better visual perception than 'Shepp-Logan'
%P = phantom('Modified Shepp-Logan',N);     %Fail-safe version

% a simple 2D delta function which is off-centre
%P = zeros(N);
%P(12,12)=1;

% a stripe
T=6;
P=[zeros(N,(N-T)/2) ones(N,T) zeros(N,(N-T)/2)];

% a square
%T=30;
%P=[zeros(N,(N-T)/2) ones(N,T) zeros(N,(N-T)/2)];
%P=P'.*P; %image of square

% a 45deg straight line
%P=eye(N);

% Determine the range of x and y
x = linspace(-N/2,N/2,N);
y = x;

% Show and save the phantom
figure(1)
imagesc(x,y,P),colormap(gray),colorbar
title('Phantom'),xlabel('x'),ylabel('y')
print -dpng 1_phantom.png

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Apply radon transformation Rf
%we may change the number of beams that we use to cover 180 degree
theta=linspace(0,179,180);
%return a vector XP containing the radial coordinates corresponding to each row of RT
Rf = radon(P,theta);

% Determine the range of s
s_max=sqrt( max(x)^2 + max(y)^2 );
[s_size theta_size] = size(P);
s = linspace(-s_max,s_max,s_size);

%% Apply noise to the Radon image
%Rf = Rf + SNR * ( rand(s_size,theta_size)*2 - 1 );


%% Show and save Radon image
figure(2)
imagesc(theta,s,Rf),colormap(gray),colorbar
title('Radon image'),xlabel('theta'),ylabel('s')
print -dpng 2_radon.png

%% Polar Fourier transform
FRf = fftshift(fft(Rf),1);         % Apply 1D Fourier transform in each column

% Determine the range of omega
dx=mean(diff(x));
dy=mean(diff(y));
ds=sqrt( dx^2 + dy^2 );
size_omega=size(FRf,1);
omega_max=2*pi/ds*max(s);
omega=linspace(-omega_max,omega_max,size_omega);

%% Show and save the Fourier transform image
figure(3)
imagesc(theta, omega, real(FRf)),colormap(gray),colorbar
xlabel('theta'),ylabel('omega_s')
title('Polar Fourier transform of Radon image, Real Part')
print -dpng 3a_fourier_radon_real.png

figure(4)
imagesc(theta, omega, imag(FRf)),colormap(gray),colorbar
xlabel('theta'),ylabel('omega_s')
title('Polar Fourier transform of Radon image, Imagimary Part')
print -dpng 3b_fourier_radon_imag.png

%% Change from polar to x-y coordinate
FRf_widescreen = horzcat(FRf,FRf,FRf,FRf);       % Increase the range of theta by four times

%% Determine the new range of theta and omega
[size_omega size_theta]=size(FRf_widescreen);
theta_max=max(theta);
omega_widescreen=omega;
theta_widescreen=linspace(-360,180+theta_max,size_theta);
[THETA OMEGA]=meshgrid(theta_widescreen,omega_widescreen);

%% DEBUG: show and save the widescreen image
if(DEBUG)
figure(98)
imagesc(theta_widescreen, omega_widescreen, real(FRf_widescreen)),colormap(gray),colorbar
xlabel('theta'),ylabel('omega_s')
title('Polar Fourier transform of Radon image, Real Part')
print -dpng 3c_fourier_radon_real.png

figure(99)
imagesc(theta_widescreen, omega_widescreen, imag(FRf_widescreen)),colormap(gray),colorbar
xlabel('theta'),ylabel('omega_s')
title('Polar Fourier transform of Radon image, Imagimary Part')
print -dpng 3d_fourier_radon_imag.png
end

% Determine range of the desired xy scale
x = linspace(-N/2,N/2,N);
y = x;
omega_x_max=2*pi/dx*max(x)/sqrt(2);
omega_x = linspace(-omega_x_max,omega_x_max,N);
omega_y = omega_x;
[WX WY]=meshgrid( omega_x , omega_y );
xy_to_theta = atan2(WY,WX).*180./pi;
xy_to_omega = sqrt( WX.^2 + WY.^2 );

F2f = interp2(THETA,OMEGA,FRf_widescreen,xy_to_theta,xy_to_omega,'nearest');
F2f(isnan(F2f))=0;        % set all NaN (Not a Number) error to zero

figure(5)
imagesc(x,y,real(F2f)),colormap(gray),colorbar
xlabel('omega_x'),ylabel('omega_y')
title('polar to x-y cubic interpolation, Real Part')
print -dpng 4a_fourier_xy_real.png

figure(6)
imagesc(x, y, imag(F2f)),colormap(gray),colorbar
xlabel('omega_x'),ylabel('omega_y')
title('polar to x-y cubic interpolation, Imaginary Part')
print -dpng 4b_fourier_xy_imag.png

%% inverse FFT
f = ifft2(fftshift(F2f));

figure(7)
imagesc(x,y,real(f)),colormap(gray),colorbar
xlabel('x'),ylabel('y')
title('Reconstructed Image, Real Part')
print -dpng 5_reconstruct_xy_real.png

figure(8)
imagesc(x,y,imag(f)),colormap(gray),colorbar
xlabel('x'),ylabel('y')
title('Reconstructed Image, Imaginary Part')
print -dpng 5_reconstruct_xy_imag.png
