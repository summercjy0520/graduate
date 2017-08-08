function [K]=FuzzyEntropyT(Y)
[Y,KT]=sort(Y);
maxgain=0;
diff=zeros(size(Y,1),1);
for i=1:size(Y,1)
    gain=computeEntropy(Y)-computeConditionalEntropy(Y,i);
    if(gain>maxgain)
        maxgain=gain;
        diff(i)=DiffEntropy(Y,i);
    else
        node=i;
        break;
    end
end

A=find(diff==0);
Node=min(A);
K=min(node,Node);
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


function diff=DiffEntropy(dataset,m)
diff1=0;
diff2=0;
dataset1=dataset(1:m);
dataset2=dataset(m+1:end);
AU1=unique(dataset1);
for i=1:numel(AU1)
        A=numel(find(dataset1==AU1(i)));
        prob=A/size(dataset1,1);
        diff1=diff1+log(prob)/log(2);
end

AU2=unique(dataset2);
for i=1:numel(AU2)
        A=numel(find(dataset2==AU2(i)));
        prob=A/size(dataset2,1);
        diff2=diff2+log(prob)/log(2);
end

diff=diff2-diff1;
end