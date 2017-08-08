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

data=[data1;data2;data3;data4;data5;data6;data7;data8;data9];

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
grid on;


%三类数据合成一个不带标号的数据类

% data=[data1;data2;data3];   %这里的data是不带标号的

%k-means聚类
[u re]=KMeansCJY(data,4);  %最后产生带标号的数据，标号在所有数据的最后，意思就是数据再加一维度
[m n]=size(re);

%最后显示聚类后的数据
figure;
hold on;
for i=1:m 
    if re(i,3)==1   
         plot(re(i,1),re(i,2),'ro'); 
    elseif re(i,3)==2
         plot(re(i,1),re(i,2),'go'); 
    elseif re(i,3)==3
         plot(re(i,1),re(i,2),'yo'); 
    elseif re(i,3)==4
         plot(re(i,1),re(i,2),'ko'); 
    end
end
grid on;