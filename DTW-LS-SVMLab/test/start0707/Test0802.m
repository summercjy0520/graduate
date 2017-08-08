
clear all;
clc;

%TXT= importdata('C:\Documents and Settings\Administrator\桌面\cjy\2016\7\data\600030.txt');
TXT= importdata('C:\Documents and Settings\Administrator\桌面\cjy\2016\7\data\zxzq0703.txt');
TXT=(TXT.textdata(503:end-5,5))';% end:2015-03~06:2864-2933  %+2000
TXT=str2double(TXT);
[TXT,T1]=mapminmax(TXT);
TXT=TXT(1:end)';
% TXT=(TXT.data(:,2));

ww=70;
prediction=zeros(ww,1);

H1=size(TXT,1);

zis=1;

% h0=H1;
h0=H1-ww;
k=200;
tempy=0;
while(zis<ww+1)
q=31; %时锟斤拷
qq=q+1;
s=1;  %预锟解窗锟斤拷;
cjy1=0;
cjy2=0;
h1=size(TXT,1);
TT1=ones(h1-1,1)*100;
TT2=ones(h1-1,1)*100;
TT3=ones(h1-1,1)*100;
TT4=ones(h1-1,1)*100;
TT5=ones(h1-1,1)*100;
TT6=ones(h1-1,1)*100;
TT7=ones(h1-1,1)*100;
TT8=ones(h1-1,1)*100;
TT=zeros(h1-1,1);
YT=zeros(h1-1,1);

A1=zeros(h1-1,1);
A2=zeros(h1-1,1);
A3=zeros(h1-1,1);
A4=zeros(h1-1,1);
A5=zeros(h1-1,1);
A6=zeros(h1-1,1);
A7=zeros(h1-1,1);
A8=zeros(h1-1,1);


YYT=zeros(h1-1,1);
v=[];
for t=1:h1-1
    TT(t)=TXT(t+1)-TXT(t);
    if TT(t)>=0
%         YT(t)=1;
        if abs(TT(t))<0.005
            TT1(t)=TT(t);
            YT(t)=1;
            A1(t)=t;
        elseif abs(TT(t))>=0.005&&abs(TT(t))<0.01
            TT2(t)=TT(t);
            YT(t)=2;
            A2(t)=t;
        elseif abs(TT(t))>=0.01&&abs(TT(t))<0.02
            TT3(t)=TT(t);
            YT(t)=3;
            A3(t)=t;
        else
            TT4(t)=TT(t);
            YT(t)=4;
            A4(t)=t;
        end
    else
%         YT(t)=-1;
        if abs(TT(t))<0.005
            TT5(t)=TT(t);
            YT(t)=-1;
            A5(t)=t;
        elseif abs(TT(t))>=0.005&&abs(TT(t))<0.01
            TT6(t)=TT(t);
            YT(t)=-2;
            A6(t)=t;
        elseif abs(TT(t))>=0.01&&abs(TT(t))<0.02
            TT7(t)=TT(t);
            YT(t)=-3;
            A7(t)=t;
        else
            TT8(t)=TT(t);
            YT(t)=-4;
            A8(t)=t;
        end
    end
   
end

TT1(ismember(TT1,100,'rows')==1)=[];
TT2(ismember(TT2,100,'rows')==1)=[];
TT3(ismember(TT3,100,'rows')==1)=[];
TT4(ismember(TT4,100,'rows')==1)=[];
TT5(ismember(TT5,100,'rows')==1)=[];
TT6(ismember(TT6,100,'rows')==1)=[];
TT7(ismember(TT7,100,'rows')==1)=[];
TT8(ismember(TT8,100,'rows')==1)=[];


A1(ismember(A1,0,'rows')==1)=[];
A2(ismember(A2,0,'rows')==1)=[];
A3(ismember(A3,0,'rows')==1)=[];
A4(ismember(A4,0,'rows')==1)=[];
A5(ismember(A5,0,'rows')==1)=[];
A6(ismember(A6,0,'rows')==1)=[];
A7(ismember(A7,0,'rows')==1)=[];
A8(ismember(A8,0,'rows')==1)=[];



X=TXT(1:h0+zis-1);
% Q=TXT(5591:5600)';
Xt=TXT((h0+1+zis-1):H1);
XXt=[X;Xt];

Xs=XXt((h0-s-q+zis):(h0+zis-s));

mm=size(TXT(1:(h0-1+zis)),1);

z=mm-s-qq+1;
S=zeros(z,qq);
h=0; %锟斤拷锟斤拷锟狡讹拷时锟斤拷影锟斤拷锟皆拷锟斤拷斜锟角?

for i=1:z
    for j=1:qq
    if h+j<=mm
    S(i,j)=X(h+j);
%     S(i,2*j)=X(h+2*j);
    end
    end
    h=h+1;
end  


dd1=NHDTW(S,Xs',qq/2);

K=zeros(k,1);
dd=zeros(k,1);
[maxn maxi]=max(dd1);%用于替换，最大值
% mmm=size(X,1);

jjj=1;
while (jjj<=k)
%     jjj=1;%初值
    [minn mini]=min(dd1);%找第一个最小值
    if mini>=qq&&mini<=(size(YT,1)-q)
    K(jjj)=mini;%记录对应的行
    dd(jjj)=minn;%记录对应的最近值
    dd1(mini)=maxn;
    jjj=jjj+1;
    else
    dd1(mini)=maxn;
    end

end
SS=zeros(k,qq);%最近邻的k个序列
Y1=zeros(k,1);
for iii=1:k
    SS(iii,:)=S(K(iii),:);
    Y1(iii)=YT(K(iii)+q);
end

V1=Y1;
V1(ismember(V1,2,'rows')==1,:)=1;
V1(ismember(V1,-2,'rows')==1,:)=-1;
V1(ismember(V1,3,'rows')==1,:)=1;
V1(ismember(V1,-3,'rows')==1,:)=-1;
V1(ismember(V1,4,'rows')==1,:)=1;
V1(ismember(V1,-4,'rows')==1,:)=-1;

[gam,sig2] = tunelssvm({SS,V1,'c',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({SS,V1,'c',gam,sig2,'RBF_kernel'});
%predict next 100 points
Ytest1 = simlssvm({SS,V1,'c',gam,sig2,'RBF_kernel'},{alpha,b},Xs');

V2=YT;
V2(ismember(V2,2,'rows')==1,:)=1;
V2(ismember(V2,-2,'rows')==1,:)=-1;
V2(ismember(V2,3,'rows')==1,:)=1;
V2(ismember(V2,-3,'rows')==1,:)=-1;
V2(ismember(V2,4,'rows')==1,:)=1;
V2(ismember(V2,-4,'rows')==1,:)=-1;

index=find(V2(qq:z+q)==Ytest1);
c1=size(index,1);
SSS=zeros(c1,qq);
V3=zeros(c1,1);
for i=1:c1
    SSS(i,:)=S(index(i),:);
    V3(i)=YT(index(i)+q);
end

if Ytest1==1
    V3(ismember(V3,3,'rows')==1,:)=-1;
    V3(ismember(V3,4,'rows')==1,:)=-1;
    V3(ismember(V3,2,'rows')==1,:)=1;
else
    V3(ismember(V3,-2,'rows')==1,:)=-1;
    V3(ismember(V3,-3,'rows')==1,:)=1;
    V3(ismember(V3,-4,'rows')==1,:)=1;
end

kn=300;
dd0=NHDTW(SSS,Xs',qq/2);

KN=zeros(kn,1);
[maxn0 maxi]=max(dd0);%用于替换，最大值
% mmm=size(X,1);

jjj=1;
while (jjj<=kn)
%     jjj=1;%初值
    [minn0 mini0]=min(dd0);%找第一个最小值
    KN(jjj)=mini0;%记录对应的行
    dd0(mini0)=maxn0;
    jjj=jjj+1;
end
SSS1=zeros(kn,qq);%最近邻的k个序列
V30=zeros(kn,1);
for iii=1:kn
    SSS1(iii,:)=SSS(KN(iii),:);
    V30(iii)=V3(KN(iii));
end


[gamt,sigt2] = tunelssvm({SSS1,V30,'c',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alphat,bt] = trainlssvm({SSS1,V30,'c',gamt,sigt2,'RBF_kernel'});
%predict next 100 points
Ytest2 = simlssvm({SSS1,V30,'c',gamt,sigt2,'RBF_kernel'},{alphat,bt},Xs');


V4=YT;
if Ytest1==1
    V4(ismember(V4,3,'rows')==1,:)=-1;
    V4(ismember(V4,4,'rows')==1,:)=-1;
    V4(ismember(V4,2,'rows')==1,:)=1;
else
    V4(ismember(V4,-2,'rows')==1,:)=-1;
    V4(ismember(V4,-3,'rows')==1,:)=1;
    V4(ismember(V4,-4,'rows')==1,:)=1;
end

index1=find(V4(qq:z+q)==Ytest2);
c1=size(index1,1);
SXX=zeros(c1,qq);
V5=zeros(c1,1);
for i=1:c1
    SXX(i,:)=S(index1(i),:);
    V5(i)=YT(index1(i)+q);
end

if Ytest1==1&&Ytest2==1
    V5(ismember(V5,2,'rows')==1,:)=-1;
elseif Ytest1==1&&Ytest2==-1
    V5(ismember(V5,3,'rows')==1,:)=1;
    V5(ismember(V5,4,'rows')==1,:)=-1;
elseif Ytest1==-1&&Ytest2==1
    V5(ismember(V5,-3,'rows')==1,:)=1;
    V5(ismember(V5,-4,'rows')==1,:)=-1;
elseif Ytest1==-1&&Ytest2==-1
    V5(ismember(V5,-2,'rows')==1,:)=1;
end


knn=300;
d0=NHDTW(SXX,Xs',qq/2);

KN1=zeros(knn,1);
[maxn4 maxi]=max(d0);%用于替换，最大值
% mmm=size(X,1);

jjj=1;
while (jjj<=knn)
%     jjj=1;%初值
    [minn4 mini4]=min(d0);%找第一个最小值
    KN1(jjj)=mini4;%记录对应的行
    d0(mini4)=maxn4;
    jjj=jjj+1;
end
SSS2=zeros(knn,qq);%最近邻的k个序列
V50=zeros(knn,1);
for iii=1:knn
    SSS1(iii,:)=SXX(KN1(iii),:);
    V50(iii)=V5(KN1(iii));
end


[gamt,sigt2] = tunelssvm({SSS2,V50,'c',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alphat,bt] = trainlssvm({SSS2,V50,'c',gamt,sigt2,'RBF_kernel'});
%predict next 100 points
Ytest3= simlssvm({SSS2,V50,'c',gamt,sigt2,'RBF_kernel'},{alphat,bt},Xs');


SS1=zeros(size(A1,1),qq);%最近邻的k个序列

 for y1=1:size(A1,1)
      if A1(y1)>qq&&A1(y1)<=z+qq
           SS1(y1,:)=S(A1(y1)-qq,:);
      else
          TT1(y1)=100;
      end
 end
 SS2=zeros(size(A2,1),qq);%最近邻的k个序列

 for y2=1:size(A2,1)
       if A2(y2)>qq&&A2(y2)<=z+qq
        SS2(y2,:)=S(A2(y2)-qq,:);
       else
        TT2(y2)=100;
       end
 end
 
  SS3=zeros(size(A3,1),qq);%最近邻的k个序列

 for y3=1:size(A3,1)
       if A3(y3)>qq&&A3(y3)<=z+qq
        SS3(y3,:)=S(A3(y3)-qq,:);
       else
        TT3(y3)=100;
       end
 end
 
  SS4=zeros(size(A4,1),qq);%最近邻的k个序列

 for y4=1:size(A4,1)
       if A4(y4)>qq&&A4(y4)<=z+qq
        SS4(y4,:)=S(A4(y4)-qq,:);
       else
        TT4(y4)=100;
       end
 end
 
 SS5=zeros(size(A5,1),qq);%最近邻的k个序列

 for y5=1:size(A5,1)
       if A5(y5)>qq&&A5(y5)<=z+qq
        SS5(y5,:)=S(A5(y5)-qq,:);
       else
        TT5(y5)=100;
       end
 end
 
 SS6=zeros(size(A6,1),qq);%最近邻的k个序列

 for y6=1:size(A6,1)
       if A6(y6)>qq&&A6(y6)<=z+qq
        SS6(y6,:)=S(A6(y6)-qq,:);
       else
        TT6(y6)=100;
       end
 end
 
 SS7=zeros(size(A7,1),qq);%最近邻的k个序列

 for y7=1:size(A7,1)
       if A7(y7)>qq&&A7(y7)<=z+qq
        SS7(y7,:)=S(A7(y7)-qq,:);
       else
        TT7(y7)=100;
       end
 end
 
 SS8=zeros(size(A8,1),qq);%最近邻的k个序列

 for y8=1:size(A8,1)
       if A8(y8)>qq&&A8(y8)<=z+qq
        SS8(y8,:)=S(A8(y8)-qq,:);
       else
        TT8(y8)=100;
       end
 end
 
TT1(ismember(TT1,100,'rows')==1)=[];
TT2(ismember(TT2,100,'rows')==1)=[];
TT3(ismember(TT3,100,'rows')==1)=[];
TT4(ismember(TT4,100,'rows')==1)=[];
TT5(ismember(TT5,100,'rows')==1)=[];
TT6(ismember(TT6,100,'rows')==1)=[];
TT7(ismember(TT7,100,'rows')==1)=[];
TT8(ismember(TT8,100,'rows')==1)=[];

SS1(ismember(SS1,zeros(1,qq),'rows')==1,:)=[];
SS2(ismember(SS2,zeros(1,qq),'rows')==1,:)=[];
SS3(ismember(SS3,zeros(1,qq),'rows')==1,:)=[];
SS4(ismember(SS4,zeros(1,qq),'rows')==1,:)=[];
SS5(ismember(SS5,zeros(1,qq),'rows')==1,:)=[];
SS6(ismember(SS6,zeros(1,qq),'rows')==1,:)=[];
SS7(ismember(SS7,zeros(1,qq),'rows')==1,:)=[];
SS8(ismember(SS8,zeros(1,qq),'rows')==1,:)=[];


dd2=NHDTW(S,Xs',qq/2);
[str1,str2]=sort(dd2);
str2=str2(1);

a=zeros(8,1);
a(1)=Match(A1,str2);
a(2)=Match(A2,str2);
a(3)=Match(A3,str2);
a(4)=Match(A4,str2);
a(5)=Match(A5,str2);
a(6)=Match(A6,str2);
a(7)=Match(A7,str2);
a(8)=Match(A8,str2);
% a(1)=Match(A1,str2)/size(A1,1);
% a(2)=Match(A2,str2)/size(A2,1);
% a(3)=Match(A3,str2)/size(A3,1);
% a(4)=Match(A4,str2)/size(A4,1);
% a(5)=Match(A5,str2)/size(A5,1);
% a(6)=Match(A6,str2)/size(A6,1);
% a(7)=Match(A7,str2)/size(A7,1);
% a(8)=Match(A8,str2)/size(A8,1);
min0=max(a);
if a(1)==min0
    SS0=SS1;
    H0=TT1;
    cjy=0;
elseif a(2)==min0
    SS0=SS2;
    H0=TT2;
    cjy=1;
elseif a(3)==min0
    SS0=SS3;
    H0=TT3;
    cjy=2;
elseif a(4)==min0
    SS0=SS4;
    H0=TT4;
    cjy=3;
elseif a(5)==min0
    SS0=SS5;
    H0=TT5;
    cjy=4;
elseif a(6)==min0
    SS0=SS6;
    H0=TT6;
    cjy=5;
elseif a(7)==min0
    SS0=SS7;
    H0=TT7;
    cjy=6;
elseif a(8)==min0
    SS0=SS8;
    H0=TT8;
    cjy=7;
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


[gam,sig2] = tunelssvm({XXX,H,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({XXX,H,'f',gam,sig2,'RBF_kernel'});
%predict next 100 points
tempx = predict({XXX,H,'f',gam,sig2,'RBF_kernel'},Xs,1);

 prediction(zis)=TXT(h0+zis-1)+tempx;
 
zis=zis+1;
end

plot(prediction(1:end),'-b+');
hold on;
% plot(Xt((s+1):end),'r')7
plot(TXT(h0+1:H1),'-r*');
xlabel('time');

ylabel('Values of stockdata');
title('stock zsyh data test');


Xt=TXT(h0+1:H1);
prediction=prediction(1:end);
mn=size(prediction,1);
w=0;
W=0;
for i=1:mn
    w=w+abs(prediction(i)-Xt(i));
    W=W+(prediction(i)-Xt(i))^2;
end
mae=w/mn;
rmse=sqrt(W/mn);

