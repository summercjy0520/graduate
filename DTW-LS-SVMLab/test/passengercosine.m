clear all;  %选出一定量，删除一定部分
clc;


[TXT,TX,RAW] = xlsread('data\KNN\passenger.xlsx');

C=16;%向前预测多少个样本点
prediction=zeros(C,1);
for jia=1:C
    
X=TXT(1:200+jia-1);
% Q=TXT(5591:5600)';
Xt=TXT((201+jia-1):216);
XXt=[X;Xt];


% k=2*round((mm/2)^(1/2));
k0=3; %KNN过程小密度聚类的k值

th=2; %cosine sum的阈值
% kernel_type=RBF_kernel;
q=12; %时滞
qq=q+1;
s=1;  %预测窗口
k=150;
KC=[];
% k=6;
% q=1;
% s=2;
% qq=q+1;
mm=size(TXT(1:(200+jia-1)),1);
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
csum=11;
a=1;
K0=zeros(k0,1);
Q0=Q;

dd1=NHDTW1(S,Q,qq/2);
% dd1=NH(S,Q,qq/2);
% % 换成DTW算法
% dd1=zeros(z,1);
%  for a=1:z
%     test=S(a,:); 
%     dd1(a) = DTW(test, Q);  
% %  for i=1:qq     
% %     [d,j] = min(dist(i,:));     
% %  end
%  end
%找临近序列
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
for iii=1:k
    SS(iii,:)=S(K(iii),:);
end

A=K(1);
SS0=SS;
KS=K;
while(any(K==A))
% 第一次计算混合距离
jjk=1;
% MIN=[];

dd2=NHDTW1(S,Q0,qq/2);
% dd1=NH(S,Q,qq/2);
% % 换成DTW算法
% dd1=zeros(z,1);
%  for a=1:z
%     test=S(a,:); 
%     dd1(a) = DTW(test, Q);  
% %  for i=1:qq     
% %     [d,j] = min(dist(i,:));     
% %  end
%  end
%找临近序列
KK=zeros(k0,1);
[maxn maxi]=max(dd2);%用于替换，最大值

while (jjk<=k0)
%     jjj=1;%初值
    [minn mini]=min(dd2);%找第一个最小值
    if mini>=qq&&mini<=(mmm-q-s)
    KK(jjk)=mini;%记录对应的行
%     MIN=[MIN,minn]; %记录对应的距离值
    dd2(mini)=maxn;
    jjk=jjk+1;
    else
    dd2(mini)=maxn;
    end   
%     jjj=jjj+1;
end
KCC=[];
SSK=zeros(k0,qq);
for iii=1:k0
    SSK(iii,:)=S(KK(iii),:);
end
csum=cosinecjy(SSK,Q0,'lin_kernel',k0);
% KCC=[SSK;Q];%小聚类的序列集
% entropy=kentropy(KCC,'lin_kernel',0); %计算熵，线性核
% [maxkc,maxk]=min(MIN);
pos=[];
if(csum<th)
    for a=1:k0
        if(any(K==KK(a)))
            temp1=find(K==KK(a));
            temp2=S(K(temp1),:);
            for c=1:k
                if(isequal(SS(c,:),temp2))
                    pos=[pos,c];
                end
            end
            SS0(pos,:)=[];
            KS(pos,:)=[];
        end
    end
end   %删去不满足要求的序列

A=KK(end);

K1=K0;
if a==k0||a==1
    K0=KK;
    a=1;
else
    K0=K1; 
end
%挑离中心点最近的点替换中心
if K0(a)<size(S,1)
Q=S(K0(a),:); %替换中心序列
S(K0(a),:)=[];
a=a+1;
else
    a=a+1;
end
%kc=size(KC,2);
%if kc>kmax
    %break;
%end
end


%KC=intersect(KC,KC); %去掉重复元素

% K=zeros(kc,1);

% for b=1:kc
% for c=1:(z-4)
%     if(isequal(S(c,:),SS(b,:)))
%                     K(b)=c;
%     end
% end
% end
kc=size(KS,1);
Z=zeros(qq,kc);

for n=1:qq
    for nn=1:kc
    mnn=KS(nn)+n-1;
    Z(n,nn)=X(mnn);%公式（7）
%     Z(2*n,nn)=Y(mnn);%公式（7）
%     nn=nn+1;
    end
%     n=n+1;
end   %很棒~~

H=zeros(1,kc);
MI=zeros(qq,1);%存储Z序列与H之间的互信息大小，用于比较
%计算互信息MI的大小
for aa=1:kc
%     H(aa)=X(K(aa)+s);
    H(aa)=X(KS(aa)+q+s);
end
for a=1:qq
%     MI(a)=mi(Z(a,:)',H'); %调用函数求解MI值
    MI(a)=mi(Z(a,:)',H'); %调用函数求解MI值
end


M=[]; %初始化{}里面的元素
% s0=s;
d=10;
d0=10;
temp=zeros(d0,kc);%用于存储选择出来的参与训练序列对应的序号,不可能大于q
% % MI求解过程中每增加一个Zi要怎么处理，知道求出s个z序列
tem=zeros(d0,1);%用于存储每次选择出来的序列对应的时刻点
Z0=Z;
while(d>0)
    for j=1:d0
    [maxx,maxi]=max(MI);
    tem(j)=maxi;
%     temp(j,:)=Z(maxi,:);
    M=[M Z(maxi,:)']; %每次将选择好的Z序列加进来，也要用于最后训练样本的求取
    Z(maxi,:)=zeros(1,kc);%除去选中的这一行....置零值
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
%     if MI(i)<0
%         break;  %终止条件
        
%     end
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
SSS=zeros(kc,d0);%k为对应的原来Z序列里面每条序列的长度
SSY=zeros(kc,1);
% temp=[1,2]';
%得到s条z序列，也就可以得到对应的预测输入
for b=1:kc
    for bb=1:d0
    SSS(b,bb)=temp(bb,b);
    SSY(b)=H(b); %每条序列对应的预测值
%     bb=bb+1; 
    end
%     b=b+1;%循环一次得到一条目标序列
end

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

%取最近的d个点
% SSQ(d0)=MN(end);
% for i=1:(d0-1)
%     SSQ(d0-i)=MN(end-i);%取对应时刻的值
% end

% 模型推导！！！
% 根据公式（10）求得变量sai的值，这里用cjy表示好了
% 第二次计算混合距离
mediann=median(X); %求取输入训练样本的中位值
mn=size(X,1);
ymedian=zeros(mn,1);
for ff=1:mn
    ymedian(ff)=X(ff)-mediann;
end
ymediann=max(abs(ymedian));%第二个计算因子的分母
cjy1=zeros(kc,1);%存放变量第一个计算因子
cjy2=zeros(kc,1);%存放变量第二个计算因子
cjy=zeros(kc,1);%存放所求变量
for f=1:kc
%     cjy1(f)=NH(SSS(f,:),SSQ,(d0-1)/2);
    cjy1(f)=NHDTW1(SSS(f,:),SSQ,(d0-1)/2);

% %换成DTW算法
%      for a=1:k
%      test=S(a,:);
%      cjy1(a) = DTW(test, Q);  
%      end
    cjy2(f)=abs(X(f)-mediann)/ymediann;
    cjy(f)=exp((-1/2)*(cjy1(f)+cjy2(f)));
end


%对应到SVM模型里面，猜想可以调用我们工程里面的函数，得到alpha、b进行预测

% SST=Xt;%预测序列
% SSS=[SSS;SSS];
% SSY=[SSY;SSY];
%tunel 过程
[gam,sig2] = tunelssvm({SSS,SSY,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% gam=2.4*(10^7);
% sig2=700;
%train
[alpha,b] = trainlssvmknn({SSS,SSY,'f',gam,sig2,'RBF_kernel'},cjy); %lin_kernel
%[alpha,b] = trainlssvm({SSS,SSY,'f',gam,sig2,'RBF_kernel'}); %lin_kernel

%predict
prediction(jia) = predict({SSS,SSY,'f',gam,sig2,'RBF_kernel'},SSQ,1);
% C0=C0-1;
end
% end

X1=TXT(1:200);
Xt=TXT(201:216);
ticks=cumsum(ones(216,1));
ts=datenum('1960-01');
tf=datenum('1977-12');
t=linspace(ts,tf,216);
plot(t(1:size(X1)),X1);
hold on;
plot(t(size(X1)+1:size(ticks)),[prediction Xt]);
ylabel('Values of passenger database');
title('the example 1 of KNN');

mn=size(prediction,1);
w=0;
W=0;
for i=1:mn
    w=w+abs(prediction(i)-Xt(i));
    W=W+(prediction(i)-Xt(i))^2;
end
mae=w/mn;
rmse=sqrt(W/mn);
