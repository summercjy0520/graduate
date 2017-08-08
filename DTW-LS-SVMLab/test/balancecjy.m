% X=2.*rand(100,4)-1;
% Y=sign(sin(X(:,1))+X(:,2)+sin(X(:,3))+X(:,4));
% X=2.*rand(200,2)-1;
% Y=sign(sin(X(:,1))+X(:,2));
% X
% Y
% CJY=importdata('data\iris.data');
M = importdata('data\balance-scale.data');
CJY=M.textdata(1:400,:);
Yn=M.textdata(401:625);
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
X=M.data(1:400,:);
mm=size(X,1);
nn=size(X,2);
Y=zeros(mm,2);
for i=1:mm
    if strcmp(CJY(i),'L');
        Y(i,1)=0;
        Y(i,2)=0;
    else if strcmp(CJY(i),'R');
            Y(i,1)=0;
            Y(i,2)=1;
            else if strcmp(CJY(i),'B');
                      Y(i,1)=1;
                      Y(i,2)=0;
                end
        end
    end
end
mmm=size(Yn);
Y1=zeros(mmm,1);
for i=1:mmm
    if strcmp(Yn(i),'L');
        Y1(i,1)=0;
        Y1(i,2)=0;
    else if strcmp(Yn(i),'R');
        Y1(i,1)=0;
        Y1(i,2)=1;
        else if strcmp(Yn(i),'B');
        Y1(i,1)=1;
        Y1(i,2)=0;
            end
        end
    end
end
% Y=zeros(mm,1);
% for i=1:mm
%     if strcmp(CJY(i),'L');
%         Y(i)=0;
%     else if strcmp(CJY(i),'R');
%             Y(i)=1;
%             else if strcmp(CJY(i),'B');
%                       Y(i)=2;
%                 end
%         end
%     end
% end
% mmm=size(Yn);
% Y1=zeros(mmm,1);
% for i=1:mmm
%     if strcmp(Yn(i),'L');
%         Y1(i)=0;
%     else if strcmp(Yn(i),'R');
%             Y1(i)=1;
%             else if strcmp(Yn(i),'B');
%                       Y1(i)=2;
%                 end
%         end
%     end
% end
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
Xt=M.data(401:625,:);
Y
% load dataset
type='classification';
L_fold=10; % L_fold crossvalidation
[gam,sig2] = tunelssvm({X,Y,type,[],[],'lin_kernel'},'simplex',...
'crossvalidatelssvm',{L_fold,'misclass'});  %单分类
[alpha,b]=trainlssvm({X,Y,type,gam,sig2,'lin_kernel'});
Ytest=simlssvm1({X,Y,type,gam,sig2,'lin_kernel'},{alpha,b},Xt);
plotlssvm({Xt,Ytest,type,gam,sig2,'lin_kernel'});
% hold on;
% plotlssvm({X,Y,type,gam,sig2,'RBF_kernel'},{alpha,b});%最后一步报错：第一个无效数据参数
% [gam,sig2] = tunelssvm({X,Y,type,[],[],'lin_kernel'},'gridsearch',...
% 'crossvalidatelssvm',{L_fold,'misclass'});   %网格搜索
% [alpha,b] = trainlssvm({X,Y,type,gam,sig2,'lin_kernel'});
% % latent variables are needed to make the ROC curve
% % Y_latent = latentlssvm({X,Y,type,gam,sig2,'lin_kernel'},{alpha,b},X);
% % [area,se,thresholds,oneMinusSpec,Sens]=roc(Y_latent,Y);
% % [thresholds oneMinusSpec Sens]
% plotlssvm({X,Y,type,gam,sig2,'lin_kernel'},{alpha,b});
