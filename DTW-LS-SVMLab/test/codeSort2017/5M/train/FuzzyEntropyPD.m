function [K]=FuzzyEntropyPD(Y)
[Y,KT]=sort(Y);
maxgain=0; %-inf
diff=zeros(size(Y,1),1);
for i=1:size(Y,1)
    gain=computeEntropy(Y)-computeConditionalEntropy(Y,i);
    diff(i)=gain;
    if(gain>maxgain)
        maxgain=gain;
        diff(i)=DiffEntropy(Y,i);
        node=i;
    else
        node=i;
        break;
    end
end
K=node;
end

function entropy=computeEntropy(dataset)
[entropy] = MIToolboxMex(4,dataset);
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