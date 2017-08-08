%计算混合距离
function dd = NHDTW(S,Q,q)
z=size(S,1);
ed1=zeros(z,1);%euclidean distance
ed2=zeros(z,1);%euclidean distance
dd=zeros(z,1);%hybird distance
qq=size(Q,2);
F1=zeros(z,qq-2);%相对序列1
F2=zeros(1,qq-2);%相对序列2

%换成DTW算法

for ii=1:z
    ed1(ii)=DTW(S(ii,:),Q);
    for jj=1:(q-1)
        if qq-1==1
            F1=S(2)-S(1);
            F2=Q(2)-Q(1);
        else
            F1(ii,2*jj-1)=S(ii,2*jj+1)-S(ii,2*jj-1);
%         else
%              F1(ii,jj)=S(ii+1,1)-S(ii,jj);
            F1(ii,2*jj)=S(ii,2*(jj+1))-S(ii,2*jj);
            F2(2*jj-1)=Q(2*jj+1)-Q(2*jj-1);
            F2(2*jj)=Q(2*(jj+1))-Q(2*jj);
%         jj=jj+1;

        end

    end
    ed2(ii)=DTW(F1(ii,:),F2);
    dd(ii)=(ed1(ii)+ed2(ii))/2;
end