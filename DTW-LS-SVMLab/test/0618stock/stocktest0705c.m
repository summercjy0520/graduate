
clear all;
clc;

TXT= importdata('C:\Documents and Settings\Administrator\桌面\cjy\2016\6\data\main\true\zxzq.txt');
%TXT= importdata('C:\Documents and Settings\Administrator\桌面\cjy\2016\7\data\zxzq0703.txt');
TXT=(TXT.textdata(503:end,5))';% end:2015-03~06:2864-2933  %+2000
TXT=str2double(TXT);
[TXT,T1]=mapminmax(TXT);
TXT=TXT(1:end)';
% TXT=(TXT.data(:,2));

ww=50;
prediction=zeros(ww,1);
zis=1;

H1=size(TXT,1);
% h0=h1;
h0=H1-ww;
k=200;
cjy1=0;

while(zis<ww+1)
q=15; %时锟斤拷
qq=q+1;
s=1;  %预锟解窗锟斤拷
% k=6;
% q=1;
% s=2;
% qq=q+1;
X=TXT(1:h0+zis-1);
% Q=TXT(5591:5600)';
Xt=TXT((h0+1+zis-1):H1);
XXt=[X;Xt];
Xs=XXt((h0-s-q+zis):(h0+zis-s));

h1=size(X,1);
TT=zeros(h1-1,1);
YT=zeros(h1-qq,1);
YYT=zeros(h1-1,1);
v=[];
for t=1:h1-1
%     TT(t)=TXT(t)-TXT(t+1);
%    TT(t)=(X(t+1)-X(t))/X(t);
 TT(t)=(X(t+1)-X(t));
   if t>q
    if TT(t)>=0.002&&TT(t)<0.02
        YT(t-q)=1;
    elseif TT(t)>=0.02
        YT(t-q)=2;
    elseif TT(t)<-0.02
        YT(t-q)=-2;
    elseif TT(t)>=-0.002&&TT(t)<0.002
        YT(t-q)=0;
    else
        YT(t-q)=-1;
    end
   end
end

% YYT(ismember(YYT,0,'rows')==1)=[];
% YT(ismember(YT,0,'rows')==1)=[];

index1=find(YT==2);
index2=find(YT==1);
index3=find(YT==0);
index4=find(YT==-1);
index5=find(YT==-2);

n1=size(index1,1);
n2=size(index2,1);
n3=size(index3,1);
n4=size(index4,1);
n5=size(index5,1);


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

S1=zeros(n1,qq);
S2=zeros(n2,qq);
S3=zeros(n3,qq);
S4=zeros(n4,qq);
S5=zeros(n5,qq);

for i1=1:n1
    S1(i1,:)=S(index1(i1),:);
end
for i2=1:n2
    S2(i2,:)=S(index2(i2),:);
end
for i3=1:n3
    S3(i3,:)=S(index3(i3),:);
end
for i4=1:n4
    S4(i4,:)=S(index4(i4),:);
end
for i5=1:n5
    S5(i5,:)=S(index5(i5),:);
end

dd1=paixu(NHDTW(S1,Xs',qq/2));
dd2=paixu(NHDTW(S2,Xs',qq/2));
dd3=paixu(NHDTW(S3,Xs',qq/2));
dd4=paixu(NHDTW(S4,Xs',qq/2));
dd5=paixu(NHDTW(S5,Xs',qq/2));


cjy2=0;
m1=5;
dd=zeros(m1,1);
dd(1)=mean(dd1(1:3));
dd(2)=mean(dd2(1:3));
dd(3)=mean(dd3(1:3));
dd(4)=mean(dd4(1:3));
dd(5)=mean(dd5(1:3));

if min(dd)==dd(1)
    SS=S1;
    ddx=dd1;
    index=index1;
elseif min(dd)==dd(2)
    SS=S2;
    ddx=dd2;
    index=index2;
elseif min(dd)==dd(3)
    SS=S3;
    ddx=dd3;
    index=index3;
elseif min(dd)==dd(4)
    SS=S4;
    ddx=dd4;
    index=index4;
elseif min(dd)==dd(5)
    SS=S5;
    ddx=dd5;
    index=index5;
end

m2=size(SS,1);
if m2>k
SSS=zeros(k,qq);
K=zeros(k,1);
dd=zeros(k,1);
[maxn maxi]=max(ddx);%用于替换，最大值
% mmm=size(X,1);

jjj=1;
while (jjj<=k)
%     jjj=1;%初值
    [minn mini]=min(ddx);%找第一个最小值
%     if mini>=qq&&mini<=(size(YT,1)-q-s)
    K(jjj)=mini;%记录对应的行
    dd(jjj)=minn;%记录对应的最近值
    ddx(mini)=maxn;
    jjj=jjj+1;
%     else
%     dd1(mini)=maxn;
%     end
end
for iii=1:k
    SSS(iii,:)=SS(K(iii),:);
end

H=zeros(1,k)';
for aa=1:k
   H(aa)=TT(index(K(aa))+q);
end

else
    SSS=SS;
    H=zeros(1,size(SS,1))';
    for aa=1:size(SS,1)
        H(aa)=TT(index(aa)+q);
    end
end


kk=30;
kkk=3;
% t1=kk;
temp=zeros(kk,1);

  
[gam,sig2] = tunelssvm({SSS,H,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({SSS,H,'f',gam,sig2,'RBF_kernel'});
%predict next 100 points
% Ytest = simlssvm({SSS,H,'f',gam,sig2,'RBF_kernel'},{alpha,b},Xs');
Ytest = predict({SSS,H,'f',gam,sig2,'RBF_kernel'},Xs,1);

% prediction(zis)=TXT(h0+zis-1)*Ytest+TXT(h0+zis-1);
% %     end
% % end
% zis=zis+1;
% end


    for e=1:kk
       temp(e)=H(e);
    end
    temp=paixu(temp);
    temp0=zeros(2*kkk,1);
    for g=1:kkk
        temp0(g)=temp(g);
        temp0(end-g+1)=temp(end-g+1);
    end
    if Ytest* mean(temp0)<0&&cjy1==0
       prediction(zis)=TXT(h0+zis-1)+abs(mean(temp0))+abs(Ytest);
       cjy1=1;
    else
        if abs(mean(temp0))>0.1
            prediction(zis)=TXT(h0+zis-1)-Ytest;
        else
            prediction(zis)=TXT(h0+zis-1)+abs(mean(temp0)-Ytest);
        end
       cjy1=0;
    end
zis=zis+1;
end

plot(prediction(1:end),'-b+');
hold on;
% plot(Xt((s+1):end),'r')7
plot(TXT(h0+1:H1),'-r*');
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


Xt=TXT(h0+1:H1);
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

