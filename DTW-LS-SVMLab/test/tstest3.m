X = linspace(-1,1,50)';
Y = (15*(X.^2-1).^2.*X.^4).*exp(-X)+normrnd(0,0.1,length(X),1);
X
Y
type = 'function estimation';
Yp = lssvm(X,Y,type);

type = 'function approximation';
X = linspace(-2.2,2.2,250)';
Y = sinc(X) +normrnd(0,.1,size(X,1),1);
[Yp,alpha,b,gam,sig2] = lssvm(X,Y,type);
plotlssvm({X,Y,type,gam,sig2,'lin_kernel'},{alpha,b});

% using Bayesian inference
sig2e = bay_errorbar({X,Y,type, gam, sig2},'figure');

X = normrnd(0,2,100,3);
Y = sinc(X(:,1)) + 0.05.*X(:,2) +normrnd(0,.1,size(X,1),1);

inputs = bay_lssvmARD({X,Y,type, 10,3});
[alpha,b] = trainlssvm({X(:,inputs),Y,type, 10,1});

% Using the object oriented model interface
type = 'function approximation';
X = normrnd(0,2,100,1);
Y = sinc(X) +normrnd(0,.1,size(X,1),1);
kernel = 'RBF_kernel';
gam = 10;
sig2 = 0.2;
model = initlssvm(X,Y,type,gam,sig2,kernel);
model
model = trainlssvm(model);
Xt = normrnd(0,2,150,1);
Yt = simlssvm(model,Xt);
plotlssvm(model);

model = bay_optimize(model,2,'eign', 50);
model = bay_initlssvm(model);
model = bay_optimize(model,3,'eign',50);