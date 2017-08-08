OliveOil_train=importdata('data\disan.txt');
X=OliveOil_train(1:18);
Xt=OliveOil_train(19:24);
lag = 6;
Xu = windowize(X,1:lag+1);
Xtra = Xu(1:end-lag,1:lag); %training set
Ytra = Xu(1:end-lag,end); %training set
Xs=X(end-lag+1:end,1); %starting point for iterative prediction迭代预测的起点
% Xt = rand(10,1).*sign(randn(10,1));

% [gam,sig2] = tunelssvm({Xtra,Ytra,'f',[],[],'lin_kernel'},'simplex',...
% 'crossvalidatelssvm');
gam=10;
sig2=0.4;
% Prediction of the next 100 points
[alpha,b] = trainlssvm({Xtra,Ytra,'f',gam,sig2,'lin_kernel'});
%predict next 100 points
% prediction = predict({Xtra,Ytra,'f',gam,sig2,'lin_kernel'},Xs,2);
% prediction1=[160.2,168.1,182.4,193.6,211.3,264.5]';
% prediction=[160.2,168.1]';
% prediction2=[6120.4 6634.7 7214.0 6988.0 7845.9 8214.7]';
prediction3=[984.2 1136.8 1462.0 1248.6 1537.0 1783.2]';
% ticks=cumsum(ones(24,1));
ticks=[1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014]';
plot(ticks(1:size(X)),X);
hold on;
plot(ticks(size(X)+1:size(ticks)),[prediction3]);
% plot([prediction Xt]);
xlabel('time');
% ylabel('CO2 of the Secondary industry');
ylabel('CO2 of the Tertiary Industry');
% ylabel('CO2 of the Primary Industry');