function [K]=FuzzyEntropy0217(Y)
maxgain=0;
[Y,KT]=sort(Y);
for i=1:size(Y,1)
    gain=computeEntropy(Y)-computeConditionalEntropy(Y,i);
    Threod=MaxGain(Y,i);
    if(gain>maxgain)
        maxgain=gain;
        if(maxgain>Threod)
            node=i;
        end
    end
end
K=KT(1:node);
end

function Threod=MaxGain(dataset,node)
dataset1=dataset(1:node);
dataset2=dataset(node+1:end);
K=numel(unique(dataset));
k1=numel(unique(dataset1));
k2=numel(unique(dataset2));
Threod=(log2(size(dataset,1)-1)+log2(3^K-2)-(K*computeEntropy(dataset)-k1*computeEntropy(dataset1)-k2*computeEntropy(dataset2)));
Threod=Threod/size(dataset,1);
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