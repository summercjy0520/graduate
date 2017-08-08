% TXT= importdata('data\Metal goods\13013-13599.txt');
% 
% X=TXT.data(92:517);
% Xt=TXT.data(518:547);
clear all；
clc;

%注意！！！！这里并不是变量和附加变量的关系，而是输入与输出的关系
% Y=[1.073,1.062,0.963,0.874,1.048,1.078,1.084,1.106,1.104,1.002,0.897,1.099,1.137,1.136,1.130,1.097,0.990,0.870,1.066,1.114]';
% X=[1.118,1.116,1.005,0.903,1.099,1.131,0.969,1.093,1.125,1.091,0.943,1.138,1.149,1.155,1.158,1.161,1.065,0.944,1.140,1.174]';
% %QQ=[1.140,1.066,1.174,1.114];
% Q=[1.140,1.066,1.174,1.114];
% X=2.*rand(200,2)-1;

% Y=[1.073,1.062,0.963,0.874,1.048,1.078,1.084,1.106,1.104,1.002,0.897,1.099,1.137,1.136,1.130,1.097,0.990,0.870]';
% X=[1.118,1.116,1.005,0.903,1.099,1.131,0.969,1.093,1.125,1.091,0.943,1.138,1.149,1.155,1.158,1.161,1.065,0.944]';
% % %QQ=[1.140,1.066,1.174,1.114];
% Q=[1.140,1.066,1.174,1.114];
% X=[X;X];
% Y=[Y;Y];
% Q=[Q,Q];

% X=[40.6000,40.8000,44.4000,46.7000,54.1000,58.5000,57.7000,56.4000,54.3000,50.5000,42.9000,39.8000,44.2000,39.8000,45.1000,47.0000,54.1000,58.7000,66.3000,59.9000]';
% Y=[40.8000,44.4000,46.7000,54.1000,58.5000,57.7000,56.4000,54.3000,50.5000,42.9000,39.8000,44.2000,39.8000,45.1000,47.0000,54.1000,58.7000,66.3000,59.9000,57.0000]';
% Q=[57.0000,54.2000,54.2000,39.7000];

% % X=importdata('data\KNN\X.txt');
% % Y=importdata('data\KNN\Y.txt');
% % % XX=importdata('data\KNN\XX.txt');
% % % YY=importdata('data\KNN\YY.txt');
% % % ee=size(XX,1);
% % % Q=zeros(1,2*ee);
% % % for i=1:ee
% % %     Q(2*i-1)=XX(i);
% % %     Q(2*i)=YY(i);
% % % end
% % Q=importdata('data\KNN\Q.txt');


OliveOil_train=importdata('data\ARIMA.txt');
X=OliveOil_train(1:192);
Xt=OliveOil_train(193:216);
lag = 32;
Xu = windowize(X,1:lag+1);
X = Xu(1:end-lag,lag); %training set
Y = Xu(1:end-lag,end); %training set
Q=X(end-lag+1:end,1)';


cc=size(X,1);
XY=zeros(1,2*size(X));
for i=1:cc
    XY(2*i-1)=X(i);
    XY(2*i)=Y(i);
end

% X=[4,4,7,7,8,9,10,10,10,11,11,12,12,12,12,13,13,13,13,14,14,14,14,15,15,15,16,16,17,17,17,18,18,18,18,19,19,19,20,20,20,20,20,22,23]';
% Y=[2,10,4,22,16,10,18,26,34,17,28,14,20,24,28,26,34,34,46,26,36,60,80,20,26,54,32,40,32,40,50,42,56,76,84,36,46,68,32,48,52,56,64,66,54]';
% Q=[24,70,24,92,24,93,24,120,25,85];

mm=size(X,1)+(1/2)*size(Q,2)-1;
mmm=size(X,1);
% k=2*round((mm/2)^(1/2));
k=80;
q=15; %时滞
qq=q+1;
s=16;  %预测窗口
% k=6;
% q=1;
% s=2;
% qq=q+1;
z=mm-s+1-q;
S=zeros(z,2*qq);
h=0; %用于移动时滞影响的原序列标签

for i=1:z
    for j=1:qq
    if h+j<=mm
    S(i,2*j-1)=X(h+j);
    S(i,2*j)=Y(h+j);
    end
    end
    h=h+1;
end   %写得很棒！！

% Q=Xt;

%第一次计算混合距离
dd1=NH(S,Q,qq);

%找临近序列
SS=zeros(k,2*qq);%最近邻的k个序列
K=zeros(k,1);
[maxn maxi]=max(dd1);%用于替换，最大值

jjj=1;
while (jjj<=k)
%     jjj=1;%初值
    [minn mini]=min(dd1);%找第一个最小值
    if mini>=qq&&mini<=(mmm-s)
    K(jjj)=mini;%记录对应的行
    dd1(mini)=maxn;
    jjj=jjj+1;
    else
    dd1(mini)=maxn;
    end   
%     jjj=jjj+1;
end
for iii=1:k
    SS(iii,:)=S(K(iii),:);
end

%整理2q+3个Z序列&&单变量
Z=zeros(2*qq,k);
% t=zeros(k,1);%整理选择的临近序列下标
% t=K;
% for m=1:k
%     t(m)=K(m)-q;
% end
for n=1:qq
    for nn=1:k
    mnn=K(nn)+n-qq;
    Z(2*n-1,nn)=X(mnn);%公式（7）
    Z(2*n,nn)=Y(mnn);%公式（7）
%     nn=nn+1;
    end
%     n=n+1;
end   %很棒~~

H=zeros(1,k);
MI=zeros(2*qq,1);%存储Z序列与H之间的互信息大小，用于比较
%计算互信息MI的大小
for aa=1:k
    H(aa)=X(K(aa)+s);
end
for a=1:2*qq
    MI(a)=mi(Z(a,:)',H'); %调用函数求解MI值
end


M=[]; %初始化{}里面的元素
% s0=s;
d=12;
d0=12;
temp=zeros(d0,k);%用于存储选择出来的参与训练序列对应的序号,不可能大于q
% % MI求解过程中每增加一个Zi要怎么处理，知道求出s个z序列
while(d>0)
    [maxx,maxi]=max(MI);
    for j=1:d0
    temp(j,:)=Z(maxi,:);
    M=[M Z(maxi,:)']; %每次将选择好的Z序列加进来，也要用于最后训练样本的求取
    Z(maxi,:)=[];%除去选中的这一行
    zz=size(Z,1);
    MI=zeros(zz,1);
    for i=1:zz
    M=[M Z(i,:)'];
    MI(i)=mi(M,H');
%     if MI(i)<0
%         break;  %终止条件
%     end
    M(:,2)=[];
%     i=i+1;
    end
    d=d-1;
    end
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

% for i=1:d
% SSQ(2*i-1)=X(end);
% end
SSQ=zeros(1,d0);
for i=1:d0
SSQ(i)=XY(end-d0+i);
end



%模型推导！！！
%根据公式（10）求得变量sai的值，这里用cjy表示好了
%第二次计算混合距离
mediann=median(Y); %求取输入训练样本的中位值
mn=size(Y,1);
ymedian=zeros(mn,1);
for ff=1:mn
    ymedian(ff)=Y(ff)-mediann;
%     ff=ff+1;
end
ymediann=max(abs(ymedian));%第二个计算因子的分母
cjy1=zeros(k,1);%存放变量第一个计算因子
cjy2=zeros(k,1);%存放变量第二个计算因子
cjy=zeros(k,1);%存放所求变量
for f=1:k
    cjy1(f)=NH(SSS(f,:),SSQ,d0/2);
    cjy2(f)=abs(X(f)-mediann)/ymediann;
    cjy(f)=exp((-1/2)*(cjy1(f)+cjy2(f)));
    k=k+1;
end


%对应到SVM模型里面，猜想可以调用我们工程里面的函数，得到alpha、b进行预测

% SST=Xt;%预测序列
% SSS=[SSS;SSS];
% SSY=[SSY;SSY];
%tunel 过程
[gam,sig2] = tunelssvm({SSS,SSY,'f',[],[],'lin_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

%train
[alpha,b] = trainlssvmknn({SSS,SSY,'f',gam,sig2,'lin_kernel'},cjy); %lin_kernel

%predict
prediction = predict({SSS,SSY,'f',gam,sig2,'lin_kernel'},SSQ,s);

%plot
ticks=cumsum(ones(144,1));
plot(prediction);
xlabel('time');
% ts=datenum('1972-01');
% tf=datenum('7');
t=linspace(ts,tf,144);
plot(t(1:size(X)),X);
hold on;
plot(t(size(X)+1:size(ticks)),[prediction Xt(1:16)]);
datetick('x','yyyy','keepticks');
ylabel('average air temperatures at Nottinghan Castle');
title('the example 1 of forcasting of time series datasets');
