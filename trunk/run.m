%% Size of reconstructed image
N=256;

%% Create Phantom
%P = phantom('Shepp-Logan',N);

%Modified Shepp-Logan' gives better visual perception than 'Shepp-Logan'
%P = phantom('Modified Shepp-Logan',N);     %Fail-safe version

% a simple 2D delta function which is off-centre
%P = zeros(N);
%P(12,12)=1;

% a straight line
P=eye(N);

P = phantom('Modified Shepp-Logan',N); 
% N is the number of rows and columns in P, which is 256 respectively
%P = zeros(N);
%P(200,100)=1;

figure(1)
imagesc(P)
xlabel('x'),ylabel('y'),colormap(gray),colorbar
title('Shepp-Logan head model')
print -dpng 1_phantom.png

%% Apply radon transformation
theta = 0:1:180; 
%we may change the number of beams that we use to cover 180 degree
[RT,XP] = radon(P,theta); 
%return a vector XP containing the radial coordinates corresponding to each
%row of RT

%% apply noise
%SNR=0.1;    % Signal to noise ratio
%[a b] = size(RT);
%RT = RT + SNR * 2 *( rand(a,b)/2 );

%% Show radon image

figure(2)
r = (256^2 * 2)^0.5;  
imagesc(0, -r/2, RT);
xlabel('theta'),ylabel('s'),colormap(gray),colorbar
title('Radon image')
print -dpng 2_radon.png

%% polar fourier transform
F2 = fftshift(fft(RT),1);

[a,b]=size(F2);
theta=(1:b);
omega=(1:a)-floor(a/2);
[Theta Omega]=meshgrid(theta,omega);

figure(3)
imagesc(theta, omega, real(F2)),colormap(gray),colorbar
xlabel('theta'),ylabel('omega_s')
title('polar fourier transform of Radon image, Re')
print -dpng 3a_fourier_radon_real.png

figure(4)
imagesc(theta, omega, imag(F2)),colormap(gray),colorbar
xlabel('theta'),ylabel('omega_s')
title('polar fourier transform of Radon image, Im')
print -dpng 3b_fourier_radon_imag.png

%% change to x-y coordinate
F22 = horzcat(F2,F2,F2);
theta2=(1-b:b+b);
omega2=(1:a)-floor(a/2);
[Theta2 Omega2]=meshgrid(theta2,omega2);

xx=(1:N)-N/2;
yy=(1:N)-N/2;
[XX YY]=meshgrid( xx , yy );
th = atan2(YY,XX).*180./pi;
w = sqrt( XX.^2 + YY.^2 ) .* sign (th);
th = abs(th);

Fxy = interp2(Theta2,Omega2,F22,th,w);
Fxy(isnan(Fxy))=0;        % set all nan to zero

figure(5)
imagesc(xx,yy,real(Fxy)),colormap(gray),colorbar
xlabel('omega_x'),ylabel('omega_y')
title('polar to x-y cubic interpolation, Re')
print -dpng 4a_fourier_xy_real.png

figure(6)
imagesc(xx, yy, imag(Fxy)),colormap(gray),colorbar
xlabel('omega_x'),ylabel('omega_y')
title('polar to x-y cubic interpolation, Im')
print -dpng 4b_fourier_xy_imag.png

%% inverse FFT
f = ifft2(Fxy);

figure(7)
imagesc(xx,yy,real(f)),colormap(gray),colorbar
xlabel('x'),ylabel('y')
title('Inverse FFT, Re')
print -dpng 5_reconstruct_xy_real.png

figure(8)
imagesc(xx,yy,imag(f)),colormap(gray),colorbar
xlabel('x'),ylabel('y')
title('Inverse FFT, Im')
print -dpng 5_reconstruct_xy_imag.png
