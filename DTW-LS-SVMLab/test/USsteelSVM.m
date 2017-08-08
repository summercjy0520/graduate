
clear all;
clc;

[TXT,TX,RAW] = xlsread('data\KNN\US steel.xls');
TXT=TXT(:,4);
TXT=TXT(1:1800);

prediction=zeros(50,1);
zis=1;
while(zis<51)
q=7; %ʱ��
qq=q+1;
s=1;  %Ԥ�ⴰ��
% k=6;
% q=1;
% s=2;
% qq=q+1;
X=TXT(1:1750+zis-1);
% Q=TXT(5591:5600)';
Xt=TXT((1751+zis-1):1800);
XXt=[X;Xt];

mm=size(TXT(1:(1749+zis)),1);

z=mm-s-q+1;
Xtra=zeros(z,q);
h=0; %�����ƶ�ʱ��Ӱ���ԭ���б��?

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
Xs=XXt((1750-s-q+zis+1):(1750+zis-s));

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
plot(TXT(1751:1800),'-r*');
xlabel('time');
ylabel('Laser');
