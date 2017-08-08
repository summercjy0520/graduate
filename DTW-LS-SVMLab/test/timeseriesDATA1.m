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
X=TXT.data(92:447);
Xt=TXT.data(448:547);
lag = 52;
Xu = windowize(X,1:lag+1);
Xtra = Xu(1:end-lag,1:lag); %training set
Ytra = Xu(1:end-lag,end); %training set
Xs=X(end-lag+1:end,1); %starting point for iterative prediction迭代预测的起点
% Xt = rand(10,1).*sign(randn(10,1));

[gam,sig2] = tunelssvm({Xtra,Ytra,'f',[],[],'lin_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({Xtra,Ytra,'f',gam,sig2,'lin_kernel'});
%predict next 100 points
prediction = predict({Xtra,Ytra,'f',gam,sig2,'lin_kernel'},Xs,30);
ticks=cumsum(ones(386,1));
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
tf=datenum('2007-12');
t=linspace(ts,tf,386);
plot(t(1:size(X)),X);
hold on;
plot(t(size(X)+1:size(ticks)),[prediction Xt(1:30)]);

X1=TXT.data(92:447);
Xt1=TXT.data(448:547);
lag1 = 52;
Xu1 = windowize(X1,1:lag1+1);
Xtra1 = Xu1(1:end-lag1,1:lag1); %training set
Ytra1 = Xu1(1:end-lag1,end); %training set
Xs1=X1(end-lag1+1:end,1); %starting point for iterative prediction迭代预测的起点
% Xt = rand(10,1).*sign(randn(10,1));

[gam1,sig21] = tunelssvm({Xtra1,Ytra1,'f',[],[],'lin_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha1,b1] = trainlssvm({Xtra1,Ytra1,'f',gam1,sig21,'lin_kernel'});
%predict next 100 points
prediction1 = predict({Xtra1,Ytra1,'f',gam1,sig21,'lin_kernel'},Xs1,100);
ticks1=cumsum(ones(456,1));
plot([prediction1 Xt1]);
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
tf=datenum('2007-12');
t=linspace(ts,tf,456);
plot(t(1:size(X1)),X1);
hold on;
plot(t(size(X1)+1:size(ticks1)),[prediction1 Xt1]);

datetick('x','yyyy','keepticks');
ylabel('average air temperatures at Nottinghan Castle');
title('the example 1 of forcasting of time series datasets');