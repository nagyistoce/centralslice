function run(N=256)
P = phantom('Modified Shepp-Logan',N);
%P = zeros(N);
%P(200,100)=1;

imagesc(P)
xlabel("x"),ylabel("y"),colormap(gray),colorbar
print -dpng 1_phantom.png

% apply radon transformation
[RT,XP] = radon(P);

% noise?

%Show radon image
imagesc(RT);
xlabel("theta"),ylabel("s"),colormap(gray),colorbar
print -dpng 2_radon.png

% polar fourier transform
F2 = fftshift(fft(RT),1);

%F21 = vertcat( F2([ceil(a/2):a],:), F2([1:floor(a/2)],:));

[a,b]=size(F2);
[Theta Omega]=meshgrid([1:b],[1:a]-floor(a/2));

imagesc(Theta, Omega, real(F2))
xlabel("theta"),ylabel("omega_s")
print -dpng 3a_fourier_radon_real.png

imagesc(Theta, Omega, imag(F2))
xlabel("theta"),ylabel("omega_s")
print -dpng 3b_fourier_radon_imag.png

%change to x-y coordinate

F22 = horzcat(F2,F2,F2);
[Theta2 Omega2]=meshgrid([1-b:b+b],[1:a]-floor(a/2));

[XX YY]=meshgrid( [1:N]-N/2 , [1:N]-N/2 );
th = atan2(YY,XX).*180./pi;
w = sqrt( XX.^2 + YY.^2 ) .* sign (th);
th = abs(th);

Fxy = interp2(Theta2,Omega2,F22,th,w);
%set all nan to zero
Fxy(isnan(Fxy))=0;

imagesc(XX,YY,real(Fxy))
axis equal,xlabel("omega_x"),ylabel("omega_y")
print -dpng 4a_fourier_xy_real.png

imagesc(XX, YY, imag(Fxy))
axis equal,xlabel("omega_x"),ylabel("omega_y")
print -dpng 4b_fourier_xy_imag.png

%inverse fft
f = ifft2(Fxy);
imagesc(XX,YY,real(f))
axis equal,xlabel("x"),ylabel("y")
print -dpng 5_reconstruct_xy_real.png

imagesc(XX,YY,imag(f))
axis equal,xlabel("x"),ylabel("y")
print -dpng 5_reconstruct_xy_imag.png


