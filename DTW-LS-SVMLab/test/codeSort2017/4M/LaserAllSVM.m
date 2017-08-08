clear all;
clc;

TXT= importdata('data\KNN\Laser.txt');
TXT1= importdata('data\KNN\Lasercon.txt');
TXT=[TXT;TXT1];


prediction=zeros(95,1);
zis=1;
while(zis<2)
q=8; %ʱ��
qq=q+1;
s=1;  %Ԥ�ⴰ��
% k=6;
% q=1;
% s=2;
% qq=q+1;
X=TXT(1:5605+zis-1);
% Q=TXT(5591:5600)';
Xt=TXT((5606+zis-1):5700);
XXt=[X;Xt];

mm=size(TXT(1:(5604+zis)),1);

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

Xmean=zeros(1,qq);
for i=1:qq
    Xmean(i)=mean(Xtra(:,i));
end
Ytra=X(s+qq:end);
Ymean=mean(Ytra);
for j=1:z
    Xtra(j,:)=Xtra(j,:)-Xmean;
    Ytra(j)=Ytra(j)-Ymean;
end

Xs=XXt((5605-s-q+zis):(5605+zis-s))'-Xmean;

d=1;


[gam,sig2] = tunelssvm({Xtra,Ytra,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'});
%predict next 100 points
%prediction = predict({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'},Xs,95);
prediction = predictcjy_mean({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'},{[X;Xt],Xs},{Xmean,Ymean},{d,95});
prediction=prediction+Ymean;
zis=zis+1;
end
% ticks=cumsum(ones(216,1));

Xt=TXT(5606:5700);

plot(prediction,'-+');
hold on;
plot(Xt,'-r*');
xlabel('time');
ylabel('Laser(1:5605)');
title('mae=');
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
