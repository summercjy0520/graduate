clear all;
close all;
clc;

TXTa= importdata('C:\Documents and Settings\Administrator\×ÀÃæ\cjy\2017\7\data\synthetic.txt');

num=size(TXTa,1);

rowrank=randperm(num);
TXTa=TXTa(rowrank,:);

Label=TXTa(1:560,7);
TXTA=TXTa(1:560,1:6);

% [re]=kmeans(TXTA,2); %KNNClustering
% re=[TXTA,re];
% re(find(re==2))=-1;
[re]=KNNC7m(TXTA);

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

textlabel=TXTa(2901:end,3);
textA=TXTa(2901:end,1:2);

type='c';
Y_latent=zeros(size(textA,1),3);
for i=1:size(textA,1)
    index=findCluster(re,textA(i,:));
    Y_latent(i,1)=index;
    
    Y_latent(i,2) = latentlssvm({S1,Y1,type,Agam,Asig2,'RBF_kernel'},{Aalpha,Ab},textA(i,:));
    
    Y_latent(i,3) = latentlssvm({S2,Y2,type,Bgam,Bsig2,'RBF_kernel'},{Balpha,Bb},textA(i,:));
    
%     Y_latent(i,4) = latentlssvm({S3,Y3,type,Cgam,Csig2,'RBF_kernel'},{Calpha,Cb},textA(i,:));
    
end

[gam,sig2,alpha,b]=classKLSSVM(TXTA,Label);
Y_l= latentlssvm({TXTA,Label,type,gam,sig2,'RBF_kernel'},{alpha,b},textA);