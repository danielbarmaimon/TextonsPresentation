% Author: Susana Alvarez
% 
% LG
%  It returns log filter with s_x, s_y and rotate ang degrees.
%
%[gxx, gyy]=LG(s_x,s_y, ang,mida)

function  [gxx, gyy]=LG(s_x,s_y, ang,mida)

% If there is a single imput, the image has a square size
if(size(mida,2)==1)
    mida=[mida mida];
end

siz   = (mida-1)/2;
  
[x2,y2] = meshgrid(-siz(2):siz(2),-siz(1):siz(1));

ang2=ang*pi/180;                % angle in radians
x=x2.*cos(ang2)-y2.*sin(ang2);
y=x2.*sin(ang2)+y2.*cos(ang2);


fac1=1/(2*pi*s_x*s_y);
arg1=-0.5*((x./s_x).^2+(y./s_y).^2);

fac2x=(1/s_x.^2)*(1-(x/s_x).^2);
fac2y=(1/s_y.^2)*(1-(y/s_y).^2);


gxx=-fac1.*exp(arg1).*fac2x;        % Second derivative of gaussian with respect x
gyy=-fac1.*exp(arg1).*fac2y;        % Second derivative of gaussian with respect y


