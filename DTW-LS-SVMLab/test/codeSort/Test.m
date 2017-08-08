clear all;
clc;

txt= importdata('C:\Documents and Settings\Administrator\桌面\cjy\2016\11\data\austres.txt');
TXT=[];

for i=1:size(txt,1)
    TXT=[TXT;txt(i,2:end)'];
end
[TXT,T1]=mapminmax(TXT',0,1);
TXT=TXT';

C=4;%向前预测多少个样本点
prediction=zeros(C,1);
for jia=1:C
    
X=TXT(1:(80+jia-1));
% Q=TXT(5591:5600)';
Xt=TXT((81+jia):84);
XXt=[X;Xt];


% k=2*round((mm/2)^(1/2));
k=10;
q=3; %时滞
qq=q+1;
s=1;  %预测窗口
% k=6;
% q=1;
% s=2;
% qq=q+1;
mm=size(TXT(1:(80+jia-1)),1);
Xtt=XXt((end-size(Xt,1)-q-s+1):end);
MN=X(1:(mm+1-s));
X=X(1:(mm+1-2*s));
mmm=size(X,1);


z=mm-2*s-q+1;
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

% Q=Xt;

% 第一次计算混合距离
dd1=NHs(S,Q);

%找临近序列
SS=zeros(k,qq);%最近邻的k个序列
K=zeros(k,1);
[maxn maxi]=max(dd1);%用于替换，最大值

jjj=1;
while (jjj<=k)
%     jjj=1;%初值
    [minn mini]=min(dd1);%找第一个最小值
    if mini>=qq&&mini<=(mmm-q-s)
    K(jjj)=mini;%记录对应的行
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

%整理2q+3个Z序列&&单变量
Z=zeros(qq,k);

for n=1:qq
    for nn=1:k
    mnn=K(nn)+n-1;
    Z(n,nn)=X(mnn);%公式（7）
%     Z(2*n,nn)=Y(mnn);%公式（7）
%     nn=nn+1;
    end
%     n=n+1;
end   %很棒~~

H=zeros(k,1);
MI=zeros(qq,1);%存储Z序列与H之间的互信息大小，用于比较
%计算互信息MI的大小
for aa=1:k
%     H(aa)=X(K(aa)+s);
    H(aa)=X(K(aa)+q+s);
end


%模型推导！！！
%根据公式（10）求得变量sai的值，这里用cjy表示好了
%第二次计算混合距离
mediann=median(H); %求取决策维的中位值
mn=size(H,1);
ymedian=zeros(mn,1);
for ff=1:mn
    ymedian(ff)=H(ff)-mediann;
%     ff=ff+1;
end
ymediann=max(abs(ymedian));%第二个计算因子的分母
% cjy1=zeros(k,1);%存放变量第一个计算因子
cjy2=zeros(k,1);%存放变量第二个计算因子
cjy=zeros(k,1);%存放所求变量
cjy1=NHs(SS,Q);
for f=1:k
%     cjy1(f)=NH(SSS(f,:),SSQ,(d0-1)/2);    
%     cjy1(f)=0;
    cjy2(f)=abs(H(f)-mediann)/ymediann;
    cjy(f)=exp((-1/2)*(cjy1(f)+1*cjy2(f)));
end


%对应到SVM模型里面，猜想可以调用我们工程里面的函数，得到alpha、b进行预测

%tunel 过程
[gam,sig2] = tunelssvm({SS,H,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% gam=2.4*(10^7);
% sig2=700;
%train
[alpha,b] = trainlssvmknn({SS,H,'f',gam,sig2,'RBF_kernel'},cjy); %lin_kernel
% [alpha,b] = trainlssvm({SSS,SSY,'f',gam,sig2,'RBF_kernel'}); %lin_kernel

%predict
% prediction(jia) = predictknn({SSS,SSY,'f',gam,sig2,'RBF_kernel'},SSQ,1);
prediction(jia) = predictknn({SS,H,'f',gam,sig2,'RBF_kernel'},Q,cjy,1);

% C0=C0-1;
end
% end

%plot
% ticks=cumsum(ones(70,1));
plot(prediction(1:end),'-+');
hold on;
% plot(Xt((s+1):end),'r')
plot(TXT(5606:5700),'-r*');
xlabel('time');
ylabel('Values of Laser database');
title('DTW:mae=2.2339,rmse=6.8317');

Xt=TXT(5606:5700);
mn=size(prediction,1);
w=0;
W=0;
for i=1:mn
    w=w+abs(prediction(i)-Xt(i));
    W=W+(prediction(i)-Xt(i))^2;
end
mae=w/mn;
rmse=sqrt(W/mn);
