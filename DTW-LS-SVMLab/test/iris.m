% X=2.*rand(100,4)-1;
% Y=sign(sin(X(:,1))+X(:,2)+sin(X(:,3))+X(:,4));
% X=2.*rand(200,2)-1;
% Y=sign(sin(X(:,1))+X(:,2));
% X
% Y
% CJY=importdata('data\iris.data');
CJY=importdata('data\iris.data');
% X=X';
% [mm,nn]=size(CJY{1,1});
% mm=CJY{1,1};
% X=cell2mat(CJY);
for i=1:50
X1(i,:)=cell2mat(CJY(i,:));
% A(i,:)=num2str(X(i,:));
% A(i,:)=regexp(A(i,:),',','split');
% X(i,:)= textscan(X(i,:),'%s','delimiter',',');
% disp(A(i,:));
Y1(i)=1;
i=i+1;
end
for i=51:100
X2(i-50,:)=cell2mat(CJY(i,:));
% A(i,:)=num2str(X(i,:));
% A(i,:)=regexp(A(i,:),',','split');
% X(i,:)= textscan(X(i,:),'%s','delimiter',',');
% disp(A(i,:));
Y2(i-50)=2;
i=i+1;
end
for i=101:150
X3(i-100,:)=cell2mat(CJY(i,:));
% A(i,:)=num2str(X(i,:));
% A(i,:)=regexp(A(i,:),',','split');
% X(i,:)= textscan(X(i,:),'%s','delimiter',',');
% disp(A(i,:));
Y3(i-100)=3;
i=i+1;
end
% A=cell2mat(CJY);
X=[X1(:,1:15);X2(:,1:15);X3(:,1:15)];
% mm=size(A,1);
% nn=size(A,2);
Y=[Y1(1:50)';Y2';Y3'];
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
X;
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
