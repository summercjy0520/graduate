clear all;  %选出一定量，删除一定部分
clc;

TXT= importdata('C:\Documents and Settings\Administrator\桌面\cjy\2016\10\R data\co2.txt');
txt=TXT.data;
TXT=[];
for i=1:size(txt,1)
    TXT=[TXT;txt(i,2:end)'];
end

C=120;%向前预测多少个样本点
prediction=zeros(C,1);

h1=size(TXT,1);
h0=h1-C;
for jia=1:C
    
X=TXT(1:(h0+jia-1));
% Q=TXT(5591:5600)';
Xt=TXT((h0+jia):h1);
XXt=[X;Xt];


% k=2*round((mm/2)^(1/2));
k0=3; %KNN过程小密度聚类的k值

th=2; %cosine sum的阈值
% kernel_type=RBF_kernel;
q=43; %时滞
qq=q+1;
s=1;  %预测窗口
k=150;
KC=[];
% k=6;
% q=1;
% s=2;
% qq=q+1;
mm=size(TXT(1:(h0+jia-1)),1);
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
csum=11;
a=1;
K0=zeros(k,1);
Q0=Q;

% dd1=NHDTWnewest(S,Q,qq/2);
dd1=NHDTWnew0(S,Q);

[K]=FuzzyEntropy0217(dd1);
k=size(K,1);
SS=zeros(k,qq);%最近邻的k个序列
% K=zeros(k,1);
[maxn maxi]=max(dd1);%用于替换，最大值

jjj=1;
% MIN=[];
while (jjj<=k)
%     jjj=1;%初值
    [minn mini]=min(dd1);%找第一个最小值
    if mini>=qq&&mini<=(mmm-q-s)
    K(jjj)=mini;%记录对应的行
%     MIN=[MIN,minn]; %记录对应的距离值
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
%计算互信息MI的大小
for aa=1:k
%     H(aa)=X(K(aa)+s);
    H(aa)=X(K(aa)+q+s);
end

%tunel 过程
[gam,sig2] = tunelssvm({SS,H,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% gam=2.4*(10^7);
% sig2=700;
%train
% [alpha,b] = trainlssvmknn({SSS,SSY,'f',gam,sig2,'RBF_kernel'},cjy); %lin_kernel
%[alpha,b] = trainlssvm({SSS,SSY,'f',gam,sig2,'RBF_kernel'}); %lin_kernel

%predict
prediction(jia) = predict({SS,H,'f',gam,sig2,'RBF_kernel'},Q,1);
% prediction(jia) = predictknn({SSS,SSY,'f',gam,sig2,'RBF_kernel'},SSQ,cjy,1);

% C0=C0-1;
end
% end

%plot
% ticks=cumsum(ones(70,1));
plot(prediction(1:end),'-+');
hold on;
% plot(Xt((s+1):end),'r')
plot(TXT(h0+1:h1),'-r*');
xlabel('time');
ylabel('Values of co2 database');
title('Cosine:mae=2.2339,rmse=6.8317');

Xt=TXT(h0+1:h1);
mn=size(prediction,1);
w=0;
W=0;
for i=1:mn
    w=w+abs(prediction(i)-Xt(i));
    W=W+(prediction(i)-Xt(i))^2;
end
mae=w/mn;
rmse=sqrt(W/mn);
