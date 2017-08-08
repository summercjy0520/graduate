
clear all;
clc;

TXT= importdata('C:\Documents and Settings\Administrator\桌面\cjy\2016\6\data\main\true\zxzq.txt');
%TXT= importdata('C:\Documents and Settings\Administrator\桌面\cjy\2016\7\data\zxzq0703.txt');
TXT=(TXT.textdata(503:end,5))';% end:2015-03~06:2864-2933  %+2000
TXT=str2double(TXT);
[TXT,T1]=mapminmax(TXT);
TXT=TXT(1:end)';
% TXT=(TXT.data(:,2));

ww=13;
prediction=zeros(ww,1);
zis=1;
H1=size(TXT,1);

% h0=h1;
h0=H1-ww;
k=500;
while(zis<ww+1)
q=15; %时锟斤拷
qq=q+1;
s=1;  %预锟解窗锟斤拷
% k=6;
% q=1;
% s=2;
% qq=q+1;
X=TXT(1:h0+zis-1);
% Q=TXT(5591:5600)';
Xt=TXT((h0+1+zis-1):H1);
XXt=[X;Xt];

Xs=XXt((h0-s-q+zis):(h0+zis-s));

mm=size(TXT(1:(h0-1+zis)),1);

h1=size(X,1);
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
    TT(t)=X(t)-X(t+1);
    if TT(t)>=0
%         YT(t)=1;
        if abs(TT(t))>=0.008
            TT1(t)=TT(t);
            YT(t)=2;
            A1(t)=t;
        else
            TT2(t)=TT(t);
            YT(t)=1;
            A2(t)=t;
        end
    else
%         YT(t)=-1;
        if abs(TT(t))>=0.008
           TT3(t)=TT(t);
           YT(t)=-2;
           A3(t)=t;
        else
            TT4(t)=TT(t);
            YT(t)=-1;
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

[gam,sig2] = tunelssvm({SS,V1,'c',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({SS,V1,'c',gam,sig2,'RBF_kernel'});
%predict next 100 points
Ytest1 = simlssvm({SS,V1,'c',gam,sig2,'RBF_kernel'},{alpha,b},Xs');

if Ytest1==1

SS1=zeros(z,qq);%最近邻的k个序列
for y1=1:size(A1,1)
    if A1(y1)>qq
        SS1(y1,:)=S(A1(y1)-qq,:);
    else
        TT1(y1)=[];
    end
end

SS2=zeros(z,qq);
for y2=1:size(A2,1)
    if A2(y2)>qq
        SS2(y2,:)=S(A2(y2)-qq,:);
    else
        TT2(y2)=[];
    end
end
SS1(ismember(SS1,zeros(1,qq),'rows')==1,:)=[];
SS2(ismember(SS2,zeros(1,qq),'rows')==1,:)=[];

SSS=[SS1;SS2];
V2=YT;
V2(ismember(V2,-2,'rows')==1,:)=[];
V2(ismember(V2,-1,'rows')==1,:)=[];
V2(ismember(V2,2,'rows')==1,:)=-1;

[gamt,sigt2] = tunelssvm({SSS,V2,'c',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alphat,bt] = trainlssvm({SSS,V2,'c',gamt,sigt2,'RBF_kernel'});
%predict next 100 points
Ytest2 = simlssvm({SSS,V2,'c',gamt,sigt2,'RBF_kernel'},{alphat,bt},Xs');

if Ytest2==1
    SSSS=SS2;
    H=TT2;
else
    SSSS=SS1;
    H=TT1;
end

else
SS3=zeros(z,qq);
for y3=1:size(A3,1)
    if A3(y3)>qq
        SS3(y3,:)=S(A3(y3)-qq,:);
    else
        TT3(y3)=[];
    end
end

SS4=zeros(z,qq);
for y4=1:size(A4,1)
    if A4(y4)>qq
        SS4(y4,:)=S(A4(y4)-qq,:);
    else
        TT4(y4)=[];
    end
end

SS3(ismember(SS3,zeros(1,qq),'rows')==1,:)=[];
SS4(ismember(SS4,zeros(1,qq),'rows')==1,:)=[];

SSS=[SS3;SS4];
V2=YT(16:end);
V2(ismember(V2,2,'rows')==1,:)=[];
V2(ismember(V2,1,'rows')==1,:)=[];
V2(ismember(V2,-2,'rows')==1,:)=-1;

[gamt,sigt2] = tunelssvm({SSS,V2,'c',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alphat,bt] = trainlssvm({SSS,V2,'c',gamt,sigt2,'RBF_kernel'});
%predict next 100 points
Ytest2 = simlssvm({SSS,V2,'c',gamt,sigt2,'RBF_kernel'},{alphat,bt},Xs');

if Ytest2==1
    SSSS=SS4;
    H=TT4;
else
    SSSS=SS3;
    H=TT3;
end

end

[gam,sig2] = tunelssvm({SSS,H,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({SSS,H,'f',gam,sig2,'RBF_kernel'});
%predict next 100 points
tempx = predict({SSS,H,'f',gam,sig2,'RBF_kernel'},Xs,1);

G=H;
G=paixu(G);
if tempx<0
    tempy=[G(1:5);G(end-20:end)];
else
    tempy=[G(1:20);G(end-5:end)];
end
if abs(tempx)<=abs(mean(tempy))
    prediction(zis)=TXT(h0+zis-1)+tempx;
else
    prediction(zis)=TXT(h0+zis-1)+mean(tempy);
end
zis=zis+1;
end

plot(prediction(1:end),'-b+');
hold on;
% plot(Xt((s+1):end),'r')7
plot(TXT(h0+1:H1),'-r*');
xlabel('time');
% ts=datenum('1972-01');
% tf=datenum('2010-10');
% t=linspace(ts,tf,70);
% plot(t(1:size(X(end-68:end))),X(end-68:end));
% hold on;
% plot(t(size(X(end-68:end))+1:size(ticks)),[prediction SSQ(1)]);
% datetick('x','yyyy','keepticks');
ylabel('Values of stockdata');
title('stock data test');


Xt=TXT(h0+1:h1);
% mn=size(prediction,1);
% w=zeros(mn,1);
% W=zeros(mn,1);
% for i=1:mn
%     w(i)=(prediction(i)-Xt(i))^2;
%     W(i)=(mean(Xt)-Xt(i))^2;
% end
% nmse = mean(w)/mean(W);
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

