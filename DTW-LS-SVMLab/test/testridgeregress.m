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