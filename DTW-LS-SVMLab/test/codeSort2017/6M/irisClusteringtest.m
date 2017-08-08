clear all;
close all;
clc;

[TXT,TX,RAW] = xlsread('C:\Documents and Settings\Administrator\桌面\cjy\2017\6\5\IRIS数据集.xls');

TXTA=zeros(size(TXT,1),size(TXT,2));

for i=1:size(TXT,1)
    if strcmp(TX(i+1,6),'Iris-setosa')
        TXTA(i,end)=1;
    elseif strcmp(TX(i+1,6),'Iris-versicolor')
        TXTA(i,end)=2;
    else
        TXTA(i,end)=3;
    end
end
TXTA(:,1:4)=TXT(:,2:5);

[re]=KNNC7m(TXTA(:,1:4));%KNN_Clustering

% [u re]=KMeansCJY(data,2);
% [le,u]=kmeans(TXTA(:,1:4),3);

% re=TXTA(:,1:4);
le=re(:,end);
figure;
hold on;
for i=1:size(le,1) 
    if le(i)==1   
         plot3(re(i,1),re(i,2),re(i,3),'ro'); 
    elseif le(i)==2
         plot3(re(i,1),re(i,2),re(i,3),'go'); 
    else 
         plot3(re(i,1),re(i,2),re(i,3),'bo'); 
    end
end
grid on;