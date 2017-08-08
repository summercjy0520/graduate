clear all;
clc;


[NUMERICY,TY,RAWY] = xlsread('data\KNN\Load1997.xls');
[NUMERICY1,TY1,RAWY1] = xlsread('data\KNN\Load1998.xls');
TYT=NUMERICY(2:366,4:51);
TYT1=NUMERICY1(2:366,4:51);
TYT=[TYT;TYT1];
d=3;
aa=size(TYT,1);
% aaa=aa-qq;
bb=size(TYT,2);
X=zeros(aa,1);
for i=1:aa
%     X(i)=TXT(i);
    X(i)=max(TYT(i,:));%取每一天的最大值
end

Xt=[752,702,677,718,738,707,742,745,733,679,744,739,757,760,752,738,692,780,780,790,798,778,726,700,782,791,788,777,789,762,740]';
lag = 35;
Xu = windowize(X,1:lag+1);
Xtra = Xu(1:end-lag,1:lag); %training set
Ytra = Xu(1:end-lag,end); %training set
Xs=X(end-lag+1:end,1); %starting point for iterative prediction迭代预测的起点
% Xt = rand(10,1).*sign(randn(10,1));

[gam,sig2] = tunelssvm({Xtra,Ytra,'f',[],[],'lin_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({Xtra,Ytra,'f',gam,sig2,'lin_kernel'});
%predict next 100 points
% prediction = predict({Xtra,Ytra,'f',gam,sig2,'lin_kernel'},Xs,31);
prediction = predictcjy({Xtra,Ytra,'f',gam,sig2,'lin_kernel'},{[X;Xt],Xs},{d,31});

% ticks=cumsum(ones(216,1));
plot(prediction);
hold on;
plot(Xt,'r');
% plot([prediction Xt]);
xlabel('time');
ylabel('EUTINE');