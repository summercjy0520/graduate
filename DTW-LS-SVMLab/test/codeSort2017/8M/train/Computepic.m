function [dist]=Computepic(data)
m=size(data,2);
dist=zeros(m*(m-1)/2,3);
index=1;
for i=1:m-1
    for j=i+1:m
        dist(index,1)=i;
        dist(index,2)=j;
        dist(index,3)=ssim(data{i},data{j});
        index=index+1;
    end
end
end