clear all;
close all;
clc;

%第一类数据
mu1=[0 0];  %均值
S1=[5.5 0 ;0 6.5 ];  %协方差
data1=mvnrnd(mu1,S1,200);   %产生高斯分布数据

%%第二类数据
mu2=[10.25 10.25];
S2=[5.5 0;0 6.5];
data2=mvnrnd(mu2,S2,200);

% %第三个类数据
% mu3=[-1.25 1.25 -1.25];
% S3=[0.3 0 0;0 0.35 0;0 0 0.3];
% data3=mvnrnd(mu3,S3,100);

%显示数据
plot(data1(:,1),data1(:,2),'+');
hold on;
plot(data2(:,1),data2(:,2),'r+');
hold on
plot(0,0,'g*');
hold on
plot(10.25,10.25,'g*');
grid on;

%三类数据合成一个不带标号的数据类
data=[data1;data2];
% data=[data1;data2;data3];   %这里的data是不带标号的

% DATA=data;
%  dtemp=pdist2(DATA,A);
% [Y,KT]=sort(dtemp);
% [K]=FuzzyEntropyPDF(dtemp,2)



%k-means聚类
[u re]=KMeansCJY(data,2);  %最后产生带标号的数据，标号在所有数据的最后，意思就是数据再加一维度
[m n]=size(re);

%最后显示聚类后的数据
figure;
hold on;
for i=1:m 
    if re(i,3)==1   
         plot(re(i,1),re(i,2),'ro'); 
    elseif re(i,3)==2
         plot(re(i,1),re(i,2),'go'); 
    end
end
grid on;