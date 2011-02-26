%% Image defaults
set(0,'defaultsurfaceedgecolor','none')

%% Debug flag: print out everything when DEBUG==1
DEBUG=1;

%% Signal to noise ratio
%SNR=0.1;

%% Interpolation method: nearest / linear / cubic
interp_m='nearest';

%% Size of phantom and reconstructed image
% N is the number of rows and columns in P, which is 256 respectively
N=64;

%Radon scan angles
%we may change the number of beams that we use to cover 180 degree
theta=linspace(0,180-1,180);

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
%return a vector XP containing the radial coordinates corresponding to each row of RT
Rf = radon(P,theta);

% Determine the range of s
s_max=sqrt( max(x)^2 + max(y)^2 );
[s_size theta_size] = size(Rf);
s = linspace(-s_max,s_max,s_size);

%% Apply noise to the Radon image
%noise = SNR * ( rand(s_size,theta_size)*2 - 1 );
%Rf = Rf + noise;

%if(DEBUG)
%figure(97)
%imagesc(noise),colorbar
%title('noise profile')
%end


%% Show and save Radon image
figure(2)
imagesc(theta,s,Rf),colormap(gray),colorbar
title('Radon image'),xlabel('theta'),ylabel('s')
print -dpng 2_radon.png

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Polar Fourier transform
FRf = fftshift(fft(Rf),1);         % Apply 1D Fourier transform in each column

% Determine the range of omega
ds=mean(diff(s));
size_omega=size(FRf,1);
d_omega=2*pi/ds;
omega_max=size_omega*d_omega/2;
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
title('Polar Fourier transform of Radon image, Imaginary Part')
print -dpng 3b_fourier_radon_imag.png

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Change from polar to x-y coordinate

%% Label omega_x, omega_y on the image of FRf:
[THETA WW] = meshgrid(theta, omega);
label_WX = WW.*cosd(THETA);
label_WY = WW.*sind(THETA);

%% Determine range of the desired rectangular coordinates
omega_x = omega;
omega_y = omega;
[WX WY]=meshgrid( omega_x , omega_y );
d_omega=mean(diff(omega));
dx=2*pi/d_omega;
max_x=N*dx/2;
x=linspace(-max_x,max_x,N);
y=x;

%% Prepare data for interpolation
%reshape matrix to array in columns
[cols rows]=size(label_WX);
WX_array=reshape(label_WX,cols*rows,1);
WY_array=reshape(label_WY,cols*rows,1);
FRf_array=reshape(FRf,cols*rows,1);

%% Apply interpolation
F2f = griddata(WX_array,WY_array,FRf_array,WX,WY,interp_m);
F2f(isnan(F2f))=0;        % set all NaN (Not a Number) error to zero

%% DEBUG: test label WX,WY
if(DEBUG)
figure(95)
surf(label_WX,label_WY,abs(FRf)),colorbar,colormap(jet)
axis tight;
title('DEBUG: Radon Fourier image before interpolation, Absolute Value')
xlabel('omega_x'),ylabel('omega_y')
print -dpng 4c_fourier_polar_abs.png

figure(96)
surf(WX,WY,abs(F2f)),colorbar,colormap(jet)
axis tight;
title('DEBUG: Radon Fourier image after interpolation, Absolute Value')
xlabel('omega_x'),ylabel('omega_y')
print -dpng 4d_fourier_xy_abs.png
end

%% Save image
figure(5)
imagesc(omega_x,omega_y,real(F2f)),colormap(gray),colorbar
xlabel('omega_x'),ylabel('omega_y')
title('polar to x-y interpolation, Real Part')
print -dpng 4a_fourier_xy_real.png

figure(6)
imagesc(omega_x, omega_y, imag(F2f)),colormap(gray),colorbar
xlabel('omega_x'),ylabel('omega_y')
title('polar to x-y interpolation, Imaginary Part')
print -dpng 4b_fourier_xy_imag.png

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Apply Inverse FFT to F2f
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
