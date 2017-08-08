% clear all;
% clc;
%
%
%
% prediction=zeros(100,1);
% zis=1;
%
% TXT0= importdata('data\KNN\Laser.txt');
% TXT1= importdata('data\KNN\Lasercon.txt');

clear all;
clc;

TXT= importdata('C:\Documents and Settings\Administrator\×ÀÃæ\cjy\2016\7\co2.txt');
TXT1= importdata('C:\Documents and Settings\Administrator\×ÀÃæ\cjy\2016\7\pred.txt');
TXTX=[TXT;TXT1];
% X=TXT(3000:5600);
% Xt=TXT(5601:5700);


% prediction=zeros(36,1);
% zis=1;
% while(zis<10)
q=9; %Ê±ï¿½ï¿½
qq=q+1;
s=1;  %Ô¤ï¿½â´°ï¿½ï¿½
% X=TXT(2000:5605+zis-1);
% Xt=TXT((5606+zis-1):5700);
% XXt=[X;Xt];
% mm=size(TXT(2000:(5604+zis)),1);
X=TXT;
Xt=TXT1;
XXt=[X;Xt];
mm=size(X,1);

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
% Xs=XXt((3605-s-q+zis):(3605+zis-s));
Xs=TXT1;


[gam,sig2] = tunelssvm({Xtra,Ytra,'f',[],[],'RBF_kernel'},'simplex',...
    'crossvalidatelssvm',{10,'mae'});

%prediction(zis) = predict({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'},Xs,1);
prediction = predictcjy({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'},{[X;Xt],TXTX},{2,36});

% zis=zis+1;
% end
plot(prediction);
hold on;
plot(Xt,'r');
xlabel('time');
ylabel('Laser');