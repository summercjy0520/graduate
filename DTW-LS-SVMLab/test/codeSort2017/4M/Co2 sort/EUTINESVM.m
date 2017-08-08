

clear all;
clc;

[NUMERIC,TX,RAW] = xlsread('data\KNN\Temperature1997.xls');
[NUMERIC1,TX1,RAW1] = xlsread('data\KNN\Temperature1998.xls');
TXT=NUMERIC;
TXT1=NUMERIC1;
TXT=[TXT;TXT1];

C=31;%向前预测多少个样本点
prediction=zeros(C,1);

h1=size(TXT,1);
h0=h1-C;

for jia=1:C
    
X=TXT(1:(h0+jia-1));
% Q=TXT(5591:5600)';
Xt=TXT((h0+jia):h1);
XXt=[X;Xt];



q=34; %时滞
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
H=X(s+qq:end);

%对应到SVM模型里面，猜想可以调用我们工程里面的函数，得到alpha、b进行预测

%tunel 过程
[gam,sig2] = tunelssvm({S,H,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

%train
% [alpha,b] = trainlssvmknn({SSS,SSY,'f',gam,sig2,'RBF_kernel'},cjy); %lin_kernel

%predict
prediction(jia) = predict({S,H,'f',gam,sig2,'RBF_kernel'},Q,1);
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