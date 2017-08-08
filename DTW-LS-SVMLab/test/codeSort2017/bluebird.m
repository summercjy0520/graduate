clear all;
clc;

TXT= importdata('C:\Documents and Settings\Administrator\桌面\cjy\2017\1\pic\15\bluebird.sales.txt');
TYT=importdata('C:\Documents and Settings\Administrator\桌面\cjy\2017\1\pic\15\bluebird.price.txt');

q=3; %时滞
qq=q+1;

aa=size(TXT(1:90),1);
% aaa=aa-qq;
bb=size(TXT(1:90),2);
X=zeros(aa,1);
Y=zeros(aa,1);
for i=1:aa
    X(i)=TXT(i);
    Y(i)=max(TYT(i,:));%取每一天的最大值
end

Q1=zeros(qq,1);
Q2=zeros(qq,1);
Q=zeros(2*qq,1);
for i=1:qq
Q1(qq-i+1)=X(end-i+1);
Q2(qq-i+1)=Y(end-i+1,:);
end
for i=1:qq
Q(2*i-1)=Q1(i);
Q(2*i)=Q2(i);
end
Q=Q';

%Xt=[752,702,677,718,738,707,742,745,733,679,744,739,757,760,752,738,692,780,780,790,798,778,726,700,782,791,788,777,789,762,740]';

prediction=zeros(14,1);
for s=1:14   %预测窗口
% Xtt=XXt((end-size(Xt,1)-q-s+1):end);
X=X(1:(aa-s+1));
Y=Y(1:(aa-s+1));
mmm=size(X,1);

z=aa-s-qq+1;
S=zeros(z,2*qq);
h=0; %用于移动时滞影响的原序列标签

for i=1:z
    for j=1:qq
    if h+j<=aa
    S(i,2*j-1)=X(h+j);
    S(i,2*j)=Y(h+j);
    end
    end
    h=h+1;
end   %写得很棒！！
H=TXT(s+qq:z+s+qq-1);

%tunel 过程
[gam,sig2] = tunelssvm({S,H,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

%predict
prediction(s) = predict({S,H,'f',gam,sig2,'RBF_kernel'},Q,1);
% C0=C0-1;
end
% end

%plot
ticks=cumsum(ones(104,1));
% plot(prediction);
% hold on;
% % plot(Xt((s+1):end),'r')
% plot(TXT(91:104),'r');
% xlabel('time');
ts=datenum('1972-01');
tf=datenum('2010-10');
t=linspace(ts,tf,104);
plot(t(1:size(TXT(1:end-14))),TXT(1:end-14));
hold on;
plot(t(size(TXT(1:end-14))+1:size(ticks)),[prediction TXT(91:104)],'-*');
datetick('x','yyyy','keepticks');
ylabel('Values of bluebird database');
title('the result of LSSVM');


