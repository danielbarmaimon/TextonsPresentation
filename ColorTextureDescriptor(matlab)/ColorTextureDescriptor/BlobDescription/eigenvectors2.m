% eigenvectors2
% It returns the eigenvalues and eigenvectors needed by the estructural tensor
% It is designed for a 2x2 matrix
%
% INPUT
%   - mu11: (1,1) component of the second moment matrix
%
%   - mu12: (1,2) & (2,1) component of the second moment matrix
%
%   - mu22: (2,2) component of the second moment matrix
%
% OUTPUT:
%   - vec1 : eigenvector 1
% 
%   - vec2 : eigenvector 2
% 
%   - val1 : eigenvalue 1
% 
%   - val2 : eigenvalue 1
% 

function [vec1,vec2,val1,val2]=eigenvectors2(mu11,mu12,mu22);

%to avoid precision errors
a=mu11.*(abs(mu11)>10.^-10);
b=mu22.*(abs(mu22)>10.^-10);
c=mu12.*(abs(mu12)>10.^-10);


% eigenvalues
temp1 = (b+a+sqrt((b+a).*(b+a)-4*(a.*b-c.*c)))./2;
temp2 = (b+a-sqrt((b+a).*(b+a)-4*(a.*b-c.*c)))./2;

%  negative eigenvalues are not considered 
ind=find(temp1 <0);
temp1(ind)=0;

ind=find(temp2 <0);
temp2(ind)=0;

val1=max(temp1,temp2);
val2=min(temp1,temp2);

% eigenvector computation 
    % eigenvector of val1
    vec1_1 = ones(length(val1),1);
    vec1_2 = ones(length(val1),1);
    norma_1 = ones(length(val1),1);
    ii=1;
    while (ii <= length(val1))
        if (c(ii) ~= 0)
            vec1_2(ii) = (val1(ii) - a(ii)).*vec1_1(ii)./c(ii);
            norma_1(ii) = sqrt(vec1_1(ii).^2 + vec1_2(ii).^2);
            vec1_1(ii) = 1./norma_1(ii);
            vec1_2(ii) = vec1_2(ii)./norma_1(ii);
        end
       ii=ii+1;
    end

    % eigenvector of val2
    vec2_1 = ones(length(val1),1);
    vec2_2 = ones(length(val1),1);
    norma_2 = ones(length(val1),1);
    ii=1;
    while (ii <= length(val1))
        if (c(ii) ~= 0)
            vec2_2(ii) = (val2(ii) - a(ii)).*vec2_1(ii)./c(ii);
            norma_2(ii) = sqrt(vec2_1(ii).^2 + vec2_2(ii).^2);
            vec2_1(ii) = -1./norma_2(ii);
            vec2_2(ii) = -vec2_2(ii)./norma_2(ii);
        end
       ii=ii+1;
    end

    cZero=(c==0); % not valid points 

    isA=(max(a,b)==a); 

    t_val1=isA.*a+not(isA).*b; 
    t_val2=not(isA).*a+(isA).*b;

    t_vec1_1=isA*1;
    t_vec1_2=not(isA)*1;

    t_vec2_1=not(isA)*1;
    t_vec2_2=isA.*1;

vec1_1(cZero)=t_vec1_1(cZero);
vec1_2(cZero)=t_vec1_2(cZero);
vec2_1(cZero)=t_vec2_1(cZero);
vec2_2(cZero)=t_vec2_2(cZero);

vec1(:,1)=vec1_1;
vec1(:,2)=vec1_2;

vec2(:,1)=vec2_1;
vec2(:,2)=vec2_2;
