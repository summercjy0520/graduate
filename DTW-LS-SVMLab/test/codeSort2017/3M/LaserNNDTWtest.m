clear all;
clc;

TXT= importdata('C:\Documents and Settings\Administrator\×ÀÃæ\cjy\MIToolbox2.11\LS-SVMLab v1.7(R2006a-R2009a)\data\KNN\Laser.txt');
TXT1= importdata('C:\Documents and Settings\Administrator\×ÀÃæ\cjy\MIToolbox2.11\LS-SVMLab v1.7(R2006a-R2009a)\data\KNN\Lasercon.txt');
TXT=[TXT;TXT1];

prediction=zeros(95,1);

zis=1;
while(zis<96)
y=TXT(1:5605+zis-1);
[mm,net,MSE]=TimeS_Pre_net_DTW(y,13);
prediction(zis)=mm;
zis=zis+1;
end

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

% 
% ftdnn_net=timedelaynet(1:8,10);
% ftdnn_net.trainParam.epochs=1000;
% ftdnn_net.divideFcn='';
% 
% p=y(9:end);
% t=y(9:end);
% pi=(1:8);
% ftdnn_net=train(ftdnn_net,p,t,pi);
% 
% yp=ftdnn_net(p,pi);