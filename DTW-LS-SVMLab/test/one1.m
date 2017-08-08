% X=2.*rand(200,2)-1;
% Y=sign(sin(X(:,1))+X(:,2));
% X=[   -0.11    0.19
%    -0.39   -0.96
%     0.02   -0.15
%     0.02   -0.37
%     0.64   -0.68
%     0.59   -0.64];
X=[   -0.11    0.19
   -0.39   -0.96
    0.02   -0.15
    0.02   -0.37
    0.64   -0.68
    0.59   -0.64
    -0.42  0.24
    -0.28  0.32];
% Y=[  -1
%     -1
%     1
%     1
%     1
%     1];
Y=[  -1
    -1
    1
    1
    1
    1
    -1
    -1];
X
Y
% gam=6;
% sig2=0;
% sig2=0.4;
type='classification';
L_fold=3; % L_fold crossvalidation
% L_fold=2; % L_fold crossvalidation
[gam,sig2] = tunelssvm({X,Y,type,[],[],'lin_kernel'},'simplex',...
'crossvalidatelssvm',{L_fold,'misclass'}); 
[alpha,b]=trainlssvm({X,Y,type,gam,sig2,'lin_kernel'});
% Xt=2.*rand(10,2)-1;
% Ytest=simlssvm({X,Y,type,gam,sig2,'lin_kernel'},{alpha,b},Xt);
plotlssvm({X,Y,type,gam,sig2,'lin_kernel'},{alpha,b});




