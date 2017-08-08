% X=2.*rand(100,4)-1;
% Y=sign(sin(X(:,1))+X(:,2)+sin(X(:,3))+X(:,4));
% X=2.*rand(200,2)-1;
% Y=sign(sin(X(:,1))+X(:,2));
% X
% Y
% CJY=importdata('data\iris.data');
CJY=importdata('data\50words_TRAIN.data');
% [NUMERIC,TXT,RAW] = xlsread('data\soybean.xlsx');

% X=X';
% [mm,nn]=size(CJY{1,1});
% mm=CJY{1,1};
% X=char(CJY);
% for i=1:150
% X(i,:)=regexp(X(i,:),',','split');
% disp(X(i,:));
% i=i+1;
% end
A=cell2mat(CJY);
mm=size(A,1);
nn=size(A,2);
Y=A(:,nn);
% for i=1:mm
%     Y(i)=A(i,nn);
%    i=i+1;
% end
% % for i=1:m 
% for j=1:m
%     if mod(j,2)==1
%     Y=Y+sin(X(:,j));
%     else 
%     Y=Y+X(:,j);
%     end
%     j=j+1;
% end
% % j=j+1;
% % end
% Y=sign(Y);
X=A(:,1:69);
Y
% load dataset
type='classification';
L_fold=10; % L_fold crossvalidation
[gam,sig2] = tunelssvm({X,Y,type,[],[],'lin_kernel'},'simplex',...
'crossvalidatelssvm',{L_fold,'misclass'});  %单分类
[alpha,b]=trainlssvm({X,Y,type,gam,sig2,'lin_kernel'});
plotlssvm({X,Y,type,gam,sig2,'lin_kernel'},{alpha,b});%最后一步报错：第一个无效数据参数
% [gam,sig2] = tunelssvm({X,Y,type,[],[],'lin_kernel'},'gridsearch',...
% 'crossvalidatelssvm',{L_fold,'misclass'});   %网格搜索
% [alpha,b] = trainlssvm({X,Y,type,gam,sig2,'lin_kernel'});
% % latent variables are needed to make the ROC curve
% % Y_latent = latentlssvm({X,Y,type,gam,sig2,'lin_kernel'},{alpha,b},X);
% % [area,se,thresholds,oneMinusSpec,Sens]=roc(Y_latent,Y);
% % [thresholds oneMinusSpec Sens]
% plotlssvm({X,Y,type,gam,sig2,'lin_kernel'},{alpha,b});
