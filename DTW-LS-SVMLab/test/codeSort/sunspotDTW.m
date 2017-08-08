clear all;
clc;

TXT= importdata('data\sunspot.txt');
TXT=TXT(:,2);


C=67;%向前预测多少个样本点
prediction=zeros(C,1);
for jia=1:C
    
X=TXT(1:(221+jia-1));
% Q=TXT(5591:5600)';
Xt=TXT((221+jia):288);
XXt=[X;Xt];


% k=2*round((mm/2)^(1/2));
k=100;
q=11; %时滞
qq=q+1;
s=1;  %预测窗口
% k=6;
% q=1;
% s=2;
% qq=q+1;
mm=size(TXT(1:(221+jia-1)),1);
Xtt=XXt((end-size(Xt,1)-q-s+1):end);
MN=X(1:(mm+1-s));
X=X(1:(mm+1-2*s));
mmm=size(X,1);


z=mm-2*s-q+1;
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
% Q=Xt;

%第一次计算混合距离
dd1=zeros(z,1);
for i=1:z
    dd1(i)=dtwdistance(S(i,:),Q);
end

%找临近序列
SS=zeros(k,qq);%最近邻的k个序列
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
Z=zeros(qq,k);
for n=1:qq
    for nn=1:k
    mnn=K(nn)+n-qq;
    Z(n,nn)=X(mnn);%公式（7）
%     Z(2*n,nn)=Y(mnn);%公式（7）
%     nn=nn+1;
    end
%     n=n+1;
end   %很棒~~

H=zeros(1,k);
MI=zeros(qq,1);%存储Z序列与H之间的互信息大小，用于比较
%计算互信息MI的大小
for aa=1:k
    H(aa)=X(K(aa)+s);
end
for a=1:qq
    MI(a)=mi(Z(a,:)',H'); %调用函数求解MI值
end


M=[]; %初始化{}里面的元素
% s0=s;
d=9;
d0=9;
temp=zeros(d0,k);%用于存储选择出来的参与训练序列对应的序号,不可能大于q
% % MI求解过程中每增加一个Zi要怎么处理，知道求出s个z序列
while(d>0)
    for j=1:d0
    [maxx,maxi]=max(MI);
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
SSQ(i)=X(end-d0+i);
end



%模型推导！！！
%根据公式（10）求得变量sai的值，这里用cjy表示好了
%第二次计算混合距离
mediann=median(X); %求取输入训练样本的中位值
mn=size(X,1);
ymedian=zeros(mn,1);
for ff=1:mn
    ymedian(ff)=X(ff)-mediann;
%     ff=ff+1;
end
ymediann=max(abs(ymedian));%第二个计算因子的分母
cjy1=zeros(k,1);%存放变量第一个计算因子
cjy2=zeros(k,1);%存放变量第二个计算因子
cjy=zeros(k,1);%存放所求变量
for f=1:k
    cjy1(f)=dtwdistance(SSS(f,:),SSQ,(d0-1)/2);
    cjy2(f)=abs(X(f)-mediann)/ymediann;
    cjy(f)=exp((-1/2)*(cjy1(f)+cjy2(f)));
    k=k+1;
end


%对应到SVM模型里面，猜想可以调用我们工程里面的函数，得到alpha、b进行预测


%tunel 过程
[gam,sig2] = tunelssvm({SSS,SSY,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% gam=3600;
% sig2=700;
%train
[alpha,b] = trainlssvmknn({SSS,SSY,'f',gam,sig2,'RBF_kernel'},cjy); %lin_kernel

%predict
prediction(jia) = predict({SSS,SSY,'f',gam,sig2,'RBF_kernel'},SSQ,1);
end

%plot
plot(prediction(1:end));
hold on;
% plot(Xt((s+1):end),'r')
plot(TXT(222:288),'r');
xlabel('time');
ylabel('Values of sunspots database');
title('the example 1 of KNN');

Xt=TXT(289:end);
% mn=size(prediction,1);
% w=zeros(mn,1);
% W=zeros(mn,1);
% for i=1:mn
%     w(i)=(prediction(i)-Xt(i))^2;
%     W(i)=(mean(Xt)-Xt(i))^2;
% end
% nmse = mean(w)/mean(W);
mn=size(prediction,1);
w=0;
W=0;
for i=1:mn
    w=w+abs(prediction(i)-Xt(i));
    W=W+(prediction(i)-Xt(i))^2;
end
mae=w/mn;
rmse=sqrt(W/mn);