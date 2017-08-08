%计算混合距离
function dd = NHDTWnewb0108(S,Q)
z=size(S,1);
ed1=zeros(z,1);%euclidean distance
ed2=zeros(z,1);%euclidean distance
dd=zeros(z,1);%hybird distance
qq=size(Q,2);
F1=zeros(z,qq-1);%相对序列1
F2=zeros(1,qq-1);%相对序列2
A=zeros(z,1);
temp=zeros(1,qq);
%换成DTW算法

for ii=1:z
    ed1(ii)=Dtwdistance(S(ii,:),Q);
    for jj=1:(qq-1)
        if qq-1==1
            F1=S(ii,2)-S(ii,1);
            F2=Q(2)-Q(1);
        else
            F1(ii,jj)=S(ii,jj+1)-S(ii,jj);
            F2(jj)=Q(jj+1)-Q(jj);

        end
    temp(jj)=(S(ii,jj)-Q(jj));
    end
    ed2(ii)=Dtwdistance(F1(ii,:),F2);
    temp=paixu(abs(temp));
    A(ii)=temp(end);
end
% ed2=pdist2(F1,F2);
ed3=pdist2(S,Q);
[ed1,t1]=mapminmax(ed1',0,1);   
[ed2,t2]=mapminmax(ed2',0,1);
[ed3,t3]=mapminmax(ed3',0,1);
[A,t3]=mapminmax(A',0,1);
for iii=1:z
    dd(iii)=(ed1(iii)+ed2(iii)+ed3(iii))/3;%+A(iii))/4;
%     dd(iii)=(ed1(iii)+ed2(iii))/2;
end
[dd,T1]=mapminmax(dd',0,1);
dd=dd';