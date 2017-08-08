function [tempx]=updown2(TXT,S,Xs,qq)
h1=size(TXT,1);
TT1=ones(h1-qq,1)*100;
TT2=ones(h1-qq,1)*100;
TT3=ones(h1-qq,1)*100;
TT4=ones(h1-qq,1)*100;

TT=zeros(h1-qq,1);
DIFF1=zeros(h1-qq,1);
DIFF2=zeros(h1-qq,1);

YT=zeros(h1-qq,1);

A1=zeros(h1-qq,1);
A2=zeros(h1-qq,1);
A3=zeros(h1-qq,1);
A4=zeros(h1-qq,1);

for tt=1:h1-qq
    t=tt+qq-1;
    TT(tt)=TXT(t+1)-TXT(t);
    DIFF1(tt)=TXT(t)-TXT(t-1);
    DIFF2(tt)=TXT(t-1)-TXT(t-2);
    if DIFF1(tt)>=0&&DIFF2(tt)>=0
               TT1(tt)=TT(tt);
               YT(tt)=1;
               A1(tt)=tt;
    elseif DIFF1(tt)>=0&&DIFF2(tt)<0
                TT2(tt)=TT(tt);
                YT(tt)=2;
                A2(tt)=tt;
    elseif DIFF1(tt)<0&&DIFF2(tt)>=0
                TT3(tt)=TT(tt);
                YT(tt)=3;
                A3(tt)=tt;
    elseif DIFF1(tt)<0&&DIFF2(tt)<0
                TT4(tt)=TT(tt);
                YT(tt)=4;
                A4(tt)=tt;                
    end
end

TT1(ismember(TT1,100,'rows')==1)=[];
TT2(ismember(TT2,100,'rows')==1)=[];
TT3(ismember(TT3,100,'rows')==1)=[];
TT4(ismember(TT4,100,'rows')==1)=[];


A1(ismember(A1,0,'rows')==1)=[];
A2(ismember(A2,0,'rows')==1)=[];
A3(ismember(A3,0,'rows')==1)=[];
A4(ismember(A4,0,'rows')==1)=[];



z=size(S,1);

SS1=zeros(size(A1,1),qq);%最近邻的k个序列

 for y1=1:size(A1,1)
      if A1(y1)<=z
           SS1(y1,:)=S(A1(y1),:);
      else
          TT1(y1)=100;
      end
 end
 SS2=zeros(size(A2,1),qq);%最近邻的k个序列

 for y2=1:size(A2,1)
       if A2(y2)<=z
        SS2(y2,:)=S(A2(y2),:);
       else
        TT2(y2)=100;
       end
 end
 
  SS3=zeros(size(A3,1),qq);%最近邻的k个序列

 for y3=1:size(A3,1)
       if A3(y3)<=z
        SS3(y3,:)=S(A3(y3),:);
       else
        TT3(y3)=100;
       end
 end
 
  SS4=zeros(size(A4,1),qq);%最近邻的k个序列

 for y4=1:size(A4,1)
       if A4(y4)<=z
        SS4(y4,:)=S(A4(y4),:);
        else
        TT4(y4)=100;
       end
 end
 

TT1(ismember(TT1,100,'rows')==1)=[];
TT2(ismember(TT2,100,'rows')==1)=[];
TT3(ismember(TT3,100,'rows')==1)=[];
TT4(ismember(TT4,100,'rows')==1)=[];

SS1(ismember(SS1,zeros(1,qq),'rows')==1,:)=[];
SS2(ismember(SS2,zeros(1,qq),'rows')==1,:)=[];
SS3(ismember(SS3,zeros(1,qq),'rows')==1,:)=[];
SS4(ismember(SS4,zeros(1,qq),'rows')==1,:)=[];

Ytest1=Xs(end)-Xs(end-1);
Ytest2=Xs(end-1)-Xs(end-2);

if Ytest1>=0
    Ytest1=1;
else
    Ytest1=-1;
end

if Ytest2>=0
    Ytest2=1;
else
    Ytest2=-1;
end


if Ytest1==1&&Ytest2==1
    SS0=SS1;
    H0=TT1;
elseif Ytest1==1&&Ytest2==-1
    SS0=SS2;
    H0=TT2;
elseif Ytest1==-1&&Ytest2==1
    SS0=SS3;
    H0=TT3;
elseif Ytest1==-1&&Ytest2==-1
    SS0=SS4;
    H0=TT4;
end

cc=size(H0,1);
for i=1:cc
    if H0(i)>=0
        H0(i)=1;
    else
        H0(i)=-1;
    end
end

km=300;
if size(SS0,1)<km
    km=size(SS0,1);
end

dd0=NHDTW(SS0,Xs',qq/2);

KK=zeros(km,1);
[maxn0 maxi0]=max(dd0);%用于替换，最大值
% mmm=size(X,1);

jjj=1;
while (jjj<=km)
%     jjj=1;%初值
    [minn0 mini0]=min(dd0);%找第一个最小值
    KK(jjj)=mini0;%记录对应的行
    dd0(mini0)=maxn0;
    jjj=jjj+1;
end
XXX=zeros(km,qq);%最近邻的k个序列
H=zeros(km,1);
for iii=1:km
    XXX(iii,:)=SS0(KK(iii),:);
    H(iii)=H0(KK(iii));
end

% [gam,sig2] = tunelssvm({XXX,H,'c',[],[],'RBF_kernel'},'simplex',...
% 'crossvalidatelssvm',{10,'mae'});
% [alpha,b] = trainlssvm({XXX,H,'c',gam,sig2,'RBF_kernel'});
% tempx= simlssvm({XXX,H,'c',gam,sig2,'RBF_kernel'},{alpha,b},Xs');

[gam,sig2] = tunelssvm({XXX,H,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

tempx = predict({XXX,H,'f',gam,sig2,'RBF_kernel'},Xs',1);

if tempx>=0
    tempx=1;
else
    tempx=-1;
end
