% load time-series in X and Xt
% X= linspace(-1,1,50)';
%Xt = rand(10,1).*sign(randn(10,1));
% X = (-5:.07:5)';
% epsilon = 0.3;
% sel = rand(length(X),1)>epsilon;
% Y = sinc(X)+sel.*normrnd(0,.1,length(X),1)+(1-sel).*trnd(1,length(X),1).^3;
clear all；
X = linspace(-1,1,50)';
Y = (15*(X.^2-1).^2.*X.^4).*exp(-X)+normrnd(0,0.1,length(X),1);
lag = 8;
Xu = windowize(X,1:lag+1);
Xtra = Xu(1:end-lag,1:lag); %training set
Ytra = Xu(1:end-lag,end); %training set
Xs=X(end-lag+1:end,1); %starting point for iterative prediction迭代预测的起点
Xt = rand(8,1).*sign(randn(8,1));

[gam,sig2] = tunelssvm({Xtra,Ytra,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'});
%predict next 100 points
prediction = predict({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'},Xs,20);
plot(X);
hold on;
plot(prediction);



