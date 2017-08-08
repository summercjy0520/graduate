function Jcs=ComputeCS(S1,S2,q)
crossE1=Crossentropy(S1,S2,q);
crossE2=Crossentropy(S2,S1,q);

entropy1=EntropyP(S1,q);
entropy2=EntropyP(S2,q);

if entropy1*entropy2>0
    Jcs=(1/2)*(crossE1+crossE2)/sqrt(entropy1*entropy2);
else
    Jcs=inf;
end
end

function crossE=Crossentropy(S1,S2,q)
k=1;
% p1=size(removeINF(C1));
% p2=size(removeINF(C2));
mm=size(S1,1);
nn=size(S2,1);
temp=0;
for i=1:nn
    distance=pdist2(S2(i,:),S1);
    distance=sort(distance);
    Vk=computeVk(distance(k),q);
    if Vk>0
        temp=temp+1/Vk;
    end
end

crossE=k*temp/(mm*nn);
end

function entropy=EntropyP(S,q)
if size(S,1)>1
    k=size(S,1);
    temp=0;
    for i=1:size(S,1)
        distance=pdist2(S(i,:),S);
        distance=sort(distance);
        Vk=computeVk(distance(k),q);
        temp=temp+1/Vk;
    end
    entropy=k*temp/(size(S,1)^2);
else
    entropy=inf;
end
%  entropy=-log(entropy);
end

function Vk=computeVk(Y,q)
Vk=((pi^(q/2))*(Y^2/gamma(q/2+1)));
end
% 
% function C=removeINF(C)
% inf_ind=isinf(C);
% [inf_r inf_c]=find(inf_ind==1);
% C(:,inf_c)=[];
% end