%%
%! @file
% Expand the matrix to power of 2 before doing FFT.
%

%%
%! Zeropad each column to preprare for FFT. Expand the length of each column to the power of 2. The value of s in each row is also computed.
% @param Radon matrix of Radon image
% @retval Radon2 expaned matrix of Radon image
% @retval axis_s value of s in each row
function [Radon2 axis_s] = zeropad(Radon)

[size_s size_theta] = size(Radon);
next_power_of_2 = 2^ceil(log2(size_s));

size_zeropad = next_power_of_2 - size_s;
zeropad = zeros(floor(size_zeropad/2),size_theta);
Radon2 = vertcat(zeropad,Radon,zeropad);

% if size of zeropad is an odd number, add one more row of zeropad to the bottom.
if(size_zeropad & 2)
Radon2 = vertcat(Radon2,zeros(1,size_theta));
end

axis_s = linspace(-next_power_of_2/2,next_power_of_2/2,next_power_of_2);

