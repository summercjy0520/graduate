
clear all;
clc;

% [TXT,TX,RAW] = xlsread('C:\Documents and Settings\Administrator\桌面\cjy\2016\5\data\gupiao\pufayinhang.xls');
% TXT=TXT(:,2);

TXT= importdata('C:\Documents and Settings\Administrator\桌面\cjy\2016\6\data\main\zxzq.txt');
TXT=(TXT.textdata(2002:3098,5))';% end:2015-03~06:2864-2933  %+2000
TXT=str2double(TXT);
[TXT,T1]=mapminmax(TXT);
TXT=TXT(1:end)';
% TXT=(TXT.data(:,2));


TYT= importdata('C:\Documents and Settings\Administrator\桌面\cjy\2016\6\data\main\szzs.txt');
TYT=(TYT.textdata(5055:6151,4))'; % end:2015-03~06:5917-5986
TYT=str2double(TYT);
[TYT,T2]=mapminmax(TYT);
TYT=TYT(1:end)';

% [TYT,TY,RAW1] = xlsread('C:\Documents and Settings\Administrator\桌面\cjy\2016\5\data\gupiao\shangzhengzhishu.xls');
% TYT=TYT(:,2);

step=1;
number0=1097;
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
% number=35;
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

prediction=zeros(63,1);
zis=1;
h0=1033;
h1=1097;
k=200;
while(zis<64)
q=15; %时锟斤拷
s=1;  %预锟解窗锟斤拷
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
S=zeros(z,2*qq);
h=0; %锟斤拷锟斤拷锟狡讹拷时锟斤拷影锟斤拷锟皆拷锟斤拷斜锟角?

for i=1:z
    for j=1:qq
    if h+j<=mm
    S(i,2*j-1)=Y(h+j);
    S(i,2*j)=X(h+j);
    end
    end
    h=h+1;
end   %写得很棒！！

Q1=zeros(qq,1);
Q2=zeros(qq,1);
Q=zeros(2*qq,1);
for i=1:qq
Q2(qq-i+1)=B(h0+delay+zis-i);
Q1(qq-i+1)=A(h0+zis-i);
end
for i=1:qq
Q(2*i-1)=Q1(i);
Q(2*i)=Q2(i);
end
Q=Q';

Ytra=zeros(1,mm-q-s+1)';
for tt=1:mm-q-s+1
    Ytra(tt)=A(tt+q+s-1);
end

dd1=NHDTW(S,Q,qq);

%找临近序列
SS=zeros(k,2*qq);%最近邻的k个序列
K=zeros(k,1);
[maxn maxi]=max(dd1);%用于替换，最大值
mmm=size(X,1);

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

kc=size(SS,1);
%整理2q+3个Z序列&&单变量
Z=zeros(qq,kc);
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
%计算互信息MI的大小
for aa=1:kc
%     H(aa)=X(K(aa)+s);
    H(aa)=A(K(aa)+q+s);
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
%prediction1= predict0602({SSS,SSY,'f',gam,sig2,'RBF_kernel'},Q,TT,2);
%prediction = predictcjy({Xtra,Ytra,'f',gam,sig2,'lin_kernel'},{[X;Xt],Xs},{d,100});
% prediction(zis)=prediction1(2);
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
ylabel('guojinzhengquan');

Xt=A(h0+1:h1);
mk=size(prediction,1);
w=0;
W=0;
for i=1:mk
    w=w+abs(prediction(i)-Xt(i));
    W=W+(prediction(i)-Xt(i))^2;
end
mae=w/mk;
