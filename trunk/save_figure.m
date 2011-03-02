%%
%! @file
% Save the gray-scale representation of the image.

%! Save the gray-scale representation of the image.
% @param X value of X in each column
% @param Y value of Y in each row
% @param Z matrix of the image
% @param Title title of the graph
% @param Xlabel label of the x-axis
% @param Ylabel label of the y-axis

function save_figure(X,Y,Z,Title,Xlabel,Ylabel)

imagesc(X,Y,Z)
colormap(gray),colorbar
title(Title)
if(nargin > 2)
  xlabel(Xlabel),ylabel(Ylabel)
end
print('-dpng',strcat(Title,'.png'))
