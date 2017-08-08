% X=2.*rand(100,4)-1;
% Y=sign(sin(X(:,1))+X(:,2)+sin(X(:,3))+X(:,4));
% X = linspace(-1,1,50)';
% Y = (15*(X.^2-1).^2.*X.^4).*exp(-X)+normrnd(0,0.1,length(X),1);
% OliveOil_train=importdata('data\ARIMA.txt');
% X=OliveOil_train(1:108);
% Xt=OliveOil_train(109:216);
% lag = 36;
% Xu = windowize(X,1:lag+1);
% Xtra = Xu(1:end-lag,1:lag); %training set
% Ytra = Xu(1:end-lag,end); %training set
% X=Xtra;
% Y=Ytra;
% % Xt=2.*rand(30,4)-1;
% % Yt=sign(sin(Xt(:,1))+Xt(:,2)+sin(Xt(:,3))+Xt(:,4));
% % Xt = linspace(-1,1,20)';
% % Yt = (15*(X.^2-1).^2.*X.^4).*exp(-X)+normrnd(0,0.1,length(X),1);
% lag1=36;
% Xp = windowize(Xt,1:lag1+1);
% Xt = Xp(1:end-lag1,1:lag1); %training set
% Yt = Xp(1:end-lag1,end); %training set
% load dataset
% X=[   -0.11    0.19
%    -0.39   -0.96
%     0.02   -0.15
%     0.02   -0.37];
X=[   -0.11    1
   -0.39   1
    0.02   1
    0.02   -1];
Xt=[0.59   -0.64
    -0.42  0.24
    -0.28  0.32
    0.64   -0.68];

Y=[  -1
    -1
    1
    1];
Yt=[ 1
    -1
    -1
    1];

type='c';
% L_fold=10; % L_fold crossvalidation
% [gam,sig2] = tunelssvm({X,Y,type,[],[],'lin_kernel'},'simplex',...
% 'crossvalidatelssvm',{L_fold,'mae'});  %单分类
[gam,sig2] = tunelssvm({X,Y,type,[],[],'lin_kernel'},'simplex',...
'crossvalidatelssvm',{3,'mae'});
[model]=trainlssvm({X,Y,type,gam,sig2,'lin_kernel'});
% [w] = Newtonsss(model,X,Y,Xt,Yt);
% [alpha,b] = exchange(w,X,Y,Xt,Yt);
[alpha,b] = trainlssvm({X,Y,type,gam,sig2,'lin_kernel'});
% []=trainlssvm({X,Y,type,gam,sig2,'lin_kernel'});
plotlssvm({X,Y,type,gam,sig2,'lin_kernel'},{alpha,b});
% [gam,sig2] = tunelssvm({X,Y,type,[],[],'RBF_kernel'},'gridsearch',...
% 'crossvalidatelssvm',{L_fold,'misclass'});   %网格搜索
% [alpha,b] = trainlssvm({X,Y,type,gam,sig2,'RBF_kernel'});
% % latent variables are needed to make the ROC curve
% Y_latent = latentlssvm({X,Y,type,gam,sig2,'RBF_kernel'},{alpha,b},X);
% [area,se,thresholds,oneMinusSpec,Sens]=roc(Y_latent,Y);
% [thresholds oneMinusSpec Sens]