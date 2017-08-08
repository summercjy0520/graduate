function [Gain,D1,D2]=CheckCandidate(dataset,Shapelet)
objects_histogram=zeros(size(dataset,1),1);
for i=1:size(dataset,1)
    dist=SubsequenceDistanceEarlyAbandon(dataset(i,:),Shapelet);
%     dist=SubsequenceDist(dataset(i,:),Shapelet);
    objects_histogram(i)=dist;
end
split_dist=OptimalSplitPoint(dataset,objects_histogram);
[Gain,D1,D2]=CalculateInformationGain(dataset,objects_histogram,split_dist);
end

function [dist]=SubsequenceDist(T,Shapelet)
m=size(Shapelet,2);
n=size(T,2)-1;
Disttemp=zeros(n-m+1,1);
for i=1:(n-m+1)
    Ttemp=T(i:i+m-1);
    Disttemp(i)=pdist2(Ttemp,Shapelet,'Euclidean');
end
[dist,~]=min(Disttemp);
end

function [Gain,D1,D2]=CalculateInformationGain(dataset,obj_hist,split_dist)
% D1=[];
% D2=[];
% for i=1:size(obj_hist,1)
%     if obj_hist(i)<=split_dist
%         D1=[D1;dataset(i,:)];
%     else
%         D2=[D2;dataset(i,:)];
%     end
% end
index=find(obj_hist==split_dist);
if index==1
    D1=dataset(1,:);
    D2=dataset(2:end,:);
elseif index==size(obj_hist,1)
    D1=dataset(1:end-1,:);
    D2=dataset(end,:);
else 
    D1=dataset(1:index,:);
    D2=dataset(index+1:end,:);
end
    
Gain=ComputeEntropyGain(dataset,D1,D2);
end

function [Gain]=ComputeEntropyGain(dataset,D1,D2)
m=size(find(dataset(:,end)==1),1);
n=size(dataset,1)-m;
if isempty(D1)==1
    m1=0;
    n1=0;
else
    m1=size(find(D1(:,end)==1),1);
    n1=size(D1,1)-m1;
end
if isempty(D2)==1
    m2=0;
    n2=0;
else
    m2=size(find(D2(:,end)==1),1);
    n2=size(D2,1)-m2;
end

if m1==0&&m2==0
    Gain=-inf;
else
    if m1>0&&n1>0
        entropy1=-(m1/(m1+n1))*log(m1/(m1+n1))-(n1/(m1+n1))*log(n1/(m1+n1));
    elseif m1==0&& n1>0
        entropy1=-(n1/(m1+n1))*log(n1/(m1+n1));
    elseif n1==0 && m1>0
        entropy1=-(m1/(m1+n1))*log(m1/(m1+n1));
    elseif m1==0 && n1==0
        entropy1=0;
    end
    if m2>0 && n2>0
        entropy2=-(m2/(m2+n2))*log(m2/(m2+n2))-(n2/(m2+n2))*log(n2/(m2+n2));
    elseif m2==0 && n2>0
        entropy2=-(n2/(m2+n2))*log(n2/(m2+n2));
    elseif n2==0 && m2>0
        entropy2=-(m2/(m2+n2))*log(m2/(m2+n2));
    elseif m2==0 && n2==0
        entropy2=0;
    end
    entropy=-(m/(m+n))*log(m/(m+n))-(n/(m+n))*log(n/(m+n));
    Gain=entropy-(m1+n1)*entropy1/(m+n)-(m2+n2)*entropy2/(m+n);
%     entropy1=-(m1/(m1+n1))*log(m1/(m1+n1))-(n1/(m1+n1))*log(n1/(m1+n1));
%     entropy2=-(m2/(m2+n2))*log(m2/(m2+n2))-(n2/(m2+n2))*log(n2/(m2+n2));
% elseif m1==0||n1==0
%     entropy1=0;
% elseif m2==0||n2==0
%     entropy2=0;
end
end

function [split_dist]=OptimalSplitPoint(dataset,obj_dist)
Gainlist=zeros(size(obj_dist,1),1);
for i=1:size(obj_dist,1)
    Gainlist(i)=CalculateInformationGain(dataset,obj_dist,obj_dist(i));
end
[~,aa]=max(Gainlist);
split_dist=obj_dist(aa);
% Gain=Gainlist(aa);
end

% function [split_dist]=OptimalSplitPoint(obj_dist)
% [Y,KT]=sort(obj_dist);
% 
% maxgain=0; 
% for i=1:size(Y,1)
%     gain=computeEntropy(Y)-computeConditionalEntropy(Y,i);
%     if(gain>maxgain)
%         maxgain=gain;
%     else
%         node=i;
%         break;
%     end
% end
% split_dist=obj_hist(node);
% end

% function entropy=computeEntropy(dataset)
% [entropy] = MIToolboxMex(4,dataset);
% end
% 
% function conditionalentropy=computeConditionalEntropy(dataset,m)
% % conditionalentropy=0;
% probx=m/size(dataset,1);
% proby=1-probx;
% 
% dataset1=dataset(1:m);
% dataset2=dataset(m+1:end);
% 
% probEntropyx=computeEntropy(dataset1);
% probEntropyy=computeEntropy(dataset2);
% 
% conditionalentropy=probx*probEntropyx+proby*probEntropyy;
% end