TXT= importdata('data\Metal goods\13013-13599.txt');
% TXT=str2num(cell2mat(TXT));
% XX=TXT.data;
%预测值4个：168.7、163.7、160.7、159.4
% mm=size(TXT,1);
% % nn=size(char(TXT(1)),2);
% XX=zeros(mm,5);
% for i=1:mm
%     XX(i)=cell2mat(TXT(i));
%     i=i+1;
% end
X=TXT.data(92:420);
Xt=TXT.data(421:450);
lag = 26;
d=13;
% Xu = windowize(X,1:lag+1);
% Xtra = Xu(1:end-lag,1:lag); %training set
% Ytra = Xu(1:end-lag,end); %training set
% Xs=X(end-lag+1:end,1); %starting point for iterative prediction迭代预测的起点
% % Xt = rand(10,1).*sign(randn(10,1));
% Xss=Xtra(end-lag+1:end,12);
Xu = windowize(X,1:lag+1);
Xtra = Xu(1:end-1,1:lag); %training set
Ytra = Xu(1:end-1,end); %training set
Xs=Xu(end,2:lag+1); %starting point for iterative prediction迭代预测的起点
% Xt = rand(10,1).*sign(randn(10,1));

% L=size(Xtra,1);

[gam,sig2] = tunelssvm({Xtra,Ytra,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% gam=300*sig2+gam;
% gam=2.3;
% sig2=sig2*100;
% Prediction of the next 100 points
[alpha,b] = trainlssvm({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'}); %lin_kernel
%predict next 100 points
prediction = predictcjy({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'},{TXT.data(92:547),Xs},{d,60});
% prediction = predict({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'},Xs,30);

ticks=cumsum(ones(359,1));
plot(prediction);
xlabel('time');
% x=[1920*ones(1,12) 1921*ones(1,12) 1922*ones(1,12) 1923*ones(1,12) 1924*ones(1,12) 1925*ones(1,12) 1926*ones(1,12) 1927*ones(1,12) 1928*ones(1,12) 1929*ones(1,12) 1930*ones(1,12) 1931*ones(1,12) 1932*ones(1,12) 1933*ones(1,12) 1934*ones(1,12) 1935*ones(1,12) 1936*ones(1,12) 1937*ones(1,12)];
% m=[(1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12)];
% % s=[prediction Xt];
% bar(datenum(y,m,1),[X;Xt]);
% t=linspace(1920,1937,216);
% dt=t(2)-t(1);
% Y=fft(OliveOil_train);
% mag=abs(Y);
% f=(0:215)/(dt*18);
% plot(t,mag);
ts=datenum('1972-01');
tf=datenum('2001-03');
t=linspace(ts,tf,359);
plot(t(1:size(X)),X);
hold on;
plot(t(size(X)+1:size(ticks)),[prediction Xt(1:30)]);
datetick('x','yyyy','keepticks');
ylabel('average air temperatures at Nottinghan Castle');
title('the example 1 of forcasting of time series datasets');

mn=size(prediction,1);
w=zeros(mn,1);
W=zeros(mn,1);
for i=1:mn
    w(i)=(prediction(i)-Xt(i))^2;
    W(i)=(mean(Xt)-Xt(i))^2;
end
nmse = mean(w)/mean(W);