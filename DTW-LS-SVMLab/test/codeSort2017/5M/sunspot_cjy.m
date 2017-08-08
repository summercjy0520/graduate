clear all;
clc;

TXT= importdata('data\sunspot.txt');
TXT=TXT(:,2);


C=67;%向前预测多少个样本点
h1=288;
h0=h1-C;

prediction=zeros(C,1);
for jia=1:C
    
X=TXT(1:(h0+jia-1));
% Q=TXT(5591:5600)';
Xt=TXT((h0+jia):h1);
XXt=[X;Xt];

q=11; %时滞
qq=q+1;
s=1;  %预测窗口

mm=size(TXT(1:(h0+jia-1)),1);
Xtt=XXt((end-size(Xt,1)-q-s+1):end);
MN=X(1:(mm+1-s));
X=X(1:(mm+1-s));
mmm=size(X,1);


z=mm-s-qq+1;
S=zeros(z,qq);
h=0; %用于移动时滞影响的原序列标签

for i=1:z
    for j=1:qq
    if h+j<=mm
    S(i,j)=X(h+j);
%     S(i,2*j)=X(h+2*j);
    end
    end
    h=h+1;
end   %写得很棒！！

Q=Xtt(1:qq)';
Ytra=X(s+qq:end);

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
cjy1=NHDTWnew1219(S,Q);%  NHEH0306   CosineDistance
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

[gam,sig2] = tunelssvm({S,Ytra,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
% [alpha,b] = trainlssvm({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'});
%predict next 100 points
% prediction(zis) = predict({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'},Xs,1);
prediction(jia) = predictknn({S,Ytra,'f',gam,sig2,'RBF_kernel'},Q,cjy,1);
end

%plot
plot(prediction(1:end),'-+');
hold on;
% plot(Xt((s+1):end),'r')
plot(TXT(h0+1:h1),'-r*');
xlabel('time');

ylabel('Values of sunspot database');
title('DTW:mae= ,rmse= ');

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