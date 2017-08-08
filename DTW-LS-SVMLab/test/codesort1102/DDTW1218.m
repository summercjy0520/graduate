function dd = DDTW1218(S,Q)
z=size(S,1);
ed1=zeros(z,1);%euclidean distance
ed2=zeros(z,1);%euclidean distance
dd=zeros(z,1);%hybird distance
qq=size(Q,2);
F1=zeros(z,qq-2);%相对序列1
F2=zeros(1,qq-2);%相对序列2

for ii=1:z
    ed1(ii)=Dtwdistance(S(ii,:),Q);
    for jj=2:(qq-1)
        if qq-1==2
            F1=(1/2)*(S(ii,2)-S(ii,1))+1/2*(S(ii,3)-S(ii,1));
            F2=(1/2)*(Q(ii,2)-Q(ii,1))+1/2*(Q(ii,3)-Q(ii,1));
        else
            F1(ii,jj-1)=(1/2)*((S(ii,jj)-S(ii,jj-1))+1/2*(S(ii,jj+1)-S(ii,jj-1)));
            F2(jj-1)=(1/2)*((Q(jj)-Q(jj-1))+1/2*(Q(jj+1)-Q(jj-1)));
        end
    end
    ed2(ii)=DDtwdistance(F1(ii,:),F2);
end
dd(ii)=(ed1(ii)+ed2(ii))/2;
[dd,T1]=mapminmax(dd',0,1);
dd=dd';