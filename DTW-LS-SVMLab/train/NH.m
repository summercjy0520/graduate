%计算混合距离
function dd = NH(S,Q)
z=size(S,1);
ed1=zeros(z,1);%euclidean distance
ed2=zeros(z,1);%euclidean distance
dd=zeros(z,1);%hybird distance
qq=size(Q,2);
F1=zeros(z,qq-1);%相对序列1
F2=zeros(1,qq-1);%相对序列2

for ii=1:z
%    ed1(ii)=0.5*((norm((S(ii,:)-mean(S(ii,:)'))-(Q-mean(Q')))^2)/(norm(S(ii,:)-mean(S(ii,:)'))^2+norm(Q-mean(Q'))^2));
%     ed1(ii)=0.5*(std(S(ii,:)-Q)^2)/(std(S(ii,:))^2+std(Q)^2);
%     ed1(ii)=Euclidean11(S(ii,:),Q);
%     ed1(ii)=disteu(S(ii,:),Q);
    ed1(ii)=pdist2(S(ii,:),Q);
    for jj=1:(qq-1)
        if qq-1==1
            F1=S(ii,2)-S(ii,1);
            F2=Q(2)-Q(1);
        else
%             F1(ii,2*jj-1)=S(ii,2*jj+1)-S(ii,2*jj-1);
% %         else
% %              F1(ii,jj)=S(ii+1,1)-S(ii,jj);
%             F1(ii,2*jj)=S(ii,2*(jj+1))-S(ii,2*jj);
%             F2(2*jj-1)=Q(2*jj+1)-Q(2*jj-1);
%             F2(2*jj)=Q(2*(jj+1))-Q(2*jj);
%         jj=jj+1;
            F1(ii,jj)=S(ii,jj+1)-S(ii,jj);
            F2(jj)=Q(jj+1)-Q(jj);
        end

    end
%      ed2(ii)=0.5*((norm((F1(ii,:)-mean(F1(ii,:)'))-(F2-mean(F2')))^2)/(norm(F1(ii,:)-mean(F1(ii,:)'))^2+norm(F2-mean(F2'))^2));
%      ed2(ii)=0.5*(std(F1(ii,:)-F2)^2)/(std(F1(ii,:))^2+std(F2)^2);
%     ed2(ii)=Euclidean11(F1(ii,:),F2);
%     ed2(ii)=disteu(F1(ii,:),F2);
    ed2(ii)=pdist2(F1(ii,:),F2);
    dd(ii)=(ed1(ii)+ed2(ii))/2; 
end
[dd,T1]=mapminmax(dd',0,1);
dd=dd';