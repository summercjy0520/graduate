clear all;
clc;

TXT= importdata('data\KNN\Laser.txt');
TXT1= importdata('data\KNN\Lasercon.txt');
TXT=[TXT;TXT1];

C=95;%向前预测多少个样本点
prediction=zeros(C,1);
for jia=1:C
    
X=TXT(1:(5605+jia-1));
Xt=TXT((5605+jia):5700);
XXt=[X;Xt];


k=200;
q=9; %时滞
qq=q+1;
s=1;  %预测窗口

mm=size(TXT(1:(5605+jia-1)),1);
Xtt=XXt((end-size(Xt,1)-q-s+1):end);
MN=X(1:(mm+1-s));
X=X(1:(mm+1-s));
mmm=size(X,1);

z=mm-s-qq+1;
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


dd=NHDTWnew0(S,Q);

%找临近序列
K=zeros(k,1);
[maxn maxi]=max(dd);%用于替换，最大值

jjj=1;
while (jjj<=k)
%     jjj=1;%初值
    [minn mini]=min(dd);%找第一个最小值
    if mini>=qq&&mini<=(mmm-q-s)
    K(jjj)=mini;%记录对应的行
    dd(mini)=maxn;
    jjj=jjj+1;
    else
    dd(mini)=maxn;
    end   
%     jjj=jjj+1;
end

SS=zeros(k,qq);%最近邻的k个序列
for iii=1:k
    SS(iii,:)=S(K(iii),:);
end

class=1:size(SS,1);
p=class(randi(end,1,1));
temp=zeros(2*q,qq);
pivor=1;
SA=SS;
while(isempty(SS)==0)
    index=K(p);
    if index<qq
        temp(1:index-1,:)=S(1:index-1,:);
        temp(qq:2*q,:)=S(index+1:index+q,:);
    elseif index>z-q
        temp(1:q,:)=S((index-q):(index-1),:);
        temp(qq:(qq+(z-index-1)),:)=S(index+1:end,:);
    else
        temp(1:q,:)=S((index-q):(index-1),:);
        temp(qq:2*q,:)=S(index+1:index+q,:);
    end
    TM=intersect(SS,temp,'rows');
    if size(TM,1)>0
        TM=[TM;SA(p,:)];
        for j=1:size(TM,1)
            for i=1:size(SS,1)
                if all(SS(i,:)==TM(j,:))==1
                    SS(i,:)=zeros(1,qq);
                end
            end
        end
        SS(ismember(SS,zeros(1,qq),'rows')==1,:)=[];
        dtemp=NHDTWnewa(TM,Q);
%         dtemp=pdist2(TM,Q);
        [mtemp mitemp]=min(dtemp);
        p=find(ismember(SA,TM(mitemp,:),'rows'));
        if ismember(pivor,p,'rows')==0
            pivor=[pivor;p];
        end
%         pivor=[pivor;TM(mitemp,:)];
    else
%         if ismember(pivor,p,'rows')==0
%              pivor=[pivor;p];
% %             pivor=[pivor;SA(p,:)];
%         end
        for i=1:size(SS,1)
            if all(SS(i,:)==SA(p,:))==1
                SS(i,:)=zeros(1,qq);
            end
        end
        SS(ismember(SS,zeros(1,qq),'rows')==1,:)=[];
        class=1:size(SA,1); %SS
        p=class(randi(end,1,1));
    end
end

SSA=zeros(size(pivor,1),qq);%最近邻的k个序列
for iii=1:size(pivor,1)
    SSA(iii,:)=SA(pivor(iii),:);
end

k=size(pivor,1);
H=zeros(1,k);
for aa=1:k
    H(aa)=X(K(pivor(aa))+q+s);
end

SSY=H';
mediann=median(SSY); %求取决策维的中位值
mn=size(SSY,1);
ymedian=zeros(mn,1);
for ff=1:mn
    ymedian(ff)=SSY(ff)-mediann;
%     ff=ff+1;
end
ymediann=max(abs(ymedian));%第二个计算因子的分母
cjy2=zeros(k,1);%存放变量第二个计算因子
cjy=zeros(k,1);%存放所求变量
cjy1=NHDTWnewb0108(SSA,Q); %NHDTWnewb0108
for f=1:k
%     cjy1(f)=NH(SSS(f,:),SSQ,(d0-1)/2);    
%     cjy1(f)=0;
    cjy2(f)=abs(SSY(f)-mediann)/ymediann;
%     cjy(f)=exp((-1/2)*(1*cjy1(f)+1*cjy2(f)));
    if (cjy1(f)==0||cjy2(f)==0)
        cjy(f)=exp((-1/2)*cjy1(f))+exp((-1/2)*cjy2(f));
    else
        namda=log(cjy1(f)/cjy2(f))/(cjy1(f)/cjy2(f)+1);
        cjy(f)=exp((-namda)*cjy1(f))+exp((-(1-namda))*cjy2(f));
    end
%       cjy(f)=exp((-1/2)*cjy1(f))+exp((-1/2)*cjy2(f));
%     cjy(f)=(-1/2)*exp(cjy1(f))+(-1/2)*exp(cjy2(f));
end

%tunel 过程
[gam,sig2] = tunelssvm({SSA,SSY,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});
% gam=2.4*10^7; poly_kernel lin_kernel RBF_kernel wav_kernel
% sig2=700;

%train
[alpha,b] = trainlssvmknn({SSA,SSY,'f',gam,sig2,'RBF_kernel'},cjy); %lin_kernel
% [alpha,b] = trainlssvm({SSS,SSY,'f',gam,sig2,'RBF_kernel'}); %lin_kernel

% prediction(jia) = predict({SSA,SSY,'f',gam,sig2,'RBF_kernel'},Q,1);
prediction(jia) = predictknn({SSA,SSY,'f',gam,sig2,'RBF_kernel'},Q,cjy,1);
end

plot(prediction(1:end),'-+');
hold on;
plot(TXT(5606:5700),'-r*');
xlabel('time');
ylabel('Values of Laser database');
title('DTW:mae=2.2339,rmse=6.8317');

Xt=TXT(5606:5700);
mn=size(prediction,1);
w=0;
W=0;
PW=0;
for i=1:mn
    w=w+abs(prediction(i)-Xt(i));
    PW=PW+abs(prediction(i)-Xt(i))/Xt(i);
    W=W+(prediction(i)-Xt(i))^2;
end
mae=w/mn;
rmse=sqrt(W/mn);
mape=100*PW/mn;
