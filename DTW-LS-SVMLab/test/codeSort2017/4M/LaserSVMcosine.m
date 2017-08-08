
clear all;
clc;
TXT= importdata('data\KNN\Laser.txt');
TXT1= importdata('data\KNN\Lasercon.txt');
TXT=[TXT;TXT1];

prediction=zeros(95,1);
zis=1;
while(zis<96)
q=8; %Ê±ï¿½ï¿½
qq=q+1;
s=1;  %Ô¤ï¿½â´°ï¿½ï¿½
k=150;
% q=1;
% s=2;
% qq=q+1;
X=TXT(1:5605+zis-1);
% Q=TXT(5591:5600)';
Xt=TXT((5605+zis):5700);
XXt=[X;Xt];

mm=size(TXT(1:(5605+zis-1)),1);

z=mm-s-qq+1;
Xtra=zeros(z,qq);
h=0; %ï¿½ï¿½ï¿½ï¿½ï¿½Æ¶ï¿½Ê±ï¿½ï¿½Ó°ï¿½ï¿½ï¿½Ô­ï¿½ï¿½ï¿½Ð±ï¿½Ç?

for i=1:z
    for j=1:qq
    if h+j<=mm
    Xtra(i,j)=X(h+j);
%     S(i,2*j)=X(h+2*j);
    end
    end
    h=h+1;
end  

Ytra=X(s+qq:end);
Xs=XXt((5605-s-q+zis):(5605+zis-s));
dd2=NHDTWnew1219(Xtra,Xs');
dd1=zeros(z,1);
for i=1:z
    metrixD1=kernel_matrix(Xs','lin_kernel',0,Xtra(i,:));
    metrixD2=kernel_matrix(Xtra(i,:),'lin_kernel',0);
    metrixD3=kernel_matrix(Xs','lin_kernel',0);
    dd1(i)=norm(metrixD1)/(sqrt(norm(metrixD2))*sqrt(norm(metrixD3)));
%     dd1(i)=cosinecjy([Xtra(i,:);Xs'],Xs','lin_kernel',2);
end

%ÕÒÁÙ½üÐòÁÐ
SS=zeros(k,qq);%×î½üÁÚµÄk¸öÐòÁÐ
H=zeros(k,1);
K=zeros(k,1);
[minn mini]=min(dd1);%ÓÃÓÚÌæ»»£¬×î´óÖµ

jjj=1;
while (jjj<=k)
%     jjj=1;%³õÖµ
    [maxn maxi]=max(dd1);%ÕÒµÚÒ»¸ö×îÐ¡Öµ
    if maxi>=qq&&maxi<=(size(X,1)-q-s)
    K(jjj)=maxi;%¼ÇÂ¼¶ÔÓ¦µÄÐÐ
    dd1(maxi)=minn;
    jjj=jjj+1;
    else
    dd1(maxi)=minn;
    end   
%     jjj=jjj+1;
end
for iii=1:k
    SS(iii,:)=Xtra(K(iii),:);
    H(iii)=Ytra(K(iii));
end
% d=3;


[gam,sig2] = tunelssvm({SS,H,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'});
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

