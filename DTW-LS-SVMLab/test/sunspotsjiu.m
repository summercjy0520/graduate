

clear all;
clc;

TXT= importdata('data\sunspot1.txt');
TXT1= importdata('data\KNN\sunspotscon.txt');
TXT=[TXT;TXT1];


prediction=zeros(67,1);
zis=1;
while(zis<68)
q=10; %ʱ��
qq=q+1;
s=1;  %Ԥ�ⴰ��
% k=6;
% q=1;
% s=2;
% qq=q+1;
X=TXT(1:221+zis-1);
% Q=TXT(5591:5600)';
Xt=TXT((222+zis-1):288);
XXt=[X;Xt];

mm=size(TXT(1:(220+zis)),1);
Xtt=XXt((end-size(Xt,1)-q-s+1):end);

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

Ytra=X(s+qq:end);
Xs=Xtt(1:qq)';
% d=3;

gam=3600;
sig2=700;

% [gam,sig2] = tunelssvm({Xtra,Ytra,'f',[],[],'RBF_kernel'},'simplex',...
% 'crossvalidatelssvm',{10,'mae'});

prediction(zis) = predict({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'},Xs,1);
% prediction = predictcjy({Xtra,Ytra,'f',gam,sig2,'lin_kernel'},{[X;Xt],Xs},{d,100});

zis=zis+1;
end
% ticks=cumsum(ones(216,1));


plot(prediction(1:end));
hold on;
% plot(Xt((s+1):end),'r')
plot(TXT(222:288),'r');
xlabel('time');
% ts=datenum('1972-01');
% tf=datenum('2010-10');
% t=linspace(ts,tf,70);
% plot(t(1:size(X(end-68:end))),X(end-68:end));
% hold on;
% plot(t(size(X(end-68:end))+1:size(ticks)),[prediction SSQ(1)]);
% datetick('x','yyyy','keepticks');
ylabel('Values of Sunspots database');
title('the example 1 of KNN');


Xt=TXT(222:288);
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

