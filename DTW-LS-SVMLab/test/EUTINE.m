clear all;
clc;

% TXT= importdata('data\KNN\Load1997.txt');
[NUMERIC,TX,RAW] = xlsread('data\KNN\Temperature1997.xls');
[NUMERIC1,TX1,RAW1] = xlsread('data\KNN\Temperature1998.xls');
TXT=NUMERIC;
TXT1=NUMERIC1;
TXT=[TXT;TXT1];

[NUMERICY,TY,RAWY] = xlsread('data\KNN\Load1997.xls');
[NUMERICY1,TY1,RAWY1] = xlsread('data\KNN\Load1998.xls');
TYT=NUMERICY(2:366,4:51);
TYT1=NUMERICY1(2:366,4:51);
TYT=[TYT;TYT1];

q=35; %时滞
qq=q+1;

aa=size(TXT,1);
% aaa=aa-qq;
bb=size(TXT,2);
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
Q1(qq-i+1)=TXT(end-i+1);
Q2(qq-i+1)=max(TYT(end-i+1,:));
end
for i=1:qq
Q(2*i-1)=Q1(i);
Q(2*i)=Q2(i);
end
Q=Q';

% k=2*round((mm/2)^(1/2));
k=200;
% k=6;
% q=1;
% s=2;
% qq=q+1;
% mm=aa;
% mmm=1/2*aa;

% z=aa-q;
% S=zeros(z,2*qq);
% h=0; %用于移动时滞影响的原序列标签
% 
% 
% % Q=Xt;
Xt=[752,702,677,718,738,707,742,745,733,679,744,739,757,760,752,738,692,780,780,790,798,778,726,700,782,791,788,777,789,762,740]';
% XXt=[Y;Xt];
% %第一次计算混合距离
% dd1=NH(S,Q,qq);
% 
% %找临近序列
% SS=zeros(k,2*qq);%最近邻的k个序列
% K=zeros(k,1);
% [maxn maxi]=max(dd1);%用于替换，最大值
prediction=zeros(31,1);
for s=1:31   %预测窗口
% Xtt=XXt((end-size(Xt,1)-q-s+1):end);
X=X(1:(aa-s+1));
Y=Y(1:(aa-s+1));
mmm=size(X,1);

z=aa-s-q+1;
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

%整理2q+3个Z序列&&单变量
Z=zeros(2*qq,k);
% t=zeros(k,1);%整理选择的临近序列下标
% t=K;
% for m=1:k
%     t(m)=K(m)-q;
% end
for n=1:qq
    for nn=1:k
    mnn=K(nn)+n-1;
    Z(2*n-1,nn)=X(mnn);%公式（7）
    Z(2*n,nn)=Y(mnn);%公式（7）
%     nn=nn+1;
    end
%     n=n+1;
end   %很棒~~

H=zeros(1,k);
MI=zeros(qq,1);%存储Z序列与H之间的互信息大小，用于比较
%计算互信息MI的大小
for tt=1:k
    H(tt)=Y(K(tt)+q+s);
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
tem=zeros(d0,1);%用于存储每次选择出来的序列对应的时刻点
Z0=Z;
while(d>0)
    for j=1:d0
    [maxx,maxi]=max(MI);
%     if j<d0
%         if mod(maxi,2)==0
%             maxii=maxi-1;
%         end
%     end             %预测序列选取的另一种可能
    tem(j)=maxi;
    temp(j,:)=Z(maxi,:);
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
end

% for i=1:d
% SSQ(2*i-1)=X(end);
% end



% C0=C-d0;
% SSQQ=zeros(1,qq);
SSQ=zeros(1,d0);
% Xtt=[X((end-s+2):end);Xt];
% while(C0>0)
% for i=1:qq
% SSQQ(i)=Q(i);
% end

for i=1:d0
    SSQ(i)=Q(tem(i));%取对应时刻的值
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
    cjy1(f)=NH(SSS(f,:),SSQ,d0/2);
    cjy2(f)=abs(X(f)-mediann)/ymediann;
    cjy(f)=exp((-1/2)*(cjy1(f)+cjy2(f)));
end


%对应到SVM模型里面，猜想可以调用我们工程里面的函数，得到alpha、b进行预测

% SST=Xt;%预测序列
% SSS=[SSS;SSS];
% SSY=[SSY;SSY];
%tunel 过程
% [gam,sig2] = tunelssvm({SSS,SSY,'f',[],[],'RBF_kernel'},'simplex',...
% 'crossvalidatelssvm',{10,'mae'});

gam=400;
sig2=40;
%train
[alpha,b] = trainlssvmknn({SSS,SSY,'f',gam,sig2,'RBF_kernel'},cjy); %lin_kernel

%predict
prediction(s) = predict({SSS,SSY,'f',gam,sig2,'RBF_kernel'},SSQ,1);
% C0=C0-1;
end
% end

%plot
% ticks=cumsum(ones(70,1));
plot(prediction);
hold on;
% plot(Xt((s+1):end),'r')
plot(Xt,'r');
xlabel('time');
% ts=datenum('1972-01');
% tf=datenum('2010-10');
% t=linspace(ts,tf,70);
% plot(t(1:size(X(end-68:end))),X(end-68:end));
% hold on;
% plot(t(size(X(end-68:end))+1:size(ticks)),[prediction SSQ(1)]);
% datetick('x','yyyy','keepticks');
ylabel('Values of Laser database');
title('the example 1 of KNN');




% s=31;  %预测窗口
% prediction=zeros(s,1);
% for c=1:s
% jjj=1;
% while (jjj<=k)
% %     jjj=1;%初值
%     [minn mini]=min(dd1);%找第一个最小值
%     if mini>=qq&&mini<=(mmm-s)
%     K(jjj)=mini;%记录对应的行
%     dd1(mini)=maxn;
%     jjj=jjj+1;
%     else
%     dd1(mini)=maxn;
%     end   
% %     jjj=jjj+1;
% end
% for iii=1:k
%     SS(iii,:)=S(K(iii),:);
% end
% 
% %整理2q+3个Z序列&&单变量
% Z=zeros(2*qq,k);
% % t=zeros(k,1);%整理选择的临近序列下标
% % t=K;
% % for m=1:k
% %     t(m)=K(m)-q;
% % end
% for n=1:qq
%     for nn=1:k
%     mnn=K(nn)+n-qq;
%     Z(2*n-1,nn)=X(mnn);%公式（7）
%     Z(2*n,nn)=Y(mnn);%公式（7）
% %     nn=nn+1;
%     end
% %     n=n+1;
% end   %很棒~~
% 
% H=zeros(1,k);
% MI=zeros(2*qq,1);%存储Z序列与H之间的互信息大小，用于比较
% %计算互信息MI的大小
% for aa=1:k
%     H(aa)=Y(K(aa)+s);
% end
% for a=1:2*qq
%     MI(a)=mi(Z(a,:)',H'); %调用函数求解MI值
% end
% 
% 
% M=[]; %初始化{}里面的元素
% % s0=s;
% d=12;
% d0=12;
% temp=zeros(d0,k);%用于存储选择出来的参与训练序列对应的序号,不可能大于q
% % % MI求解过程中每增加一个Zi要怎么处理，知道求出s个z序列
% while(d>0)
%     [maxx,maxi]=max(MI);
%     for j=1:d0
%     temp(j,:)=Z(maxi,:);
%     M=[M Z(maxi,:)']; %每次将选择好的Z序列加进来，也要用于最后训练样本的求取
%     Z(maxi,:)=[];%除去选中的这一行
%     zz=size(Z,1);
%     MI=zeros(zz,1);
%     for i=1:zz
%     M=[M Z(i,:)'];
%     MI(i)=mi(M,H');
% %     if MI(i)<0
% %         break;  %终止条件
% %     end
%     M(:,2)=[];
% %     i=i+1;
%     end
%     d=d-1;
%     end
% end
% 
% % d=s-s0; %贪婪算法得到的最终的时滞
% SSS=zeros(k,d0);%k为对应的原来Z序列里面每条序列的长度
% SSY=zeros(k,1);
% % temp=[1,2]';
% %得到s条z序列，也就可以得到对应的预测输入
% for b=1:k
%     for bb=1:d0
%     SSS(b,bb)=temp(bb,b);
%     SSY(b)=H(b); %每条序列对应的预测值
% %     bb=bb+1; 
%     end
% %     b=b+1;%循环一次得到一条目标序列
% end
% tempp=zeros(k,1);
% 
% %怎么会是反的呢？？？
% for i=1:d0/2
%     tempp=SSS(:,2*i);
%     SSS(:,2*i)=SSS(:,2*i-1);
%     SSS(:,2*i-1)=tempp;
% end
% % for i=1:d
% % SSQ(2*i-1)=X(end);
% % end
% SSQ=zeros(1,d0);
% SQ=zeros(1,d0);
% for i=1:d0/2
% SQ(2*i-1)=X(end-s-d0/2+i);
% SQ(2*i)=Y(end-s-d0/2+i);
% end
% for i=1:d0
% SSQ(d0-i+1)=SQ(i);
% end
% 
% for i=1:d0/2
%     tempm=SSQ(1,2*i);
%     SSQ(1,2*i)=SSQ(1,2*i-1);
%     SSQ(1,2*i-1)=tempm;
% end
% 
% %模型推导！！！
% %根据公式（10）求得变量sai的值，这里用cjy表示好了
% %第二次计算混合距离
% mediann=median(Y); %求取输入训练样本的中位值
% mn=size(Y,1);
% ymedian=zeros(mn,1);
% for ff=1:mn
%     ymedian(ff)=Y(ff)-mediann;
% %     ff=ff+1;
% end
% ymediann=max(abs(ymedian));%第二个计算因子的分母
% cjy1=zeros(k,1);%存放变量第一个计算因子
% cjy2=zeros(k,1);%存放变量第二个计算因子
% cjy=zeros(k,1);%存放所求变量
% for f=1:k
%     cjy1(f)=NH(SSS(f,:),SSQ,d0/2);
%     cjy2(f)=abs(X(f)-mediann)/ymediann;
%     cjy(f)=exp((-1/2)*(cjy1(f)+cjy2(f)));
%     k=k+1;
% end
% 
% 
% gam=400;
% sig2=40;
% %train
% [alpha,b] = trainlssvmknn({SSS,SSY,'f',gam,sig2,'RBF_kernel'},cjy); %lin_kernel
% 
% %predict
% prediction(c) = predict({SSS,SSY,'f',gam,sig2,'RBF_kernel'},SSQ,1);
% end
% 
% 
% ticks=cumsum(ones(396,1));
% plot(prediction);
% xlabel('time');
% % x=[1920*ones(1,12) 1921*ones(1,12) 1922*ones(1,12) 1923*ones(1,12) 1924*ones(1,12) 1925*ones(1,12) 1926*ones(1,12) 1927*ones(1,12) 1928*ones(1,12) 1929*ones(1,12) 1930*ones(1,12) 1931*ones(1,12) 1932*ones(1,12) 1933*ones(1,12) 1934*ones(1,12) 1935*ones(1,12) 1936*ones(1,12) 1937*ones(1,12)];
% % m=[(1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12)];
% % % s=[prediction Xt];
% % bar(datenum(y,m,1),[X;Xt]);
% % t=linspace(1920,1937,216);
% % dt=t(2)-t(1);
% % Y=fft(OliveOil_train);
% % mag=abs(Y);
% % f=(0:215)/(dt*18);
% % plot(t,mag);
% ts=1700;
% tf=1987;
% t=linspace(ts,tf,396);
% axis([1,400,660,820]);
% plot(t(1:size(X)),X);
% hold on;
% plot(t(size(X)+1:size(ticks)),[prediction Xt]);
% % datetick('x','yyyy','keepticks');
% % ylabel('average air temperatures at Nottinghan Castle');
% title('the example 1 of forcasting of time series datasets');

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
for i=1:mn
    w=w+abs(prediction(i)-Xt(i));
end
mae=w/mn;