% Author: Susana Alvarez
%
% RGB2HSLX_OP
% Given an image in (R,G,B) components returns the components at HSL space.
% It adds grey component: (H,S,L,grey).
%
%
%   H range:   [0 .. 360]
%   S range:   [-1 .. 1]
%   L range:   [-1 .. 1]
%
% INPUT: 
%   - I : image in RGB components
%
% OUTPUT: 
%   - 0:   image in HSL-grey components
%
% EXAMPLE: [hsl]=rgb2hslX_OP(image);

function O=rgb2hslX_OP(I)

  NOSAT= -1;
  NOHUE= -1;

    % convert RGB image to HSL 
    % rd,gd,bd range 0-1 instead of 0-255 
        
  rdR=  double(I(:,:,1)) ./ 255.0;                   
  gdR = double(I(:,:,2)) ./ 255.0;       
  bdR = double(I(:,:,3)) ./ 255.0;       
  
  [r c]=size(rdR);

  % compute L

  l = reshape((rdR + gdR + bdR)./ 3.0,r*c,1);

  rd=reshape(rdR,r*c,1);
  gd=reshape(gdR,r*c,1);
  bd=reshape(bdR,r*c,1);
  
  % compute minimum of rd, gd, bd 
 
  ii=1:r*c;
  mi1=min(rd(ii),gd(ii));
  mi=min(bd(ii),mi1);

  gris=zeros(r*c,1);

  ind1=find(l < 0.00001);
  ind2=find(l >= 0.00001);
  
  if (size(ind1,1) >0)
      s(ind1) = NOSAT; 
      h(ind1) = NOHUE;
  end

  s(ind2)=1 - (mi(ind2)./ l(ind2));

  ind3=find(s  > 0.0001);
  ind4=find(s  <= 0.0001);
 
  gris(ind3) = 0;

  temp1(ind3) = ((rd(ind3) - gd(ind3)) + (rd(ind3) - bd(ind3))) ./ 2;
  temp2(ind3) = sqrt((rd(ind3) - gd(ind3)).*(rd(ind3) - gd(ind3)) + (rd(ind3) - bd(ind3)).*(gd(ind3) - bd(ind3)));
  h(ind3) = (180/pi) .* acos(temp1(ind3) ./ temp2(ind3));
  h((bd > gd) & (s' > 0.0001))= 360- h((bd > gd) & (s' > 0.0001));

  if (size(ind4,2) >0) 
        h(ind4) = NOHUE; 
        gris(ind4) = 1;
  end

  O(:,:,1) = reshape(h,r,c);  
  O(:,:,2) = reshape(s,r,c);  
  O(:,:,3) = reshape(l,r,c);
  O(:,:,4) = reshape(gris,r,c);

  