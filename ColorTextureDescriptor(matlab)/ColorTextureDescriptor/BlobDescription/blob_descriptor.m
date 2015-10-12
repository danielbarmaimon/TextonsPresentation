%Autor: Susana Alvarez
%
%  Calculate the blobs of an image. 
%
% INPUT: 
%   - img_name : name of the image to be analysed. It must be in BD/ folder.
%   The format of the name depends on the BD where the iamge is member.
% 
%   - Threshold: threshold of the detection. It should be a real number
%   in [0.??????????]
%
%
% OUTPUT:
% - bloF :  shape attributes of the blobs found. 
% - bloC : color atributes of the blobs found.
%
%
% EXAMPLE: [bloF bloC]=blob_descriptor('D1-1.bmp', 'Brodatz', 0.03)


function  [bloF bloC]=blob_descriptor(img_name,threshold)

    global VISUAL;                  % If you want to view the results graphically or not
    %VISUAL= 1;                     % If you want to view the results graphyically and create the intermediate files 
    VISUAL= 0;                      % If you DON'T want to view the results graphyically and create the intermediate files 
    
    dirres2='/descrip/';
    dirq='BD';
    



    if strcmp(nomBD,'Brodatz')
        nomima=img_name; 
        ext='bmp'; 
    else if strcmp(nomBD,'Ponce')
            nomimaext=img_name;                % nom= nom_imatge-n, on n es un nombre
            [s1,f1]=regexp(nomimaext,'\w*\W*\d*');
            nomima=nomimaext(s1(1):f1(1)-1);                % nom de la imatge, sense extensio
            ext=nomimaext(s1(2):f1(2));                     % extensio de la imatge
        else if (strcmp(nomBD,'VisTex') | strcmp(nomBD,'VisTexL') | strcmp(nomBD,'VisTexP') | strcmp(nomBD,'VisTexL2') | strcmp(nomBD,'VisTexP2') | strcmp(nomBD,'BDIP'))
                  nomimaext=fscanf(arxiu,'%s ',1);           % nom= nom_imatge-nnnn, on n es un nombre
                  [s1,f1]=regexp(nomimaext,'\w*\W*\d*');     % nom de la imatge amb extensio
                  nomima=nomimaext(s1(1):f1(2));             % nom de la imatge, sense extensio
                  ext=nomimaext(s1(4):f1(4));                % extensio de la imatge
            else if ( strcmp(nomBD,'Curet') | strcmp(nomBD,'Outex') | strcmp(nomBD,'Outex2') | strcmp(nomBD,'Sorres') | strcmp(nomBD,'CorelTexPattern') | strcmp(nomBD,'CorelSandPeb') | strcmp(nomBD,'Catsi_c4') | strcmp(nomBD,'CorelTex') | strcmp(nomBD,'CorelTex1') | strcmp(nomBD,'CorelTex2') | strcmp(nomBD,'CorelVTex'))
                     nomimaext=fscanf(arxiu,'%s ',1);           % nom= mmm-nnnn, on n es un nombre i mmm es un altre nombre que identifica clase textura
                     [s1,f1]=regexp(nomimaext,'\w*\W*\d*');
                     nomima=nomimaext(s1(1):f1(1));            % nom de la imatge, sense extensio
                     ext=nomimaext(s1(3):f1(3));               % extensio de la imatge
                end
            end
        end
    end
                                  
    imaC=imread([dirq,nomima,'.',ext]);                  % llegeixo imatge color, 
    [r c t]=size(imaC);
     
    imaresul=RGB2OPP2(double(imaC));      % conte la imatge al espai RG,BY, necesari per fer la deteccio de blobs
    ima{1}=imaresul(:,:,1);               % imatge Intensitat normalitzada
    ima{2}=imaresul(:,:,2);               % cromatica R-G normalitzada
    ima{3}=imaresul(:,:,3);               % cromatica B-Y normalitzada
    clear imaresul;
    
    if ord=='CASL'
         dirres=[dirres2,nomima,'/'];      
    else
       dirres=[dirres2,nomima,'\'];
       comanda=['mkdir ',dirres];              % creo el subdirectori on deixare les descripcions
       [s,re]=dos(comanda);
    end
    if VISUAL
        comanda=['mkdir ',dirres];        % creo el subdirectori on deixare resultats parcials, blobs detectats
        [s,re]=dos(comanda);
    end
  
    switch (espaiC)
        case 'OPP'
            imaespaiC=RGB2OPP3(double(imaC));     % conte la imatge al espai (I,RG,BY) pero amb una normalitzacio diferent, per calcular el color
            [r c t]=size(imaespaiC);
        case 'HSL'
            imaespaiC=rgb2hslX_OP(double(imaC));     % conte la imatge al espai HSL, tambe retorna la component gris
            [r c t tt]=size(imaespaiC);
    end
    
    % abans de calcular els atributs dels blobs miro si ja existeixen
  
   [llindarDS,err]=sprintf('%3.2f',llindarD);
  
  
     
     nima=3;
     q=1;
     while (q <=nima)         % per a cada component del espai oponent
       qs=int2str(q);
       nomf=[nomima,'Blobs-',qs];
       if VISUAL disp(['Detectant blobs al canal ',qs]);           end
       %blobsd{q}=detector_blobs4(ima{q},nomf,llindarD);      % blobs de l'Anna
       blobsd{q}=detector_blobs5(ima{q},nomf,llindarD);       % blobs de l'Anna, no es filtren ni per area ni per forma, ja es fa despres al clustering
       q=q+1;
     end
     save ([dirres,'\Blobs-Canals',espaiC,'-',llindarDS,'.mat'],'blobsd');    % guardo la detecci� dels blobs
     
   end       % del try  
   
   disp(['Detectant blobs de ',nomima]); 
      % depenent del parametre op: Ajunto els blobs dels 3 canals eliminant
      % els blobs solapats o els considero tots
   bloF=fusio_blobsCol(blobsd,r,c,op);
  
      % volco el resultat de la fusio en un arxiu i ho mostro per pantalla
   if VISUAL 
        nomf=[nomima,'BlobsFUSIO'];
        name=[dirres,'/',nomf];
        Blobs_ellipses2(bloF,ima{1},name);  
   end
  
    % Calculo el color dels blobs
  if (size(bloF.pos_m,1) >0)     % s'han detectat blobs
         bloC=Calcular_color_blobs(bloF,imaespaiC,espaiC);     % Per a cada blob calculo les components cromatiques, mediana de tots els seus pixels
    else
         bloC=struct('I',[],'RG',[],'BY',[]);
  end
  
  save ([dirres,'\Blobs-',espaiC,'-',llindarDS,'.mat'],'bloF','bloC');    % guardo la detecci� dels blobs

             
