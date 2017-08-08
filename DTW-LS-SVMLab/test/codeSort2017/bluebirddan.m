clear all;
clc;

TXT= importdata('C:\Documents and Settings\Administrator\桌面\cjy\2017\1\pic\15\bluebird.sales.txt');


C=14;%向前预测多少个样本点
prediction=zeros(C,1);
for jia=1:C
    
X=TXT(1:(90+jia-1));
% Q=TXT(5591:5600)';
Xt=TXT((90+jia):end);
XXt=[X;Xt];


% k=2*round((mm/2)^(1/2));

q=3; %时滞
qq=q+1;
s=1;  %预测窗口
% k=6;
% q=1;
% s=2;
% qq=q+1;
mm=size(TXT(1:(90+jia-1)),1);
Xtt=XXt((end-size(Xt,1)-q-s+1):end);
MN=X(1:(mm+1-s));
X=X(1:(mm+1-2*s));
mmm=size(X,1);


z=mm-2*s-qq+1;
S=zeros(z,qq);
h=0; %用于移动时滞影响的原序列标签

for i=1:z
    for j=1:qq
    if h+j<=mm
    S(i,j)=X(h+j);
%     S(i,2*j)=X(h+2*j);
    end
    end
    h=h+1;
end   %写得很棒！！

Q=Xtt(1:qq)';
H=X(qq+1:end);

%tunel 过程
[gam,sig2] = tunelssvm({S,H,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

prediction(jia) = predict({S,H,'f',gam,sig2,'RBF_kernel'},Q,1);
% prediction(jia) = predictknn({SSS,SSY,'f',gam,sig2,'RBF_kernel'},SSQ,cjy,1);

% C0=C0-1;
end
% end

Xt=[11.76327,11.21616, 11.31977, 11.26278,11.70895,11.62008,11.47251,11.29767,11.09718,11.84976,11.34809,11.49860,11.37318,11.59894]';
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
plot(t(size(TXT(1:end-14))+1:size(ticks)),[prediction TXT(91:104) Xt],'-*');
datetick('x','yyyy','keepticks');
ylabel('Values of bluebird database');
title('the result of LSSVM');