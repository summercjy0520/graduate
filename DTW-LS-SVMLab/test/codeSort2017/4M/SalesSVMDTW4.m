

clear all;
clc;

TXT=importdata('C:\Documents and Settings\Administrator\����\cjy\MIToolbox2.11\LS-SVMLab v1.7(R2006a-R2009a)\data\ARIMA.txt');

prediction=zeros(16,1);
zis=1;
while(zis<17)
q=11; %ʱ��
qq=q+1;
s=1;  %Ԥ�ⴰ��
k=80;
% q=1;
% s=2;
% qq=q+1;
X=TXT(1:200+zis-1);
% Q=TXT(5591:5600)';
Xt=TXT((200+zis):216);
XXt=[X;Xt];

mm=size(TXT(1:(200+zis-1)),1);

z=mm-s-qq+1;
Xtra=zeros(z,qq);
h=0; %�����ƶ�ʱ��Ӱ���ԭ���б��?

for i=1:z
    for j=1:qq
    if h+j<=mm
    Xtra(i,j)=X(h+j);
%     S(i,2*j)=X(h+2*j);
    end
    end
    h=h+1;
end  

Xs=XXt((200-s-q+zis):(200+zis-s))';
Ytra=X(s+qq:end);
[gam,sig2] = tunelssvm({Xtra,Ytra,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

dd1=NHDTWnew0(Xtra,Xs);%NHEH0306

%���ٽ�����
SS=zeros(k,qq);%����ڵ�k������
H=zeros(k,1);
K=zeros(k,1);
[maxn maxi]=max(dd1);%�����滻�����ֵ

jjj=1;
while (jjj<=k)
%     jjj=1;%��ֵ
    [minn mini]=min(dd1);%�ҵ�һ����Сֵ
    if mini>=qq&&mini<=(size(X,1)-q-s)
    K(jjj)=mini;%��¼��Ӧ����
    dd1(mini)=maxn;
    jjj=jjj+1;
    else
    dd1(mini)=maxn;
    end   
%     jjj=jjj+1;
end
for iii=1:k
    SS(iii,:)=Xtra(K(iii),:);
    H(iii)=Ytra(K(iii));
end
% d=3;

% 
% [gam,sig2] = tunelssvm({SS,H,'f',[],[],'RBF_kernel'},'simplex',...
% 'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({SS,H,'f',gam,sig2,'RBF_kernel'});
%predict next 100 points
prediction(zis) = predict({SS,H,'f',gam,sig2,'RBF_kernel'},Xs,1);
% prediction = predictcjy({Xtra,Ytra,'f',gam,sig2,'lin_kernel'},{[X;Xt],Xs},{d,100});

zis=zis+1;
end
% ticks=cumsum(ones(216,1));


plot(prediction(1:end),'-+');
hold on;
% plot(Xt((s+1):end),'r')
plot(TXT(201:216),'-*r');
xlabel('time');
ylabel('Values of Sales database');
title('SVM: mae= ,rmse=');


Xt=TXT(201:216);

mn=size(prediction,1);
w=0;
W=0;
PW=0;
for i=1:mn
    w=w+abs(prediction(i)-Xt(i));
    PW=PW+abs(prediction(i)-Xt(i))/Xt(i);
    W=W+(prediction(i)-Xt(i))^2;
end
mae=w/mn;
rmse=sqrt(W/mn);
mape=100*PW/mn;

