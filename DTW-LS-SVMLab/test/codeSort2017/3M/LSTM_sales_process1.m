function [train_data,test_data]=LSTM_sales_process1(zis)
%% 数据加载并完成初始归一化
TXT=importdata('C:\Documents and Settings\Administrator\桌面\cjy\MIToolbox2.11\LS-SVMLab v1.7(R2006a-R2009a)\data\ARIMA.txt');
[TXT,minx,maxx] = premnmx(TXT);

q=11; %时锟斤拷
qq=q+1;
s=4;  

X=TXT(1:200+zis-1);
Xt=TXT((200+zis):216);
XXt=[X;Xt];

mm=size(TXT(1:(200+zis-1)),1);

z=mm-s-qq+1;
train_data_initial=zeros(z,qq);
h=0; %锟斤拷锟斤拷锟狡讹拷时锟斤拷影锟斤拷锟皆拷锟斤拷斜锟角?

for i=1:z
    for j=1:qq
    if h+j<=mm
    Train_data_initial(i,j)=X(h+j);
%     S(i,2*j)=X(h+2*j);
    end
    end
    h=h+1;
end  

Test_data_initial=[XXt(qq+1:qq+s)]';
for i=qq+2:length(X)-s+2
    Test_data_initial=[Test_data_initial;XXt(i:i+s-1)'];
end

i=size(Test_data_initial,1)-4;
test_data_initial=[];
while i>0
    test_data_initial=[test_data_initial;Test_data_initial(i,:)];
    i=i-12;
end

test_data_initial=flipdim(test_data_initial,1);
test_data_initial=test_data_initial';

j=size(Train_data_initial,1)-3;
train_data_initial=[];
while j>0
    train_data_initial=[train_data_initial;Train_data_initial(j,:)];
    j=j-12;
end

train_data_initial=flipdim(train_data_initial,1);
train_data_initial=train_data_initial';
data_length=size(train_data_initial,1);            %每个样本的长度
data_num=size(train_data_initial,2);               %样本数目  

%%归一化过程
for n=1:data_num
    train_data(:,n)=train_data_initial(:,n)/sqrt(sum(train_data_initial(:,n).^2));  
end
% test_data=test_data_initial;
for m=1:size(test_data_initial,2)
    test_data(:,m)=test_data_initial(:,m)/sqrt(sum(test_data_initial(:,m).^2));
end