% calcul_numbinsCol4
% given a type of quantization (tq), it returns the number of bins in each
% axis of the colour and shape blob spaces
function dim=calcul_numbinsCol4(tq)
  
  switch (tq)
        case 1          
            dim=[5,5,5,5,5,5]; % 5 for the axis log(a-r).cos(A), 5 for the axis log(a-r).sin(A), 5 scales,  5H, 5S, 5L 
        case 2 
            dim=[5,5,5,9,9,6]; % 5 for the axis log(a-r).cos(A), 5 for the axis log(a-r).sin(A), 5 scales,  9H, 9S, 6L 
        case 3          
            dim=[6,6,6,8,8,4]; % 6 for the axis log(a-r).cos(A), 6 for the axis log(a-r).sin(A), 6 scales,  8H, 8S, 4L 
        case 4          
            dim=[7,7,7,8,8,4]; % 7 for the axis log(a-r).cos(A), 7 for the axis log(a-r).sin(A), 7 scales,  8H, 8S, 4L 
        case 5          
            dim=[7,7,7,9,9,6]; % 7 for the axis log(a-r).cos(A), 7 for the axis log(a-r).sin(A), 7 scales,  9H, 9S, 6L       
        case 6         
            dim=[5,5,7,10,10,6]; % 5 for the axis log(a-r).cos(A), 5 for the axis log(a-r).sin(A), 7 scales,  10H, 10S, 6L  
        case 7    
            dim=[9,9,9,9,9,9]; % 9 for the axis log(a-r).cos(A), 9 for the axis log(a-r).sin(A), 9 scales,  9H, 9S, 9L 
        case 8         
            dim=[6,6,6,12,12,9]; %  6 for the axis log(a-r).cos(A), 6 for the axis log(a-r).sin(A), 6 scales,  12H, 12S, 9L
        case 9         
            dim=[5,5,5,16,4,4]; % 5 for the axis log(a-r).cos(A), 5 for the axis log(a-r).sin(A), 5 scales, 16H, 4S, 4L 
        case 10         
            dim=[7,7,7,16,4,4]; % 7 for the axis log(a-r).cos(A), 7 for the axis log(a-r).sin(A), 7 scales, 16H, 4S, 4L 
        case 11         
            dim=[5,5,7,16,6,6]; % 5 for the axis log(a-r).cos(A), 5 for the axis log(a-r).sin(A), 7 scales, 16H, 6S, 6L
        case 12         
            dim=[7,7,7,16,9,9]; % 7 for the axis log(a-r).cos(A), 7 for the axis log(a-r).sin(A), 7 scales, 16H, 9S, 9L   
        case 13    
            dim=[9,9,9,16,9,9]; % 9 for the axis log(a-r).cos(A), 9 for the axisx log(a-r).sin(A), 9 scales, 16H, 9S, 9L
        case 14       
            dim=[8,4,5,8,4,4]; % 8 orientations, 4 isotropic-non isotropic shapes, 5 scales, 8H, 4S, 4L     
        case 15        
            dim=[8,4,5,16,4,4]; % 8 orientations, 4 isotropic-non isotropic shapes, 5 scales, 16H, 4S, 4L              
        case 16         
            dim=[8,4,7,16,4,4]; % 8 orientations, 4 isotropic-non isotropic shapes, 7 scales, 16H, 4S, 4L  
        case {17, 21}    
            dim=[8,3,7,16,6,6]; % 8 orientations, 2 non isotropic shapes and 1 isotropic, 7 scales, 16H, 6S, 6L
        case 18         
            dim=[8,4,7,16,9,9]; % 8 orientations, 4 isotropic-non isotropic shapes, 7 scales, 16H, 9S, 9L 
        case 19    
            dim=[8,3,7,16,4,4]; % 8 orientations, 2 non isotropic shapes and 1 isotropic, 7 scales, 16H, 4S, 4L 
        case 20    
            dim=[8,3,7,16,5,5]; % 8 orientations, 2 non isotropic shapes and 1 isotropic, 7 scales, 16H, 5S, 5L
        case 22    
            dim=[8,3,7,16,8,8]; % 8 orientations, 2 non isotropic shapes and 1 isotropic, 7 scales, 16H, 8S, 8L
        case 23    
            dim=[8,3,7,16,9,9]; % 8 orientations, 2 non isotropic shapes and 1 isotropic, 7 scales, 16H, 9S, 9L
        case 24    
            dim=[8,4,7,16,9,9]; % 8 orientations, 3 non isotropic shapes and 1 isotropic, 7 scales, 16H, 9S, 9L           
        case 25    
            dim=[8,3,7,16,10,10]; % 8 orientations, 2 non isotropic shapes and 1 isotropic, 7 scales, 16H, 10S, 10L        
  end   
  
