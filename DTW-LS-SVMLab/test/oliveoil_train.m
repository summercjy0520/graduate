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
OliveOil_train=importdata('data\Coffee_TRAIN.txt');
X1=OliveOil_train(12,1:240);
X=X1';
Xt1=OliveOil_train(12,241:287);
Xt=Xt1';
lag = 80;
Xu = windowize(X,1:lag+1);
Xtra = Xu(1:end-lag,1:lag); %training set
Ytra = Xu(1:end-lag,end); %training set
Xs=X(end-lag+1:end,1); %starting point for iterative prediction迭代预测的起点
% Xt = rand(10,1).*sign(randn(10,1));

[gam,sig2] = tunelssvm({Xtra,Ytra,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'});
%predict next 100 points
prediction = predict({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'},Xs,47);
ticks=cumsum(ones(287,1));
plot(ticks(1:size(X)),X);
hold on;
plot(ticks(size(X)+1:size(ticks)),[prediction Xt]);
% plot([prediction Xt]);
xlabel('time');
ylabel('oliveoil');



