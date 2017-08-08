
clear all;
clc;

[TXT,TX,RAW] = xlsread('data\KNN\EGtemperature.xlsx');
% TXT= importdata('C:\Documents and Settings\Administrator\桌面\cjy\2016\8\data\Riverf.txt');

[TXT,T1]=mapminmax(TXT');
TXT=TXT(1:end)';

ww=100;
prediction=zeros(ww,1);
class=zeros(ww,1);

H1=size(TXT,1);

zis=1;

% h0=h1;
h0=H1-ww;
k=180;
tempy=0;
while(zis<ww+1)
q=11; %时锟斤拷
qq=q+1;
s=1;  %预锟解窗锟斤拷;
cjy1=0;
cjy2=0;
h1=size(TXT,1);
TT1=ones(h1-1,1)*100;
TT2=ones(h1-1,1)*100;
TT3=ones(h1-1,1)*100;
TT4=ones(h1-1,1)*100;
TT=zeros(h1-1,1);
YT=zeros(h1-1,1);

A1=zeros(h1-1,1);
A2=zeros(h1-1,1);
A3=zeros(h1-1,1);
A4=zeros(h1-1,1);

YYT=zeros(h1-1,1);
v=[];
for t=1:h1-1
%     TT(t)=(TXT(t+1)-TXT(t))/TXT(t);
    TT(t)=TXT(t+1)-TXT(t);
    if TT(t)>=0
%         YT(t)=1;
        if abs(TT(t))<0.08
            TT1(t)=TT(t);
            YT(t)=1;
            A1(t)=t;
        else
            TT2(t)=TT(t);
            YT(t)=2;
            A2(t)=t;
        end
    else
%         YT(t)=-1;
        if abs(TT(t))<0.08
           TT3(t)=TT(t);
           YT(t)=-1;
           A3(t)=t;
        else
            TT4(t)=TT(t);
            YT(t)=-2;
            A4(t)=t;
        end
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
    if mini>=qq&&mini<=(z+q)
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

[gam,sig2] = tunelssvm({SS,V1,'c',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({SS,V1,'c',gam,sig2,'RBF_kernel'});
%predict next 100 points
Ytest1 = simlssvm({SS,V1,'c',gam,sig2,'RBF_kernel'},{alpha,b},Xs');

V2=YT;
V2(ismember(V2,2,'rows')==1,:)=1;
V2(ismember(V2,-2,'rows')==1,:)=-1;

index=find(V2==Ytest1);
c1=size(index,1);
SSS=zeros(c1,qq);
V3=zeros(c1,1);
for i=1:c1
    if index(i)>q&&index(i)<z+qq
    SSS(i,:)=S(index(i)-q,:);
    V3(i)=YT(index(i));
    end
end

if Ytest1==1
    V3(ismember(V3,2,'rows')==1,:)=-1;
else
    V3(ismember(V3,-2,'rows')==1,:)=1;
end
V3(ismember(V3,0,'rows')==1)=[];
SSS(ismember(SSS,zeros(1,qq),'rows')==1,:)=[];


kn=50;
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

if all(V30==1)
    Ytest2=1;
elseif all(V30==-1)
    Ytest2=-1;
else
[gamt,sigt2] = tunelssvm({SSS1,V30,'c',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alphat,bt] = trainlssvm({SSS1,V30,'c',gamt,sigt2,'RBF_kernel'});
%predict next 100 points
Ytest2 = simlssvm({SSS1,V30,'c',gamt,sigt2,'RBF_kernel'},{alphat,bt},Xs');
end

SS1=zeros(size(A1,1),qq);%最近邻的k个序列

 for y1=1:size(A1,1)
      if A1(y1)>q&&A1(y1)<=z+q
           SS1(y1,:)=S(A1(y1)-q,:);
      else
          TT1(y1)=100;
      end
 end
 SS2=zeros(size(A2,1),qq);%最近邻的k个序列

 for y2=1:size(A2,1)
       if A2(y2)>q&&A2(y2)<=z+q
        SS2(y2,:)=S(A2(y2)-q,:);
       else
        TT2(y2)=100;
       end
 end
 
  SS3=zeros(size(A3,1),qq);%最近邻的k个序列

 for y3=1:size(A3,1)
       if A3(y3)>q&&A3(y3)<=z+q
        SS3(y3,:)=S(A3(y3)-q,:);
       else
        TT3(y3)=100;
       end
 end
 
  SS4=zeros(size(A4,1),qq);%最近邻的k个序列

 for y4=1:size(A4,1)
       if A4(y4)>q&&A4(y4)<=z+q
        SS4(y4,:)=S(A4(y4)-q,:);
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

if Ytest1==1&&Ytest2==1
    SS0=SS1;
    H0=TT1;
    class(zis)=1;
elseif Ytest1==1&&Ytest2==-1
    SS0=SS2;
    H0=TT2;
    class(zis)=2;
elseif Ytest1==-1&&Ytest2==1
    SS0=SS4;
    H0=TT4;
    class(zis)=-1;
elseif Ytest1==-1&&Ytest2==-1
    SS0=SS3;
    H0=TT3;
    class(zis)=-2;
end

% dd2=NHDTW(SS1,Xs',qq/2);
% dd3=NHDTW(SS2,Xs',qq/2);
% dd4=NHDTW(SS3,Xs',qq/2);
% dd5=NHDTW(SS4,Xs',qq/2);
% 
% a=zeros(4,1);
% if isempty(dd2)==1
%     a(1)=inf;
% else
%     a(1)=min(dd2);
% end
% if isempty(dd3)==1
%     a(2)=inf;
% else
%     a(2)=min(dd3);
% end
% if isempty(dd4)==1
%     a(3)=inf;
% else
%     a(3)=min(dd4);
% end
% if isempty(dd5)==1
%     a(4)=inf;
% else
%     a(4)=min(dd5);
% end
% min0=min(a);
% if min(dd2)==min0
%     SS0=SS1;
%     H0=TT1;
%     cjy=0;
% elseif min(dd3)==min0
%     SS0=SS2;
%     H0=TT2;
%     cjy=1;
% elseif min(dd4)==min0
%     SS0=SS3;
%     H0=TT3;
%     cjy=2;
% elseif min(dd5)==min0
%     SS0=SS4;
%     H0=TT4;
%     cjy=3;
% end

km=50;
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

prediction(zis)=TXT(h0+zis-1)+tempx;
zis=zis+1;
end


cLassR=zeros(ww,1);

for i=1:ww
    diff=TXT(h0+i)-TXT(h0+i-1);
    if diff>=0
        if abs(diff)<0.08
            classR(i)=1;
        else 
            classR(i)=2;
        end
    else
        if abs(diff)<0.08
            classR(i)=-1;
        else
            classR(i)=-2;
        end
    end
end

subplot(2,1,1);
stem(class,'fill');
hold on;
stem(classR,'fill','r');
x=0:ww;
y=1;
hold on;
plot(x,y);

subplot(2,1,2);
plot(prediction(1:end),'-b+');
hold on;
% plot(Xt((s+1):end),'r')7
plot(TXT(h0+1:H1),'-r*');

plot(prediction(1:end),'-b+');
hold on;
% plot(Xt((s+1):end),'r')7
plot(TXT(h0+1:H1),'-r*');
xlabel('time');

ylabel('Values of EGtemprature');
title('0821EGtemprature');

TXT=mapminmax('reverse',TXT,T1);
prediction=mapminmax('reverse',prediction,T1);

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

