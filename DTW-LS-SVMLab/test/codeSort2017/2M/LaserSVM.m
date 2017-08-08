clear all;
clc;

TXT= importdata('data\KNN\Laser.txt');
TXT1= importdata('data\KNN\Lasercon.txt');
TXT=[TXT;TXT1];
% X=TXT(3000:5600);
% Xt=TXT(5601:5700);


prediction=zeros(505,1);
zis=1;
while(zis<506)
q=9; %Ê±ï¿½ï¿½
qq=q+1;
s=1;  %Ô¤ï¿½â´°ï¿½ï¿½
% k=6;
% q=1;
% s=2;
% qq=q+1;
X=TXT(1:545+zis-1);
% Q=TXT(5591:5600)';
Xt=TXT((546+zis-1):1050);
XXt=[X;Xt];

mm=size(TXT(1:(544+zis)),1);

z=mm-s-q+1;
Xtra=zeros(z,q);
h=0; %ï¿½ï¿½ï¿½ï¿½ï¿½Æ¶ï¿½Ê±ï¿½ï¿½Ó°ï¿½ï¿½ï¿½Ô­ï¿½ï¿½ï¿½Ð±ï¿½Ç?

for i=1:z
    for j=1:q
    if h+j<=mm
    Xtra(i,j)=X(h+j);
%     S(i,2*j)=X(h+2*j);
    end
    end
    h=h+1;
end  

Ytra=X(s+q:end);
Xs=XXt((545-q+zis):(545+zis-s));
% d=3;


[gam,sig2] = tunelssvm({Xtra,Ytra,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
% [alpha,b] = trainlssvm({Xtra,Ytra,'f',gam,sig2,'lin_kernel'});
%predict next 100 points
prediction(zis) = predict({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'},Xs,1);
% prediction = predictcjy({Xtra,Ytra,'f',gam,sig2,'lin_kernel'},{[X;Xt],Xs},{d,100});

zis=zis+1;
end
% ticks=cumsum(ones(216,1));
plot(prediction);
hold on;
plot(Xt,'r');
% plot([prediction Xt]);
xlabel('time');
ylabel('Laser');

Xt=TXT(546:1050);

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

% TXT=[TXT0;TXT1];
% X=TXT(4600:5599+zis);
% Xt=TXT(5601:5700);
% d=3;
% 
% lag = 9;
% Xu = windowize(X,1:lag+1);
% Xtra = Xu(1:end-lag,1:lag); %training set
% Ytra = Xu(1:end-lag,end); %training set
% Xs=X(end-lag+1:end,1); %starting point for iterative predictionµü´úÔ¤²âµÄÆðµã
% % Xt = rand(10,1).*sign(randn(10,1));
% 
% 
% [gam,sig2] = tunelssvm({Xtra,Ytra,'f',[],[],'RBF_kernel'},'simplex',...
% 'crossvalidatelssvm',{10,'mae'});
% 
% % Prediction of the next 100 points
% % [alpha,b] = trainlssvm({Xtra,Ytra,'f',gam,sig2,'lin_kernel'});
% %predict next 100 points
% prediction(zis) = predict({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'},Xs,1);
% % prediction = predictcjy({Xtra,Ytra,'f',gam,sig2,'lin_kernel'},{[X;Xt],Xs},{d,100});
% zis=zis+1;
% end
% 
% % ticks=cumsum(ones(216,1));
% plot(prediction);
% hold on;
% plot(Xt,'r');
% % plot([prediction Xt]);
% xlabel('time');
% ylabel('Laser');