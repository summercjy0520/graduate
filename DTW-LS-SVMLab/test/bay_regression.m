%to do active support vector selection(基于熵（体系混乱程度）的标准)???online
% X,Y contains the dataset, svX is a subset of X
X=importdata('data\ARIMA.txt');
Y = (15*(X.^2-1).^2.*X.^4).*exp(-X)+normrnd(0,0.1,length(X),1);
Xm=X(1:192);
Xt=X(193:216);
lag = 64;
Xu = windowize(Xm,1:lag+1);
Xtra = Xu(1:end-lag,1:lag); %training set
Ytra = Xu(1:end-lag,end); %training set
Xs=Xm(end-lag+1:end,1); %starting point for iterative prediction迭代预测的起点
% Xt = rand(10,1).*sign(randn(10,1));
svX=X(1:192);
sig2 = 1;
features = AFEm(svX,'RBF_kernel',sig2, X);
[Cl3, gam_optimal] = bay_rr(features,Y,1,3);
[W,b] = ridgeregress(features, Y, gam_optimal);
Yh = features*W+b;

%对于不同内核参数和容量（支持向量数目的选择），评估随机子集的支持向量数目，穷举搜索得到最小化
%穷举搜索支持向量数目
caps = [10 20 50 100 200]
sig2s = [.1 .2 .5 1 2 4 10]
nb = 10;
for i=1:length(caps),
for j=1:length(sig2s),
for t = 1:nb,
sel = randperm(size(X,1));
svX = X(sel(1:caps(i)));
features = AFEm(svX,'RBF_kernel',sig2s(j), X);
[Cl3, gam_opt] = bay_rr(features,Y,1,3);
[W,b] = ridgeregress(features, Y, gam_opt);
Yh = features*W+b;
performances(t) = mse(Y - Yh);
end
minimal_performances(i,j) = mean(performances);
end
end

%搜索良好性能的内核参数和容量
[minp,ic] = min(minimal_performances,[],1);
[minminp,is] = min(minp);
capacity = caps(ic);
sig2 = sig2s(is);

%根据二次以下方法优化支持向量的选择二阶Renyi熵：
% load data X and Y, ’capacity’ and the kernel parameter ’sig2’
sv = 1:capacity;
max_c = -inf;
for i=1:size(X,1),
replace = ceil(rand.*capacity);
subset = [sv([1:replace-1 replace+1:end]) i];
crit = kentropy(X(subset,:),'RBF_kernel',sig2);
if max_c <= crit, max_c = crit; sv = subset; end
end

%估计的成本面向不同的子集的能力和内核参数。
%支持向量此选定的子集被用于构造最终模型
features = AFEm(svX,'RBF_kernel',sig2, X);
[Cl3, gam_optimal] = bay_rr(features,Y,1,3);
% [W,b, Yh] = ridgeregress(features, Y, gam_opt);

[alpha,b] = trainlssvm({Xtra,Ytra,'f',gam_optimal,sig2,'RBF_kernel'});
%predict next 100 points
prediction = predict({Xtra,Ytra,'f',gam_optimal,sig2,'RBF_kernel'},Xs,24);
ticks=cumsum(ones(216,1));
plot(ticks(1:size(X)),X);
hold on;
plot(ticks(size(Xm)+1:size(ticks)),[prediction Xt]);
% plot([prediction Xt]);
xlabel('time');
ylabel('sales');
