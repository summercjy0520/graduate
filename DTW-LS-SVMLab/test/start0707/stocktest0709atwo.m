
clear all;
clc;

TXT= importdata('C:\Documents and Settings\Administrator\桌面\cjy\2016\6\data\main\true\zxzq.txt');
%TXT= importdata('C:\Documents and Settings\Administrator\桌面\cjy\2016\7\data\zxzq0703.txt');
TXT=(TXT.textdata(503:end,5))';% end:2015-03~06:2864-2933  %+2000
TXT=str2double(TXT);
[TXT,T1]=mapminmax(TXT);
TXT=TXT(1:end)';
% TXT=(TXT.data(:,2));

ww=25;
prediction=zeros(ww,1);

H1=size(TXT,1);

zis=1;

% h0=h1;
h0=H1-ww;
k=300;
tempy=0;
while(zis<ww+1)
q=15; %时锟斤拷
qq=q+1;
s=1;  %预锟解窗锟斤拷;
cjy1=0;
cjy2=0;
h1=size(TXT,1);
TT1=ones(h1-1,1)*100;
TT2=ones(h1-1,1)*100;
TT=zeros(h1-1,1);
YT=zeros(h1-1,1);

A1=zeros(h1-1,1);
A2=zeros(h1-1,1);
YYT=zeros(h1-1,1);
for t=1:h1-1
    TT(t)=TXT(t+1)-TXT(t);
    if TT(t)>=0
        YT(t)=1;
    else
        YT(t)=-1;
    end
    
    if abs(TT(t))>=0.01
            TT1(t)=TT(t);
            A1(t)=t;
    else
            TT2(t)=TT(t);
            A2(t)=t;
    end
end

TT1(ismember(TT1,100,'rows')==1)=[];
TT2(ismember(TT2,100,'rows')==1)=[];

A1(ismember(A1,0,'rows')==1)=[];
A2(ismember(A2,0,'rows')==1)=[];


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

[gam,sig2] = tunelssvm({SS,V1,'c',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({SS,V1,'c',gam,sig2,'RBF_kernel'});
%predict next 100 points
Ytest= simlssvm({SS,V1,'c',gam,sig2,'RBF_kernel'},{alpha,b},Xs');

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
 
TT1(ismember(TT1,100,'rows')==1)=[];
TT2(ismember(TT2,100,'rows')==1)=[];

SS1(ismember(SS1,zeros(1,qq),'rows')==1,:)=[];
SS2(ismember(SS2,zeros(1,qq),'rows')==1,:)=[];

dd2=NHDTW(SS1,Xs',qq/2);
dd3=NHDTW(SS2,Xs',qq/2);


if min(dd2)<min(dd3)
    SS0=SS1;
    H0=TT1;
    cjy=0;
else
    SS0=SS2;
    H0=TT2;
    cjy=1;
end

km=300;

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
SSS=zeros(km,qq);%最近邻的k个序列
H=zeros(km,1);
for iii=1:km
    SSS(iii,:)=SS0(KK(iii),:);
    H(iii)=H0(KK(iii));
end


[gam,sig2] = tunelssvm({SSS,H,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({SSS,H,'f',gam,sig2,'RBF_kernel'});
%predict next 100 points
tempx = predict({SSS,H,'f',gam,sig2,'RBF_kernel'},Xs,1);

kk=30;
kkk=5;
% t1=kk;
temp=zeros(kk,1);

if cjy==1
    for e=1:kk
       temp(e)=H(e);
    end
    temp=paixu(temp);
    temp0=zeros(2*kkk,1);
    for g=1:kkk
        temp0(g)=temp(g);
        temp0(end-g+1)=temp(end-g+1);
    end
    prediction(zis)=TXT(h0+zis-1)+mean(temp0);
else
    for e=1:kk
    temp(e)=H(e);
    if H(e)>=0
           cjy1=cjy1+1;
       else
           cjy2=cjy2+1;
    end
    end
    temp=paixu(temp);
    temp0=zeros(2*kkk,1);
    for g=1:kkk
        temp0(g)=temp(end-kkk*2+g);
        temp0(end-g+1)=temp(end-g+1);
    end
    if Ytest==1||cjy1>=cjy2
       prediction(zis)=TXT(h0+zis-1)+mean(temp0);
    else
       prediction(zis)=TXT(h0+zis-1)-mean(temp0);
    end
end
zis=zis+1;
end

plot(prediction(1:end),'-b+');
hold on;
% plot(Xt((s+1):end),'r')7
plot(TXT(h0+1:H1),'-r*');
xlabel('time');

ylabel('Values of stockdata');
title('stock data test');


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

