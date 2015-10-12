%
% SHIFEDGAUSSIAN
% Image convolution with a gaussian. 
%
% INPUT:
%   - x_desp: shift with respect to x
%
%   - y_desp: shift with respect to y
%
%   - sx: value of the 11 scales corresponding to
%   sigma_x for the differential Laplacian of the Guassian operator
%
%   - sy: value of the 11 scales corresponding to
%   sigma_y for the differential Laplacian of the Guassian operator
%
%   - ang: value of the 11 scales corresponding to
%   orientation for the differential Laplacian of the Guassian operator
%
%   - mida: image size.
%
% OUTPUT:
% - h: Integration gaussian
%
% EXAMPLE: h=ShifedGaussian(0,0,1.284,1.284,0,[125,125])


function h=ShiftedGaussian(x_desp, y_desp,s_x, s_y,ang,mida)

if(size(mida,2)==1)
    mida=[mida mida];
end
    
 siz   = (mida-1)/2;
     
  
     [x,y] = meshgrid(-siz(2):siz(2),-siz(1):siz(1));
     x2=x-x_desp;
     y2=y-y_desp;
     
     ang2=ang*pi/180;
     x=x2.*cos(ang2)-y2.*sin(ang2);
     y=x2.*sin(ang2)+y2.*cos(ang2);

     arg   = -(((x.*x)/(2*s_x*s_x) )+( (y.*y)/(2*s_y*s_y)));

     h     = exp(arg);
     h(h<eps*max(h(:))) = 0;

     sumh = sum(h(:));
     if sumh ~= 0,
       h  = h/sumh;
     end;
     
     

