% Author: Susana Alvarez
%
% Detector_blobs5
% Given a monochromatic image it finds image's blobs. 
%
% INPUT:
%   - img: monochromatic image
%
%   - Threshold: threshold in the blob detection. This is the minimum filter response level to consider the detection.
%     It should be a real number in [0.1 ... 0.05] if the image has low contrast
%     If the constrast of the image is hight it should be 0.15 or less.
%
% OUTPUT:
%   - Returns blobs structure with blob shape features.
%
%
% EXAMPLE: [blobs]=detector_blobs5(image, 0.03)

function blobs=detector_blobs5(im,llindarD)
global dirres;


%      FILTERS CREATION
load base3.mat;             % It has the parameters for 11 scales.
filter_sym_log_generation(size(im),sx,sy,ori); %this function generates the filters and save them in a .mat

% BLOBS' DETECTION AND BLOBS' CARACTERITZATION       

dades=blob_properties4(im,llindarD);     % It does not remove blobs produced by edges

blobs=dades;  
    
    




    