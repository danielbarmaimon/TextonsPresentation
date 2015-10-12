%Author: Susana Alvarez
%
% FUSIO_BLOBSCOL
% Given a blob structure (blobsd) with the detected blobs in all the channels (I,RG,BY), 
% it fuses overlaping blobs that have the same or adjacent centers
%
% INPUT:
%   - blobsd: structure with the shape features of the blobs
% 
%   - rr : number of rows of the image
%
%   - cc: number of columns of the image
%
%   - op: to indicate the operation of the nearby blobs:
%           - 'F': take all blobs found at 3 channels and remove overlap blobs
%           - 'S': consider all blobs
%
% OUTPUT:
%  - blobs: structure of the blobs.
%       [semi-major_axis semi-menor_axis angle position]

function blobs=fusio_blobsCol(blobsd,rr,cc,op)

 if (op == 'F')
    num=size(blobsd,2);
    p=1;
 
    for (ii=1:num)
      if (numel(blobsd{ii}.pos_m) >0) 
          s(p)=ii;
          p=p+1;
      end
    end
   
 
    if (p > 2)     % There are blobs at least two channels
        
      % REMOVE WRONG MAXIMUMS
      % Given two nearby blobs if one of the centers is within the area of its neighbor, 
      % removes one of the blobs (which has a minor filter response) 

      % Reconstruct the blobs 
      ii=1;
      while (ii <=num)
       if ( numel(blobsd{ii}.pos_m) >0 ) 
           imab(:,:,ii)=generar_blobs(blobsd{ii},rr,cc);     % image containing filled blobs (with the magnitude value of the filter response)
        else imab(:,:,ii)=zeros(rr,cc);
       end
       ii=ii+1;
      end

      Mmax=max(imab,[],3);     % absolute maximums    
 
      ii=1;
      q=1;
      maxi=zeros(rr,cc);
      while (ii <= num)
        pp=1;
        while (pp <= length(blobsd{ii}.pos_m) )
               % index in (i,j) format of the centers positions that are absolute maximums
            [y x]=ind2sub([rr cc],blobsd{ii}.pos_m(pp)); 
            if ( abs(blobsd{ii}.valfilt(y,x) - Mmax(y,x)) < eps)     %  The blob must be considered
               
                 maxi(y,x)=1;           
                 blobs.e_g(q,1)= blobsd{ii}.e_g(pp);
                 blobs.e_p(q,1)= blobsd{ii}.e_p(pp);
                 blobs.angle(q,1)= blobsd{ii}.angle(pp);
                 blobs.pos_m(q,1)= blobsd{ii}.pos_m(pp);
                 q=q+1;
            end
            pp=pp+1;
        end
        ii=ii+1;
      end
      blobs.maxim=reshape(maxi,rr*cc,1);
    else if (p>1)      %  There are blobs in a single channel
           blobs=blobsd{s(p-1)};
           val=find(blobs.maxim ~=0);
           blobs.maxim=zeros(rr*cc,1);
           blobs.maxim(val)=1;
         
        else
            blobs=struct('e_g',[],'e_p',[],'angle',[],'pos_m',[]);
        end
    end
 else   % op= 'S'
    % Take together all the blobs detected.
    blobs.e_g=[blobsd{1}.e_g; blobsd{2}.e_g; blobsd{3}.e_g];
    blobs.e_p=[blobsd{1}.e_p; blobsd{2}.e_p; blobsd{3}.e_p];
    blobs.angle=[blobsd{1}.angle; blobsd{2}.angle; blobsd{3}.angle];
    blobs.pos_m=[blobsd{1}.pos_m; blobsd{2}.pos_m; blobsd{3}.pos_m]; 
    blobs.signe=[blobsd{1}.maxim(blobsd{1}.pos_m); blobsd{2}.maxim(blobsd{2}.pos_m); blobsd{3}.maxim(blobsd{3}.pos_m)];
   
 end
