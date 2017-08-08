
clear all;
clc;

TXT= importdata('C:\Documents and Settings\Administrator\×ÀÃæ\cjy\2016\6\data\main\zxzq.txt');
TXT=(TXT.textdata(2002:3098,5))';% end:2015-03~06:2864-2933  %+2000
TXT=str2double(TXT);
[TXT,T1]=mapminmax(TXT);
TXT=TXT(1:end)';
% TXT=(TXT.data(:,2));


prediction=zeros(64,1);
zis=1;
while(zis<65)
q=15; %Ê±ï¿½ï¿½
qq=q+1;
s=1;  %Ô¤ï¿½â´°ï¿½ï¿½
% k=6;
% q=1;
% s=2;
% qq=q+1;
X=TXT(1:1033+zis-1);
% Q=TXT(5591:5600)';
Xt=TXT((1034+zis-1):1097);
XXt=[X;Xt];

mm=size(TXT(1:(1032+zis)),1);

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
Xs=XXt((1034-s-q+zis):(1034+zis-s));
% d=3;

% lag = 100;
% Xu = windowize(X,1:lag+1);
% Xtra = Xu(1:end-lag,1:lag); %training set
% Ytra = Xu(1:end-lag,end); %training set
% Xs=X(end-lag+1:end,1); %starting point for iterative predictionï¿½ï¿½ï¿½Ô¤ï¿½ï¿½ï¿½ï¿½ï¿½ï¿?
% % Xt = rand(10,1).*sign(randn(10,1));

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


plot(prediction(1:end));
hold on;
% plot(Xt((s+1):end),'r')
plot(TXT(1034:1097),'r');
xlabel('time');
% ts=datenum('1972-01');
% tf=datenum('2010-10');
% t=linspace(ts,tf,70);
% plot(t(1:size(X(end-68:end))),X(end-68:end));
% hold on;
% plot(t(size(X(end-68:end))+1:size(ticks)),[prediction SSQ(1)]);
% datetick('x','yyyy','keepticks');
ylabel('Values of stockdata');
title('stock data test');


Xt=TXT(1034:1097);
% mn=size(prediction,1);
% w=zeros(mn,1);
% W=zeros(mn,1);
% for i=1:mn
%     w(i)=(prediction(i)-Xt(i))^2;
%     W(i)=(mean(Xt)-Xt(i))^2;
% end
% nmse = mean(w)/mean(W);
prediction=prediction(1:end);
mn=size(prediction,1);
w=0;
W=0;
for i=1:mn
    w=w+abs(prediction(i)-Xt(i));
    W=W+(prediction(i)-Xt(i))^2;
end
mae=w/mn;
rmse=sqrt(W/mn);

