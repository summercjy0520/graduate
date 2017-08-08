function [re]=InitializeKNN(data,N,M)   
    [m n]=size(data);   %m是数据个数，n是数据维数
    u=zeros(N,n);       %随机初始化，最终迭代到每一类的中心位置
%    dataT=data;
    for i=1:N
            index=randperm(size(data,1),1);
            u(i,:)=data(index,:);
            tmp{i}=u(i,:); 
            data(index,:)=[];
    end
    
    while size(data,1)>0
        dd=zeros(size(data,1),1);
        for h=1:size(data,1)
            dd(h)=min(pdist2(data(h,:),u));
        end
        [~,index]=min(dd);
%         index=randperm(size(data,1),1);
        dd=zeros(N,1);
        for j=1:N
            dd(j)=min(pdist2(tmp{j},data(index,:)));
        end
        tmp=findtmp(tmp,dd,data(index,:),M);
        
        u=[u;data(index,:)];
        data(index,:)=[];
    end
    
    re=[];
    for i=1:N
        B=tmp{i};
        re=[re;[B,i*ones(size(B,1),1)]];
    end
    
end

function tmp=findtmp(tmp,dd,xx,M)

A=zeros(size(tmp,2),1);
for i=1:size(A,1)
    A(i)=size(tmp{i},1);
end
B=find(A>M);
dd(B)=inf;
[~,ii]=min(dd);
tmp{ii}=[tmp{ii};xx];
end