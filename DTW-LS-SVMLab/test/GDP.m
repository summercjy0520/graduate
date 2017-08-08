% [NUMERIC,TXT,RAW] = xlsread('oil.price.xlsx');
% %aa = fints(NUMERIC (:,1)+693960, NUMERIC (:,5));
% %[SUCCESS,MESSAGE] = xlswrite('sh02.xls',NUMERIC);数据写回
% X =NUMERIC;
% mounths = size(NUMERIC);
% dt = cell(mounths,1);
% n=floor((mounths)/12);
% for k = 1:(mounths-12)
%     t=rem(k,13);
%     dt{t} = ['2003-' int2str(t)];
% end;
% for k = 13:mounths
%     t=rem(k,12);
%     dt{t+12} = ['2004-' int2str(t)];
% % end;
% d = 1:mounths;
% sm = exp(d);
% plot(d,sm,'r-');
% xlabel('日期');
% set(gca,'XTickLabel',dt);
% plot(X);
% xlabel('日期');
% set(gca,'XTickLabel',dt);
% OliveOil_train=importdata('data\ARIMA.txt');
[NUMERIC,TXT,RAW] = xlsread('GDP.xlsx');
OliveOil_train=NUMERIC(:,2);
X=OliveOil_train(1:81);
Xt=OliveOil_train(82:93);
lag = 27;
Xu = windowize(X,1:lag+1);
Xtra = Xu(1:end-lag,1:lag); %training set
Ytra = Xu(1:end-lag,end); %training set
Xs=X(end-lag+1:end,1); %starting point for iterative prediction迭代预测的起点
% Xt = rand(10,1).*sign(randn(10,1));

[gam,sig2] = tunelssvm({Xtra,Ytra,'f',[],[],'lin_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({Xtra,Ytra,'f',gam,sig2,'lin_kernel'});
%predict next 100 points
prediction = predict({Xtra,Ytra,'f',gam,sig2,'lin_kernel'},Xs,12);
% ticks=cumsum(ones(93,1));
% plot(ticks(1:size(X)),X);
% hold on;
% plot(ticks(size(X)+1:size(ticks)),[prediction Xt]);
ts=datenum('1992-1');
tf=datenum('2015-1');
t=linspace(ts,tf,93);
plot(t(1:size(X)),X);
hold on;
plot(t(size(X,1)+1:size(t,2)),[prediction Xt]);
datetick('x','yyyy','keepticks');
ylabel('GDP in China from 1992 to 2015');
title('the example 2 of forcasting of time series datasets');



