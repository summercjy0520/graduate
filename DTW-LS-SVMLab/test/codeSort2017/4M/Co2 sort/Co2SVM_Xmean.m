

clear all;
clc;

TXT= importdata('C:\Documents and Settings\Administrator\×ÀÃæ\cjy\2016\10\R data\co2.txt');
txt=TXT.data;
TXT=[];
for i=1:size(txt,1)
    TXT=[TXT;txt(i,2:end)'];
end

C=60;
prediction=zeros(C,1);
zis=1;
h1=size(TXT,1);
h0=h1-C;
while(zis<C+1)
q=11; %Ê±ï¿½ï¿½
qq=q+1;
s=1;  
X=TXT(1:h0+zis-1);
Xt=TXT((h0+zis):h1);
XXt=[X;Xt];

mm=size(TXT(1:(h0+zis-1)),1);

z=mm-s-qq+1;
Xtra=zeros(z,qq);
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
for j=1:size(Xtra,1)
    temp=mean(Xtra(j,:));
    Xtra(j,:)=Xtra(j,:)-temp;
    Ytra(j)=Ytra(j)-temp;
end
Xs=XXt((h0-s-q+zis):(h0+zis-s))';
Xs0=Xs;
Xs=Xs-mean(Xs0);
% d=3;


[gam,sig2] = tunelssvm({Xtra,Ytra,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'});
%predict next 100 points
prediction(zis) = predict({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'},Xs,1);
% prediction = predictcjy({Xtra,Ytra,'f',gam,sig2,'lin_kernel'},{[X;Xt],Xs},{d,100});
prediction(zis) =prediction(zis) +mean(Xs0);
zis=zis+1;
end
% ticks=cumsum(ones(216,1));


plot(prediction(1:end),'-+');
hold on;
% plot(Xt((s+1):end),'r')
plot(TXT(h0+1:h1),'-*r');
xlabel('time');
ylabel('Values of Sales database');
title('SVM(RBF_kernel) (Sales):mae=1.5741,rmse=1.7757,mape=3.5218');


Xt=TXT(h0+1:h1);

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

