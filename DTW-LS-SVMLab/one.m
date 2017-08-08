X=2.*rand(100,4)-1;
Y=sign(sin(X(:,1))+X(:,2)+sin(X(:,3))+X(:,4));
X;
Y;
% load dataset
type='classification';
L_fold=10; % L_fold crossvalidation
[gam,sig2] = tunelssvm({X,Y,type,[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{L_fold,'misclass'});  %单分类
[alpha,b]=trainlssvm({X,Y,type,gam,sig2,'RBF_kernel'});
plotlssvm({X,Y,type,gam,sig2,'RBF_kernel'},{alpha,b});
[gam,sig2] = tunelssvm({X,Y,type,[],[],'RBF_kernel'},'gridsearch',...
'crossvalidatelssvm',{L_fold,'misclass'});   %网格搜索
[alpha,b] = trainlssvm({X,Y,type,gam,sig2,'RBF_kernel'});
% latent variables are needed to make the ROC curve
Y_latent = latentlssvm({X,Y,type,gam,sig2,'RBF_kernel'},{alpha,b},X);
[area,se,thresholds,oneMinusSpec,Sens]=roc(Y_latent,Y);
[thresholds oneMinusSpec Sens]