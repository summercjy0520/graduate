clear all;
Xu= linspace(-1,1,50)';
Yu= linspace(-1,1,30)';
lag = 10;
Xn= windowize(Xu, 1: lag + 1);
X = Xn(1:end-lag,1:lag);
Y = (15*(Yu.^2-1).^2.*Yu.^4).*exp(-Yu)+normrnd(0,0.1,length(Yu),1);
X;
Y;
type = 'function estimation';% º¯Êý¹À¼Æ
% type='classification';
[gam,sig2] = tunelssvm({X,Y,type,[],[],'RBF_kernel'},'simplex',...%gridsearch
'leaveoneoutlssvm',{'mse'});
[alpha,b] = trainlssvm({X,Y,type,gam,sig2,'RBF_kernel'});
plotlssvm({X,Y,type,gam,sig2,'RBF_kernel'},{alpha,b});

% [alpha,b] = trainlssvm({X,Y,type,gam,sig2,'lin_kernel','original'});
% plotlssvm({X,Y,type,gam,sig2,'lin_kernel'},{alpha,b});
% % or can be switched on (by default):
% [alpha,b] = trainlssvm({X,Y,type,gam,sig2,'lin_kernel','preprocess'});
% plotlssvm({X,Y,type,gam,sig2,'lin_kernel'},{alpha,b});

%Xt = rand(5,1).*sign(randn(5,1));
% simulated on the test data
%Yt = simlssvm({X,Y,type,gam,sig2,'lin_kernel','preprocess'},{alpha,b},Xt);
%plotlssvm({X,Y,type,gam,sig2,'lin_kernel','preprocess'},{alpha,b});