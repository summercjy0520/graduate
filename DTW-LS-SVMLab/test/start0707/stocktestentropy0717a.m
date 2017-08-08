
clear all;
clc;

TXT= importdata('C:\Documents and Settings\Administrator\桌面\cjy\2016\6\data\main\true\zxzq.txt');
%TXT= importdata('C:\Documents and Settings\Administrator\桌面\cjy\2016\7\data\zxzq0703.txt');
TXT=(TXT.textdata(503:end,5))';% end:2015-03~06:2864-2933  %+2000
TXT=str2double(TXT);
[TXT,T1]=mapminmax(TXT);
TXT=TXT(1:end)';
% TXT=(TXT.data(:,2));

ww=70;
prediction=zeros(ww,1);

H1=size(TXT,1);

zis=1;

% h0=h1;
h0=H1-ww;
k=300;
% tempy=0;
class=8;
while(zis<ww+1)
q=15; %时锟斤拷
qq=q+1;
s=1;  %预锟解窗锟斤拷;
% cjy1=0;
% cjy2=0;

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

h1=size(X,1);
TT=zeros(h1-1,1);
% YT=zeros(h1-1,1);

YYT=zeros(h1-1,1);
v=[];
for t=1:h1-1
    TT(t)=X(t+1)-X(t); 
end

[TT,pos]=sort(TT);

w1=fix(size(TT,1)/class);
u1=mod(size(TT,1),class);

TT1=size(class,w1);
for i=1:class
    for j=1:w1
        TT1(i,j)=TT((i-1)*w1+j);
    end
end
       
entropy1=0;
entropy2=entropy(TT((u1+1):end)');
temp0=0;
A1=TT1(1,:);
A2=TT1(2,:);
A3=TT1(3,:);
A4=TT1(4,:);
A5=TT1(5,:);
A6=TT1(6,:);
A7=TT1(7,:);
A8=TT1(8,:);

while (entropy2<entropy1)
    
    entropy1=entropy2;
    length=zeros(class,1);
    length(1)=size(A1,2);
    length(2)=size(A2,2);
    length(3)=size(A3,2);
    length(4)=size(A4,2);
    length(5)=size(A5,2);
    length(6)=size(A6,2);
    length(7)=size(A7,2);
    length(8)=size(A8,2);
    a=max(length);
    TA=ones(class,a)*100;
    TA(1,1:length(1))=A1;
    TA(2,1:length(2))=A2;
    TA(3,1:length(3))=A3;
    TA(4,1:length(4))=A4;
    TA(5,1:length(5))=A5;
    TA(6,1:length(6))=A6;
    TA(7,1:length(7))=A7;
    TA(8,1:length(8))=A8;

    for i=1:class
        TAS=TA(i,:)';
        TAS(ismember(TAS,100,'rows')==1)=[];
        s1=size(TAS,1);
        s2=size(TT,1);
        entropy2=entropy2+(s1/s2)*(entropy(TAS'));
%         entropy2=entropy2+(s1/s2)*(kentropy(TT(i,i),'lin_kernel',0));
    end
%     v=TT1(1,1);
%     tempi=0;
    temp=zeros(class-1,1);
%     temp(1)=size(A1,2);
    mm=10;
    for i=1:class
%         entropy3=0;
        entropy4=0;
%         while temp(i)~=0
%             for h=1:i
%                 tempi=tempi+temp(h);
%             end
%         end
        for j=1:size(TA(i,:),2)/mm
%             v=[v;TT(j+1+temp(i-1))];
            v=TA(i,1:end-mm*(j-1));
            entropy3=entropy4;
            entropy4=entropy(v');
            if entropy4>entropy3
%                 temp(i)=j+temp(i-1);
                temp(i)=size(TA(i,:),2)-mm*(j-1);
            end
        end
    end
    A1=TT(u1+1:temp(2))';
    A2=TT(temp(2)+1:temp(3))';
    A3=TT(temp(3)+1:temp(4))';
    A4=TT(temp(4)+1:temp(5))';
    A5=TT(temp(5)+1:temp(6))';
    A6=TT(temp(6)+1:temp(7))';
    A7=TT(temp(7)+1:temp(8))';
    A8=TT(temp(8)+1:end)';
    
    if all(temp0==temp)
        B1=pos(u1+1:temp(2))';
        B2=pos(temp(2)+1:temp(3))';
        B3=pos(temp(3)+1:temp(4))';
        B4=pos(temp(4)+1:temp(5))';
        B5=pos(temp(5)+1:temp(6))';
        B6=pos(temp(6)+1:temp(7))';
        B7=pos(temp(7)+1:temp(8))';
        B8=pos(temp(8)+1:end)';
        break;
    end
    temp0=temp;
end

SS1=zeros(temp(2)-u1,qq);
for c1=1:temp(2)-u1
    if B1(c1)<z-q
        SS1(c1,:)=S((B1(c1)-q),:);
    end
end

SS2=zeros(temp(3)-temp(2),qq);
for c2=1:temp(3)-temp(2)
    if B2(c2)<z-q
        SS2(c2,:)=S((B2(c2)-q),:);
    end
end

SS3=zeros(temp(4)-temp(3),qq);
for c3=1:temp(4)-temp(3)
    if B3(c3)<z-q
        SS3(c3,:)=S((B3(c3)-q),:);
    end
end

SS4=zeros(temp(5)-temp(4),qq);
for c4=1:temp(5)-temp(4)
    if B4(c4)<z-q
        SS4(c4,:)=S((B4(c4)-q),:);
    end
end

SS5=zeros(temp(6)-temp(5),qq);
for c5=1:temp(6)-temp(5)
    if B5(c5)<z-q
        SS5(c5,:)=S((B5(c5)-q),:);
    end
end

SS6=zeros(temp(7)-temp(6),qq);
for c6=1:temp(7)-temp(6)
    if B6(c6)<z-q
        SS6(c6,:)=S((B6(c6)-q),:);
    end
end

SS7=zeros(temp(8)-temp(7),qq);
for c7=1:temp(8)-temp(7)
    if B7(c7)<z-q
        SS7(c7,:)=S((B7(c7)-q),:);
    end
end

SS8=zeros(size(pos,1)-temp(8),qq);
for c8=1:size(pos,1)-temp(8)
    if B8(c8)<z-q
        SS8(c8,:)=S((B8(c8)-q),:);
    end
end


dd1=NHDTW(SS1,Xs',qq/2);
dd2=NHDTW(SS2,Xs',qq/2);
dd3=NHDTW(SS3,Xs',qq/2);
dd4=NHDTW(SS4,Xs',qq/2);
dd5=NHDTW(SS5,Xs',qq/2);
dd6=NHDTW(SS6,Xs',qq/2);
dd7=NHDTW(SS7,Xs',qq/2);
dd8=NHDTW(SS8,Xs',qq/2);
% dd9=NHDTW(S,Xs',qq/2);

a=zeros(8,1);
a(1)=min(dd1);
a(2)=min(dd2);
a(3)=min(dd3);
a(4)=min(dd4);
a(5)=min(dd5);
a(6)=min(dd6);
a(7)=min(dd7);
a(8)=min(dd8);
min0=min(a);
if min(dd1)==min0
    SS0=SS1;
    H0=A1;
    cjy=0;
elseif min(dd2)==min0
    SS0=SS2;
    H0=A2;
    cjy=1;
elseif min(dd3)==min0
    SS0=SS3;
    H0=A3;
    cjy=2;
elseif min(dd4)==min0
    SS0=SS4;
    H0=A4;
    cjy=3;
elseif min(dd5)==min0
    SS0=SS5;
    H0=A5;
    cjy=4;
elseif min(dd6)==min0
    SS0=SS6;
    H0=A6;
    cjy=5;
elseif min(dd7)==min0
    SS0=SS7;
    H0=A7;
    cjy=6;
elseif min(dd8)==min0
    SS0=SS8;
    H0=A8;
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


[gam,sig2] = tunelssvm({XXX,H,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({XXX,H,'f',gam,sig2,'RBF_kernel'});
%predict next 100 points
tempx = predict({XXX,H,'f',gam,sig2,'RBF_kernel'},Xs,1);

prediction(zis)=TXT(h0+zis-1)+tempx;

zis=zis+1;
end

plot(prediction(1:end),'-b+');
hold on;
% plot(Xt((s+1):end),'r')7
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

