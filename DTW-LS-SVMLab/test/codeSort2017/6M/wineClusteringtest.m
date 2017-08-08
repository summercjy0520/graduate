clear all;
close all;
clc;

TXT= importdata('C:\Documents and Settings\Administrator\����\cjy\2017\6\8\wine.txt');

Label=TXT(:,1);
TXTA=TXT(:,2:end);

% [re]=KNNC7m(TXTA); %KNNClustering   KNN_Clustering

[u re]=KMeansCJY(TXTA,3);
% [le,u]=kmeans(TXTA,3);

% re=TXTA(:,1:4);
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