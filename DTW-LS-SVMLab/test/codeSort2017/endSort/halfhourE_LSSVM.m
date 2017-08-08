clear all;
clc;

XX=importdata('C:\Documents and Settings\Administrator\桌面\cjy\2017\6\endsort\data\callcenter.txt'); %csvread
TXT=XX.data(1,:)';
for i=2:size(XX.data,1)
    TXT=[TXT;XX.data(i,:)'];
end


C=100;%向前预测多少个样本点
h0=1350;
h1=h0+C;
prediction=zeros(C,1);

for jia=1:C
    
X=TXT(1:(h0+jia-1));
% Q=TXT(5591:5600)';
Xt=TXT((h0+jia):h1);

q=8; %时滞
qq=q+1;
s=1;  %预测窗口

Xtt=[X;Xt];

mm=size(TXT(1:(h0-1+jia)),1);


z=mm-s-qq+1;
Xtra=zeros(z,qq);
h=0; 

for i=1:z
    for j=1:qq
    if h+j<=mm
    Xtra(i,j)=X(h+j);
%     S(i,2*j)=X(h+2*j);
    end
    end
    h=h+1;
end

Q=Xtt((h0-s-q+jia):(h0+jia-s))';
Ytra=X(qq+s:end);

[gam,sig2] = tunelssvm({Xtra,Ytra,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

%predict
prediction(jia) = predict({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'},Q,1);
end

%plot
plot(prediction(1:end));
hold on;
% plot(Xt((s+1):end),'r')
plot(TXT(1351:1450),'r');
xlabel('time');
ylabel('Values of Poland electricity database');
title('the example 1 of KNN');

Xt=TXT(1351:1450);
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
nrmse=rmse/std(TXT(1:h0));