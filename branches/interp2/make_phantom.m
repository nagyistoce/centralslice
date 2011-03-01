%! @file
% Make Radon Projection image of a phantom
% @param shape Type of the phantom. Can be 'Shepp-Logan', 'Modified Shepp-Logan', 'dot', 'square', or 'stripe'
% @param N Size of the matrix
% @return P Matrix of the phantom image
function P = make_phantom(shape,N)

%! @var T
% T width of the square pulse or the stripe. T must be an even number.
    T=round(N/4)*2;

switch shape
  case {'Shepp-Logan','Modified Shepp-Logan'}
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

