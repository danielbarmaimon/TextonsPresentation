% RGB2OPP2
%
% Given an (R,G,B) image it returns the components at (I,RG,BY).
% All the components are in range [0..255]
%
% INPUT: 
%   - I : image in RGB components
%
% OUTPUT: 
%   - 0:   image in (I,RG,BY) components
%
function O=RGB2OPP2(I)
 
if ndims(I)==3

    % range of the I component [0..255]
	O(:,:,1)=sum(I,3)./3; 
     
    %range of the RG component [-1..1];
	O(:,:,2)=(I(:,:,1)-I(:,:,2))./(sum(I,3)+eps);
    
    % To have RG in range [0..255];
    O(:,:,2)=(O(:,:,2)+1).*(255/2);

    %range of the BY component [-2..1];
	O(:,:,3)=(I(:,:,1)+I(:,:,2)-2*I(:,:,3))./(sum(I,3)+eps); 

    % To have RG in range  [0..255];
    O(:,:,3)=(O(:,:,3)+2).*(255/3);
 
else 

    %range of the I component [0..255]
    O(:,1)=sum(I,2)./3;
   
    %range of the RG component [-1..1];
    O(:,2)=(I(:,1)-I(:,2))./(sum(I,2)+eps);

     % To have RG in range [0..255];
    O(:,2)=(O(:,2)+1).*(255/2);
  
    %range of the BY component [-2..1];
    O(:,3)=(I(:,1)+I(:,2)-2*I(:,3))./(sum(I,2)+eps);
 
    % To have RG in range  [0..255];
    O(:,3)=(O(:,3)+2).*(255/3);
   
end
