function [K]=YOffsetEntropy(Y)
[Y,KT]=sort(Y);
maxgain=0;

for i=1:size(Y,1)
    gain=computeEntropy(Y)-computeConditionalEntropy(Y,i);
    if(gain>maxgain)
        maxgain=gain;
        node=i;
    end
end

K=Y(node);
end


function entropy=computeEntropy(dataset)
entropy=0;
AU=unique(dataset);
for i=1:numel(AU)
        A=numel(find(dataset==AU(i)));
        prob=A/size(dataset,1);
        entropy=entropy+(-1)*prob*log(prob)/log(2);
end
end

function conditionalentropy=computeConditionalEntropy(dataset,m)
% conditionalentropy=0;
probx=m/size(dataset,1);
proby=1-probx;

dataset1=dataset(1:m);
dataset2=dataset(m+1:end);

probEntropyx=computeEntropy(dataset1);
probEntropyy=computeEntropy(dataset2);

conditionalentropy=probx*probEntropyx+proby*probEntropyy;
end