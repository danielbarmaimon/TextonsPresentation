% ShapeColorQuantif3
% Made a quantization of shape and colour blob attributes
%
% INPUT:
%   - matriu: matrix with six components [area a-r ori hsx hsy i]
%   - mida: image size
%   - tipusq: type of quantization (determines quantization model and bins size)
%   - espaiC: color space
%
% OUTPUT:
%   - c2: coordinates list of each bin
%   - p: total blobs included in each bin

function [c2,p]=ShapeColorQuantif3(matriu,mida,tipusq,espaiC)

global area;
global aspectRatio;


dim=calcul_numbinsCol4(tipusq);   


switch (tipusq)       
        case {1, 2, 3, 4, 5, 6}                     % shape and colour texton space linear quantized, squared bins   
            shapecol=QuantifAnnotate4LOG2(matriu,dim(1),dim(3),dim(4),dim(6),espaiC);
        case {9, 10, 11}                            % shape texton space linear quantized and colour texton space circular quantized
            shapecol=QuantifAnnotate2LOG2(matriu,dim(1),dim(3),dim(4),dim(5),dim(6),espaiC);
        case {14, 15, 16, 17}                       % shape and colour texton space circular quantized
            shapecol=QuantifAnnotate3LOG2(matriu,dim(1),dim(2),dim(3),dim(4),dim(5),dim(6),espaiC);
        case {19, 20, 21}                           % shape and colour texton space circular quantized, but shape space discriminates isotropic blobs
            shapecol=QuantifAnnotate3bLOG2(matriu,dim(1),dim(2),dim(3),dim(4),dim(5),dim(6),espaiC);   
end   

[c2,m,n]=unique(shapecol,'rows');                

for ii=1:max(n)
    ind=find(n==ii);
    p(ii)=size(ind,1);                    
end


function c=QuantifAnnotate3LOG2(vec,binsOr,binsAr,binsA,binsH,binsS,binsI,espaiC)
global area;
global aspectRatio;
% Transform (area, aspect ratio and orientation) components to log space
larea=log2(log2(vec(:,1)));           % area component, 
% it can be negative values. Impose them at 0
larea(larea<0)=0;

% Orientation component. Intitaly, in range [-pi/2 .. pi/2]
ori=vec(:,3)+(pi/2);          % Added 90 degrees because the computed orientation is perpendicular at the orientation it should be.
                              % Orientation range [0..180]
ori(find(ori== pi))=0;        % If orientation value is PI, imposes to 0.

lar=log2(vec(:,2));

if strcmp(espaiC,'HSL')                     % Cartesian coordinates
    hsx=vec(:,4);
    hsy=vec(:,5);
    ss=sqrt(hsx.^2+hsy.^2);                 % Transform them at polar coordinates. Saturation
    hh=atan2(hsy,hsx);                      % atan2 range is [-pi..pi]
    hh(hh<0)= hh(hh<0) + (2*pi);            % hue, range[0..2*pi]
    hh(find(hh== 2*pi))=0;                  % If angle value is 2*pi, imposes to 0
  else if strcmp(espaiC,'HSIYagi') | strcmp(espaiC,'HSV')     % They are in cylindrical coordinates, hue in degrees
          hh=vec(:,4).*pi./180;             % transform it to radians
          hh(find(hh== 2*pi))=0;            % If angle value is 2*pi, imposes to 0
          ss=vec(:,5);
      end
end     
hsii=vec(:,6);

mida=size(larea,1);

MaxA=log2(log2(area));
MaxAr=log2(aspectRatio);
MaxOr=pi;                 % range  blob angle [0..pi]
MaxH=2*pi;                % hs cartesian coordinates range at HSI space [0..2*pi]
MaxS=1.1;                 % hs cartesian coordinates range at HSI space  [0..1]
MaxI=1.1;                 % coordinates range i at HSI space [0..1]

mbinA=MaxA/binsA;         % size bin axis Area
mbinAr=MaxAr/binsAr;      % size bin axis A-r 
mbinOr=MaxOr/binsOr;      % size bin axis orientation

mbinH=MaxH/binsH;         % size bin axis H 
mbinS=MaxS/binsS;         % size bin axis S
mbinI=MaxI/binsI;         % size bin axis Intensity

rangA=0:mbinA:MaxA;
rangAr=0:mbinAr:MaxAr;
rangOr=0:mbinOr:MaxOr;
rangH=0:mbinH:MaxH;
rangS=0:mbinS:MaxS;
rangI=0:mbinI:MaxI;

ii=1;
while (ii <= mida)
  c1(ii)=sum(ori(ii)>= rangOr);                 % Orientation can be 0, so >=
  c2(ii)=sum(lar(ii)>= rangAr);                 % log a-r can be 0, so >=
  c3(ii)=sum(larea(ii)>= rangA);                % log area can be 0, so >=
  c4(ii)=sum(hh(ii)>= rangH);                   %  Hue pcan be 0, so >=
  c5(ii)=sum(ss(ii)>= rangS);                   %  saturation can be 0, so >=
  c6(ii)=sum(hsii(ii)>= rangI);                 % intensity can be 0, so >=
  ii=ii+1;
end

c=[c1' c2' c3' c4' c5' c6']; 


function c=QuantifAnnotate3bLOG2(vec,binsOr,binsAr,binsA,binsH,binsS,binsI,espaiC)
global area;
global aspectRatio;
% Transform (area, aspect ratio and orientation) components to log space
larea=log2(log2(vec(:,1)));           % area component
% it can be negative values. Impose them to 0
larea(larea<0)=0;

% Orientation component. Intitaly, in range [-pi/2 .. pi/2]
ori=vec(:,3)+(pi/2);                    % Added 90 degrees because the computed orientation is perpendicular at the orientation it should be.
                                        % Orientation range [0..180]
ori(find(ori== pi))=0;                  % If orientation value is PI, imposes to 0. 

lar=log2(vec(:,2));

if strcmp(espaiC,'HSL')                 % Cartesian coordinates
    hsx=vec(:,4);
    hsy=vec(:,5);
    ss=sqrt(hsx.^2+hsy.^2);             % Transform them at polar coordinates. Saturation
    hh=atan2(hsy,hsx);                  % atan2 range is [-pi..pi]
    hh(hh<0)= hh(hh<0) + (2*pi);        % hue, range[0..2*pi]
    hh(find(hh== 2*pi))=0;              % If angle value is 2*pi, imposes to 0
  else if strcmp(espaiC,'HSIYagi') | strcmp(espaiC,'HSV')     % They are in cylindrical coordinates; hue in degrees
          hh=vec(:,4).*pi./180;        % transform it to radians
          hh(find(hh== 2*pi))=0;       % If angle value is 2*pi, imposes to 0
          ss=vec(:,5);
      end
end     
hsii=vec(:,6);

mida=size(larea,1);

MaxA=log2(log2(area));
MaxAr=log2(aspectRatio);
MaxOr=pi;                 % range  blob angle [0..pi]
MaxH=2*pi;                % hs cartesian coordinates range at HSI space [0..2*pi]
MaxS=1.1;                 % hs cartesian coordinates range at HSI space  [0..1]
MaxI=1.1;                 % coordinates range i at HSI space [0..1]

mbinA=MaxA/binsA;         % size bin axis Area
mbinOr=MaxOr/binsOr;      % size bin axis orientation

mbinH=MaxH/binsH;         % size bin axis H 
mbinS=MaxS/binsS;         % size bin axis S
mbinI=MaxI/binsI;         % size bin axis intensity

rangA=0:mbinA:MaxA;
if (binsAr == 3) rangAr=[0 0.32 2 MaxAr];
 else if (binsAr == 4)
         rangAr=[0 0.32 1 2 MaxAr];
        else if (binsAr == 5)
                 rangAr=[0 0.32 1 2 3 MaxAr];
             end
     end
end
rangOr=0:mbinOr:MaxOr;
rangH=0:mbinH:MaxH;
rangS=0:mbinS:MaxS;
rangI=0:mbinI:MaxI;

ii=1;
while (ii <= mida)
  c2(ii)=sum(lar(ii)>= rangAr);                         % log a-r can be 0, so >=
  if c2(ii) == 1                    % isotropic blob
      c1(ii)= 1;                    % impose orientation to 0
  else                              % blob not isotropic
       c1(ii)=sum(ori(ii)>= rangOr);                    % Orientation can be 0, so >=
  end
  c3(ii)=sum(larea(ii)>= rangA);                        % log area can be 0, so >=
  c4(ii)=sum(hh(ii)>= rangH);                           % Hue can be 0, so >=
  c5(ii)=sum(ss(ii)>= rangS);                           % saturation can be 0, so >=
  c6(ii)=sum(hsii(ii)>= rangI);                         % intensity can be 0, so >=
  ii=ii+1;
end

c=[c1' c2' c3' c4' c5' c6']; 


      
function c=QuantifAnnotate2LOG2(vec,binsARO,binsA,binsH,binsS,binsI,espaiC)
global area;
global aspectRatio;
%Transform (area, aspect ratio and orientation) components to log space
larea=log2(log2(vec(:,1)));           % area component 
% it can be negative values. Imposes them to 0
larea(larea<0)=0;


% Orientation component. Intitaly, in range [-pi/2 .. pi/2]
ori=vec(:,3)+(pi/2);                    % Added 90 degrees because the computed orientation is perpendicular at the orientation it should be.
                                        % Orientation range [0..180]
ori(find(ori== pi))=0;                  % If orientation value is PI, imposes to 0. 
ara1=log2(vec(:,2)).*cos(2*ori);        % angle aspect-ratio component
ara2=log2(vec(:,2)).*sin(2*ori);                          

if strcmp(espaiC,'HSL')                 % Cartesian coordinates
    hsx=vec(:,4);
    hsy=vec(:,5);
    ss=sqrt(hsx.^2+hsy.^2);             % Transform them at polar coordinates. Saturation
    hh=atan2(hsy,hsx);                  % atan2 range is [-pi..pi]
    hh(hh<0)= hh(hh<0) + (2*pi);        % hue, range[0..2*pi]
    hh(find(hh== 2*pi))=0;              % If angle value is 2*pi, imposes to 0
  else if strcmp(espaiC,'HSIYagi') | strcmp(espaiC,'HSV')     % They are in cylindrical coordinates
          hh=vec(:,4).*pi./180;         % transform it to radians
          hh(find(hh== 2*pi))=0;        % If angle value is 2*pi, imposes to 0
          ss=vec(:,5);
      end
end     
hsii=vec(:,6);
mida=size(larea,1);

% Quantization with squre bins
MaxA=log2(log2(area));
MaxAr=log2(aspectRatio);
MaxH=2*pi;                              % hs cartesian coordinates range at HSI space [0..2*pi]
MaxS=1.1;                               % hs cartesian coordinates range at HSI space  [0..1]
MaxI=1.1;                               % coordinates range i at HSI space [0..1]

mbinA=MaxA/binsA;                       % size bin axis Area
mbinAr=MaxAr*2/binsARO;                 % size bin axis A-r and angle

mbinH=MaxH/binsH;                       % size bin axis H 
mbinS=MaxS/binsS;                       % size bin axis S
mbinI=MaxI/binsI;                       % size bin axis Intensity

rangA=0:mbinA:MaxA;
rangAro=-MaxAr:mbinAr:MaxAr;
rangH=0:mbinH:MaxH;
rangS=0:mbinS:MaxS;
rangI=0:mbinI:MaxI;

ii=1;
while (ii <= mida)
  c1(ii)=sum(ara1(ii)> rangAro);
  c2(ii)=sum(ara2(ii)> rangAro);
  c3(ii)=sum(larea(ii)>= rangA);
  c4(ii)=sum(hh(ii)>= rangH);
  c5(ii)=sum(ss(ii)>= rangS);
  c6(ii)=sum(hsii(ii)>= rangI);
  ii=ii+1;
end

c=[c1' c2' c3' c4' c5' c6'];       


function c=QuantifAnnotate4LOG2(vec,binsARO,binsA,binsHS,binsI,espaiC)
global area;
global aspectRatio;

%Transform (area, aspect ratio and orientation) components to log space
larea=log2(log2(vec(:,1)));           % area component area
% it can be negative values. Impose them at 0
larea(larea<0)=0;


% Orientation component. Intitaly, in range [-pi/2 .. pi/2]
ori=vec(:,3)+(pi/2);                    % Added 90 degrees because the computed orientation is perpendicular at the orientation it should be.
                                        % Orientation range [0..180]
ori(find(ori== pi))=0;                  % If orientation value is PI, imposes to 0. 
ara1=log2(vec(:,2)).*cos(2*ori);        % angle aspect-ratio component
ara2=log2(vec(:,2)).*sin(2*ori);                         

if strcmp(espaiC,'HSIYagi') | strcmp(espaiC,'HSV')           % cylindrical coordinates
    hsx=vec(:,5).* cosd(vec(:,4));
    hsy=vec(:,5).* sind(vec(:,4));
  else if espaiC == 'HSL'                                    % Cartesian coordinates
          hsx=vec(:,4);
          hsy=vec(:,5);
      end
end    
hsii=vec(:,6);

mida=size(larea,1);

% Quantization with squre bins
MaxA=log2(log2(area));
MaxAr=log2(aspectRatio);
MaxHS=1.1;                                          % hs cartesian coordinates range at HSI space  [-1..1]
MaxI=1.1;                                           % hs cartesian coordinates range at HSI space  [0..1]
mbinA=MaxA/binsA;                                   % size bin axis Area
mbinAr=MaxAr*2/binsARO;                             % size bin axis A-r i angle
mbinHS=MaxHS*2/binsHS;                              % size bin axis H and S
mbinI=MaxI/binsI;                                   % size bin axis Intensity
rangA=0:mbinA:MaxA;
rangAro=-MaxAr:mbinAr:MaxAr;
rangHS=-MaxHS:mbinHS:MaxHS;
rangI=0:mbinI:MaxI;

ii=1;
while (ii <= mida)
  c1(ii)=sum(ara1(ii)> rangAro);
  c2(ii)=sum(ara2(ii)> rangAro);
  c3(ii)=sum(larea(ii)>= rangA);
  c4(ii)=sum(hsx(ii)> rangHS);
  c5(ii)=sum(hsy(ii)> rangHS);
  c6(ii)=sum(hsii(ii)>= rangI);
  ii=ii+1;
end

c=[c1' c2' c3' c4' c5' c6'];     
  