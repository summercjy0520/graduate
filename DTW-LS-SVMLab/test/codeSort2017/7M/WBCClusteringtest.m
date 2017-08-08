clear all;
close all;
clc;

TXT= importdata('C:\Documents and Settings\Administrator\×ÀÃæ\cjy\2017\6\8\WBC.txt');

Label=zeros(size(TXT,1),1);
for i=1:size(TXT,1)
    if TXT(i,end)==2
        Label(i)=1;
    else
        Label(i)=2;
    end
end

TXTA=TXT(:,1:end-1);

% [re]=KNNC7m(TXTA); %KNNClustering   KNN_Clustering

[u re]=KMeansCJY(TXTA,2);
% [le,u]=kmeans(TXTA,2);

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