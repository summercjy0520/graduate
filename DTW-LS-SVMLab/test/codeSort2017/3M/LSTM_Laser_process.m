function [train_data,test_data]=LSTM_Laser_process(zis)
%% 数据加载并完成初始归一化

TXT= importdata('data\KNN\Laser.txt');
TXT1= importdata('data\KNN\Lasercon.txt');
TXT=[TXT;TXT1];

q=8; %时锟斤拷
qq=q+1;
s=1;  
t=qq;

X=TXT(1:5605+zis-1);
Xt=TXT((5605+zis):5700);
XXt=[X;Xt];

mm=size(TXT(1:(5605+zis-1)),1);

z=mm-s-qq+1+1;
S=zeros(z,qq);
h=0; %锟斤拷锟斤拷锟狡讹拷时锟斤拷影锟斤拷锟皆拷锟斤拷斜锟角?

for i=1:z
    for j=1:qq
    if h+j<=mm
    S(i,j)=X(h+j);
%     S(i,2*j)=X(h+2*j);
    end
    end
    h=h+1;
end  

Test_data_initial=zeros(z,t);
i=z;
while i>3*t
    Test_data_initial(z-i+1,:)=S(i,:);
    i=i-t;
end
Test_data_initial(ismember(Test_data_initial,zeros(1,t),'rows')==1,:)=[];
test_data_initial=flipdim(Test_data_initial,1);
test_data_initial=test_data_initial';

train_data_initial=zeros(z,3*qq);
i=z-t;
while i>2*t
    train_data_initial(z-1-i+1,:)=X(i-2*t:i+t-1)';
%     train_data_initial(z-1-i+1,1:qq)=S(i-2*t,:);
%     train_data_initial(z-1-i+1,qq+1:2*qq)=S(i-t,:);
%     train_data_initial(z-1-i+1,2*qq+1:3*qq)=S(i,:);
    i=i-t;
end

train_data_initial(ismember(train_data_initial,zeros(1,3*qq),'rows')==1,:)=[];
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