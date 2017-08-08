function [x1,net,MSE]=TimeS_Pre_net(x0,lk)
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
output=x(n-n1:n)';
for ii=1:lk
    n2=n-n1-ii;
    n3=n-ii;
    input(ii,1:n1+1)=x(n2:n3)';
end

%创建网络
net=newff(minmax(input),[2*lk,1],{'tansig','purelin'},'trainlm');

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
out_test=sim(net,input);

%计算误差
E(ii,:)=output-out_test;%ii步预测误差
MSE(ii)=mse(E(ii,:));

input1(1,:)=out_test(1:end);
input1(2:lk,:)=input(1:lk-1,:);
input=input1;
end

figure(1);
plot(MSE);




%===============预报===========
figure(2);
for ii=1:lk
inputp(1:lk,1)=x(n+ii-1:-1:n-lk+ii);
x(n+ii)=sim(net,inputp);
end
x1 = postmnmx(x,minx,maxx);  %反归一化
plot(x1)
hold on
plot(x0,'r')