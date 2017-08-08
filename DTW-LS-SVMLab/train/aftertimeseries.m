% X,Y contains the dataset, svX is a subset of X
Xu= linspace(-1,1,50)';
Yu= linspace(-1,1,41)';
lag = 10;
X= windowize(Xu, 1: lag);
svX = X(1:end-lag,1:lag);
Y = (15*(Yu.^2-1).^2.*Yu.^4).*exp(-Yu)+normrnd(0,0.1,length(Yu),1);
X
Y
sig2 = 1;
features = AFEm(svX,'RBF_kernel',sig2, X);
[Cl3, gam_optimal] = bay_rr(features,Y,1,3);
[W,b] = ridgeregress(features, Y, gam_optimal);
Yh = features*W+b;

%穷举搜索支持向量数目
caps = [10 10]
sig2s = [.1 .2 .5 1 2 4 10]
nb = 10;
for i=1:length(caps),
for j=1:length(sig2s),%length(sig2s)*nb*caps
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

[minp,ic] = min(minimal_performances,[],1);
[minminp,is] = min(minp);
capacity = caps(ic);
sig2 = sig2s(is);

% load data X and Y, ’capacity’ and the kernel parameter ’sig2’
sv = 1:capacity;
max_c = -inf;
for i=1:size(X,1),
replace = ceil(rand.*capacity);
subset = [sv([1:replace-1 replace+1:end]) i];
crit = kentropy(X(subset,:),'RBF_kernel',sig2);
if max_c <= crit, max_c = crit; sv = subset; end
end

features = AFEm(svX,'RBF_kernel',sig2, X);
[Cl3, gam_optimal] = bay_rr(features,Y,1,3);
[W,b, Yh] = ridgeregress(features, Y, gam_opt,Xt);

% %The same idea can be used for learning a classifier from a huge data set.
% % load the input and output of the trasining data in X and Y
% cap = 25;
% % initialise a subset of cap points: Xs
% for i = 1:1000,
% Xs_old = Xs;
% % substitute a point of Xs by a new one
% crit = kentropy(Xs, kernel, kernel_par);
% % if crit is not larger then in the previous loop,
% % substitute Xs by the old Xs_old
% end
% 
% % the Fisher discriminant is obtained:
% features = AFEm(Xs,kernel, sigma2,X);
% [w,b] = ridgeregress(features,Y,gamma);
% % New data points can be simulated as follows:
% features_t = AFEm(Xs,kernel, sigma2,Xt);
% Yht = sign(features_t*w+b);