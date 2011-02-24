
%% Size of reconstructed image
N=256;

%% Create Phantom
P = phantom('Modified Shepp-Logan',N);
%P = zeros(N);
%P(200,100)=1;

figure(1)
imagesc(P)
xlabel('x'),ylabel('y'),colormap(gray),colorbar
print -dpng 1_phantom.png

% apply radon transformation
[RT,XP] = radon(P);

% apply noise?
%RT = RT * rand

%% Show radon image
figure(2)
imagesc(RT);
xlabel('theta'),ylabel('s'),colormap(gray),colorbar
print -dpng 2_radon.png

%% polar fourier transform
F2 = fftshift(fft(RT),1);

%% F21 = vertcat( F2([ceil(a/2):a],:), F2([1:floor(a/2)],:));

[a,b]=size(F2);
theta=(1:b);
omega=(1:a)-floor(a/2)
[Theta Omega]=meshgrid(theta,omega);

figure(3)
imagesc(theta, omega, real(F2)),colormap(gray),colorbar
xlabel('theta'),ylabel('omega_s')
print -dpng 3a_fourier_radon_real.png

figure(4)
imagesc(theta, omega, imag(F2)),colormap(gray),colorbar
xlabel('theta'),ylabel('omega_s')
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
% set all nan to zero
Fxy(isnan(Fxy))=0;

figure(5)
imagesc(xx,yy,real(Fxy)),colormap(gray),colorbar
xlabel('omega_x'),ylabel('omega_y')
print -dpng 4a_fourier_xy_real.png

figure(6)
imagesc(xx, yy, imag(Fxy)),colormap(gray),colorbar
xlabel('omega_x'),ylabel('omega_y')
print -dpng 4b_fourier_xy_imag.png

%% inverse fft
f = ifft2(Fxy);

figure(7)
imagesc(xx,yy,real(f)),colormap(gray),colorbar
xlabel('x'),ylabel('y')
print -dpng 5_reconstruct_xy_real.png

figure(8)
imagesc(xx,yy,imag(f)),colormap(gray),colorbar
xlabel('x'),ylabel('y')
print -dpng 5_reconstruct_xy_imag.png
