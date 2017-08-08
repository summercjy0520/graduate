% load dataset ...
% gateway to the object oriented interface
model = initlssvm(X,Y,type,[],[],'RBF_kernel');
model = tunelssvm(model,'simplex','crossvalidatelssvm',{L_fold,'misclass'});
model = trainlssvm(model);
plotlssvm(model);
% latent variables are needed to make the ROC curve
Y_latent = latentlssvm(model,X);
[area,se,thresholds,oneMinusSpec,Sens]=roc(Y_latent,Y);



 % load dataset ...
type = 'classification';
Yp = lssvm(X,Y,type);


[gam, sig2] = bay_initlssvm({X,Y,type,gam,sig2,'RBF_kernel'});
[model, gam_opt] = bay_optimize({X,Y,type,gam,sig2,'RBF_kernel'},2);
[cost_L3,sig2_opt] = bay_optimize({X,Y,type,gam_opt,sig2,'RBF_kernel'},3);
gam = 10;
sig2 = 1;
Ymodout = bay_modoutClass({X,Y,type,10,1,'RBF_kernel'},'figure');
Np = 10;
Nn = 50;
prior = Np / (Nn + Np);
Posterior_class_P = bay_modoutClass({X,Y,type,10,1,'RBF_kernel'},...
'figure', prior);


% Multi-class coding
% load multiclass data ...
[Ycode, codebook, old_codebook] = code(Y,'code_MOC');
[alpha,b] = trainlssvm({X,Ycode,'classifier',gam,sig2});
Yhc = simlssvm({X,Ycode,'classifier',gam,sig2},{alpha,b},Xtest);
Yhc = code(Yh,old_codebook,[],codebook,'codedist_hamming');

% load multiclass data ...
model = initlssvm(X,Y,'classifier',[],[],'RBF_kernel');
model = tunelssvm(model,'simplex',...
'leaveoneoutlssvm',{'misclass'},'code_OneVsOne');
model = trainlssvm(model);
plotlssvm(model);

