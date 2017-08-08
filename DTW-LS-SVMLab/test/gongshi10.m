X=[   -0.11    0.19
   -0.39   -0.96
    0.02   -0.15
    0.02   -0.37
    0.64   -0.68];
%     0.59   -0.64
%     -0.42  0.24
%     -0.28  0.32
%     0.52  -0.08
%     0.35  0.14
%     -0.18  -0.26];
Y=[  -1
    -1
    1
    1
    1];
%     1
%     -1
%     -1
%     1
%     1
%     -1];
X
Y
gam=6;
sig2=0;
type='classification';
[alpha,b]=trainlssvm({X,Y,type,gam,sig2,'RBF_kernel'});
% Xt=2.*rand(10,2)-1;
% Ytest=simlssvm({X,Y,type,gam,sig2,'lin_kernel'},{alpha,b},Xt);
plotlssvm({X,Y,type,gam,sig2,'RBF_kernel'},{alpha,b});