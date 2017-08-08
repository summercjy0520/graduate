clear all;
clc;

TXT=importdata('C:\Documents and Settings\Administrator\桌面\cjy\MIToolbox2.11\LS-SVMLab v1.7(R2006a-R2009a)\data\ARIMA.txt');


% [TXT,TX,RAW] = xlsread('data\KNN\EGtemperature.xlsx');
% [TXT,T1]=mapminmax(TXT);
% TXT=TXT(1:end);

C=16;%向前预测多少个样本点
prediction=zeros(C,1);

h1=size(TXT,1);
h0=h1-C;

t=5;
for jia=1:C
% jia=21; 
X=TXT(1:(h0+jia-1));
% Q=TXT(5591:5600)';
Xt=TXT((h0+jia):h1);
XXt=[X;Xt];


q=11; %时滞
qq=q+1;
s=1;  %预测窗口
% k=6;
% q=1;
% s=2;
% qq=q+1;
mm=size(TXT(1:(h0+jia-1)),1);
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
% Ytra=X(s+qq:end);
% % Q=Xt;
% [Ytra,T1]=mapminmax(Ytra');


dd1=NHDTWnew0(S,Q);%NHEH0306

% Ym=median(Ytra);
% [k]=FuzzyEntropyY(dd1,Ytra',Ym,t);
[k]=FuzzyEntropyD(dd1);

% k=150;
SS=zeros(k,qq);%最近邻的k个序列
K=zeros(k,1);
[maxn maxi]=max(dd1);%用于替换，最大值

jjj=1;
while (jjj<=k)
%     jjj=1;%初值
    [minn mini]=min(dd1);%找第一个最小值
    if mini>=qq&&mini<=(mmm-q-s)
    K(jjj)=mini;%记录对应的行
    dd1(mini)=maxn;
    jjj=jjj+1;
    else
    dd1(mini)=maxn;
    end   
%     jjj=jjj+1;
end
H=zeros(1,k);
for iii=1:k
    SS(iii,:)=S(K(iii),:);
    H(iii)=X(K(iii)+q+s);
end


Z=SS';
MI=zeros(qq,1);%存储Z序列与H之间的互信息大小，用于比较

for a=1:qq
%     MI(a)=mi(Z(a,:)',H'); %调用函数求解MI值
    MI(a)=mi(Z(a,:)',H'); %调用函数求解MI值
end


M=[]; %初始化{}里面的元素
% s0=s;
d=12;
d0=12;
temp=zeros(d0,k);%用于存储选择出来的参与训练序列对应的序号,不可能大于q
% % MI求解过程中每增加一个Zi要怎么处理，知道求出s个z序列
tem=zeros(d0,1);%用于存储每次选择出来的序列对应的时刻点
Z0=Z;
while(d>0)
    for j=1:d0
    [maxx,maxi]=max(MI);
    tem(j)=maxi;
%     temp(j,:)=Z(maxi,:);
    M=[M Z(maxi,:)']; %每次将选择好的Z序列加进来，也要用于最后训练样本的求取
    Z(maxi,:)=zeros(1,k);%除去选中的这一行....置零值
    zz=size(Z,1);
%     MI=zeros(zz,1);
    for ii=1:zz
        if MI(ii)==0
            MI(ii)=0;
        else
            MI(ii)=1;
        end
    end
    for i=1:zz
        if i==tem(j)
            MI(i)=0;
        else
            M=[M Z0(i,:)'];
%             cheng=mi(M,H');
            cheng=mi(M,H');
            if MI(i)==1
            MI(i)=cheng;
            end
             M(:,2)=[];
        end 
%     i=i+1;
    end
    d=d-1;
    end
end
tem=paixu(tem);
for i=1:d0
    temp(i,:)=Z0(tem(i),:);
end

% d=s-s0; %贪婪算法得到的最终的时滞
SSS=zeros(k,d0);%k为对应的原来Z序列里面每条序列的长度
SSY=zeros(k,1);
% temp=[1,2]';
%得到s条z序列，也就可以得到对应的预测输入
for b=1:k
    for bb=1:d0
    SSS(b,bb)=temp(bb,b);
    SSY(b)=H(b); %每条序列对应的预测值
%     bb=bb+1; 
    end
%     b=b+1;%循环一次得到一条目标序列
end



% C0=C-d0;
SSQQ=zeros(1,qq);
SSQ=zeros(1,d0);
% Xtt=[X((end-s+2):end);Xt];
% while(C0>0)
for i=1:qq
SSQQ(i)=Xtt(i);
end

for i=1:d0
    SSQ(i)=SSQQ(tem(i));%取对应时刻的值
end

%模型推导！！！
%根据公式（10）求得变量sai的值，这里用cjy表示好了
%第二次计算混合距离
mediann=median(SSY); %求取决策维的中位值
mn=size(SSY,1);
ymedian=zeros(mn,1);
for ff=1:mn
    ymedian(ff)=SSY(ff)-mediann;
%     ff=ff+1;
end
ymediann=max(abs(ymedian));%第二个计算因子的分母
% cjy1=zeros(k,1);%存放变量第一个计算因子
cjy2=zeros(k,1);%存放变量第二个计算因子
cjy=zeros(k,1);%存放所求变量
cjy1=NHDTWnew0(SSS,SSQ);
for f=1:k
%     cjy1(f)=NH(SSS(f,:),SSQ,(d0-1)/2);    
%     cjy1(f)=0;
    cjy2(f)=abs(SSY(f)-mediann)/ymediann;
%     cjy(f)=exp((-1/2)*(1*cjy1(f)+1*cjy2(f)));
    if (cjy1(f)==0||cjy2(f)==0)
        cjy(f)=(1/2)*(exp((-1/2)*cjy1(f))+exp((-1/2)*cjy2(f)));
    else
        namda=log(cjy1(f)/cjy2(f))/(cjy1(f)/cjy2(f)+1);
        cjy(f)=(1/2)*(exp((-namda)*cjy1(f))+exp((-(1-namda))*cjy2(f)));
    end
%       cjy(f)=exp((-1/2)*cjy1(f))+exp((-1/2)*cjy2(f));
%     cjy(f)=(-1/2)*exp(cjy1(f))+(-1/2)*exp(cjy2(f));
end

resultT=zeros(t,1);
for i=1:t
    resultT(i)=EDLSSVM(SSS,SSY,SSQ,cjy);
end
prediction(jia)=mae(resultT);

% C0=C0-1;
end
% end

%plot

plot(prediction(1:end),'-+');
hold on;
% plot(Xt((s+1):end),'r')
plot(TXT(h0+1:h1),'-r*');
xlabel('time');
ylabel('Values of Laser database');
title('DTW:mae=2.2339,rmse=6.8317');

Xt=TXT(h0+1:h1);
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
