% X=2.*rand(100,4)-1;
% Y=sign(sin(X(:,1))+X(:,2)+sin(X(:,3))+X(:,4));
% X=2.*rand(200,2)-1;
% Y=sign(sin(X(:,1))+X(:,2));
% X
% Y
A=importdata('data\wine.data');
% X=X';
m=size(A,2);
n=size(A,1);
Y=zeros(n,1);
sum=0;
sum1=0;
sum2=0;
sum3=0;
for i=1:n
if A(i,1)==1
    sum1=sum1+1;
elseif A(i,1)==2
    sum2=sum2+1;
else sum3=sum3+1;
end
i=i+1;
end
Y=[A(1:40,1);A(60:109,1);A(131:161,1)];
X=[A(1:40,2:14);A(60:109,2:14);A(131:161,2:14)];
% for i=1:size(Y,1)
%    if Y(i,1)==1
%     Y(i,:)=1;
% else     Y(i,:)=-1;
%    end
%    i=i+1;
% end
Xt=[A(41:59,2:14);A(110:130,2:14);A(162:178,2:14)];
% % for i=1:m 
% for j=1:m
%     if mod(j,2)==1
%     Y=Y+sin(X(:,j));
%     else 
%     Y=Y+X(:,j);
%     end
%     j=j+1;
% end
% j=j+1;
% end
% Y=sign(Y);
X
Y
% load dataset
type='classification';
L_fold=10; % L_fold crossvalidation
[gam,sig2] = tunelssvm({X,Y,type,[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{L_fold,'misclass'});  %单分类
[alpha,b]=trainlssvm({X,Y,type,gam,sig2,'RBF_kernel'});
Ytest=simlssvm1({X,Y,type,gam,sig2,'RBF_kernel'},{alpha,b},Xt);
for i=1:size(Ytest)
if Ytest(i)==1
    sum=sum+1;
end
end
plotlssvm({Xt,Ytest,type,gam,sig2,'RBF_kernel'});
hold on;
plotlssvm({X,Y,type,gam,sig2,'RBF_kernel'},{alpha,b});

% [gam,sig2] = tunelssvm({X,Y,type,[],[],'lin_kernel'},'gridsearch',...
% 'crossvalidatelssvm',{L_fold,'misclass'});   %网格搜索
% [alpha,b] = trainlssvm({X,Y,type,gam,sig2,'lin_kernel'});
% % latent variables are needed to make the ROC curve
% % Y_latent = latentlssvm({X,Y,type,gam,sig2,'lin_kernel'},{alpha,b},X);
% % [area,se,thresholds,oneMinusSpec,Sens]=roc(Y_latent,Y);
% % [thresholds oneMinusSpec Sens]
% plotlssvm({X,Y,type,gam,sig2,'lin_kernel'},{alpha,b});
