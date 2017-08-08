clear all;
clc;

TXT= importdata('C:\Documents and Settings\Administrator\����\cjy\2016\10\R data\co2.txt');
txt=TXT.data;
TXT=[];
for i=1:size(txt,1)
    TXT=[TXT;txt(i,2:end)'];
end

C=60;%��ǰԤ����ٸ�������
prediction=zeros(C,1);
best=zeros(C,1);
worst=zeros(C,1);

h1=size(TXT,1);
h0=h1-C;

for jia=1:C
    
X=TXT(1:(h0+jia-1));
% Q=TXT(5591:5600)';
Xt=TXT((h0+jia):h1);

q=11; %ʱ��
qq=q+1;
s=1;  %Ԥ�ⴰ��

Xtt=[X;Xt];

mm=size(TXT(1:(h0-1+jia)),1);


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

Q=Xtt((h0-s-q+jia):(h0+jia-s))';
Ytra=X(qq+s:end);

[gam,sig2] = tunelssvm({Xtra,Ytra,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

%predict
prediction(jia) = predict({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'},Q,1);
end

%plot
plot(prediction(1:end),'-+');
hold on;
% plot(Xt((s+1):end),'r')
plot(TXT(h0+1:h1),'-r*');
xlabel('time');
ylabel('Values of Poland electricity database');
title('the example 1 of KNN');

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
nrmse=rmse/std(TXT(1:h0));