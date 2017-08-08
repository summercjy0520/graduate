function [K]=FuzzyEntropCosineT(Y,Q)
% [Y,KT]=sort(Y);
% Ck=NHDTWnew0510(Q,Q);
maxgain=0;
diff=zeros(size(Y,1),1);
for i=1:size(Y,1)
    gain=computeEntropy(Y)-computeConditionalEntropy(Y,i);
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

function entropy=computeEntropy(dataset)
entropy=0;
AU=size(dataset,1);
if AU>1
    for i=2:AU 
        if dataset(i)>0
            csum=cosinecjy(dataset(2:i),dataset(1),'lin_kernel',i-1);
            prob=i/csum;
            entropy=entropy+(-1)*prob*log(prob)/log(2);
        else
            entropy=entropy+0;
        end
    end
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