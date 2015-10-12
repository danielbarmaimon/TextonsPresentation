
% ShapeColorQuantif3SC
%  Made a quantization of shape and colour attributes in a separated way
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

function [c2S,pS,c2C,pC]=ShapeColorQuantif3SC(matriu,mida,tipusq,espaiC)

dim=calcul_numbinsCol4(tipusq);   

switch (tipusq)           
        case {2, 5, 7, 8}                   % shape and colour texton space linear quantized, squared bins 
            shapecol=QuantifAnnotate4LOG2(matriu,dim(1),dim(3),dim(4),dim(6),espaiC);
        case {9, 12, 13}                    % shape texton space linear quantized and colour texton space circular quantized
            shapecol=QuantifAnnotate2LOG2(matriu,dim(1),dim(3),dim(4),dim(5),dim(6),espaiC);
        case {14, 15, 16, 18}               % shape and colour texton space circular quantized
            shapecol=QuantifAnnotate3LOG2(matriu,dim(1),dim(2),dim(3),dim(4),dim(5),dim(6),espaiC);
        case {19, 21, 22, 23, 24, 25}       % shape and colour texton space circular quantized, but shape space discriminates isotropic blobs
            shapecol=QuantifAnnotate3bLOG2(matriu,dim(1),dim(2),dim(3),dim(4),dim(5),dim(6),espaiC);   
end   


[c2S,mS,nS]=unique(shapecol(:,1:3),'rows');                     % Remove repeated quantization (they corresponds at the same label). Shape attributes
[c2C,mC,nC]=unique(shapecol(:,4:size(dim,2)),'rows');           % Remove repeated quantization (they corresponds at the same label). Color attributes

for ii=1:max(nS)
    ind=find(nS==ii);
    pS(ii)=size(ind,1);                                         
end

for ii=1:max(nC)
    ind=find(nC==ii);
    pC(ii)=size(ind,1);                                         
end



function c=QuantifAnnotate3LOG2(vec,binsOr,binsAr,binsA,binsH,binsS,binsI,espaiC)

% Transform (area, aspect ratio and orientation) components to log space
larea=log2(log2(vec(:,1)));           % area component
% it can be negative values. Impose them at 0
larea(larea<0)=0;

% Orientation component. Intitaly, in range [-pi/2 .. pi/2]
ori=vec(:,3)+(pi/2);          % Added 90 degrees because the computed orientation is perpendicular at the orientation it should be.
                              % Orientation range [0..180]
ori(find(ori== pi))=0;        % If orientation value is PI, imposes to 0.   

lar=log2(vec(:,2));

if strcmp(espaiC,'HSL')                             % Cartesian coordinates
    hsx=vec(:,4);
    hsy=vec(:,5);
    ss=sqrt(hsx.^2+hsy.^2);                         % Transform them at polar coordinates. Saturation
    hh=atan2(hsy,hsx);                              % atan2 range is [-pi..pi]
    hh(hh<0)= hh(hh<0) + (2*pi);                    % hue, range[0..2*pi]
    hh(find(hh== 2*pi))=0;                          % If angle value is 2*pi, imposes to 0
  else if strcmp(espaiC,'HSIYagi') | strcmp(espaiC,'HSV')     % They are in cylindrical coordinates
          hh=vec(:,4).*pi./180;                     % transform it to radians
          hh(find(hh== 2*pi))=0;                    % If angle value is 2*pi, imposes to 0
          ss=vec(:,5);
      end
end     
hsii=vec(:,6);

mida=size(larea,1);

MaxA=4.6;                                           % range area=[1..9374], range log2(log2) area=[0 .. 3.72];
MaxAr=21.6;                                         % range a-r=[1..786], range log2 ar=[0 .. 9.61];
MaxOr=pi;                                           % range  blob angle [0..pi]
MaxH=2*pi;                                          % hs cartesian coordinates range at HSI space [0..2*pi]
MaxS=1.1;                                           % hs cartesian coordinates range at HSI space [0..1]
MaxI=1.1;                                           % coordinates range i at HSI space [0..1]

mbinA=MaxA/binsA;                                   % size bin axis Area
mbinAr=MaxAr/binsAr;                                % size bin axis A-r 
mbinOr=MaxOr/binsOr;                                % size bin axis orientation

mbinH=MaxH/binsH;                                   % size bin axis H 
mbinS=MaxS/binsS;                                   % size bin axis S
mbinI=MaxI/binsI;                                   % size bin axis Intensity

rangA=0:mbinA:MaxA;
rangAr=0:mbinAr:MaxAr;
rangOr=0:mbinOr:MaxOr;
rangH=0:mbinH:MaxH;
rangS=0:mbinS:MaxS;
rangI=0:mbinI:MaxI;

ii=1;
while (ii <= mida)
  
  c1(ii)=sum(ori(ii)>= rangOr);                     % Orientation can be 0, so >=
  c2(ii)=sum(lar(ii)>= rangAr);                     % log a-r can be 0, so >=
  c3(ii)=sum(larea(ii)>= rangA);                    % log area can be 0, so >=
  c4(ii)=sum(hh(ii)>= rangH);                       % Hue can be 0, so >=
  c5(ii)=sum(ss(ii)>= rangS);                       % saturation can be 0, so >=
  c6(ii)=sum(hsii(ii)>= rangI);                     % intensity can be 0, so >=
  
  ii=ii+1;
end

c=[c1' c2' c3' c4' c5' c6']; 


function c=QuantifAnnotate3bLOG2(vec,binsOr,binsAr,binsA,binsH,binsS,binsI,espaiC)

% Transform (area, aspect ratio and orientation) components to log space
larea=log2(log2(vec(:,1)));           % area component 
% it can be negative values. Impose them at 0
larea(larea<0)=0;

% Orientation component. Intitaly, in range [-pi/2 .. pi/2]
ori=vec(:,3)+(pi/2);          % Added 90 degrees because the computed orientation is perpendicular at the orientation it should be.
                              % Orientation range [0..180]
ori(find(ori== pi))=0;        % If orientation value is PI, imposes to 0.0   
lar=log2(vec(:,2));

if strcmp(espaiC,'HSL')                         % Cartesian coordinates
    hsx=vec(:,4);
    hsy=vec(:,5);
    ss=sqrt(hsx.^2+hsy.^2);                     % Transform them at polar coordinates. Saturation
    hh=atan2(hsy,hsx);                          % atan2 range is [-pi..pi]
    hh(hh<0)= hh(hh<0) + (2*pi);                % hue, range[0..2*pi]
    hh(find(hh== 2*pi))=0;                      % If angle value is 2*pi, imposes to 0
  else if strcmp(espaiC,'HSIYagi') | strcmp(espaiC,'HSV')     % They are in cylindrical coordinates, hue in degrees
          hh=vec(:,4).*pi./180;                 % transform it to radians
          hh(find(hh== 2*pi))=0;                % If angle value is 2*pi, imposes to 0
          ss=vec(:,5);
      end
end     
hsii=vec(:,6);

mida=size(larea,1);

MaxA=4.6;                                       % range area=[1..9374], range log2(log2) area=[0 .. 3.72];
MaxAr=21.6;                                     % range a-r=[1..786], range log2 ar=[0 .. 9.61];
MaxOr=pi;                                       % range  blob angle [0..pi]
MaxH=2*pi;                                      % hs cartesian coordinates range at HSI space [0..2*pi]
MaxS=1.1;                                       % hs cartesian coordinates range at HSI space [0..1]
MaxI=1.1;                                       % coordinates range i at HSI space [0..1]

mbinA=MaxA/binsA;                               % size bin axis Area
mbinOr=MaxOr/binsOr;                            % size bin axis orientacio

mbinH=MaxH/binsH;                               % size bin axis H 
mbinS=MaxS/binsS;                               % size bin axis S
mbinI=MaxI/binsI;                               % size bin axis Intensity

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
  
  c2(ii)=sum(lar(ii)>= rangAr);                 %  log a-r can be 0, so >=
  if c2(ii) == 1            % isotropic blob 
      c1(ii)= 1;            % impose orientation at 0
  else                      % non isotropic blob
       c1(ii)=sum(ori(ii)>= rangOr);            % orientation can be 0, so >=
  end
  c3(ii)=sum(larea(ii)>= rangA);                % log area can be 0, so >=
  c4(ii)=sum(hh(ii)>= rangH);                   % Hue can be 0, so >=
  c5(ii)=sum(ss(ii)>= rangS);                   % la saturation can be 0, so >=
  c6(ii)=sum(hsii(ii)>= rangI);                 % la intensity can be 0, so >=
  
  ii=ii+1;
end

c=[c1' c2' c3' c4' c5' c6']; 


function c=QuantifAnnotate2LOG2(vec,binsARO,binsA,binsH,binsS,binsI,espaiC)

%Transform (area, aspect ratio and orientation) components to log space
larea=log2(log2(vec(:,1)));           % area component
% it can be negative values. Impose them to 0
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
MaxA=4.6;                               % range area=[1..9374], range log2(log2) area=[0 .. 3.72];
MaxAr=21.6;                             % range a-r=[1..786], range log2 ar=[0 .. 9.61];
MaxH=2*pi;                              % hs cartesian coordinates range at HSI space [0..2*pi]
MaxS=1.1;                               % hs cartesian coordinates range at HSI space  [0..1]
MaxI=1.1;                               % coordinates range i at HSI space [0..1]

mbinA=MaxA/binsA;                       % size bin axis Area
mbinAr=MaxAr*2/binsARO;                 % size bin axis A-r and angle

mbinH=MaxH/binsH;                       % size bin axis H 
mbinS=MaxS/binsS;                       % size bin axis S
mbinI=MaxI/binsI;                       % size bin axis Intensitat

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

% Transform (area, aspect ratio and orientation) components to log space
larea=log2(log2(vec(:,1)));           % area component,  
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
  else if espaiC == 'HSL'               % Cartesian coordinates
          hsx=vec(:,4);
          hsy=vec(:,5);
      end
end    
hsii=vec(:,6);

mida=size(larea,1);

% Quantization with squre bins 
MaxA=4.6;                                   % range area=[1..9374], range log2(log2) area=[0 .. 3.72];
MaxAr=21.6;                                 % range a-r=[1..786], range log2 ar=[0 .. 9.61];
MaxHS=1.1;                                  % hs cartesian coordinates range at HSI space  [-1..1]
MaxI=1.1;                                   % hs cartesian coordinates range at HSI space  [0..1]

mbinA=MaxA/binsA;                           % size bin axis Area
mbinAr=MaxAr*2/binsARO;                     % size bin axis A-r i angle
mbinHS=MaxHS*2/binsHS;                      % size bin axis H and S
mbinI=MaxI/binsI;                           % size bin axis Intensity

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

