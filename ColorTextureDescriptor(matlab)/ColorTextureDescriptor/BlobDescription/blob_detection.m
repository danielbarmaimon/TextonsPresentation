%Author: Susana Alvarez
%
%  Calculates the blobs of an image. 
%
% INPUT: 
%   - img_name : name of the image to be analysed. It must be in BD/ folder.
%   The format of the name should be NameTexture_nnnn.xxx where nnnn is a
%   number which specifies the number of the image, xxx the extension of the
%   image.
% 
%   - Threshold: threshold in the blob detection. This is the minimum filter response level to consider the detection.
%     It should be a real number in [0.1 ... 0.05] if the image has low contrast
%     If the constrast of the image is hight it should be 0.15 or less.
%
% OUTPUT:
% - bloF : shape attributes of the found blobs. 
% - bloC : color atributes of the found blobs.
%
%
% EXAMPLE: [bloF bloC]=blob_detection('example.bmp', 0.03)


function  [bloF bloC]=blob_detection(img_name,threshold)

     % DEFAULT VALUES. the user can change this values if he wants to test
     % other possibilities
    op='S';            % OP:       can be 'S' or 'F' to indicate what kind of fusion we want to do with the nearby blobs
    espaiC='HSL';      % espaiC:   can be 'HSL' or 'OPP' to indicate the colour space
     
    barra=filesep;                  % To get the symbol of the system to separate the files in a path
    dirres2=[barra,'descrip',barra];
    dirq=[barra,'BD',barra];
  
              
    [s1,f1]=regexp(img_name,'\w*\W*\d*');     % image name with the extension
    nomima=img_name(s1(1):(f1(1)-1));         % image name without the extension
    ext=img_name(f1(1)+1:f1(2));
                                  
    imaC=imread([dirq,nomima,'.',ext]);      % reading colour image 
    [r c t]=size(imaC);
     
    imaresul=RGB2OPP2(double(imaC));      % imaresult is the image represented in RG-BY space; needed for the blob detection 
    ima{1}=imaresul(:,:,1);               % Intensity image normalized
    ima{2}=imaresul(:,:,2);               % chromatic R-G normalized
    ima{3}=imaresul(:,:,3);               % chromatic B-Y normalized
    clear imaresul;
    
    dirres=[dirres2,nomima,barra];
    comanda=['mkdir ',dirres];
    [s,re]=dos(comanda);                % create the directory where we save the intermediate files

    imaespaiC=rgb2hslX_OP(double(imaC));     % to transform image in HSL space. Returns grey component, too.
    [r c t tt]=size(imaespaiC);
 
     nima=3;
     q=1;
     while (q <=nima)         % For each component of the colour space
       qs=int2str(q);
       nomf=[nomima,'Blobs-',qs];
       blobsd{q}=detector_blobs5(ima{q},threshold);       % Blob detection.
       q=q+1;
     end
     
   
   disp(['Detecting blobs of ',nomima, '.',ext]); 
   
    % depending of the parameter OP:
    %       - 'F': take all blobs found at 3 channels and remove overlap blobs
    %       - 'S': consider all blobs
   
   bloF=fusio_blobsCol(blobsd,r,c,op);
  
  
    % Calculates color blob 
  if (size(bloF.pos_m,1) >0)     % there are blobs
         bloC=Calcular_color_blobs(bloF,imaespaiC,espaiC);    % For each blob, calculate chromatic components and median of all his pixels
    else
         bloC=struct('I',[],'RG',[],'BY',[]);
  end
  disp(['Blobs detected!'])
  
      % removing temporal files
  delete('filter_sym_log.mat');
  delete('struct_sym_syn.mat');
  delete('tf_gaussian_derivates.mat');
  delete('dades_filtres.mat');
 
  

             
