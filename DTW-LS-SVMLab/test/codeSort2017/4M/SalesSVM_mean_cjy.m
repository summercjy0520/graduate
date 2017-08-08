

clear all;
clc;

TXT=importdata('C:\Documents and Settings\Administrator\桌面\cjy\MIToolbox2.11\LS-SVMLab v1.7(R2006a-R2009a)\data\ARIMA.txt');


C=16;
prediction=zeros(C,1);
zis=1;
h1=size(TXT,1);
h0=h1-C;
while(zis<C+1)
q=11; %时锟斤拷
qq=q+1;
s=1;  %预锟解窗锟斤拷
% k=6;
% q=1;
% s=2;
% qq=q+1;
X=TXT(1:h0+zis-1);
% Q=TXT(5591:5600)';
Xt=TXT((h0+zis):h1);
XXt=[X;Xt];

mm=size(TXT(1:(h0+zis-1)),1);

z=mm-s-qq+1;
Xtra=zeros(z,qq);
h=0; %锟斤拷锟斤拷锟狡讹拷时锟斤拷影锟斤拷锟皆拷锟斤拷斜锟角?

for i=1:z
    for j=1:qq
    if h+j<=mm
    Xtra(i,j)=X(h+j);
%     S(i,2*j)=X(h+2*j);
    end
    end
    h=h+1;
end  

Xmean=zeros(1,qq);
for i=1:qq
    Xmean(i)=mean(Xtra(:,i));
end
Ytra=X(s+qq:end);
Ymean=mean(Ytra);
for j=1:z
    Xtra(j,:)=Xtra(j,:)-Xmean;
    Ytra(j)=Ytra(j)-Ymean;
end

Xs=XXt((h0-s-q+zis):(h0+zis-s))'-Xmean;

mediann=median(Ytra); %求取决策维的中位值
mn=size(Ytra,1);
ymedian=zeros(mn,1);
for ff=1:mn
    ymedian(ff)=Ytra(ff)-mediann;
%     ff=ff+1;
end
ymediann=max(abs(ymedian));%第二个计算因子的分母
% cjy1=zeros(k,1);%存放变量第一个计算因子
cjy2=zeros(z,1);%存放变量第二个计算因子
cjy=zeros(z,1);%存放所求变量
cjy1=CosineDistance(Xtra,Xs);%  NHEH0306 NHDTWnew1219  
for f=1:z
%     cjy1(f)=NH(SSS(f,:),SSQ,(d0-1)/2);    
%     cjy1(f)=0;
    cjy2(f)=abs(Ytra(f)-mediann)/ymediann;
    cjy(f)=exp((-1/2)*(1*cjy1(f)+1*cjy2(f)));
%     if (cjy1(f)==0||cjy2(f)==0)
%         cjy(f)=(1/2)*(exp((-1/2)*cjy1(f))+exp((-1/2)*cjy2(f)));
%     else
%         namda=log(cjy1(f)/cjy2(f))/(cjy1(f)/cjy2(f)+1);
%         cjy(f)=(1/2)*(exp((-namda)*cjy1(f))+exp((-(1-namda))*cjy2(f)));
%     end
%       cjy(f)=exp((-1/2)*cjy1(f))+exp((-1/2)*cjy2(f));
%     cjy(f)=(-1/2)*exp(cjy1(f))+(-1/2)*exp(cjy2(f));
end

[gam,sig2] = tunelssvm({Xtra,Ytra,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
% [alpha,b] = trainlssvm({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'});
%predict next 100 points
% prediction(zis) = predict({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'},Xs,1);
prediction(zis) = predictknn({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'},Xs,cjy,1);
% prediction = predictcjy({Xtra,Ytra,'f',gam,sig2,'lin_kernel'},{[X;Xt],Xs},{d,100});
prediction(zis) =prediction(zis) +Ymean;
zis=zis+1;
end
% ticks=cumsum(ones(216,1));


plot(prediction(1:end),'-+');
hold on;
% plot(Xt((s+1):end),'r')
plot(TXT(h0+1:h1),'-*r');
xlabel('time');
ylabel('Values of Sales database');
title('SVM(RBF_kernel) (Sales):mae=1.5741,rmse=1.7757,mape=3.5218');


Xt=TXT(h0+1:h1);

mn=size(prediction,1);
w=0;
W=0;
PW=0;
for i=1:mn
    w=w+abs(prediction(i)-Xt(i));
    PW=PW+abs(prediction(i)-Xt(i))/Xt(i);
    W=W+(prediction(i)-Xt(i))^2;
end
mae=w/mn;
rmse=sqrt(W/mn);
mape=100*PW/mn;

