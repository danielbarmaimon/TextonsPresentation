
% Histogram_JTD
%  This function builds the JTD descriptor given the blobs features of an
%  image.
%
% INPUT:
%   - name: name of the image. it must be at BD/ Folder
%   - tipusq: type of quantization (determines quantization model and bins size)
%   - bloF: structure with blob shape features
%   - bloC: structure with blob color features
%
% OUTPUT:
%   - histo: histogram JTD of the image


function histo=Histogram_JTD(name,tipusq,bloF,bloC)
                           
  currentFolder=pwd;
  barra=filesep;
  method='JTD';
  espaiC='HSL';  % DEFAULT VALUE

  imaC=imread(['BD',barra,name]);
  [r c t]= size(imaC);
  mida=min(r,c);
  clear imaC;
  
  dim=calcul_numbinsCol4(tipusq);      % Calculates the number of bins needed for the histogram according to the quantification type
  numbins=1;
  for y=1:size(dim,2)
     numbins=numbins*dim(y);
  end
       
   % Calculates the probability functions (attribute histogram) of the image      
  histo=zeros(dim(1),dim(2),dim(3),dim(4),dim(5),dim(6)); 
  if (~isempty(bloF))
        matriu_b=Pasar_blobsC_matriu(bloF,bloC);
        % Quantification of all attributes
        [c2,p]=ShapeColorQuantif3(matriu_b,mida,tipusq,espaiC);   
        for u=1:size(c2,1)
           histo(c2(u,1),c2(u,2),c2(u,3),c2(u,4),c2(u,5),c2(u,6))=histo(c2(u,1),c2(u,2),c2(u,3),c2(u,4),c2(u,5),c2(u,6))+p(u);       % increasing the value
        end
      else
           disp(['WARNING!  There is no descriptor!']); 
   end   
              
   histo=reshape(histo,numbins,1);
   histo=histo/sum(histo);        % Histogram normalization 

   disp(['JTD descriptor is computed!']);
