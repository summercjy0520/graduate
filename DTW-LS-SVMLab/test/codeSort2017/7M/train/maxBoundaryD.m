function [K]=maxBoundaryD(Y,q)
[Y,~]=sort(Y);
diff=zeros(size(Y,1),1);

for i=2:size(Y,1)
    probx=i/size(Y,1);    
    dataset=Y(1:i);
    j=i;
          Vtemp=((pi^(q/2))*((dataset(j))^(2)/gamma(q/2+1)));
          prob=j/(size(dataset,1)*Vtemp);
          gain=(-1)*prob*log2(prob);
%           if dataset(j)>dataset(j-1)
%               prob=(dataset(j)-dataset(j-1))/(dataset(j));%(dataset(end)-dataset(1));
%               gain=(-1)*prob*log2(prob);
%           end

    diff(i)=probx*gain;%DiffEntropy(Y,i);
end
[~,d]=max(diff);
K=d;
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