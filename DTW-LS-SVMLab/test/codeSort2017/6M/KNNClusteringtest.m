clear all;
close all;
clc;

%第一类数据
mu1=[0 0];  %均值
S1=[0.3 0 ;0 0.35 ];  %协方差
data1=mvnrnd(mu1,S1,200);   %产生高斯分布数据

%%第二类数据
mu2=[2.25 2.25];
S2=[0.3 0;0 0.35];
data2=mvnrnd(mu2,S2,200);

mu3=[-2.25 2.25];
S3=[0.3 0;0 0.35];
data3=mvnrnd(mu3,S3,200);

mu4=[-2.25 -2.25];
S4=[0.3 0;0 0.35];
data4=mvnrnd(mu4,S4,200);

mu5=[2.25 -2.25];
S5=[0.3 0;0 0.35];
data5=mvnrnd(mu5,S5,200);

mu6=[5.25 0];
S6=[0.3 0;0 0.35];
data6=mvnrnd(mu6,S6,200);

mu7=[0 5.25];
S7=[0.3 0;0 0.35];
data7=mvnrnd(mu7,S7,200);

mu8=[0 -5.25];
S8=[0.3 0;0 0.35];
data8=mvnrnd(mu8,S8,200);

mu9=[-5.25 0];
S9=[0.3 0;0 0.35];
data9=mvnrnd(mu9,S9,200);

mu10=[5.25 5.25];
S10=[0.3 0;0 0.35];
data10=mvnrnd(mu10,S10,200);

data=[data1;data2;data3;data4;data5;data6;data7;data8;data9;data10];

%显示数据
plot(data1(:,1),data1(:,2),'r+');
hold on;
plot(data2(:,1),data2(:,2),'+');
hold on;
plot(data3(:,1),data3(:,2),'+');
hold on;
plot(data4(:,1),data4(:,2),'+');
hold on;
plot(data5(:,1),data5(:,2),'+');
hold on;
plot(data6(:,1),data6(:,2),'+');
hold on;
plot(data7(:,1),data7(:,2),'+');
hold on;
plot(data8(:,1),data8(:,2),'+');
hold on;
plot(data9(:,1),data9(:,2),'+');
hold on
plot(data10(:,1),data10(:,2),'+');
hold on
plot(0,0,'g*');
hold on
plot(2.25,2.25,'g*');
hold on
plot(-2.25,2.25,'g*');
hold on
plot(2.25,-2.25,'g*');
hold on
plot(-2.25,-2.25,'g*');
hold on
plot(5.25,0,'g*');
hold on
plot(-5.25,0,'g*');
hold on
plot(0,-5.25,'g*');
hold on
plot(0,5.25,'g*');
hold on
plot(5.25,5.25,'g*');
grid on;


[re]=KNNClusterings(data);

% [u re]=KMeansCJY(data,2);
figure;
hold on;
A=unique(re(:,end));
for i=1:size(re,1)
    if re(i,end)==A(1)   
         plot(re(i,1),re(i,2),'ro'); 
    else
         plot(re(i,1),re(i,2),'go'); 
    end
end
grid on;