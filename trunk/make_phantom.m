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
    R=T/2;

switch shape
  case {'Shepp-Logan','Modified Shepp-Logan'}
    % Modified Shepp-Logan' gives better visual perception than 'Shepp-Logan'
    P = phantom(shape,N);
  case {'dot'}
    R=4;
    I=1:N; x=I-N/2; y=N/2-I; [X, Y]=meshgrid(x,y); P=(X.^2 +Y.^2 <= R^2)
  case {'square'}
    P=[zeros(N,(N-T)/2) ones(N,T) zeros(N,(N-T)/2)];
    P=P'*P;
  case {'stripe'}
    P=[zeros(N,(N-T)/2) ones(N,T) zeros(N,(N-T)/2)];
  case {'circle'}
    I=1:N; x=I-N/2; y=N/2-I; [X, Y]=meshgrid(x,y); P=(X.^2 +Y.^2 <= R^2);
end

