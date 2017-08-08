
clear all;
clc;

% [TXT,TX,RAW] = xlsread('C:\Documents and Settings\Administrator\×ÀÃæ\cjy\2016\5\data\gupiao\pufayinhang.xls');
% TXT=TXT(:,2);

TXT= importdata('C:\Documents and Settings\Administrator\×ÀÃæ\cjy\2016\5\data\gupiao\0523.txt');
TXT=(TXT.data(:,2))';
[TXT,T1]=mapminmax(TXT);
TXT=TXT(1:1660)';
% TXT=(TXT.data(:,2));


TYT= importdata('C:\Documents and Settings\Administrator\×ÀÃæ\cjy\2016\5\data\gupiao\0523a.txt');
TYT=(TYT.textdata(2:end,3))';
TYT=str2double(TYT);
[TYT,T2]=mapminmax(TYT);
TYT=TYT(1:1560)';

% [TYT,TY,RAW1] = xlsread('C:\Documents and Settings\Administrator\×ÀÃæ\cjy\2016\5\data\gupiao\shangzhengzhishu.xls');
% TYT=TYT(:,2);

mn=size(TYT,1);
number=100;
mae=zeros(number,1);
for delay=1:number
    w=0;
    for i=1:mn
        if isnan(abs(TXT(i+delay)-TYT(i)))
            w=w+0;
        else
            w=w+abs(TXT(i+delay)-TYT(i));
        end
    end
    mae(delay)=w/mn;
end


[a1,a2]=min(mae);
delay=a2;

for i=1:size(TXT,1)
    if isnan(TXT(i))
        TXT(i)=0;
    end
end

for j=1:size(TYT,1)
    if isnan(TYT(j))
        TYT(j)=0;
    end
end

prediction=zeros(60,1);
zis=1;
h0=1500;
h1=1560;
while(zis<61)
q=10; %Ê±ï¿½ï¿½
s=1;  %Ô¤ï¿½â´°ï¿½ï¿½
% k=6;
% q=1;
% s=2;
qq=q+1;
X=TXT(1+delay:h0+delay+zis-1);
Y=TYT(1:h0+zis-1);
% Q=TXT(5591:5600)';

mm=size(TYT(1:(h0+zis-1)),1);

z=mm-s-q+1;
% Xtra=zeros(z,q);
Xtra=zeros(z,2*qq);
h=0; %ï¿½ï¿½ï¿½ï¿½ï¿½Æ¶ï¿½Ê±ï¿½ï¿½Ó°ï¿½ï¿½ï¿½Ô­ï¿½ï¿½ï¿½Ð±ï¿½Ç?

for i=1:z
    for j=1:qq
    if h+j<=mm
    Xtra(i,2*j-1)=Y(h+j);
    Xtra(i,2*j)=X(h+j);
    end
    end
    h=h+1;
end   %Ð´µÃºÜ°ô£¡£¡

Q1=zeros(qq,1);
Q2=zeros(qq,1);
Q=zeros(2*qq,1);
for i=1:qq
Q1(qq-i+1)=X(end-i+1);
Q2(qq-i+1)=max(Y(end-i+1,:));
end
for i=1:qq
Q(2*i-1)=Q1(i);
Q(2*i)=Q2(i);
end
Q=Q';

Ytra=zeros(1,mm-q)';
for tt=1:mm-q
    Ytra(tt)=TYT(tt+q+s);
end

[gam,sig2] = tunelssvm({Xtra,Ytra,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'});
%predict next 100 points
prediction(zis) = predict({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'},Q,1);
% prediction = predictcjy({Xtra,Ytra,'f',gam,sig2,'lin_kernel'},{[X;Xt],Xs},{d,100});

zis=zis+1;
end
% ticks=cumsum(ones(216,1));

prediction1=mapminmax(prediction);

plot(prediction(1:end),'-+');
hold on;
 % plot(Xt((s+1):end),'r')

plot(TYT(h0+1:h1),'-r*');


ticks=cumsum(ones(h1,1));
Xt=TXT(h0:h1);
ts=datenum('2001-01');
tf=datenum('2016-04');
t=linspace(ts,tf,h1);
X=TXT(1:h0);
plot(t(1:size(X)),X);
hold on;
plot(t(size(X)+1:size(ticks)),[prediction Xt]);

datetick('x','yyyy','keepticks');
xlabel('time');
ylabel('international-airline-passengers');
