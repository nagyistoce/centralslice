%%
%! @file
% Make a phantom.
%

%%
%! Construct a matrix of a selected phantom.
% @param shape Type of the phantom. Can be 'Shepp-Logan', 'Modified Shepp-Logan', 'dot', 'square', or 'stripe'
% @param N Size of the matrix
% @retval P Matrix of the phantom image
%
function P = make_phantom(shape,N)

    % T width of the square pulse or the stripe. T must be an even number.
    T=round(N/4)*2;


switch shape
  case {'Shepp-Logan','Modified Shepp-Logan'}
    % Modified Shepp-Logan' gives better visual perception than 'Shepp-Logan'
    P = phantom(shape,N);
  case {'dot'}
    T=2;
    P=[zeros(N,(N-T)/2) ones(N,T) zeros(N,(N-T)/2)];
    P=P'&P;
  case {'square'}
    P=[zeros(N,(N-T)/2) ones(N,T) zeros(N,(N-T)/2)];
    P=P'&P;
  case {'stripe'}
    P=[zeros(N,(N-T)/2) ones(N,T) zeros(N,(N-T)/2)];
end

