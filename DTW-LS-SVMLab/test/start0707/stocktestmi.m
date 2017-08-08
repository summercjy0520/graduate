
clear all;
clc;

TXT= importdata('C:\Documents and Settings\Administrator\桌面\cjy\2016\7\data\600036.txt');
%TXT= importdata('C:\Documents and Settings\Administrator\桌面\cjy\2016\7\data\zxzq0703.txt');
TXT=(TXT.textdata(2:end-1,5))';% end:2015-03~06:2864-2933  %+2000
TXT=str2double(TXT);
[TXT,T1]=mapminmax(TXT);
TXT=TXT(1:end)';
% TXT=(TXT.data(:,2));

ww=70;
prediction=zeros(ww,1);

H1=size(TXT,1);

zis=1;

% h0=H1;
h0=H1-ww;
k=200;
tempy=0;
while(zis<ww+1)
q=101; %时锟斤拷
qq=q+1;
s=1;  %预锟解窗锟斤拷;
% cjy1=0;
% cjy2=0;
h1=size(TXT,1);
TT1=ones(h1-1,1)*100;
TT2=ones(h1-1,1)*100;
TT3=ones(h1-1,1)*100;
TT4=ones(h1-1,1)*100;
TT5=ones(h1-1,1)*100;
TT6=ones(h1-1,1)*100;
TT7=ones(h1-1,1)*100;
TT8=ones(h1-1,1)*100;
TT=zeros(h1-1,1);
YT=zeros(h1-1,1);

A1=zeros(h1-1,1);
A2=zeros(h1-1,1);
A3=zeros(h1-1,1);
A4=zeros(h1-1,1);
A5=zeros(h1-1,1);
A6=zeros(h1-1,1);
A7=zeros(h1-1,1);
A8=zeros(h1-1,1);


YYT=zeros(h1-s,1);
v=[];
for t=1:h1-s
    TT(t)=TXT(t+s)-TXT(t);
    if TT(t)>=0
%         YT(t)=1;
        if abs(TT(t))<0.005
            TT1(t)=TT(t);
            YT(t)=1;
            A1(t)=t;
        elseif abs(TT(t))>=0.005&&abs(TT(t))<0.01
            TT2(t)=TT(t);
            YT(t)=2;
            A2(t)=t;
        elseif abs(TT(t))>=0.01&&abs(TT(t))<0.02
            TT3(t)=TT(t);
            YT(t)=3;
            A3(t)=t;
        else
            TT4(t)=TT(t);
            YT(t)=4;
            A4(t)=t;
        end
    else
%         YT(t)=-1;
        if abs(TT(t))<0.005
            TT5(t)=TT(t);
            YT(t)=-1;
            A5(t)=t;
        elseif abs(TT(t))>=0.005&&abs(TT(t))<0.01
            TT6(t)=TT(t);
            YT(t)=-2;
            A6(t)=t;
        elseif abs(TT(t))>=0.01&&abs(TT(t))<0.02
            TT7(t)=TT(t);
            YT(t)=-3;
            A7(t)=t;
        else
            TT8(t)=TT(t);
            YT(t)=-4;
            A8(t)=t;
        end
    end
   
end

TT1(ismember(TT1,100,'rows')==1)=[];
TT2(ismember(TT2,100,'rows')==1)=[];
TT3(ismember(TT3,100,'rows')==1)=[];
TT4(ismember(TT4,100,'rows')==1)=[];
TT5(ismember(TT5,100,'rows')==1)=[];
TT6(ismember(TT6,100,'rows')==1)=[];
TT7(ismember(TT7,100,'rows')==1)=[];
TT8(ismember(TT8,100,'rows')==1)=[];


A1(ismember(A1,0,'rows')==1)=[];
A2(ismember(A2,0,'rows')==1)=[];
A3(ismember(A3,0,'rows')==1)=[];
A4(ismember(A4,0,'rows')==1)=[];
A5(ismember(A5,0,'rows')==1)=[];
A6(ismember(A6,0,'rows')==1)=[];
A7(ismember(A7,0,'rows')==1)=[];
A8(ismember(A8,0,'rows')==1)=[];



X=TXT(1:h0+zis-1);
% Q=TXT(5591:5600)';
Xt=TXT((h0+1+zis-1):H1);
XXt=[X;Xt];

Xs=XXt((h0-s-q+zis):(h0+zis-s));

mm=size(TXT(1:(h0-1+zis)),1);

z=mm-s-qq+1;
S=zeros(z,qq);
h=0; %锟斤拷锟斤拷锟狡讹拷时锟斤拷影锟斤拷锟皆拷锟斤拷斜锟角?

for i=1:z
    for j=1:qq
    if h+j<=mm
    S(i,j)=X(h+j);
%     S(i,2*j)=X(h+2*j);
    end
    end
    h=h+1;
end  


dd1=NHDTW(S,Xs',qq/2);

K=zeros(k,1);
dd=zeros(k,1);
[maxn maxi]=max(dd1);%用于替换，最大值
% mmm=size(X,1);

jjj=1;
while (jjj<=k)
%     jjj=1;%初值
    [minn mini]=min(dd1);%找第一个最小值
    if mini>=qq&&mini<=(size(YT,1)-q)
    K(jjj)=mini;%记录对应的行
    dd(jjj)=minn;%记录对应的最近值
    dd1(mini)=maxn;
    jjj=jjj+1;
    else
    dd1(mini)=maxn;
    end

end
SS=zeros(k,qq);%最近邻的k个序列
Y1=zeros(k,1);
for iii=1:k
    SS(iii,:)=S(K(iii),:);
    Y1(iii)=YT(K(iii)+q);
end

V1=Y1;
V1(ismember(V1,2,'rows')==1,:)=1;
V1(ismember(V1,-2,'rows')==1,:)=-1;
V1(ismember(V1,3,'rows')==1,:)=1;
V1(ismember(V1,-3,'rows')==1,:)=-1;
V1(ismember(V1,4,'rows')==1,:)=1;
V1(ismember(V1,-4,'rows')==1,:)=-1;

[gam,sig2] = tunelssvm({SS,V1,'c',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({SS,V1,'c',gam,sig2,'RBF_kernel'});
%predict next 100 points
Ytest1 = simlssvm({SS,V1,'c',gam,sig2,'RBF_kernel'},{alpha,b},Xs');

V2=YT;
V2(ismember(V2,2,'rows')==1,:)=1;
V2(ismember(V2,-2,'rows')==1,:)=-1;
V2(ismember(V2,3,'rows')==1,:)=1;
V2(ismember(V2,-3,'rows')==1,:)=-1;
V2(ismember(V2,4,'rows')==1,:)=1;
V2(ismember(V2,-4,'rows')==1,:)=-1;

index=find(V2(qq:z+q)==Ytest1);
c1=size(index,1);
SSS=zeros(c1,qq);
V3=zeros(c1,1);
for i=1:c1
    SSS(i,:)=S(index(i),:);
    V3(i)=YT(index(i)+q);
end

if Ytest1==1
    V3(ismember(V3,3,'rows')==1,:)=-1;
    V3(ismember(V3,4,'rows')==1,:)=-1;
    V3(ismember(V3,2,'rows')==1,:)=1;
else
    V3(ismember(V3,-2,'rows')==1,:)=-1;
    V3(ismember(V3,-3,'rows')==1,:)=1;
    V3(ismember(V3,-4,'rows')==1,:)=1;
end

kn=300;
dd0=NHDTW(SSS,Xs',qq/2);

KN=zeros(kn,1);
[maxn0 maxi]=max(dd0);%用于替换，最大值
% mmm=size(X,1);

jjj=1;
while (jjj<=kn)
%     jjj=1;%初值
    [minn0 mini0]=min(dd0);%找第一个最小值
    KN(jjj)=mini0;%记录对应的行
    dd0(mini0)=maxn0;
    jjj=jjj+1;
end
SSS1=zeros(kn,qq);%最近邻的k个序列
V30=zeros(kn,1);
for iii=1:kn
    SSS1(iii,:)=SSS(KN(iii),:);
    V30(iii)=V3(KN(iii));
end


[gamt,sigt2] = tunelssvm({SSS1,V30,'c',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alphat,bt] = trainlssvm({SSS1,V30,'c',gamt,sigt2,'RBF_kernel'});
%predict next 100 points
Ytest2 = simlssvm({SSS1,V30,'c',gamt,sigt2,'RBF_kernel'},{alphat,bt},Xs');


V4=YT;
if Ytest1==1
    V4(ismember(V4,3,'rows')==1,:)=-1;
    V4(ismember(V4,4,'rows')==1,:)=-1;
    V4(ismember(V4,2,'rows')==1,:)=1;
else
    V4(ismember(V4,-2,'rows')==1,:)=-1;
    V4(ismember(V4,-3,'rows')==1,:)=1;
    V4(ismember(V4,-4,'rows')==1,:)=1;
end

index1=find(V4(qq:z+q)==Ytest2);
c1=size(index1,1);
SXX=zeros(c1,qq);
V5=zeros(c1,1);
for i=1:c1
    SXX(i,:)=S(index1(i),:);
    V5(i)=YT(index1(i)+q);
end

if Ytest1==1&&Ytest2==1
    V5(ismember(V5,2,'rows')==1,:)=-1;
elseif Ytest1==1&&Ytest2==-1
    V5(ismember(V5,3,'rows')==1,:)=1;
    V5(ismember(V5,4,'rows')==1,:)=-1;
elseif Ytest1==-1&&Ytest2==1
    V5(ismember(V5,-3,'rows')==1,:)=1;
    V5(ismember(V5,-4,'rows')==1,:)=-1;
elseif Ytest1==-1&&Ytest2==-1
    V5(ismember(V5,-2,'rows')==1,:)=1;
end


knn=300;
d0=NHDTW(SXX,Xs',qq/2);

KN1=zeros(knn,1);
[maxn4 maxi]=max(d0);%用于替换，最大值
% mmm=size(X,1);

jjj=1;
while (jjj<=knn)
%     jjj=1;%初值
    [minn4 mini4]=min(d0);%找第一个最小值
    KN1(jjj)=mini4;%记录对应的行
    d0(mini4)=maxn4;
    jjj=jjj+1;
end
SSS2=zeros(knn,qq);%最近邻的k个序列
V50=zeros(knn,1);
for iii=1:knn
    SSS1(iii,:)=SXX(KN1(iii),:);
    V50(iii)=V5(KN1(iii));
end


[gamt,sigt2] = tunelssvm({SSS2,V50,'c',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alphat,bt] = trainlssvm({SSS2,V50,'c',gamt,sigt2,'RBF_kernel'});
%predict next 100 points
Ytest3= simlssvm({SSS2,V50,'c',gamt,sigt2,'RBF_kernel'},{alphat,bt},Xs');


SS1=zeros(size(A1,1),qq);%最近邻的k个序列

 for y1=1:size(A1,1)
      if A1(y1)>qq&&A1(y1)<=z+qq
           SS1(y1,:)=S(A1(y1)-qq,:);
      else
          TT1(y1)=100;
      end
 end
 SS2=zeros(size(A2,1),qq);%最近邻的k个序列

 for y2=1:size(A2,1)
       if A2(y2)>qq&&A2(y2)<=z+qq
        SS2(y2,:)=S(A2(y2)-qq,:);
       else
        TT2(y2)=100;
       end
 end
 
  SS3=zeros(size(A3,1),qq);%最近邻的k个序列

 for y3=1:size(A3,1)
       if A3(y3)>qq&&A3(y3)<=z+qq
        SS3(y3,:)=S(A3(y3)-qq,:);
       else
        TT3(y3)=100;
       end
 end
 
  SS4=zeros(size(A4,1),qq);%最近邻的k个序列

 for y4=1:size(A4,1)
       if A4(y4)>qq&&A4(y4)<=z+qq
        SS4(y4,:)=S(A4(y4)-qq,:);
       else
        TT4(y4)=100;
       end
 end
 
 SS5=zeros(size(A5,1),qq);%最近邻的k个序列

 for y5=1:size(A5,1)
       if A5(y5)>qq&&A5(y5)<=z+qq
        SS5(y5,:)=S(A5(y5)-qq,:);
       else
        TT5(y5)=100;
       end
 end
 
 SS6=zeros(size(A6,1),qq);%最近邻的k个序列

 for y6=1:size(A6,1)
       if A6(y6)>qq&&A6(y6)<=z+qq
        SS6(y6,:)=S(A6(y6)-qq,:);
       else
        TT6(y6)=100;
       end
 end
 
 SS7=zeros(size(A7,1),qq);%最近邻的k个序列

 for y7=1:size(A7,1)
       if A7(y7)>qq&&A7(y7)<=z+qq
        SS7(y7,:)=S(A7(y7)-qq,:);
       else
        TT7(y7)=100;
       end
 end
 
 SS8=zeros(size(A8,1),qq);%最近邻的k个序列

 for y8=1:size(A8,1)
       if A8(y8)>qq&&A8(y8)<=z+qq
        SS8(y8,:)=S(A8(y8)-qq,:);
       else
        TT8(y8)=100;
       end
 end
 
TT1(ismember(TT1,100,'rows')==1)=[];
TT2(ismember(TT2,100,'rows')==1)=[];
TT3(ismember(TT3,100,'rows')==1)=[];
TT4(ismember(TT4,100,'rows')==1)=[];
TT5(ismember(TT5,100,'rows')==1)=[];
TT6(ismember(TT6,100,'rows')==1)=[];
TT7(ismember(TT7,100,'rows')==1)=[];
TT8(ismember(TT8,100,'rows')==1)=[];

SS1(ismember(SS1,zeros(1,qq),'rows')==1,:)=[];
SS2(ismember(SS2,zeros(1,qq),'rows')==1,:)=[];
SS3(ismember(SS3,zeros(1,qq),'rows')==1,:)=[];
SS4(ismember(SS4,zeros(1,qq),'rows')==1,:)=[];
SS5(ismember(SS5,zeros(1,qq),'rows')==1,:)=[];
SS6(ismember(SS6,zeros(1,qq),'rows')==1,:)=[];
SS7(ismember(SS7,zeros(1,qq),'rows')==1,:)=[];
SS8(ismember(SS8,zeros(1,qq),'rows')==1,:)=[];


dd2=NHDTW(SS1,Xs',qq/2);
dd3=NHDTW(SS2,Xs',qq/2);
dd4=NHDTW(SS3,Xs',qq/2);
dd5=NHDTW(SS4,Xs',qq/2);
dd6=NHDTW(SS5,Xs',qq/2);
dd7=NHDTW(SS6,Xs',qq/2);
dd8=NHDTW(SS7,Xs',qq/2);
dd9=NHDTW(SS8,Xs',qq/2);

a=zeros(8,1);
a(1)=min(dd2);
a(2)=min(dd3);
a(3)=min(dd4);
a(4)=min(dd5);
a(5)=min(dd6);
a(6)=min(dd7);
a(7)=min(dd8);
a(8)=min(dd9);
min0=min(a);
if min(dd2)==min0
    SS0=SS1;
    H0=TT1;
    cjy=0;
elseif min(dd3)==min0
    SS0=SS2;
    H0=TT2;
    cjy=1;
elseif min(dd4)==min0
    SS0=SS3;
    H0=TT3;
    cjy=2;
elseif min(dd5)==min0
    SS0=SS4;
    H0=TT4;
    cjy=3;
elseif min(dd6)==min0
    SS0=SS5;
    H0=TT5;
    cjy=4;
elseif min(dd7)==min0
    SS0=SS6;
    H0=TT6;
    cjy=5;
elseif min(dd8)==min0
    SS0=SS7;
    H0=TT7;
    cjy=6;
elseif min(dd9)==min0
    SS0=SS8;
    H0=TT8;
    cjy=7;
end

km=300;

dd0=NHDTW(SS0,Xs',qq/2);

KK=zeros(km,1);
[maxn0 maxi0]=max(dd0);%用于替换，最大值
% mmm=size(X,1);

jjj=1;
while (jjj<=km)
%     jjj=1;%初值
    [minn0 mini0]=min(dd0);%找第一个最小值
    KK(jjj)=mini0;%记录对应的行
    dd0(mini0)=maxn0;
    jjj=jjj+1;
end
XXX=zeros(km,qq);%最近邻的k个序列
H=zeros(km,1);
for iii=1:km
    XXX(iii,:)=SS0(KK(iii),:);
    H(iii)=H0(KK(iii));
end


MI=zeros(qq,1);%存储Z序列与H之间的互信息大小，用于比较
Z=zeros(qq,km);

for n=1:qq
    for nn=1:km
        Z(n,nn)=XXX(nn,n);
    end
%     n=n+1;
end  
%计算互信息MI的大小
for a=1:qq
%     MI(a)=mi(Z(a,:)',H'); %调用函数求解MI值
    MI(a)=mi(Z(a,:)',H'); %调用函数求解MI值
end


M=[]; %初始化{}里面的元素
% s0=s;
d=30;
d0=30;
temp=zeros(d0,km);%用于存储选择出来的参与训练序列对应的序号,不可能大于q
% % MI求解过程中每增加一个Zi要怎么处理，知道求出s个z序列
tem=zeros(d0,1);%用于存储每次选择出来的序列对应的时刻点
Z0=Z;
while(d>0)
    for j=1:d0
    [maxx,maxi]=max(MI);
    tem(j)=maxi;
%     temp(j,:)=Z(maxi,:);
    M=[M Z(maxi,:)']; %每次将选择好的Z序列加进来，也要用于最后训练样本的求取
    Z(maxi,:)=zeros(1,km);%除去选中的这一行....置零值
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
SSS=zeros(km,d0);%k为对应的原来Z序列里面每条序列的长度
SSY=zeros(km,1);
% temp=[1,2]';
%得到s条z序列，也就可以得到对应的预测输入
for b=1:km
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
SSQQ(i)=Xs(i);
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
cjy1=zeros(km,1);%存放变量第一个计算因子
cjy2=zeros(km,1);%存放变量第二个计算因子
cjyx=zeros(km,1);%存放所求变量
for f=1:km
%     cjy1(f)=NH(SSS(f,:),SSQ,(d0-1)/2);
    cjy1(f)=NHDTW1(SSS(f,:),SSQ,(d0-1)/2);

% %换成DTW算法
%      for a=1:k
%      test=S(a,:);
%      cjy1(a) = DTW(test, Q);  
%      end
     cjy2(f)=abs(X(f)-mediann)/ymediann;
   cjyx(f)=exp((-1/2)*(cjy1(f)+cjy2(f)));
end



[gam,sig2] = tunelssvm({SSS,SSY,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% gam=2.4*(10^7);
% sig2=700;
%train
[alpha,b] = trainlssvmknn({SSS,SSY,'f',gam,sig2,'RBF_kernel'},cjyx); %lin_kernel
%[alpha,b] = trainlssvm({SSS,SSY,'f',gam,sig2,'RBF_kernel'}); %lin_kernel

%predict
tempx= predict({SSS,SSY,'f',gam,sig2,'RBF_kernel'},Xs,1);


prediction(zis)=TXT(h0+zis-s)+tempx;

zis=zis+1;
end

plot(prediction(1:end),'-b+');
hold on;
% plot(Xt((s+1):end),'r')
plot(TXT(h0+1:H1),'-r*');
xlabel('time');

ylabel('Values of stockdata');
title('stock zsyh data test');


Xt=TXT(h0+1:H1);
prediction=prediction(1:end);
mn=size(prediction,1);
w=0;
W=0;
for i=1:mn
    w=w+abs(prediction(i)-Xt(i));
    W=W+(prediction(i)-Xt(i))^2;
end
mae=w/mn;
rmse=sqrt(W/mn);

