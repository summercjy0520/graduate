function [K]=minEntropyD(Y)
[Y,KT]=sort(Y);
maxgain=0; %-inf
diff=zeros(size(Y,1),1);
entropy0=computeEntropy(Y);
for i=1:size(Y,1)
    gain=entropy0-computeConditionalEntropy(Y,i);
    if(gain>maxgain)
        maxgain=gain;
        diff(i)=gain;%DiffEntropy(Y,i);
    else
        diff(i)=gain;
        node=i;
        break;
    end
end
% [c,~]=max(diff);
K=entropy0-diff(node);
end

function entropy=computeEntropy(dataset)
entropy=0;
AU=size(dataset,1);
for i=2:AU
%     if dataset(i)>0
    if dataset(i)-dataset(i-1)>0
%           prob=i/dataset(i);
%         prob=(dataset(i)-dataset(i-1))*2/(dataset(i)+dataset(i-1));
          prob=(dataset(i)-dataset(i-1))/(dataset(i));%(dataset(end)-dataset(1)); 
%         prob=(dataset(i)+dataset(i-1))/(2*i);
%         prob=(i)/(dataset(i)^2);
%         prob=dataset(i)/i;
        entropy=entropy+(-1)*prob*log(prob)/log(2);
    else
        entropy=entropy+0;
    end
end
end

function conditionalentropy=computeConditionalEntropy(dataset,m)
% conditionalentropy=0;
probx=m/size(dataset,1);
proby=(size(dataset,1)-m+1)/size(dataset,1);

dataset1=dataset(1:m);
dataset2=dataset(m:end);

probEntropyx=computeEntropy(dataset1);
probEntropyy=computeEntropy(dataset2);

conditionalentropy=probx*probEntropyx+proby*probEntropyy;
end
