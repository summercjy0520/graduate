function [prediction]=EDLSSVM(SSS,SSY,SSQ,cjy)
%对应到SVM模型里面，猜想可以调用我们工程里面的函数，得到alpha、b进行预测

%tunel 过程
[gam,sig2] = tunelssvm({SSS,SSY,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

%predict
% prediction= predict({SSS,SSY,'f',gam,sig2,'RBF_kernel'},SSQ,1);
prediction= predictknn({SSS,SSY,'f',gam,sig2,'RBF_kernel'},SSQ,cjy,1);
% prediction = predictcjy({Xtra,Ytra,'f',gam,sig2,'lin_kernel'},{[X;Xt],Xs},{d,100});
end