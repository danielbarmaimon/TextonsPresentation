% Author: Susana Alvarez
%
% DGX
% This function returns an image with her derivative respect X of the
% sigma (s) Guassian 


function res=dGx(sx,sy,ang,size_im);

if(size(size_im,2)==1)
    size_im=[size_im size_im];
end

siz   = (size_im-1)/2;
  
[x,y] = meshgrid(-siz(2):siz(2),-siz(1):siz(1));
ang2=ang*pi/180;

res=-(1/(2.*pi.*sx.*sy)).*(((x.*cos(ang2).^2-y.*sin(ang2).*cos(ang2))./sx.^2)+((x.*sin(ang2).^2+y.*sin(ang2).*cos(ang2))./sy.^2))...
.*exp(-0.5.*(((x.*cos(ang2)-y.*sin(ang2)).^2./(sx.^2))+((x.*sin(ang2)+y.*cos(ang2)).^2./(sy.^2))));

