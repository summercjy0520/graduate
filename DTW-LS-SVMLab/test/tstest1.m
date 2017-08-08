clear all
%n_dim=1;
%[X K] = gengaussian(n_dim, 1, 2, 300, 10, 1, 1);
%end=size(X,1);
lag = 40;%10以上具有明显效果
%Xa=X{1}';
Xa= linspace(-1,1,300)';
X=Xa(1:200,:);
Xt=Xa(201:300,:);
%scatter(X(:,1),X(:,2))
Xu = windowize(X, 1: lag + 1)
Xtra = Xu(1:end-lag,1:lag);
Ytra = Xu(1:end-lag,end);
Xs=X(end-lag+1:end,1);

%[gam,sig2] = tunelssvm({Xtra,Ytra,'f',[],[],'lin_kernel'},'simplex',...
%'crossvalidatelssvm',{'mse'});
[gam,sig2] = tunelssvm({Xtra,Ytra,'f',[],[],'lin_kernel'},'simplex',...
'leaveoneoutlssvm',{'mse'});
[alpha,b] = trainlssvm({Xtra,Ytra,'f',gam,sig2,'lin_kernel'});
plotlssvm({Xtra,Ytra,'f',gam,sig2,'lin_kernel'},{alpha,b});
prediction = predict({Xtra,Ytra,'f',gam,sig2,'lin_kernel'},Xs,100);
%plot(X);
hold;
subplot(2,1,1);
plot(Xa(201:300));
subplot(2,1,2);
plot([prediction]);

