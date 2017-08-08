%计算混合距离
function dd = NH1(S,Q,q)
z=size(S,1);
ed1=zeros(z,1);%euclidean distance
ed2=zeros(z,1);%euclidean distance
dd=zeros(z,1);%hybird distance
qq=size(Q,2);
F1=zeros(z,qq-1);%相对序列1
F2=zeros(1,qq-1);%相对序列2

for ii=1:z
    ed1(ii)=Euclidean11(S(ii,:),Q);
    for jj=1:(q-1)
%         if jj<2*q
        F1(ii,jj)=S(ii,jj+1)-S(ii,jj);
%         else
%              F1(ii,jj)=S(ii+1,1)-S(ii,jj);
%         F1(ii,2*jj)=S(ii,2*(jj+1))-S(ii,2*jj);

%         end
        F2(jj)=Q(jj+1)-Q(jj);
%         F2(2*jj)=Q(2*(jj+1))-Q(2*jj);
%         jj=jj+1;
    end
    ed2(ii)=Euclidean11(F1(ii),F2);
    dd(ii)=(ed1(ii)+ed2(ii))/2;
    ii=ii+1;
end