
clear all;
clc;

%TXT= importdata('C:\Documents and Settings\Administrator\桌面\cjy\2016\7\data\zxzq0703.txt');
TXT= importdata('C:\Documents and Settings\Administrator\桌面\cjy\2016\6\data\main\true\zxzq.txt');
TXT=(TXT.textdata(503:end,5))';% end:2015-03~06:2864-2933  %+2000
TXT=str2double(TXT);
[TXT,T1]=mapminmax(TXT);
TXT=TXT(1:end)';
% TXT=(TXT.data(:,2));

ww=15;
prediction=zeros(ww,1);
zis=1;
h1=size(TXT,1);
h0=h1-ww;
k=500;
cjy1=1;

TT=zeros(h1-1,1);
for t=1:h1-1
    TT(t)=TXT(t)-TXT(t+1);
end

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
Xt=TXT((h0+1+zis-1):h1);
XXt=[X;Xt];

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

Xs=XXt((h0-s-q+zis):(h0+zis-s));

% vv=size(index,2)-1;
% S1=zeros(vv,qq);
% YT=zeros(vv,1);
% for iix=1:vv
%     S1(iix,:)=S(iix,:);
%     YT(iix)=TT(index(iix)+q+s);
% % end
% 
% if size(find(abs(YT)>0.01),1)>0.5*size(YT,1)
%     cjy=1;
% else
%     cjy=0;
% end
% 
% if k>size(YT,1)
%     k=size(YT);
% end
dd1=NHDTW(S,Xs',qq/2);

%找临近序列
SS=zeros(k,qq);%最近邻的k个序列
K=zeros(k,1);
dd=zeros(k,1);
[maxn maxi]=max(dd1);%用于替换，最大值
% mmm=size(X,1);

jjj=1;
while (jjj<=k)
%     jjj=1;%初值
    [minn mini]=min(dd1);%找第一个最小值
    if mini>=qq&&mini<=(size(X,1)-qq-s)
    K(jjj)=mini;%记录对应的行
    dd(jjj)=minn;%记录对应的最近值
    dd1(mini)=maxn;
    jjj=jjj+1;
    else
    dd1(mini)=maxn;
    end

end
for iii=1:k
    SS(iii,:)=S(K(iii),:);
end

S0=[SS;Xs'];
[center,U]=KMeans(S0,5);
Ytest=U(end);
index=find(U(:,end)==Ytest);
index(end)=[];
u=size(index,1);
SSS=zeros(u,qq);
for xx=1:u
   SSS(xx,:)=SS(index(xx),:);
end

H=zeros(1,u)';
for aa=1:u
   H(aa)=TT(K(index(aa))+q+s);
end

% kk=30;
% kkk=5;
% % t1=kk;


[gam,sig2] = tunelssvm({SSS,H,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({SSS,H,'f',gam,sig2,'RBF_kernel'});
%predict next 100 points
tempx = predict({SSS,H,'f',gam,sig2,'RBF_kernel'},Xs,1);

% if cjy==1
%     dd2=NHDTW(SS,Xs',qq/2);
%     [maxn1 maxi1]=max(dd2);
%     
%     KK=zeros(kk,1);
%     YYY=zeros(kk,1);
%     hhh=1;
%     while (hhh<=kk)
% %     jjj=1;%初值
%        [minn1 mini1]=min(dd2);%找第一个最小值
%            KK(hhh)=mini1;%记录对应的行
%            dd2(mini1)=maxn1;
%            hhh=hhh+1;
%     end
%     for ggg=1:kk
%        YYY(ggg,:)=H(ggg,:);
%     end 
%     
%         YYY=paixu(YYY);
%         temp0=zeros(2*kkk,1);
%     for g=1:kkk
%         temp0(g)=YYY(g);
%         temp0(end-g+1)=YYY(end-g+1);
%     end
% 
%      prediction(zis)=TXT(h0+zis-1)+tempx+mean(temp0);
% else
% if abs(tempx)>0.005
if cjy1==1
     prediction(zis)=TXT(h0+zis-1)-tempx;
     cjy1=0;
else
     prediction(zis)=TXT(h0+zis-1)+tempx;
     cjy1=1;
end
% else
%      prediction(zis)=TXT(h0+zis-1)-tempx;
% end
% end
zis=zis+1;
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

