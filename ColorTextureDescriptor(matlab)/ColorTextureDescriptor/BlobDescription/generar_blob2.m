%Author: Susana Alvarez
%
% GENERAR_BLOB2
% - Given blob parameters it obtains a BW image with painted blos in white color

% INPUT:
%   - x: x center of the blob
%   - y: y center of the blob
%   - e_g: semi-major axis of the blob
%   - e_p: semi-minor axis of the blob
%   - r: number of rows of the image
%   - c. number of columns of the image
%
% OUTPUT:
%   -blo: list of pixels that has the blob

function blo=generar_blob2(x,y,e_g,e_p,angle,r,c)
      
vec1=[cos(angle) -sin(angle)];
vec2=[sin(angle) cos(angle)];
    
%theta = 0:0.02:2*pi;
theta = 0:0.01:2*pi;        % by longish shapes, it should discretized more
     
x_axis = e_p*cos(theta);
y_axis = e_g*sin(theta);
      
v=[vec1(1) vec2(1); vec1(2) vec2(2)];
      
ellipse = (v*([x_axis; y_axis]))';
ellipse=ellipse + ones(length(theta), 1)*[x y];
 
ellipse=uint16(ellipse);

% If the ellipse coordinates are outside of the image
xma=(ellipse(:,1) >c);
ellipse(xma,1)=c;
xma=(ellipse(:,1)<=0);
ellipse(xma,1)=1;

xma=(ellipse(:,2) >r);
ellipse(xma,2)=r;
xma=(ellipse(:,2)<=0);
ellipse(xma,2)=1;

imablob=zeros(r,c);
for i=1:size(ellipse,1)
   imablob(ellipse(i,2),ellipse(i,1))=1;
end

blo2=imfill(imablob);
blo=find(blo2>0);


    
    