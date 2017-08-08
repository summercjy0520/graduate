% % X=2.*rand(100,4)-1;
% % Y=sign(sin(X(:,1))+X(:,2)+sin(X(:,3))+X(:,4));
% X=2.*rand(200,2)-1;
% Y=sign(sin(X(:,1))+X(:,2));
% X
% Y
% % load dataset
% type='classification';
% L_fold=10; % L_fold crossvalidation
% [gam,sig2] = tunelssvm({X,Y,type,[],[],'RBF_kernel'},'simplex',...
% 'crossvalidatelssvm',{L_fold,'misclass'});  %单分类
% Xtra=[1.0990,1.0480;1.0930,1.1060;0.9690,1.0840;0.9430,0.8970;0.9030,0.8740;1.1310,1.0780];
% Ytra=[0.9690,1.0910,1.1250,1.1490,1.1310,1.0930]';
% Xtra=[Xtra;Xtra];
% Ytra=[Ytra;Ytra];

OliveOil_train=importdata('data\ARIMA.txt');
X=OliveOil_train(1:192);
Xt=OliveOil_train(193:216);
lag = 32;
Xu = windowize(X,1:lag+1);
Xtra = Xu(1:end-lag,lag); %training set
Ytra = Xu(1:end-lag,end); %training set
Q=X(end-lag+1:end,1)';

type='f';
[gam,sig2] = tunelssvm({Xtra,Ytra,type,[],[],'lin_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});
[alpha,b]=trainlssvm({Xtra,Ytra,type,gam,sig2,'lin_kernel'});
prediction = predict({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'},Xs,24);




plotlssvm({X,Y,type,gam,sig2,'RBF_kernel'},{alpha,b});
[gam,sig2] = tunelssvm({X,Y,type,[],[],'lin_kernel'},'gridsearch',...
'crossvalidatelssvm',{L_fold,'misclass'});   %网格搜索
[alpha,b] = trainlssvm({X,Y,type,gam,sig2,'lin_kernel'});
% latent variables are needed to make the ROC curve
Y_latent = latentlssvm({X,Y,type,gam,sig2,'lin_kernel'},{alpha,b},X);
[area,se,thresholds,oneMinusSpec,Sens]=roc(Y_latent,Y);
[thresholds oneMinusSpec Sens]