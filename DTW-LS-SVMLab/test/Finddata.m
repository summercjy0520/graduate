% load('data.mat');
% column=2;
% num=1634;
% row_index=datass(:,column)==num;
% datast=datass(row_index,:);

load('data.mat');
column=1;  %指定列
num=unique(datass(:,column)); %找到该列所有不相同的值
datas=datass(:,2:3);
datasss=cell(1,length(num)); %将所有相同的分组
a=size(datasss,1);
b=size(datasss,2);
% A=zeros(2,size(datass,1))';
sum=zeros(1,b);
for i=1:length(num)
    row_index=datass(:,column)==num(i);
%     data(i,:)=datas(row_index,:);
    sum(i)=length(find(row_index==1));
end
sum;
X=datas(1:sum(1),:);
Y=sign(sin(X(:,1))+X(:,2));
type='classification';
L_fold=10; % L_fold crossvalidation
[gam,sig2] = tunelssvm({X,Y,type,[],[],'lin_kernel'},'simplex',...
'crossvalidatelssvm',{L_fold,'misclass'});  %单分类
[alpha,b]=trainlssvm({X,Y,type,gam,sig2,'lin_kernel'});
plotlssvm({X,Y,type,gam,sig2,'lin_kernel'},{alpha,b});