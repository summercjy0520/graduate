clear all;
clc;

TXT= importdata('data\KNN\Laser.txt');
TXT1= importdata('data\KNN\Lasercon.txt');
TXT=[TXT;TXT1];
y=TXT(1:600);

ftdnn_net=timedelaynet([1:8],10);
ftdnn_net.trainParam.epochs=1000;
ftdnn_net.divideFcn='';

p=y(9:end);
t=y(9:end);
pi=(1:8);
ftdnn_net=train(ftdnn_net,p,t,pi);
