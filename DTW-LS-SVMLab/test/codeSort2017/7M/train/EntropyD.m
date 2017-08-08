function [K]=EntropyD(Y)
[Y,KT]=sort(Y);
rightvalue=zeros(size(Y,1),1);
diff=zeros(size(Y,1),1);
for i=1:size(Y,1)
    diff(i)=computeEntropy(Y)-computeConditionalEntropy(Y,i);
    rightvalue(i)=computeright(Y,i);
%     if diff(i)>rightvalue(i)
%         K=i;
%         break;
%     end
end
end

function entropy=computeEntropy(dataset)
entropy=0;
AU=size(dataset,1);
for i=2:AU
    if dataset(i)-dataset(i-1)>0
          prob=(dataset(i)-dataset(i-1))/(dataset(i));%(dataset(end)-dataset(1)); 
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

function rightvalue=computeright(dataset,m)
N=size(dataset,1);
M1=(log2(N-1))/N;
M2=log2(3^2-2);

dataset1=dataset(1:m);
dataset2=dataset(m:end);

Entropy=computeEntropy(dataset);
probEntropyx=computeEntropy(dataset1);
probEntropyy=computeEntropy(dataset2);

temp=2*Entropy-probEntropyx-probEntropyy;
rightvalue=M1+(M2-temp)/N;
end

