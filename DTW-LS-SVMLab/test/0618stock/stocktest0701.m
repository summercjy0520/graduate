
clear all;
clc;

TXT= importdata('C:\Documents and Settings\Administrator\桌面\cjy\2016\7\data\zxzq0703.txt');
TXT=(TXT.textdata(503:end,3))';% end:2015-03~06:2864-2933  %+2000
TXT=str2double(TXT);
[TXT,T1]=mapminmax(TXT);
TXT=TXT(1:end)';
% TXT=(TXT.data(:,2));

ww=1;
prediction=zeros(ww,1);
zis=1;
h1=size(TXT,1);
TT=zeros(h1-1,1);
YT=zeros(h1-1,1);
YYT=zeros(h1-1,1);
v=[];
for t=1:h1-1
    TT(t)=TXT(t)-TXT(t+1);
    if TT(t)>=0
        YT(t)=1;
    else
        YT(t)=-1;
    end
    if abs(TT(t))>=0.01
        YYT(t)=1;
        v=[v;t];
        YYT(t)=YT(t);
        YT(t)=0;
    end
end

YYT(ismember(YYT,0,'rows')==1)=[];
YT(ismember(YT,0,'rows')==1)=[];

h0=h1;
% h0=h1-ww;
k=300;
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

vv=size(v,1);
V=zeros(vv,qq);
HV=zeros(vv,1);
for l=1:vv
    if v(l)>q+s&&v(l)<=z+q+s
        V(l,:)=S(v(l)-q-s,:);
        HV(l)=YT(l);
    end
end

S0=S;
S(ismember(S,V,'rows')==1,:)=[];

Ytra=X(s+qq:end);
Xs=XXt((h0-s-q+zis):(h0+zis-s));
% d=3;

dd1=NHDTW(S,Xs',qq/2);
dd3=NHDTW(V,Xs',qq/2);

% cjy2=0;

if min(dd1)<min(dd3)
cjy=1;
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
    if mini>=qq&&mini<=(size(YT,1)-q-s)
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

H=zeros(1,k)';
for aa=1:k
   H(aa)=YT(K(aa)+q+s);
end

else
    if vv<k
        k=200;
    end
    cjy=0;
    SS=zeros(k,qq);%最近邻的k个序列
     K=zeros(k,1);
    [maxn2 maxi2]=max(dd3);%用于替换，最大值

jjj=1;
while (jjj<=k)
    [minn2 mini2]=min(dd3);%找第一个最小值
    if mini2>=qq&&mini2<=(size(HV,1)-q-s)
    K(jjj)=mini2;%记录对应的行
    dd3(mini2)=maxn2;
    jjj=jjj+1;
    else
    dd3(mini2)=maxn2;
    end   
 
end
for iii=1:k
    SS(iii,:)=S0(v(iii),:);
end 

H=zeros(1,k)';
for aa=1:k
   H(aa)=HV(K(aa)+q+s);
end
end

kk=30;
kkk=5;
% t1=kk;


  
[gam,sig2] = tunelssvm({SS,H,'c',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({SS,H,'c',gam,sig2,'RBF_kernel'});
%predict next 100 points
Ytest = simlssvm({SS,H,'c',gam,sig2,'RBF_kernel'},{alpha,b},Xs');

B=(1:h1-1)';
B(ismember(B,v,'rows')==1,:)=[];


% kk=size(find(H==Ytest),1);
SSS=zeros(k,qq);
YY=ones(k,1)*10;
if cjy==1
    for e=1:k
        if H(e)==Ytest
           SSS(e,:)=SS(e,:);
           YY(e)=TT(B(K(e)));
        end
    end
%     temp=paixu(temp);
%     temp0=zeros(2*kkk,1);
%     for g=1:kkk
%         temp0(g)=temp(g);
%         temp0(end-g+1)=temp(end-g+1);
%     end
%     prediction(zis)=TXT(h0+zis-1)+mean(temp0);
else
    for e=1:k
        if H(e)==Ytest
            SSS(e,:)=SS(e,:); 
            YY(e)=TT(v(K(e)));
        end
%     if TT(v(K(e)))>=0
%            cjy1=cjy1+1;
%        else
%            cjy2=cjy2+1;
%     end
    end
%     temp=paixu(temp);
%     temp0=zeros(2*kkk,1);
%     for g=1:kkk
%         temp0(g)=temp(end-kkk*2+g);
%         temp0(end-g+1)=temp(end-g+1);
%     end
%     if Ytest==1||cjy1>=cjy2
%        prediction(zis)=TXT(h0+zis-1)+mean(temp0);
%     else
%        prediction(zis)=TXT(h0+zis-1)-mean(temp0);
%     end
end
tempp=zeros(1,qq);
SSS(ismember(SSS,tempp,'rows')==1,:)=[];
YY(ismember(YY,10,'rows')==1)=[];

[gamt,sigt2] = tunelssvm({SSS,YY,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alphat,bt] = trainlssvm({SSS,YY,'f',gamt,sigt2,'RBF_kernel'});
%predict next 100 points
tempx = predict({SSS,YY,'f',gamt,sigt2,'RBF_kernel'},Xs,1);

if cjy==0
%     
    dd2=NHDTW(SSS,Xs',qq/2);
    [maxn1 maxi1]=max(dd2);
    
    KK=zeros(kk,1);
    YYY=zeros(kk,1);
    hhh=1;
    while (hhh<=kk)
%     jjj=1;%初值
       [minn1 mini1]=min(dd2);%找第一个最小值
           KK(hhh)=mini1;%记录对应的行
           dd2(mini1)=maxn1;
           hhh=hhh+1;
    end
    for ggg=1:kk
       YYY(ggg,:)=YY(ggg,:);
    end 
    
        YYY=paixu(YYY);
        temp0=zeros(2*kkk,1);
    for g=1:kkk
        temp0(g)=YYY(g);
        temp0(end-g+1)=YYY(end-g+1);
    end
%     cjy1=length(find(YYY<0));
%     cjy2=length(find(YYY>0));
    if cjy1==1
        prediction(zis)=TXT(h0+zis-1)-mean(temp0)-tempx;
        cjy1=0;
    else
        prediction(zis)=TXT(h0+zis-1)+mean(temp0)+tempx;
        cjy1=1;
    end
else
    prediction(zis)=TXT(h0+zis-1)+tempx;
end

% prediction(zis)=TXT(h0+zis-1)+temp;
zis=zis+1;
end

plot(prediction(1:end),'-b+');
hold on;
% plot(Xt((s+1):end),'r')7
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

