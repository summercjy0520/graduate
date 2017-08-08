
clear all;
clc;

[TXT,TX,RAW] = xlsread('C:\Documents and Settings\Administrator\×ÀÃæ\cjy\2016\5\data\international-airline-passengers.xlsx');

prediction=zeros(14,1);
zis=1;
while(zis<15)
q=10; %Ê±ï¿½ï¿½
s=1;  %Ô¤ï¿½â´°ï¿½ï¿½
% k=6;
% q=1;
% s=2;
% qq=q+1;
X=TXT(1:130+zis-1);
% Q=TXT(5591:5600)';
Xt=TXT((131+zis-1):144);
XXt=[X;Xt];

mm=size(TXT(1:(129+zis)),1);

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
Xs=XXt((130-s-q+zis+1):(130+zis-s));

[gam,sig2] = tunelssvm({Xtra,Ytra,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'});
%predict next 100 points
prediction(zis) = predict({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'},Xs,1);
% prediction = predictcjy({Xtra,Ytra,'f',gam,sig2,'lin_kernel'},{[X;Xt],Xs},{d,100});

zis=zis+1;
end
% ticks=cumsum(ones(216,1));
plot(prediction(1:end),'-+');
hold on;
 % plot(Xt((s+1):end),'r')
plot(TXT(131:144),'-r*');


ticks=cumsum(ones(144,1));
Xt=TXT(131:144);
ts=datenum('2001-01');
tf=datenum('2016-04');
t=linspace(ts,tf,144);
X=TXT(1:130);
plot(t(1:size(X)),X);
hold on;
plot(t(size(X)+1:size(ticks)),[prediction Xt]);

datetick('x','yyyy','keepticks');
xlabel('time');
ylabel('international-airline-passengers');
