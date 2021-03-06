%计算混合距离
function [ed1,ed2]= NHDTWnew1(S,Q)
z=size(S,1);
ed1=zeros(z,1);%euclidean distance
ed2=zeros(z,1);%euclidean distance
% dd=zeros(z,1);%hybird distance
qq=size(Q,2);
F1=zeros(z,qq);%相对序列1
F2=zeros(1,qq);%相对序列2
% A=zeros(1,qq);

%换成DTW算法

for ii=1:z
    ed1(ii)=Dtwdistance(S(ii,:),Q);
    for jj=1:(qq-1)
        if qq-1==1
            F1=S(ii,2)-S(ii,1);
            F2=Q(2)-Q(1);
        else
%             F1(ii,jj)=S(ii,jj+1)-S(ii,1);
            F1(ii,jj)=S(ii,jj)-S(ii,1);
            F2(jj)=Q(jj)-Q(1);

        end

    end
    ed2(ii)=Dtwdistance(F1(ii,:),F2);

end
[ed1,t1]=mapminmax(ed1',0,1);   
[ed2,t2]=mapminmax(ed2',0,1);
% for iii=1:z
%     dd(iii)=(ed1(iii)+ed2(iii))/2;
% %     dd(iii)=ed2(iii);
% end
% [dd,T1]=mapminmax(dd',0,1);
% dd=dd';