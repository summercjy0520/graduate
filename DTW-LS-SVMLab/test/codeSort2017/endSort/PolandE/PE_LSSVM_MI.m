clear all;
clc;

TXT= load('data\KNN\ElectricFixedTest.mat');
TXT1= load('data\KNN\ElectricFixed.mat');
TXT=[TXT1.learn;TXT.test];

C=100;%向前预测多少个样本点
h0=1350;
h1=h0+C;
prediction=zeros(C,1);

for jia=1:C
    
X=TXT(1:(h0+jia-1));
% Q=TXT(5591:5600)';
Xt=TXT((h0+jia):h1);

q=8; %时滞
qq=q+1;
s=1;  %预测窗口

Xtt=[X;Xt];

mm=size(TXT(1:(h0-1+jia)),1);


z=mm-s-qq+1;
Xtra=zeros(z,qq);
h=0; 

for i=1:z
    for j=1:qq
    if h+j<=mm
    Xtra(i,j)=X(h+j);
%     S(i,2*j)=X(h+2*j);
    end
    end
    h=h+1;
end

Q=Xtt((h0-s-q+jia):(h0+jia-s))';
H=X(qq+s:end)';

Z=Xtra';
MI=zeros(qq,1);%存储Z序列与H之间的互信息大小，用于比较

for a=1:qq
%     MI(a)=mi(Z(a,:)',H'); %调用函数求解MI值
    MI(a)=mi(Z(a,:)',H'); %调用函数求解MI值
end

M=[]; %初始化{}里面的元素
% s0=s;
d=6;
d0=6;
temp=zeros(d0,z);%用于存储选择出来的参与训练序列对应的序号,不可能大于q
% % MI求解过程中每增加一个Zi要怎么处理，知道求出s个z序列
tem=zeros(d0,1);%用于存储每次选择出来的序列对应的时刻点
Z0=Z;
while(d>0)
    for j=1:d0
    [maxx,maxi]=max(MI);
    tem(j)=maxi;
%     temp(j,:)=Z(maxi,:);
    M=[M Z(maxi,:)']; %每次将选择好的Z序列加进来，也要用于最后训练样本的求取
    Z(maxi,:)=zeros(1,z);%除去选中的这一行....置零值
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
SSS=zeros(z,d0);%k为对应的原来Z序列里面每条序列的长度
SSY=zeros(z,1);
% temp=[1,2]';
%得到s条z序列，也就可以得到对应的预测输入
for b=1:z
    for bb=1:d0
    SSS(b,bb)=temp(bb,b);
    SSY(b)=H(b); %每条序列对应的预测值
%     bb=bb+1; 
    end
%     b=b+1;%循环一次得到一条目标序列
end

% C0=C-d0;
SSQQ=Q;
SSQ=zeros(1,qq);

for i=1:d0
    SSQ(i)=SSQQ(tem(i));%取对应时刻的值
end

[gam,sig2] = tunelssvm({SSS,SSY,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

%predict
prediction(jia) = predict({SSS,SSY,'f',gam,sig2,'RBF_kernel'},SSQ,1);
end

%plot
plot(prediction(1:end),'-k+');
hold on;
% plot(Xt((s+1):end),'r')
plot(TXT(1351:1450),'-r*');
xlabel('time');
ylabel('Values of Poland electricity database');
title('KNN-LSSVM');

Xt=TXT(1351:1450);
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
nrmse=rmse/std(TXT(1:h0));