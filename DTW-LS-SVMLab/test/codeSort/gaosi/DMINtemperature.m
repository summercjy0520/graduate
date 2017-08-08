
clear all;
clc;

[TXT,TX,RAW] = xlsread('C:\Documents and Settings\Administrator\×ÀÃæ\cjy\2016\5\data\daily-minimum-temperatures£¨1981-1990£©.xlsx');
TXT=TXT(2001:end);

ww=100;
prediction=zeros(ww,1);
class=zeros(ww,1);

H1=size(TXT,1);

% h0=h1;
h0=H1-ww;
k=200;

zis=1;
while(zis<ww+1)
q=9; %Ê±ï¿½ï¿½
qq=q+1;
s=1;  %Ô¤ï¿½â´°ï¿½ï¿½

X=TXT(1:h0+zis-1);

Xt=TXT((h0+1+zis-1):H1);
XXt=[X;Xt];

Xs=XXt((h0-s-q+zis):(h0+zis-s));
mm=size(TXT(1:(h0-1+zis)),1);

z=mm-s-qq+1;
Xtra=zeros(z,q);
h=0; 

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
Xt=TXT(h0+1:H1);
plot(prediction,'-+');
hold on;
plot(Xt,'-r*');
% plot([prediction Xt]);
xlabel('time');
ylabel('D MIN Tempreture dataset');
title('SVM: mae= ,rmse= ');

mn=size(prediction,1);
w=0;
W=0;
for i=1:mn
    w=w+abs(prediction(i)-Xt(i));
    W=W+(prediction(i)-Xt(i))^2;
end
mae=w/mn;
rmse=sqrt(W/mn);
