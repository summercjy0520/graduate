clear all;
clc;

TXT= importdata('C:\Documents and Settings\Administrator\桌面\cjy\2017\2\10\HeartDisease.txt');

Y=TXT(:,end);
for i=1:size(Y,1)
    if Y(i)==0
        Y(i)=-1;
    end
end
X=[TXT(:,8),TXT(:,5),TXT(:,4),TXT(:,9),TXT(:,2)];%TXT(:,5),
% X=TXT.data(:,3);

type='c';
% L_fold=10; % L_fold crossvalidation
% [gam,sig2] = tunelssvm({X,Y,type,[],[],'lin_kernel'},'simplex',...
% 'crossvalidatelssvm',{L_fold,'mae'});  %单分类
[gam,sig2] = tunelssvm({X,Y,type,[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});
[model]=trainlssvm({X,Y,type,gam,sig2,'RBF_kernel'});
% [w] = Newtonsss(model,X,Y,Xt,Yt);
% [alpha,b] = exchange(w,X,Y,Xt,Yt);
[alpha,b] = trainlssvm({X,Y,type,gam,sig2,'RBF_kernel'});
% []=trainlssvm({X,Y,type,gam,sig2,'lin_kernel'});
% prediction = predict({X,Y,type,gam,sig2,'RBF_kernel'},X);
Y_latent = latentlssvm({X,Y,type,gam,sig2,'RBF_kernel'},{alpha,b},X);
[area,se,thresholds,oneMinusSpec,Sens]=roc(Y_latent,Y);
plotlssvm({X,Y,type,gam,sig2,'RBF_kernel'},{alpha,b});
% [gam,sig2] = tunelssvm({X,Y,type,[],[],'RBF_kernel'},'gridsearch',...
% 'crossvalidatelssvm',{L_fold,'misclass'});   %网格搜索
% [alpha,b] = trainlssvm({X,Y,type,gam,sig2,'RBF_kernel'});
% % latent variables are needed to make the ROC curve
% Y_latent = latentlssvm({X,Y,type,gam,sig2,'RBF_kernel'},{alpha,b},X);
% [area,se,thresholds,oneMinusSpec,Sens]=roc(Y_latent,Y);
% [thresholds oneMinusSpec Sens]