% Pasar_blobsC_matriu
% Given the blob attributes structures: bloF for shape attributes and blobC
% for color, joint all of them in a matrix 

function matriu=Pasar_blobsC_matriu(bloF,bloC)

%  shape attributes of blobs
  area=[bloF.e_g.*bloF.e_p];
  aspect=[bloF.e_g./bloF.e_p];
  orien=[bloF.angle];  
%  color attributes of blobs
  hs1=[bloC.I];                     % x component at HS cartesian
  hs2=[bloC.RG];                    % y component at HS cartesian
  ii=[bloC.BY];                     % I component at HSI
  matriu=[area aspect orien hs1 hs2 ii];
  

  
  
