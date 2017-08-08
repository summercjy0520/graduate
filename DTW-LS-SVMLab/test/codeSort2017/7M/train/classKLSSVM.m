function [gam,sig2,alpha,b]=classKLSSVM(X,Y)
type='c';

[gam,sig2] = tunelssvm({X,Y,type,[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});
[alpha,b] = trainlssvm({X,Y,type,gam,sig2,'RBF_kernel'});
% []=trainlssvm({X,Y,type,gam,sig2,'lin_kernel'});
% prediction = predict({X,Y,type,gam,sig2,'RBF_kernel'},X);
end