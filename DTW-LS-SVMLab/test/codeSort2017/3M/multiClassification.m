% [NUMERIC,TXT,RAW] = xlsread('data\ionosphare.xlsx');
clear all;
clc;

X=2.*rand(100,4)-1;
Y1=sign(sin(X(:,1))+X(:,2)+sin(X(:,3))+X(:,4));
Y2=ones(50,1);
Y3=-1*ones(50,1);
Y4=[Y2;Y3];
Y=[Y4,Y1];

type='classification';
L_fold=10; % L_fold crossvalidation
[gam,sig2] = tunelssvm({X,Y,type,[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{L_fold,'misclass'});  %µ•∑÷¿‡
[alpha,b]=trainlssvm({X,Y,type,gam,sig2,'RBF_kernel'});
Xt=2.*rand(10,4)-1;
Ytest=simlssvm({X,Y,type,gam,sig2,'RBF_kernel'},{alpha,b},Xt);
% plotlssvm({X,Y,type,gam,sig2,'RBF_kernel'},{alpha,b});
    
