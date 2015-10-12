%
% IMAGE_DESCRIPTION function process an image to obtain its descriptor (JTD or STD): find its blobs and compute 
% its attribute histogram according to certain quantization model tq.
%
%
%          NOTE: there are 2 global variables: area, aspectRatio. 
%                It is IMPORTANT to change these values to get a correct description. These values delimit the Shape Texton space where blob attributes are represented
%                that is the base to construct the image description. Shape Texton Space then has to be bounded by the maximun values of blob attributes 
%                of all the images we want to have its description.
%                Area and aspectRatio should have the maximum value of area and aspect-ratio (respectively), measured in pixels, of
%                all blobs of all images we want have its description (or to be compared).
%
% 
% INPUT:
%   - name : name of the image to be analysed (with extension). It must be
%   in BD/ folder. All matlab extensions are accepted.
%
%   - Threshold: threshold in the blob detection. This is the minimum filter response level to consider the detection.
%     It should be a real number in [0.1 ... 0.05] if the image has low contrast
%     If the constrast of the image is hight it should be 0.15 or less.
%
%   - tq: Type of quantization. It can be one of the following values:
%     (below it is explained the meaning of histogram dimensions)
%             
%           o) 'q1':     
%                      -> 'JTD': dim=[5,5,5,5,5,5] 
%                               5 for the axis log(a-r).cos(A), 5 for the axis log(a-r).sin(A), 5 scales,  5H, 5S, 5L 
%                      -> 'STD': dim=[5,5,5,9,9,6]
%                               5 for the axis log(a-r).cos(A), 5 for the axis log(a-r).sin(A), 5 scales,  9H, 9S, 6L
%           o) 'q2':
%                      -> 'JTD': dim=[5,5,5,9,9,6]
%                               5 for the axis log(a-r).cos(A), 5 for the axis log(a-r).sin(A), 5 scales,  9H, 9S, 6L  
%                      -> 'STD':    dim=[7,7,7,9,9,6];
%                               7 for the axis log(a-r).cos(A), 7 for the axis log(a-r).sin(A), 7 scales,  9H, 9S, 6L 
%           o) 'q3':
%                      -> 'JTD':  dim=[6,6,6,8,8,4]; 
%                               6 for the axis log(a-r).cos(A), 6 for the axis log(a-r).sin(A), 6 scales,  8H, 8S, 4L 
%                      -> 'STD':  dim=[9,9,9,9,9,9];
%                               9 for the axis log(a-r).cos(A), 9 for the axis log(a-r).sin(A), 9 scales,  9H, 9S, 9L 
%           o) 'q4':
%                      -> 'JTD':  dim=[7,7,7,8,8,4];
%                               7 for the axis log(a-r).cos(A), 7 for the axis log(a-r).sin(A), 7 scales,  8H, 8S, 4L
%                      -> 'STD':  dim=[6,6,6,12,12,9]; 
%                               6 for the axis log(a-r).cos(A), 6 for the axis log(a-r).sin(A), 6 scales,  12H, 12S, 9L
%           o) 'q5':
%                      -> 'JTD':dim=[7,7,7,9,9,6]; 
%                               7 for the axis log(a-r).cos(A), 7 for the axis log(a-r).sin(A), 7 scales,  9H, 9S, 6L 
%                      -> 'STD': dim=[5,5,5,16,4,4]; 
%                               5 for the axis log(a-r).cos(A), 5 for the axis log(a-r).sin(A), 5 scales, 16H, 4S, 4L 
%           o) 'q6':
%                      -> 'JTD':  dim=[5,5,7,10,10,6];
%                               5 for the axis log(a-r).cos(A), 5 for the axis log(a-r).sin(A), 7 scales,  10H, 10S, 6L  
%                      -> 'STD': dim=[7,7,7,16,9,9]; 
%                               7 for the axis log(a-r).cos(A), 7 for the axis log(a-r).sin(A), 7 scales, 16H, 9S, 9L
%           o) 'q7':
%                      -> 'JTD':  dim=[5,5,5,16,4,4]; 
%                               5 for the axis log(a-r).cos(A), 5 for the axis log(a-r).sin(A), 5 scales, 16H, 4S, 4L 
%                      -> 'STD':   dim=[9,9,9,16,9,9]; 
%                               9 for the axis log(a-r).cos(A), 9 for the axisx log(a-r).sin(A), 9 scales, 16H, 9S, 9L
%           o) 'q8':
%                      -> 'JTD':  dim=[7,7,7,16,4,4]; 
%                                7 for the axis log(a-r).cos(A), 7 for the axis log(a-r).sin(A), 7 scales, 16H, 4S, 4L 
%                      -> 'STD': dim=[8,4,5,8,4,4];
%                               8 orientations, 4 isotropic-non isotropic shapes, 5 scales, 8H, 4S, 4L     
%           o) 'q9':
%                      -> 'JTD': dim=[5,5,7,16,6,6]; 
%                               5 for the axis log(a-r).cos(A), 5 for the axis log(a-r).sin(A), 7 scales, 16H, 6S, 6L
%                      -> 'STD': dim=[8,4,5,16,4,4];
%                               8 orientations, 4 isotropic-non isotropic shapes, 5 scales, 16H, 4S, 4L 
%           o) 'q10':
%                      -> 'JTD': dim=[8,4,5,8,4,4];
%                               8 orientations, 4 isotropic-non isotropic shapes, 5 scales, 8H, 4S, 4L  
%                      -> 'STD':  dim=[8,4,7,16,4,4]; 
%                               8 orientations, 4 isotropic-non isotropic shapes, 7 scales, 16H, 4S, 4L  
%           o) 'q11':
%                      -> 'JTD':  dim=[8,4,5,16,4,4]; 
%                               8 orientations, 4 isotropic-non isotropic shapes, 5 scales, 16H, 4S, 4L
%                      -> 'STD':   dim=[8,4,7,16,9,9]; 
%                               8 orientations, 4 isotropic-non isotropic shapes, 7 scales, 16H, 9S, 9L 
%           o) 'q12':
%                      -> 'JTD':  dim=[8,4,7,16,4,4];
%                               8 orientations, 4 isotropic-non isotropic shapes, 7 scales, 16H, 4S, 4L  
%                      -> 'STD': dim=[8,3,7,16,4,4]; 
%                               8 orientations, 2 non isotropic shapes and 1 isotropic, 7 scales, 16H, 4S, 4L 
%           o) 'q13':
%                      -> 'JTD':  dim=[8,3,7,16,6,6];
%                               8 orientations, 2 non isotropic shapes and 1 isotropic, 7 scales, 16H, 6S, 6L
%                      -> 'STD':  dim=[8,3,7,16,6,6]; 
%                               8 orientations, 2 non isotropic shapes and 1 isotropic, 7 scales, 16H, 6S, 6L
%           o) 'q14':
%                      -> 'JTD': dim=[8,3,7,16,4,4]; 
%                               8 orientations, 2 non isotropic shapes and 1 isotropic, 7 scales, 16H, 4S, 4L 
%                      -> 'STD':  dim=[8,3,7,16,8,8]; 
%                               8 orientations, 2 non isotropic shapes and 1 isotropic, 7 scales, 16H, 8S, 8L
%           o) 'q15':
%                      -> 'JTD':   dim=[8,3,7,16,5,5]; 
%                               8 orientations, 2 non isotropic shapes and 1 isotropic, 7 scales, 16H, 5S, 5L
%                      -> 'STD': dim=[8,3,7,16,9,9]; 
%                               8 orientations, 2 non isotropic shapes and 1 isotropic, 7 scales, 16H, 9S, 9L
%           o) 'q16':
%                      -> 'JTD': dim=[8,3,7,16,6,6]; 
%                               8 orientations, 2 non isotropic shapes and 1 isotropic, 7 scales, 16H, 6S, 6L
%                      -> 'STD':dim=[8,4,7,16,9,9]; % 8 orientations, 3 non isotropic shapes and 1 isotropic, 7 scales, 16H, 9S, 9L    
%           o) 'q17':
%                      -> 'JTD': NOT AVAILABLE QUANTIFICATION FOR THIS
%                                MEHTOD
%                      -> 'STD':  dim=[8,3,7,16,10,10]; 
%                               8 orientations, 2 non isotropic shapes and 1 isotropic, 7 scales, 16H, 10S, 10L   
%
%   - method: specify the type of descriptor. It can be 'JTD' (join
%   shape and colour features) or 'STD' (separate color and shape features)
% 
% 
% OUTPUT:
%   - histo: histogram of the image.
%
% EXAMPLE: image_description('example.bmp', 0.03, 'q1', 'JTD')



function histo=image_description(name,  threshold, tq, method)
 %  IMPORTANT TO CHANGE 
%    Global variables. 
%    They should have the maximum value of area and aspect-ratio found at blobs detected. 
%    If you want to compare differents descriptions (histograms) you should change the values with the maximum
%    value obtained in all the descriptions.
        global area 
        global aspectRatio
        area= 1.997185586403992e+07;
        aspectRatio= 3.178688028890417e+06;
        
        
        
    if(nargin~=4)
        error('ERROR. Input arguments: name, threshold, type of quantification, method')
    end
    %check correct input arguments
    if((~strcmp(tq,'q1'))&(~strcmp(tq,'q2'))&(~strcmp(tq,'q3'))&(~strcmp(tq,'q4'))&(~strcmp(tq,'q5'))&(~strcmp(tq,'q6'))&(~strcmp(tq,'q7'))&(~strcmp(tq,'q8'))&(~strcmp(tq,'q9'))&(~strcmp(tq,'q10'))&(~strcmp(tq,'q11'))&(~strcmp(tq,'q12'))&(~strcmp(tq,'q13'))&(~strcmp(tq,'q14'))&(~strcmp(tq,'q15'))&(~strcmp(tq,'q16'))&(~strcmp(tq,'q17')))
        error('ERROR. Allowed values for quantification: q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14, q15, q16, q17' );
    end
    if((~strcmp(method,'JTD'))&(~strcmp(method,'STD')))
        error('ERROR. Allowed values for method: JTD, STD');
    end
    if((strcmp(method,'JTD'))&(strcmp(tq,'q17')))
        error('ERROR. q17 is not available for JTD method');
    end
    
   
    
    currentFolder=pwd;
    barra=filesep;
    addpath(([currentFolder,barra,'BlobDescription']));
    addpath(([currentFolder,barra,'BD']));
    addpath(([currentFolder,barra,'Histograms']));
    
    [bloF bloC]=blob_detection(name, threshold);

    type_q=match_q(tq,method);
    
    switch (method)
        case 'JTD'
            histo=Histogram_JTD(name,type_q,bloF,bloC);
        case 'STD'
            histo=Histogram_STD(name,type_q,bloF,bloC);
    end
end