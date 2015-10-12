%
% This function matches the type of quantification and the method with
% internal code to construct the correct histogram
%
% INPUT:
%   - tq: tipusq: type of quantization. ['q1'..'q17'];
%   - method: type of histogram: ['STD','JTD']
function typeq=match_q(tq,method)

switch (method)
    case 'JTD'
        if(strcmp(tq,'q1'))
            typeq=1;
        elseif (strcmp(tq,'q2'))
            typeq=2;
        elseif (strcmp(tq,'q3'))
            typeq=3;
        elseif (strcmp(tq,'q4'))
            typeq=4;
        elseif (strcmp(tq,'q5'))
            typeq=5;
        elseif (strcmp(tq,'q6'))
            typeq=6;
        elseif (strcmp(tq,'q7'))
            typeq=9;
        elseif (strcmp(tq,'q8'))
            typeq=10;
        elseif (strcmp(tq,'q9'))
            typeq=11;
        elseif (strcmp(tq,'q10'))
            typeq=14;
        elseif (strcmp(tq,'q11'))
            typeq=15;
        elseif (strcmp(tq,'q12'))
            typeq=16;
        elseif (strcmp(tq,'q13'))
            typeq=17;
        elseif (strcmp(tq,'q14'))
            typeq=19;
        elseif (strcmp(tq,'q15'))
            typeq=20;
        elseif (strcmp(tq,'q16'))
            typeq=21;
        elseif (strcmp(tq,'q17'))
            error('ERROR. q17 not allowet for JTD method')
        end
    case 'STD'
        if(strcmp(tq,'q1'))
            typeq=2;
        elseif (strcmp(tq,'q2'))
            typeq=5;
        elseif (strcmp(tq,'q3'))
            typeq=7;
        elseif (strcmp(tq,'q4'))
            typeq=8;
        elseif (strcmp(tq,'q5'))
            typeq=9;
        elseif (strcmp(tq,'q6'))
            typeq=12;
        elseif (strcmp(tq,'q7'))
            typeq=13;
        elseif (strcmp(tq,'q8'))
            typeq=14;
        elseif (strcmp(tq,'q9'))
            typeq=15;
        elseif (strcmp(tq,'q10'))
            typeq=16;
        elseif (strcmp(tq,'q11'))
            typeq=18;
        elseif (strcmp(tq,'q12'))
            typeq=19;
        elseif (strcmp(tq,'q13'))
            typeq=21;
        elseif (strcmp(tq,'q14'))
            typeq=22;
        elseif (strcmp(tq,'q15'))
            typeq=23;
        elseif (strcmp(tq,'q16'))
            typeq=24;
        elseif (strcmp(tq,'q17'))
            typeq=25;
        end
        
    end
end