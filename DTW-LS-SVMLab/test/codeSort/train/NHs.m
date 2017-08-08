%计算混合距离
function dd = NHs(S,Q)
z=size(S,1);
dd=zeros(z,1);%hybird distance
qq=size(Q,2);
F1=zeros(z,qq-1);%相对序列1
F2=zeros(1,qq-1);%相对序列2

ed1=pdist2(S,Q,'seuclidean');%euclidean distance
for ii=1:z
    for jj=1:(qq-1)
        if qq-1==1
            F1=S(ii,2)-S(ii,1);
            F2=Q(2)-Q(1);
        else
            F1(ii,jj)=S(ii,jj+1)-S(ii,jj);
            F2(jj)=Q(jj+1)-Q(jj);
        end
    end
    
end
ed2=pdist2(F1,F2,'seuclidean');%euclidean distance
for i=1:z
    dd(i)=(ed1(i)+ed2(i))/2; 
%     dd(i)=(ed1(i)+ed2(i)*0); 
end
[dd,T1]=mapminmax(dd',0,1);
dd=dd';