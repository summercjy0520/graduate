
clear all;
clc;

% [TXT,TX,RAW] = xlsread('C:\Documents and Settings\Administrator\����\cjy\2016\5\data\gupiao\pufayinhang.xls');
% TXT=TXT(:,2);

TXT= importdata('C:\Documents and Settings\Administrator\����\cjy\2016\6\data\main\zxzq.txt');
TXT=(TXT.textdata(2002:2933,5))';% end:2015-03~06:2864-2933  %+2000
TXT=str2double(TXT);
[TXT,T1]=mapminmax(TXT);
TXT=TXT(1:end)';
% TXT=(TXT.data(:,2));


TYT= importdata('C:\Documents and Settings\Administrator\����\cjy\2016\6\data\main\szzs.txt');
TYT=(TYT.textdata(5055:5986,4))'; % end:2015-03~06:5917-5986
TYT=str2double(TYT);
[TYT,T2]=mapminmax(TYT);
TYT=TYT(1:end)';

% [TYT,TY,RAW1] = xlsread('C:\Documents and Settings\Administrator\����\cjy\2016\5\data\gupiao\shangzhengzhishu.xls');
% TYT=TYT(:,2);

step=1;
number0=932;
m=number0/step;
n=number0/step;
A=zeros(m,1);
B=zeros(n,1);

for i=1:m
    H=0;
    for a=1:step
        H=H+TXT(step*(i-1)+a);
    end
%       A(i)=TXT(step*(i-1)+1);
    A(i)=H/step;
end

for j=1:n
    K=0;
    for b=1:step
        K=K+TYT(step*(j-1)+b);
    end
      B(j)=TYT(step*(j-1)+1);
    B(j)=K/step;
end

% mn=size(A,1);
% number=70;
% mae=zeros(number,1);
% for delay=1:number
%     w=0;
%     for i=1:mn
%         if isnan(abs(B(i+delay)-A(i)))
%             w=w+0;
%         else
%             w=w+abs(B(i+delay)-A(i));
%         end
%     end
%     mae(delay)=w/mn;
% end
% 

% [a1,a2]=min(mae);
delay=0;

for i=1:size(A,1)
    if isnan(A(i))
        A(i)=0;
    end
end

for j=1:size(B,1)
    if isnan(B(j))
        B(j)=0;
    end
end

prediction=zeros(70,1);
zis=1;
h0=862;
h1=932;
while(zis<71)
q=15; %ʱ��
s=1;  %Ԥ�ⴰ��
% k=6;
% q=1;
% s=2;
qq=q+1;
X=B(1+delay:h0+delay+zis-1);
Y=A(1:h0+zis-1);
% Q=TXT(5591:5600)';

mm=size(A(1:(h0+zis-1)),1);

z=mm-s-q+1;
% Xtra=zeros(z,q);
Xtra=zeros(z,2*qq);
h=0; %�����ƶ�ʱ��Ӱ���ԭ���б��?

for i=1:z
    for j=1:qq
    if h+j<=mm
    Xtra(i,2*j-1)=Y(h+j);
    Xtra(i,2*j)=X(h+j);
    end
    end
    h=h+1;
end   %д�úܰ�����

Q1=zeros(qq,1);
Q2=zeros(qq,1);
Q=zeros(2*qq,1);
for i=1:qq
Q2(qq-i+1)=B(h0+delay+zis-i+1);
Q1(qq-i+1)=A(h0+zis-i+1);
end
for i=1:qq
Q(2*i-1)=Q1(i);
Q(2*i)=Q2(i);
end
Q=Q';

Ytra=zeros(1,mm-q-s+1)';
for tt=1:mm-q-s+1
    Ytra(tt)=A(tt+q+s);
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

plot(A(h0+1:h1),'-r*');

hold on;
 % plot(Xt((s+1):end),'r')

plot(B(h0+1:h1),'-g*');

% ticks=cumsum(ones(h1,1));
% Xt=TXT(h0:h1);
% ts=datenum('2001-01');
% tf=datenum('2016-04');
% t=linspace(ts,tf,h1);
% X=TXT(1:h0);
% plot(t(1:size(X)),X);
% hold on;
% plot(t(size(X)+1:size(ticks)),[prediction Xt]);

datetick('x','yyyy','keepticks');
xlabel('time');
ylabel('zhongxinzhengquan');

Xt=A(h0+1:h1);
mk=size(prediction,1);
w=0;
W=0;
for i=1:mk
    w=w+abs(prediction(i)-Xt(i));
    W=W+(prediction(i)-Xt(i))^2;
end
mae=w/mk;
