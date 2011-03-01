%%
%! @file
% Save the gray-scale representation of the image.
% @param image matrix of the image
% @param Title title of the graph
% @param Xlabel label of the x-axis
% @param Ylabel label of the y-axis

function save_figure(image,Title,Xlabel,Ylabel)

imagesc(image)
colormap(gray),colorbar
title(Title)
if(nargin > 2)
  xlabel(Xlabel),ylabel(Ylabel)
end
print('-dpng',strcat(Title,'.png'))
