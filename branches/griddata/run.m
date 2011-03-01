%% Image defaults
set(0,'defaultsurfaceedgecolor','none')

%% Debug flag: print out everything when DEBUG==1
DEBUG=1;

%% Signal to noise ratio
%SNR=0.1;

%% Interpolation method: nearest / linear / cubic
interp_m='nearest';

%%Zeropadding ratio: filter out high frequency signal
% 0:none , 1:filter everything
zeropad_ratio=0;

%%Oversampling ratio: reduce alising
%1:normal, >1 oversampling
oversamp_ratio=1;

%% Size of phantom and reconstructed image
% N is the number of rows and columns in P, which is 256 respectively
N=256;

%Radon scan angles
%we may change the number of beams that we use to cover 180 degree
theta=linspace(0,180-1/5,180*5);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create Phantom P
%P = phantom('Shepp-Logan',N);

%Modified Shepp-Logan' gives better visual perception than 'Shepp-Logan'
%P = phantom('Modified Shepp-Logan',N);     %Fail-safe version

% a simple 2D delta function which is off-centre
%P = zeros(N);
%P(12,12)=1;

% a stripe
%T=N/8;
%P=[zeros(N,(N-T)/2) ones(N,T) zeros(N,(N-T)/2)];

% a square (T must be even)
T=2;
P=[zeros(N,(N-T)/2) ones(N,T) zeros(N,(N-T)/2)];
P=P'&P; %image of square

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
FRf = fft(Rf);         % Apply 1D Fourier transform in each column

% Determine the range of omega
ds=mean(diff(s));
size_omega=size(FRf,1);
d_omega=2*pi/ds;
omega_max=size_omega*d_omega/2;
omega=linspace(-omega_max,omega_max,size_omega);

%% Zeropadding: remove high-frequency components and reduce noise
pad_begin=floor(size_omega*(1-zeropad_ratio)/2)+1;
pad_end=size_omega-pad_begin+1;
FRf(pad_begin:pad_end,:)=0;
FRf=fftshift(FRf,1);

%% Show and save the Fourier transform image
figure(3)
imagesc(theta, omega, abs(FRf)),colormap(gray),colorbar
xlabel('theta'),ylabel('omega_s')
title('Polar Fourier transform of Radon image, Absolute Value')
print -dpng 3_fourier_radon_abs.png

if(DEBUG)
figure(4)
imagesc(theta, omega, real(FRf)),colormap(gray),colorbar
xlabel('theta'),ylabel('omega_s')
title('Polar Fourier transform of Radon image, Real Part')
print -dpng 3a_fourier_radon_real.png

figure(5)
imagesc(theta, omega, imag(FRf)),colormap(gray),colorbar
xlabel('theta'),ylabel('omega_s')
title('Polar Fourier transform of Radon image, Imaginary Part')
print -dpng 3b_fourier_radon_imag.png
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Change from polar to x-y coordinate

%% Label omega_x, omega_y on the image of FRf:
[THETA WW] = meshgrid(theta, omega);
label_WX = WW.*cosd(THETA);
label_WY = WW.*sind(THETA);

%% Determine range of the desired rectangular coordinates
N=N*oversamp_ratio;
max_omega=max(omega);
omega_x = linspace(-max_omega/sqrt(2),max_omega/sqrt(2),N);
omega_y = omega_x;
[WX WY]=meshgrid( omega_x , omega_y );

d_omega=mean(diff(omega_x));
dx=2*pi/d_omega;
max_x=N*dx/2;
x=(-(N/2):(N/2))*dx;
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
figure(6)
surf(label_WX,label_WY,abs(FRf)),colorbar,colormap(jet)
axis tight;
title('DEBUG: Radon Fourier image before interpolation, Absolute Value')
xlabel('theta'),ylabel('omega')
print -dpng 4c_fourier_polar_abs.png

figure(7)
surf(WX,WY,abs(F2f)),colorbar,colormap(jet)
axis tight;
title('DEBUG: Radon Fourier image after interpolation, Absolute Value')
xlabel('omega_x'),ylabel('omega_y')
print -dpng 4d_fourier_xy_abs.png
end

%% Save image of F2f
figure(8)
imagesc(omega_x,omega_y,abs(F2f)),colormap(gray),colorbar
xlabel('omega_x'),ylabel('omega_y')
title('polar to x-y interpolation, Absolute Value')
print -dpng 4_fourier_xy_abs.png

if(DEBUG)
figure(9)
imagesc(omega_x,omega_y,real(F2f)),colormap(gray),colorbar
xlabel('omega_x'),ylabel('omega_y')
title('polar to x-y interpolation, Real Part')
print -dpng 4a_fourier_xy_real.png

figure(10)
imagesc(omega_x, omega_y, imag(F2f)),colormap(gray),colorbar
xlabel('omega_x'),ylabel('omega_y')
title('polar to x-y interpolation, Imaginary Part')
print -dpng 4b_fourier_xy_imag.png
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Apply Inverse FFT to F2f
f = ifft2(fftshift(F2f));

figure(11)
imagesc(x,y,real(f)),colormap(gray),colorbar
xlabel('x'),ylabel('y')
title('Reconstructed Image, Real Part')
print -dpng 5_reconstruct_xy_real.png

if(DEBUG)
figure(12)
imagesc(x,y,imag(f)),colormap(gray),colorbar
xlabel('x'),ylabel('y')
title('Reconstructed Image, Imaginary Part')
print -dpng 5_reconstruct_xy_imag.png
end

close all