%
% SEC_MOM_MATRIX
% Given an image and a set of scales, it calculates the second
% moment matrix with the integration scale = gamma*s_local.
%
% INPUT:
%   - size_im: vector with 2 components corresponding to the image size.
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
%   - gamma: gamma value 
%
%   - im: image
%
% OUTPUT:
%   - mu11: (1,1) component of the second moment matrix
%
%   - mu12: (1,2) & (2,1) component of the second moment matrix
%
%   - mu22: (2,2) component of the second moment matrix
%
%
% EXAMPLE:
% sx=[1,1.28402541668774,1.64872127070013,2.11700001661268,2.71828182845905,3.49034295746184,4.48168907033806,5.75460267600573,7.38905609893065,9.48773583635853,12.1824939607035,15.6426318841882,20.0855369231877];
% sy=[1,1.28402541668774,1.64872127070013,2.11700001661268,2.71828182845905,3.49034295746184,4.48168907033806,5.75460267600573,7.38905609893065,9.48773583635853,12.1824939607035,15.6426318841882,20.0855369231877];
% or=[0,0,0,0,0,0,0,0,0,0,0,0,0];     
% [mu11,mu12,mu22]=sec_mom_matrix([125,125],sx,sy,or,2,image);

function [mu11,mu12,mu22]=sec_mom_matrix(size_im,sx,sy,or,gamma,im);
 
    %load filters needed created by filter_sym_log_generation function
    load tf_gaussian_derivates.mat; % tfgx tfgy
    
    tfim=fft2(im);
     
    sx_int=gamma.*sx;
    sy_int=gamma.*sy; 
    
    mu11=zeros(size_im(1)*size_im(2), size(sx,2));
    mu12=zeros(size_im(1)*size_im(2), size(sx,2));
    mu22=zeros(size_im(1)*size_im(2), size(sx,2));
    for(i=1:size(sx,2))

        %tfgx is the Fourier Transform of the derivative with respect to x
        % of the convolucioned image by a gausian of s(i) size [local scale]
        
        Lx=real(fftshift(ifft2(tfim.*tfgx(:,:,i))));
        Ly=real(fftshift(ifft2(tfim.*tfgy(:,:,i))));
        Lxt=reshape(Lx,[],1);
        Lyt=reshape(Lx,[],1);
        % Convolutions with another gausian: the integration gaussian
        tg=fft2(ShiftedGaussian(0,0,sx_int(i),sy_int(i),or(i),size_im)); % Fourier Transform of the integration gaussian
        
        mu11(:,i)=reshape(real(fftshift(ifft2(fft2(Lx.*Lx).*tg))),size_im(1)*size_im(2),1);
        mu12(:,i)=reshape(real(fftshift(ifft2(fft2(Lx.*Ly).*tg))),size_im(1)*size_im(2),1);        
        mu22(:,i)=reshape(real(fftshift(ifft2(fft2(Ly.*Ly).*tg))),size_im(1)*size_im(2),1);    
        mu11t=reshape(mu11,[],1);
        mu12t=reshape(mu12,[],1);
        mu13t=reshape(mu22,[],1);
       
    end

