function [K]=EntropyPDF(Y,q)
[Y,KT]=sort(Y);
rightvalue=zeros(size(Y,1),1);
diff=zeros(size(Y,1),1);
for i=1:size(Y,1)
    diff(i)=computeEntropy(Y,q)-computeConditionalEntropy(Y,q,i);
    rightvalue(i)=computeright(Y,q,i);
%     if diff(i)>rightvalue(i)
%         K=i;
%         break;
%     end
end
end

function re=computeEntropy(dataset,q)
re=0;
AU=size(dataset,1);
for j=2:AU
    if dataset(j)>dataset(1)
        Vtemp=((pi^(q/2))*((dataset(j))^(q)/gamma(q/2+1)));
        Pdistance=j/(size(dataset,1)*Vtemp);
        re=re-Pdistance*log(Pdistance);
    else
        re=re+0;
    end
end
end

function conditionalentropy=computeConditionalEntropy(dataset,qq,m)
% conditionalentropy=0;
probx=m/size(dataset,1);
proby=(size(dataset,1)-m+1)/size(dataset,1);

dataset1=dataset(1:m);
dataset2=dataset(m:end);

probEntropyx=computeEntropy(dataset1,qq);
probEntropyy=computeEntropy(dataset2,qq);

conditionalentropy=probx*probEntropyx+proby*probEntropyy;
end

function rightvalue=computeright(dataset,q,m)
N=size(dataset,1);

M1=(log2(N-1))/N;
M2=log2(3^2-2);

dataset1=dataset(1:m);
dataset2=dataset(m:end);
% n1=size(dataset1,1);
% n2=size(dataset2,1);

Entropy=computeEntropy(dataset,q);
probEntropyx=computeEntropy(dataset1,q);
probEntropyy=computeEntropy(dataset2,q);

temp=2*Entropy-1*probEntropyx-1*probEntropyy;
rightvalue=M1+(M2-temp)/N;
end

