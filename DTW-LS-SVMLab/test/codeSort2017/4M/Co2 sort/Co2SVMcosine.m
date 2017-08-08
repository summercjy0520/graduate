clear all;
clc;

TXT= importdata('C:\Documents and Settings\Administrator\桌面\cjy\2016\10\R data\co2.txt');
txt=TXT.data;
TXT=[];
for i=1:size(txt,1)
    TXT=[TXT;txt(i,2:end)'];
end

C=60;%向前预测多少个样本点
prediction=zeros(C,1);

h1=size(TXT,1);
h0=h1-C;

for jia=1:C
    
X=TXT(1:(h0+jia-1));
% Q=TXT(5591:5600)';
Xt=TXT((h0+jia):h1);
XXt=[X;Xt];



q=11; %时滞
qq=q+1;
s=1;  %预测窗口
k=100;

mm=size(TXT(1:(h0+jia-1)),1);
Xtt=XXt((end-size(Xt,1)-q-s+1):end);
MN=X(1:(mm+1-s));
X=X(1:(mm+1-s));
mmm=size(X,1);

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

Ytra=X(s+qq:end);
Xs=XXt((h0-s-q+jia):(h0+jia-s));
% dd2=NHDTWnew1219(Xtra,Xs');
dd1=zeros(z,1);
for i=1:z
    metrixD1=kernel_matrix(Xs','lin_kernel',0,Xtra(i,:));
    metrixD2=kernel_matrix(Xtra(i,:),'lin_kernel',0);
    metrixD3=kernel_matrix(Xs','lin_kernel',0);
    dd1(i)=norm(metrixD1)/(sqrt(norm(metrixD2))*sqrt(norm(metrixD3)));
%     dd1(i)=cosinecjy([Xtra(i,:);Xs'],Xs','lin_kernel',2);
end

%找临近序列
SS=zeros(k,qq);%最近邻的k个序列
H=zeros(k,1);
K=zeros(k,1);
[minn mini]=min(dd1);%用于替换，最大值

jjj=1;
while (jjj<=k)
%     jjj=1;%初值
    [maxn maxi]=max(dd1);%找第一个最小值
    if maxi>=qq&&maxi<=(size(X,1)-q-s)
    K(jjj)=maxi;%记录对应的行
    dd1(maxi)=minn;
    jjj=jjj+1;
    else
    dd1(maxi)=minn;
    end   
%     jjj=jjj+1;
end
for iii=1:k
    SS(iii,:)=Xtra(K(iii),:);
    H(iii)=Ytra(K(iii));
end
% d=3;


[gam,sig2] = tunelssvm({SS,H,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'});
%predict next 100 points
prediction(jia) = predict({SS,H,'f',gam,sig2,'RBF_kernel'},Xs,1);
% prediction = predictcjy({Xtra,Ytra,'f',gam,sig2,'lin_kernel'},{[X;Xt],Xs},{d,100});

jia=jia+1;
end
% ticks=cumsum(ones(216,1));


plot(prediction(1:end),'-+');
hold on;
% plot(Xt((s+1):end),'r')
plot(TXT(h0+1:h1),'-*r');
xlabel('time');
ylabel('Values of Sales database');
title('SVM: mae= ,rmse=');


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

