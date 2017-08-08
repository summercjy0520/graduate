%Web browser market share

clear all;
clc;

[TXT,TX,RAW] = xlsread('C:\Documents and Settings\Administrator\桌面\cjy\2016\9\data\browsermarket01.xls');
TXT=TXT(1:end,1);

C=100;%向前预测多少个样本点
prediction=zeros(C,1);
for jia=1:C
    
X=TXT(1:(1268+jia-1));
% Q=TXT(5591:5600)';
Xt=TXT((1268+jia):1368);
XXt=[X;Xt];


% k=2*round((mm/2)^(1/2));
% k=400;
q=5; %时滞
qq=q+1;
s=1;  %预测窗口
% k=6;
% q=1;
% s=2;
% qq=q+1;
mm=size(TXT(1:(1268+jia-1)),1);
Xtt=XXt((end-size(Xt,1)-q-s+1):end);
MN=X(1:(mm+1-s));
X=X(1:(mm+1-2*s));
mmm=size(X,1);


z=mm-2*s-qq+1;
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

H=X(s+qq:end);
Q=Xtt(1:qq);

[gam,sig2] = tunelssvm({S,H,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});


[alpha,b] = trainlssvm({S,H,'f',gam,sig2,'RBF_kernel'});

%predict
prediction(jia) = predict({S,H,'f',gam,sig2,'RBF_kernel'},Q,1);
% C0=C0-1;
end
% end

%plot
% ticks=cumsum(ones(70,1));
plot(prediction(1:end));
hold on;
% plot(Xt((s+1):end),'r')
plot(TXT(1269:1368),'r');
xlabel('time');

ylabel('Values of Laser database');
title('the example 1 of KNN');

Xt=TXT(1269:1368);

mn=size(prediction,1);
w=0;
W=0;
for i=1:mn
    w=w+abs(prediction(i)-Xt(i));
    W=W+(prediction(i)-Xt(i))^2;
end
mae=w/mn;
rmse=sqrt(W/mn);
