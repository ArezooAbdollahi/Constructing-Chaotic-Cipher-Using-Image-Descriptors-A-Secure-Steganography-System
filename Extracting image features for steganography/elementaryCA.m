function pattern = elementaryCA(inputRule, inputSize, repetition, inputPattern)
% ELEMENTARYCA produce an elementary pattern based on the input rule the
% parameters are:
%   - INPUTRULE: It is the rule number; for instance 1, 20, 34, 255, ...
%   - INPUTSIZE: It is the size of arrays which make the pattern width
%   - REPETITION: It is the pattern length
%   - INPUTPATTERN: In a case that this parameter is set, the algorithm
%                  will work on. This parameter is optional.

if nargin<4
    inputPattern = zeros([1 inputSize]);
    inputPattern(floor((inputSize+1)/2)) = 1;
end

inputSize = length(inputPattern);
pattern = zeros([repetition inputSize]);
pattern(1,:) = inputPattern;
temp = inputPattern;

% Change decimal number to its binary equivalent
rule = bitget(inputRule,8:-1:1);

% Make the pattern matrix based on the input array, rule, and repitition
for i=2:repetition
    for j=1:inputSize
        if j==1
            previous = inputPattern(inputSize);
        else
            previous = inputPattern(j-1);
        end
        current = inputPattern(j);
        if j==inputSize
            next = inputPattern(1);
        else
            next = inputPattern(j+1);
        end
        if (previous==0)&&(current==0)&&(next==0)
            temp(j)=rule(8);
        end
        if (previous==0)&&(current==0)&&(next==1)
            temp(j)=rule(7);
        end
        if (previous==0)&&(current==1)&&(next==0)
            temp(j)=rule(6);
        end
        if (previous==0)&&(current==1)&&(next==1)
            temp(j)=rule(5);
        end
        if (previous==1)&&(current==0)&&(next==0)
            temp(j)=rule(4);
        end
        if (previous==1)&&(current==0)&&(next==1)
            temp(j)=rule(3);
        end
        if (previous==1)&&(current==1)&&(next==0)
            temp(j)=rule(2);
        end
        if (previous==1)&&(current==1)&&(next==1)
            temp(j)=rule(1);
        end
    end
    inputPattern = temp;
    pattern(i,:) = temp;
end

% Change black pixel into white and vice versa
for i=1:size(pattern,1)
    for j=1:size(pattern,2)
        if pattern(i,j)==0
            pattern(i,j) = 1;
        else
            pattern(i,j) = 0;
        end
    end
end
end