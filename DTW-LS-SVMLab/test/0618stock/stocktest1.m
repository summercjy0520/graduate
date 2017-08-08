
clear all;
clc;

TXT= importdata('C:\Documents and Settings\Administrator\桌面\cjy\2016\6\data\main\true\zxzq.txt');
TXT=(TXT.textdata(end-1514:end,5))';% end:2015-03~06:2864-2933  %+2000
TXT=str2double(TXT);
[TXT,T1]=mapminmax(TXT);
TXT=TXT(1:end)';
% TXT=(TXT.data(:,2));


prediction=zeros(1,1);
zis=1;
h0=1515;
h1=1515;
k=500;
while(zis<2)
q=15; %时锟斤拷
qq=q+1;
s=1;  %预锟解窗锟斤拷
% k=6;
% q=1;
% s=2;
% qq=q+1;
X=TXT(1:h0+zis-1);
% Q=TXT(5591:5600)';
Xt=TXT((h0+1+zis-1):h1);
XXt=[X;Xt];

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

Ytra=X(s+qq:end);
Xs=XXt((h0-s-q+zis):(h0+zis-s));
% d=3;

dd1=NHDTW(S,Xs,qq/2);
%找临近序列
SS=zeros(k,qq);%最近邻的k个序列
K=zeros(k,1);
dd=zeros(k,1);
[maxn maxi]=max(dd1);%用于替换，最大值
mmm=size(X,1);

jjj=1;
while (jjj<=k)
%     jjj=1;%初值
    [minn mini]=min(dd1);%找第一个最小值
    if mini>=qq&&mini<=(mmm-q-s)
    K(jjj)=mini;%记录对应的行
    dd(jjj)=minn;%记录对应的最近值
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

H=zeros(k,1);
for aa=1:k
%     H(aa)=X(K(aa)+s);
    H(aa)=X(K(aa)+q+s);
end

[dd,T]=mapminmax(dd',-2,3);
dd=dd';

SY=zeros(k,1);
for s=1:k
    SY(s)=round(dd(s));
end
        
[gam1,sig12] = tunelssvm({SS,SY,'classification',[],[],'RBF_kernel'},'simplex',...
 'crossvalidatelssvm',{10,'misclass'}); 
[alpha1,b1]=trainlssvm({SS,SY,'classification',gam1,sig12,'RBF_kernel'});
Ytest=simlssvm({SS,SY,'classification',gam1,sig12,'RBF_kernel'},{alpha1,b1},Xs');

PH= find(SY==Ytest);
p=size(PH,1);
Q=0;
for d=1:p
    Q=Q+H(PH(d));
end
Q=Q/(p);

[gam,sig2] = tunelssvm({SS,H,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({SS,H,'f',gam,sig2,'RBF_kernel'});
%predict next 100 points
prediction(zis) = predict({SS,H,'f',gam,sig2,'RBF_kernel'},Xs,1);
% prediction = predictcjy({Xtra,Ytra,'f',gam,sig2,'lin_kernel'},{[X;Xt],Xs},{d,100});
% if abs(TXT(h0+zis-1)-prediction(zis))<0.02
% prediction(zis)=1/3*(1*prediction(zis)+3*Q);
% elseif abs(TXT(h0+zis-1)-prediction(zis))>0.05
% prediction(zis)=1/2*(1*prediction(zis)+2*Q);
% end
zis=zis+1;
end
% ticks=cumsum(ones(216,1));


plot(prediction(1:end),'-b+');
hold on;
% plot(Xt((s+1):end),'r')
plot(TXT(h0+1:h1),'-r*');
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

