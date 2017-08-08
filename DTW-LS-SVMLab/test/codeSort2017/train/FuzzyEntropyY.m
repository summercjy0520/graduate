function [K]=FuzzyEntropyY(D,Y,Yp,t)
[D,KT]=sort(D);
maxgain=0;
Yt=zeros(size(D,1),1);
for i=1:size(D,1)
    Yt(i)=Y(KT(i));
end

Gaindiff=zeros(size(D,1),1);
for i=1:size(D,1)
    gain=computeEntropy(D,Yt,Yp,t)-computeConditionalEntropy(D,Yt,Yp,t,i);
    Gaindiff(i)=gain;
    if(gain>maxgain)
        maxgain=gain;
    else
        node=i;
        break;
    end
end

K=node;
end

function entropy=computeEntropy(dataset,Yt,Yp,t)
classA=0;
classB=0;
for j=1:size(Yt,1)
    if (Yt(j)-Yp)^2<t
        classA=classA+1;
    else
        classB=classB+1;
    end
end
probA=classA/size(dataset,1);
probB=classB/size(dataset,1);
if probA>0&&probB>0
    entropy=(-1)*probA*log(probA)/log(2)-probB*log(probB)/log(2);
elseif probB==0
    entropy=(-1)*probA*log(probA)/log(2);
elseif probA==0
    entropy=(-1)*probB*log(probB)/log(2);
else   
    entropy=0;
end
end

function conditionalentropy=computeConditionalEntropy(dataset,Yt,Yp,t,m)
probx=m/size(dataset,1);
proby=1-probx;

dataset1=dataset(1:m);
dataset2=dataset(m+1:end);

Yt1=Yt(1:m);
Yt2=Yt(m+1:end);

probEntropyx=computeEntropy(dataset1,Yt1,Yp,t);
probEntropyy=computeEntropy(dataset2,Yt2,Yp,t);

conditionalentropy=probx*probEntropyx+proby*probEntropyy;
end

