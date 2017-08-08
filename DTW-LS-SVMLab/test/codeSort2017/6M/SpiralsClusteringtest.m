clear all;
close all;
clc;

TXT= importdata('C:\Documents and Settings\Administrator\×ÀÃæ\cjy\2017\6\8\Spirals.txt');

Label=TXT(:,end);
TXTA=TXT(:,1:2);

[re]=KNNC7m(TXTA); %KNNClustering  KNN_Clustering

% [u re]=KMeansCJY(data,2);
% [le,u]=kmeans(TXTA,3);

le=re(:,end);
 figure;
hold on;
for i=1:size(le,1) 
    if le(i)==1 
         plot(re(i,1),re(i,2),'ro'); 
    elseif le(i)==2
         plot(re(i,1),re(i,2),'go'); 
    else 
         plot(re(i,1),re(i,2),'bo'); 
    end
end
grid on;