function [K]=FuzzyEntropy0217a(Y)
maxgain=0;
[Y,KT]=sort(Y);
node=0;%cut point
code=0;%layer
tode=0;%real cut point
rode=0;% all cut point
for i=1:size(Y,1)
    gain=computeEntropy(Y)-computeConditionalEntropy(Y,i);
    if(gain>maxgain)
        maxgain=gain;
        node=i;
    end
end

rode=rode+1;
Gainleft=computeEntropy(Y)-computeConditionalEntropy(Y,node);
dataset1=Y(1:node);
dataset2=Y(node+1:end);
K=numel(unique(Y));
k1=numel(unique(dataset1));
k2=numel(unique(dataset2));
Gainright=(log2(size(Y,1)-1)+log2(3^K-2)-(K*computeEntropy(Y)-k1*computeEntropy(dataset1)-k2*computeEntropy(dataset2)));
Gainright=Gainright/size(Y,1);
Diff=Gainleft-Gainright;
if(Diff>0)
    tode=tode+1;
    if(rode==(2^code))
        code=code+1;
        Cutpoint=0;
        rode=0;
    end
    node=node+Cutpoint(end);
    Cutpoint=[Cutpoint,node];
    Dvalue=Cutpoint(end)-Cutpoint(end-1); 
    fprintf('the',tode,'cut point in the',code,'layer:',node,';\n');   
end

if(code<2^(code-1))
    i=2^(code-1)+rode;
    mm=Cutpoint(i);
    nn=Cutpoint(i+1);
    datatrain=size(nn-mm+1,1);
    for j=mm:nn
        datatrain(j-mm+1)=Y(j);
    end
    rode=rode+1;
    if(rode==2^(code-1))
        Cutpoint=[Cutpoint,size(Y,1)];
    end
end
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