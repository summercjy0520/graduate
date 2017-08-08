clear all
n_dim=1;
[X K] = gengaussian(n_dim, 1, 2, 300, 10, 1, 1);
%end=size(X,1);
lag = 40;%10以上具有明显效果
Xa=X{1}';
X=Xa(1:200,:);
Xt=Xa(201:300,:);
%scatter(X(:,1),X(:,2))
Xu = windowize(X, 1: lag + 1)
Xtra = Xu(1:end-lag,1:lag);
Ytra = Xu(1:end-lag,end);
Xs=X(end-lag+1:end,1);
[gam,sig2] = tunelssvm({Xtra,Ytra,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});
[alpha,b] = trainlssvm({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'});
prediction = predict({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'},Xs,100);
%plot(X);
hold;
subplot(2,1,1);
plot(Xa(201,300));
subplot(2,1,2);
plot([prediction]);

