clear all;
close all;
clc;

TXT= importdata('C:\Documents and Settings\Administrator\×ÀÃæ\cjy\2017\6\29\abalone.txt');

num=size(TXT.data,1);

Label=zeros(num,1);
for i=1:num
    if TXT.textdata{i}=='M'
        Label(i)=1;
    else
        Label(i)=2;
    end
end


TXTA=TXT.data;

[re]=kmeans(TXTA,2); %KNNClustering
re=[TXTA,re];
% [u re]=KMeansCJY(data,2);
% [le,u]=kmeans(TXTA,3);
K1=find(re(:,end)==1);
K2=find(re(:,end)==2);

S1=zeros(size(K1,1),size(TXTA,2));
Y1=zeros(size(K1,1),1);
S2=zeros(size(K2,1),size(TXTA,2));
Y2=zeros(size(K2,1),1);

for i=1:size(K1,1)
    S1(i,:)=TXTA(K1(i),:);
    Y1(i)=Label(K1(i));
end
for i=1:size(K2,1)
    S2(i,:)=TXTA(K2(i),:);
    Y2(i)=Label(K2(i));
end

[Agam,Asig2,Aalpha,Ab]=classKLSSVM(S1,Y1);
[Bgam,Bsig2,Balpha,Bb]=classKLSSVM(S2,Y2);

Ttest= importdata('C:\Documents and Settings\Administrator\×ÀÃæ\cjy\2017\6\29\abalonetest.txt');
TXTa=Ttest.data;

textlabel=zeros(size(TXTa,1),1);
for i=1:size(TXTa,1)
    if Ttest.textdata{i}=='M'
        textlabel(i)=1;
    else
        textlabel(i)=2;
    end
end

type='c';
Y_latent=zeros(size(TXTa,1),3);
for i=1:size(TXTa,1)
    index=findCluster(re,TXTa(i,:));
    Y_latent(i,1)=index;
    
    Y_latent(i,2) = latentlssvm({S1,Y1,type,Agam,Asig2,'RBF_kernel'},{Aalpha,Ab},TXTa(i,:));
    
    Y_latent(i,3) = latentlssvm({S2,Y2,type,Bgam,Bsig2,'RBF_kernel'},{Balpha,Bb},TXTa(i,:));
    
end

[gam,sig2,alpha,b]=classKLSSVM(TXTA,Label);
Y_l= latentlssvm({TXTA,Label,type,gam,sig2,'RBF_kernel'},{alpha,b},TXTa);