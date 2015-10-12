%
% BLOBS_PARAM
% Selection of the WSMM components for the corrresponding scale
% 
% INPUT:
%   - ix: indexes of the maximums
%
%   - mu11: (1,1) component of the second moment matrix
%
%   - mu12: (1,2) & (2,1) component of the second moment matrix
%
%   - mu22: (2,2) component of the second moment matrix
%
% OUTPUT:
%   - mu11: (1,1) components of the WSMM selected
%
%   - mu12: (1,2) & (2,1) components of the WSMM selected
%
%   - mu22: (2,2) components of the WSMM selected
%
%



function [mu11s,mu12s,mu22s]=blobs_param(ix,mu11,mu12,mu22);

% Column format

temp11=zeros(size(mu11));
temp22=zeros(size(mu22));
temp12=zeros(size(mu12));


for (i=1:size(mu11,2))
    a=(ix==i);
    temp11(:,i)=mu11(:,i).*a;
    temp22(:,i)=mu22(:,i).*a;
    temp12(:,i)=mu12(:,i).*a;
end
% 
mu11s=sum(temp11,2);
mu12s=sum(temp12,2);
mu22s=sum(temp22,2);


