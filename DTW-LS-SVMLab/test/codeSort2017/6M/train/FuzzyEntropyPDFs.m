function [K]=FuzzyEntropyPDFs(Y,qq)
[Y,KT]=sort(Y);
maxgain=0; %-inf
diff=zeros(size(Y,1),1);
for i=2:size(Y,1)
    gain=computeEntropy(Y,qq)-computeConditionalEntropy(Y,qq,i);
    if(gain>maxgain)
        maxgain=gain;
        diff(i)=gain;%DiffEntropy(Y,i);
    else
        diff(i)=gain;
%         if i>100
%             break;
%         end
    end
end
[c,d]=max(diff);
K=d;
end

function re=computeEntropy(dataset,q)
re=0;
AU=size(dataset,1);
for j=2:AU
    if dataset(j)>dataset(1)
        Vtemp=((pi^(q/2))*((dataset(j))^(2)/gamma(q/2+1)));
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