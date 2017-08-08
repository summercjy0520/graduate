
clear all;
clc;

TXT= importdata('C:\Documents and Settings\Administrator\桌面\cjy\2016\6\data\main\true\zxzq.txt');
TXT=(TXT.textdata(end-1514:end,5))';% end:2015-03~06:2864-2933  %+2000
TXT=str2double(TXT);
[TXT,T1]=mapminmax(TXT);
TXT=TXT(1:end)';
% TXT=(TXT.data(:,2));

TYT= importdata('C:\Documents and Settings\Administrator\桌面\cjy\2016\6\data\main\true\gjzq.txt');
%TYT= importdata('C:\Documents and Settings\Administrator\桌面\cjy\2016\6\data\main\szzs.txt');
TYT=(TYT.textdata(end-1514:end,5))';% end:3287,3217,3157,3127
TYT=str2double(TYT);
[TYT,T2]=mapminmax(TYT);
TYT=TYT(1:end)';


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

ww=25;
prediction=zeros(ww,1);
zis=1;
h1=size(TXT,1);
% TT=zeros(h1,1);
% for t=1:h1
%     TT(t)=TXT(t+1)-TXT(t);
% end
h0=h1-ww;
k=500;
delay=0;
while(zis<ww+1)
q=15; %时锟斤拷
s=1;  %预锟解窗锟斤拷
qq=q+1;
X=TYT(1+delay:h0-1+delay+zis-1);
Y=TXT(1:h0-1+zis-1);
% Q=TXT(5591:5600)';

mm=size(X,1);

z=mm-s-q+1;
% Xtra=zeros(z,q);
Xtra=zeros(z,2*qq);
h=0; %锟斤拷锟斤拷锟狡讹拷时锟斤拷影锟斤拷锟皆拷锟斤拷斜锟角?

for i=1:z
    for j=1:qq
    if h+j<=mm
    Xtra(i,2*j-1)=X(h+j);
    Xtra(i,2*j)=Y(h+j);
    end
    end
    h=h+1;
end   %写得很棒！！

Q1=zeros(qq,1);
Q2=zeros(qq,1);
Q=zeros(2*qq,1);
for i=1:qq
Q2(qq-i+1)=TYT(h0+delay+zis-i);
Q1(qq-i+1)=TXT(h0+zis-i);
end
for i=1:qq
Q(2*i-1)=Q1(i);
Q(2*i)=Q2(i);
end
Q=Q';

Ytra=zeros(1,mm-q-s+1)';
for tt=1:mm-q-s+1
    Ytra(tt)=TXT(tt+q+s-1);
end


dd1=NHDTW(Xtra,Q,qq);
%找临近序列
SS=zeros(k,2*qq);%最近邻的k个序列
K=zeros(k,1);
dd=zeros(k,1);
[maxn maxi]=max(dd1);%用于替换，最大值
mmm=size(X,1);

jjj=1;
while (jjj<=k)
%     jjj=1;%初值
    [minn mini]=min(dd1);%找第一个最小值
    if mini>=qq&&mini<=(mmm-q-s)
    K(jjj)=mini;%记录对应的行
    dd(jjj)=minn;%记录对应的最近值
    dd1(mini)=maxn;
    jjj=jjj+1;
    else
    dd1(mini)=maxn;
    end   
%     jjj=jjj+1;
end
for iii=1:k
    SS(iii,:)=Xtra(K(iii),:);
end

kc=size(SS,1);
%整理2q+3个Z序列&&单变量
Z=zeros(2*qq,kc);
% t=zeros(k,1);%整理选择的临近序列下标
% t=K;
% for m=1:k
%     t(m)=K(m)-q;
% end
for n=1:2*qq
    for nn=1:kc
    Z(n,nn)=SS(nn,n);%公式（7）
%     Z(2*n,nn)=Y(mnn);%公式（7）
%     nn=nn+1;
    end
%     n=n+1;
end   %很棒~~

H=zeros(1,kc);
MI=zeros(2*qq,1);%存储Z序列与H之间的互信息大小，用于比较
temp=zeros(qq,1);
%计算互信息MI的大小
for aa=1:kc
%     H(aa)=X(K(aa)+s);
for m=1:qq
    temp(m)=TXT(K(aa)+m);
end
H(aa)=(TXT(K(aa)+q+s)-TXT(K(aa)+q+s-1))/mean(temp);
%     H(aa)=(TXT(K(aa)+q+s)-TXT(K(aa)+q+s-1))/TXT(K(aa)+q+s-1);
end
for a=1:2*qq
%     MI(a)=mi(Z(a,:)',H'); %调用函数求解MI值
    MI(a)=mi(Z(a,:)',H'); %调用函数求解MI值
end


M=[]; %初始化{}里面的元素
% s0=s;
d=11*2;
d0=11*2;
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


SSQ=zeros(1,d0);
% Xtt=[X((end-s+2):end);Xt];
% while(C0>0)

for i=1:d0
    SSQ(i)=Q(tem(i));%取对应时刻的值
end



[gam,sig2] = tunelssvm({SSS,SSY,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({SSS,SSY,'f',gam,sig2,'RBF_kernel'});
%predict next 100 points
prediction(zis) = predict({SSS,SSY,'f',gam,sig2,'RBF_kernel'},SSQ,1);

zis=zis+1;
end
% ticks=cumsum(ones(216,1));

for t=1:(h1-h0)
    for n=1:qq
    temp=TXT(h0-qq+n);
    end
    prediction(t)=prediction(t)*mean(temp)+TXT(h0+t-1);
end

plot(prediction(1:end),'-b+');
hold on;
% plot(Xt((s+1):end),'r')
plot(TXT(h0+1:h1),'-r*');
xlabel('time');
% ts=datenum('1972-01');
% tf=datenum('2010-10');
% t=linspace(ts,tf,70);
% plot(t(1:size(X(end-68:end))),X(end-68:end));
% hold on;
% plot(t(size(X(end-68:end))+1:size(ticks)),[prediction SSQ(1)]);
% datetick('x','yyyy','keepticks');
ylabel('Values of stockdata');
title('stock data test');


Xt=TXT(h0+1:h1);
% mn=size(prediction,1);
% w=zeros(mn,1);
% W=zeros(mn,1);
% for i=1:mn
%     w(i)=(prediction(i)-Xt(i))^2;
%     W(i)=(mean(Xt)-Xt(i))^2;
% end
% nmse = mean(w)/mean(W);
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

