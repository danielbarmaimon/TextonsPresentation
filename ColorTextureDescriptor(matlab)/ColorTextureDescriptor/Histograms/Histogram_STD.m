% Histogram_STD
%  This function builds the STD descriptor given the blobs features of an
%  image.
%
% INPUT:
%   - name: name of the image. it must be at BD/ Folder
%   - tipusq: type of quantification (determines quantization model and bins size)
%   - bloF: structure with blob shape features
%   - bloC: structure with blob color features
%
% OUTPUT:
%   - histo: histogram STD of the image
function histo=Histogram_STD(name,tipusq,bloF,bloC)
                           
  currentFolder=pwd;
  barra=filesep;
  method='STD';
  espaiC='HSL';  % DEFAULT VALUE
  
  imaC=imread(['BD',barra,name]);
  [r c t]= size(imaC);
  mida=min(r,c);
  clear imaC;

  dim=calcul_numbinsCol4(tipusq);        % Calculate the number of bins needed for the histogram according to the quantification type
  numbinsS=dim(1)*dim(2)*dim(3);
  
  numbinsC=1;
  for y=4:size(dim,2)
     numbinsC=numbinsC*dim(y);
  end
  
     % Calculates the probability functions (attribute histogram) of the image
   histoS=zeros(dim(1),dim(2),dim(3));      % histogram for shape attributes
   histoC=zeros(dim(4),dim(5),dim(6));      % histogram for colour attributes
  
   if (~isempty(bloF))
       matriu_b=Pasar_blobsC_matriu(bloF,bloC);
          % Quantification of all the components
       [c2S,pS,c2C,pC]=ShapeColorQuantif3SC(matriu_b,mida,tipusq,espaiC);     
       for u=1:size(c2S,1)
            histoS(c2S(u,1),c2S(u,2),c2S(u,3))=histoS(c2S(u,1),c2S(u,2),c2S(u,3))+pS(u);       % increasing the value
       end
       for u=1:size(c2C,1)
            histoC(c2C(u,1),c2C(u,2),c2C(u,3))=histoC(c2C(u,1),c2C(u,2),c2C(u,3))+pC(u);       %  increasing the value
       end
     else
         disp(['WARNING!  There is no descriptor!']); 
   end   
  
  histoS=reshape(histoS,numbinsS,1);        % Shape histogram
  histoS=histoS/sum(histoS);                % Shape histogram normalized
  histoC=reshape(histoC,numbinsC,1);        % Color histogram
  histoC=histoC/sum(histoC);                % Color histogram normalized
  histo=[histoS; histoC];                    % concatenation of color and shape histograms

 disp(['STD descriptor is computed!']);
