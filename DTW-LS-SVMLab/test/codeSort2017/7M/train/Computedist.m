function [dist]=Computedist(data)
m=size(data,1);
dist=zeros(m*(m-1)/2,3);
index=1;
for i=1:m-1
    for j=i+1:m
        dist(index,1)=i;
        dist(index,2)=j;
%        dist(index,3)=sqrt((data(i,1) - data(j,1))^2 + (data(i,1) - data(j,1))^2);
%         dist(index,3)=Dtwdistance(data(i,:),data(j,:));
        dist(index,3)=pdist2(data(i,:),data(j,:),'Euclidean');
        index=index+1;
    end
end
end