function [mm,net,MSE]=TimeS_Pre_net_DTW(x0,lk)
%用神经网络预测时间序列
%[x1,net,MSE]=TimeS_Pre_net(x0,lk)
%  输入          x0:   用于训练神经网络的时间序列，列向量
%                lk:   用lk个数据预测下一个数据,相当于AR模型的阶次
%  输出          x1：   在原输入序列x0后部加入了lk个预测数据
%                net:   训练好的神经网络
%                MSE:   各部预测的误差指标
%例子：
%   clc
%   clear all;
%   x0=xlsread('1X数据.xls');
%   lk=input('用多少个数据预测下一个数据？');
%   [x1,net,MSE]=TimeS_Pre_net(x0,lk);
%   lkk=input('需要进行多少步预测？');
%   [x,minx,maxx] = premnmx(x0);
%   n=length(x);
%   figure(2);
%   for ii=1:lkk
%       inputp(1:lk,1)=x(n+ii-1:-1:n-lk+ii);
%       x(n+ii)=sim(net,inputp);
%   end
%   x2 = postmnmx(x,minx,maxx);  %反归一化
%   plot(x2)
%   hold on
%   plot(x0,'r')

%归一化
[x,minx,maxx] = premnmx(x0);

n=length(x);
n1=n-lk-1;    %训练数据量
H=x(n-n1:n)';
MI=zeros(lk,1);
for ii=1:lk
    n2=n-n1-ii;
    n3=n-ii;
    Z(ii,1:n1+1)=x(n2:n3)';
end


for a=1:lk
%     MI(a)=mi(Z(a,:)',H'); %调用函数求解MI值
    MI(a)=mi(Z(a,:)',H'); %调用函数求解MI值
end


M=[]; %初始化{}里面的元素
% s0=s;
d=9;
d0=9;
temp=zeros(d0,n1+1);%用于存储选择出来的参与训练序列对应的序号,不可能大于q
% % MI求解过程中每增加一个Zi要怎么处理，知道求出s个z序列
tem=zeros(d0,1);%用于存储每次选择出来的序列对应的时刻点
Z0=Z;
while(d>0)
    for j=1:d0
    [maxx,maxi]=max(MI);
    tem(j)=maxi;
%     temp(j,:)=Z(maxi,:);
    M=[M Z(maxi,:)']; %每次将选择好的Z序列加进来，也要用于最后训练样本的求取
    Z(maxi,:)=zeros(1,n1+1);%除去选中的这一行....置零值
    zz=size(Z,1);
%     MI=zeros(zz,1);
    for ii=1:zz
        if MI(ii)==0
            MI(ii)=0;
        else
            MI(ii)=1;
        end
    end
    for i=1:zz
        if i==tem(j)
            MI(i)=0;
        else
            M=[M Z0(i,:)'];
%             cheng=mi(M,H');
            cheng=mi(M,H');
            if MI(i)==1
            MI(i)=cheng;
            end
             M(:,2)=[];
        end 
%     i=i+1;
    end
    d=d-1;
    end
end
tem=paixu(tem);
for i=1:d0
    temp(i,:)=Z0(tem(i),:);
end


%创建网络
net=newff(minmax(temp),[2*d0,1],{'tansig','purelin'},'trainlm');

%设置训练参数
net.trainParam.epochs=1000;%重复训练次数
net.trainParam.goal=1e-30;%训练终止目标
net.trainParam.lr=0.01;%学习效率
net.trainParam.show=20;%两次显示间的训练次数
net.trainParam.min_grad=1e-30;
net.trainParam.mu_max=1e12;

%训练网络
net=train(net,input,output);

%仿真
for ii=1:lk
out_test=sim(net,Z);

%计算误差
E(ii,:)=output-out_test;%ii步预测误差
MSE(ii)=mse(E(ii,:));

input1(1,:)=out_test(1:end);
input1(2:lk,:)=Z(1:lk-1,:);
Z=input1;
end



%===============预报===========
for ii=1:lk
inputp(1:lk,1)=x(n+ii-1:-1:n-lk+ii);
x(n+ii)=sim(net,inputp);
end
x1 = postmnmx(x,minx,maxx);  %反归一化
mm=x1(end-lk+1);