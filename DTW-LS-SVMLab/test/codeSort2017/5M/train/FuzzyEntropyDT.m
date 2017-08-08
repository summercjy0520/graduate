function [K]=FuzzyEntropyDT(Y)
[Y,KT]=sort(Y);
maxgain=0;
diff=zeros(size(Y,1),1);
for i=1:size(Y,1)
    gain=computeEntropy(Y,i)-computeConditionalEntropy(Y,i);
    if(gain<maxgain)
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

function entropy=computeEntropy(dataset,i)
AU=size(dataset,1);
if i==AU
    entropy=-(i/AU)*log(i/AU)/log(2);
else
    entropy=-(i/AU)*log(i/AU)/log(2)-(1-i/AU)*log(1-i/AU)/log(2);
end
end

function conditionalentropy=computeConditionalEntropy(dataset,m)

dataset1=dataset(1:m);
dataset2=dataset(m+1:end);

probx=m/size(dataset,1);
proby=1-probx;

probEntropyx=computeEntropy(dataset1,m);
probEntropyy=computeEntropy(dataset2,size(dataset,1)-m);

conditionalentropy=probx*probEntropyx+proby*probEntropyy;
end


function diff=DiffEntropy(dataset,m)
diff1=0;
diff2=0;
dataset1=dataset(1:m);
dataset2=dataset(m+1:end);
AU1=size(dataset1,1);
for i=1:AU1
    if dataset1(i)>0
        prob=i/dataset1(i);
        diff1=diff1+(-1)*prob*log(prob)/log(2);
    else
        diff1=diff1+0;
    end
end

AU2=size(dataset2,1);
for i=1:AU2
    if dataset2(i)>0
        prob=i/dataset2(i);
        diff2=diff2+(-1)*prob*log(prob)/log(2);
    else
        diff2=diff2+0;
    end
end

diff=diff2-diff1;
end