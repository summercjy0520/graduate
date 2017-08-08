function y=get_phi(dis,p)
[m,~]=size(dis);
y=zeros(m,2);
[~,index]=sort(p);
for i=1:m-1
    tmp_dis=dis(index(i),:);
    tmp_dis(index(1:i))=max(max(dis));
    [a,b]=min(tmp_dis);   
    y(index(i),:)=[a,b];
end
y(index(m),1)=max(dis(index(m),:));
y(index(m),2)=index(m);