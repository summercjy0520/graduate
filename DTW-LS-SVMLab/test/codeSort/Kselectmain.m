function [selection,Distance]=Kselectmain(S,Q,TXT,TT,qq,Direction,k)

% dd1=NHDTWnewest(S,Q,qq/2);
dd1=zeros(size(S,1),1);
for i=1:size(S,1)
%     dd1(i)=dtw(S(i,:),Q);
    S(i,:)=vpa(S(i,:),18);
    dd1(i)=dtwdistance(S(i,:),Q);
end

SS=zeros(k,qq);%最近邻的k个序列
K=zeros(k,1);
KH=zeros(k,1);
dd1=vpa(dd1,18);
[maxn maxi]=max(dd1);%用于替换，最大值

jjj=1;
while (jjj<=k)
%     jjj=1;%初值
    [minn mini]=min(dd1);%找第一个最小值
    if mini>=qq&&mini<=size(S,1)
    K(jjj)=mini;%记录对应的行
    KH(jjj)=minn;
    dd1(mini)=maxn;
    jjj=jjj+1;
    else
    dd1(mini)=maxn;
    end   
%     jjj=jjj+1;
end
for iii=1:k
    SS(iii,:)=S(K(iii),:);
end

TD=zeros(k,1);
TH=zeros(k,1);
MD=0;
for i=1:k
    TD(i)=TT(K(i)+qq+1);
    if TXT(K(i)+qq+1)>=0
        TH(i)=1;
    else
        TH(i)=-1;
    end
end
for j=1:k
    if TH(j)==Direction
        MD=MD+1;
    end
end

selection=MD/k;

% aa=0;
% for i=1:k
%     if KH(i)>=0.5001
%         aa=aa+1;
%     end
% end

Distance=KH(end);
% Distance=aa/k;

    
