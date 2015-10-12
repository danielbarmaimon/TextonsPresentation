% Author: Susana Alvarez
% Calcular_Color_blobs
% Given blobs' features, it reconstructs the blob to obtain their
% coordenates components and calculate the color of the blob according to
% all its pixels.
%
% INPUT:
%   - dades: shape features of the blobs
%   - imacol: color space components 
%   - espaiC: indicates the color space to work: 'OPP' or 'HSL'
%
% OUTPUT:
%   -blobsC: structure with the color features of the blob
%       [intensity Red-Green Blue-Yellow]
%   

function blobsC=Calcular_color_blobs(dades,imacol,espaiC)

        % In HSL space, the cartesian coordinates  are in [-1..1] and [0.. 1]; except angle H, that it's in [0 .. 360]
        % In shape space, the cartesian coordinates are between ranges [-5..5] and [0..6]
 

 if (numel(dades.pos_m) >0)      % There are some blobs detected
    r=size(imacol,1);
    c=size(imacol,2);
    C1=reshape(imacol(:,:,1),r*c,1);    % component I or H
    C2=reshape(imacol(:,:,2),r*c,1);    % component RG or S
    C3=reshape(imacol(:,:,3),r*c,1);    % component BY or L
    
    C1m=zeros(1,numel(dades.pos_m));
    C2m=zeros(1,numel(dades.pos_m));
    C3m=zeros(1,numel(dades.pos_m));
    for i=1:numel(dades.pos_m)                        % For each blob, it calculates its colour
       [y x]=ind2sub([r c],dades.pos_m(i));             % Coordinates of the central point of the blob (ellipse)
        % Get an image with all the points of the blob
       blo=generar_blob2(x,y,dades.e_g(i),dades.e_p(i),dades.angle(i),r,c);
       if (espaiC == 'OPP')
           C1m(i)=median(C1(blo));                      % Calculates the color for each channel with the median value, because 
           C2m(i)=median(C2(blo));                      % blob detection may not fit well enough the shape of the blob
           C3m(i)=median(C3(blo));
       else    %  HSI or HSV color space
           C1m(i)=median(C2(blo).*cosd(C1(blo)));          % HSI cylindrical coordinates to Cartesian to calculate the median
           C2m(i)=median(C2(blo).*sind(C1(blo)));          % HSI cylindrical coordinates to Cartesian to calculate the median                    
           C3m(i)=median(C3(blo)); 
       end
     
    end

  blobsC=struct('I',C1m','RG',C2m','BY',C3m');
  
else
   blobsC=struct('I',[],'RG',[],'BY',[]);
end