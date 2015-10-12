%
% It generates the filters to detect the blobs of certain size in an image.
%
% INPUT:
%
%   - size_im: two components vector which indicates the size of the image.
%   The image must be bigger than [41 x 41] pixels
%
%   - sx: vector with the values of the 11 scales corresponding to
%   sigma_x for the differential Laplacian of the Guassian operator
%
%   - sy:vector with the values of the 11 scales corresponding to
%   sigma_y for the differential Laplacian of the Guassian operator
%
%   - ori:vector with the values of the 11 scales corresponding to
%   orientation for the differential Laplacian of the Guassian operator
%
% NOTE: 
%  Be careful because it saves the variables in a .mat file with a fix name
%  and it can rewrite previous files.
%
% EXAMPLE: 
% sx=[1,1.28402541668774,1.64872127070013,2.11700001661268,2.71828182845905,3.49034295746184,4.48168907033806,5.75460267600573,7.38905609893065,9.48773583635853,12.1824939607035,15.6426318841882,20.0855369231877];
% sy=[1,1.28402541668774,1.64872127070013,2.11700001661268,2.71828182845905,3.49034295746184,4.48168907033806,5.75460267600573,7.38905609893065,9.48773583635853,12.1824939607035,15.6426318841882,20.0855369231877];
% ori=[0,0,0,0,0,0,0,0,0,0,0,0,0];     
%  filter_sym_log_generation([125,125],sx,sy,ori)


function filter_sym_log_generation(size_im,sx,sy,ori)

% Take the size of the image
    r=size_im(1);
    c=size_im(2);

    if ( r > 41) && (c > 41)            % Check the minimum size allowed for the image 
        
        % Calculating of the image part corresponding at estructrual
        % element
        width=[ceil(c/2)-20:ceil(c/2)+20];            % if size image is odd, round up is needed.
        length=[ceil(r/2)-20:ceil(r/2)+20];

    % Filter generation and his Fourier transform
    tf_filt=zeros(r,c,size(sx,2));
    se_syn=zeros(size(length,2),size(width,2),size(sx,2));
    tfgx=zeros(r,c,size(sx,2));
    tfgy=zeros(r,c,size(sx,2));
    for(i=1:size(sx,2))
            [gxx gyy]=LG(sx(i),sy(i),ori(i),[r c]);
            filt=sx(i).^2.*gxx+sy(i).^2.*gyy;

            %Fourier transform for the previous log
            tf_filt(:,:,i)=fft2(filt);     
            
            % Structural element to synthesize subtextures
            str_el=((filt<0.01.*min(min((filt)))));  % Structural element (corresponds to the negative part of the filter) 
                                                     % Size of the blob:
                                                     % 10% of the filte
            se_syn(:,:,i)=str_el(length,width);         
            
            % Filters needed to calculate the windowed second moment matrix
            tfgx(:,:,i)=fft2(dGx(sx(i),sy(i),ori(i),[r c]));
            tfgy(:,:,i)=fft2(dGy(sx(i),sy(i),ori(i),[r c]));  
    end       

    d_filtres=[sx;sy;ori];
       
    % Save the results
    save filter_sym_log.mat tf_filt 
    save struct_sym_syn.mat se_syn;
    save tf_gaussian_derivates.mat tfgx tfgy;
    save dades_filtres.mat d_filtres;
    
    else
        error('Image size too small. Filters can not be calculated');
    end