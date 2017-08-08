
clear all;
clc;

TXT= importdata('data\KNN\Laser.txt');
TXT1= importdata('data\KNN\Lasercon.txt');
TXT=[TXT;TXT1];


ww=100;
prediction=zeros(ww,1);

H1=size(TXT,1);

zis=1;

% h0=h1;
h0=H1-ww;
k=300;
tempy=0;
while(zis<ww+1)
q=9; %ʱ��
qq=q+1;
s=1;  %Ԥ�ⴰ��;
cjy1=0;
cjy2=0;
h1=size(TXT,1);
TT1=ones(h1-1,1)*0.01;
TT2=ones(h1-1,1)*0.01;
TT3=ones(h1-1,1)*0.01;
TT4=ones(h1-1,1)*0.01;
TT=zeros(h1-1,1);
YT=zeros(h1-1,1);

A1=zeros(h1-1,1);
A2=zeros(h1-1,1);
A3=zeros(h1-1,1);
A4=zeros(h1-1,1);

YYT=zeros(h1-1,1);
v=[];
for t=1:h1-1
    TT(t)=(TXT(t+1)-TXT(t))/TXT(t);
%     TT(t)=TXT(t+1)-TXT(t);
    if TT(t)>=0
%         YT(t)=1;
        if abs(TT(t))>=0.01
            TT1(t)=TT(t);
            YT(t)=2;
            A1(t)=t;
        else
            TT2(t)=TT(t);
            YT(t)=1;
            A2(t)=t;
        end
    else
%         YT(t)=-1;
        if abs(TT(t))>=0.01
           TT3(t)=TT(t);
           YT(t)=-2;
           A3(t)=t;
        else
            TT4(t)=TT(t);
            YT(t)=-1;
            A4(t)=t;
        end
    end
   
end

TT1(ismember(TT1,0.01,'rows')==1)=[];
TT2(ismember(TT2,0.01,'rows')==1)=[];
TT3(ismember(TT3,0.01,'rows')==1)=[];
TT4(ismember(TT4,0.01,'rows')==1)=[];

A1(ismember(A1,0,'rows')==1)=[];
A2(ismember(A2,0,'rows')==1)=[];
A3(ismember(A3,0,'rows')==1)=[];
A4(ismember(A4,0,'rows')==1)=[];



X=TXT(1:h0+zis-1);
% Q=TXT(5591:5600)';
Xt=TXT((h0+1+zis-1):H1);
XXt=[X;Xt];

Xs=XXt((h0-s-q+zis):(h0+zis-s));

mm=size(TXT(1:(h0-1+zis)),1);

z=mm-s-qq+1;
S=zeros(z,qq);
h=0; %�����ƶ�ʱ��Ӱ���ԭ���б��?

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
[maxn maxi]=max(dd1);%�����滻�����ֵ
% mmm=size(X,1);

jjj=1;
while (jjj<=k)
%     jjj=1;%��ֵ
    [minn mini]=min(dd1);%�ҵ�һ����Сֵ
    if mini>=qq&&mini<=(size(YT,1)-q)
    K(jjj)=mini;%��¼��Ӧ����
    dd(jjj)=minn;%��¼��Ӧ�����ֵ
    dd1(mini)=maxn;
    jjj=jjj+1;
    else
    dd1(mini)=maxn;
    end

end
SS=zeros(k,qq);%����ڵ�k������
Y1=zeros(k,1);
for iii=1:k
    SS(iii,:)=S(K(iii),:);
    Y1(iii)=YT(K(iii)+q);
end

V1=Y1;
V1(ismember(V1,2,'rows')==1,:)=1;
V1(ismember(V1,-2,'rows')==1,:)=-1;

[gam,sig2] = tunelssvm({SS,V1,'c',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({SS,V1,'c',gam,sig2,'RBF_kernel'});
%predict next 100 points
Ytest1 = simlssvm({SS,V1,'c',gam,sig2,'RBF_kernel'},{alpha,b},Xs');

V2=YT;
V2(ismember(V2,2,'rows')==1,:)=1;
V2(ismember(V2,-2,'rows')==1,:)=-1;

index=find(V2(16:z+q)==Ytest1);
c1=size(index,1);
SSS=zeros(c1,qq);
V3=zeros(c1,1);
for i=1:c1
    SSS(i,:)=S(index(i),:);
    V3(i)=YT(index(i)+q);
end

if Ytest1==1
    V3(ismember(V3,2,'rows')==1,:)=-1;
else
    V3(ismember(V3,-2,'rows')==1,:)=1;
end

kn=300;
dd0=NHDTW(SSS,Xs',qq/2);

KN=zeros(kn,1);
[maxn0 maxi]=max(dd0);%�����滻�����ֵ
% mmm=size(X,1);

jjj=1;
while (jjj<=kn)
%     jjj=1;%��ֵ
    [minn0 mini0]=min(dd0);%�ҵ�һ����Сֵ
    KN(jjj)=mini0;%��¼��Ӧ����
    dd0(mini0)=maxn0;
    jjj=jjj+1;
end
SSS1=zeros(kn,qq);%����ڵ�k������
V30=zeros(kn,1);
for iii=1:kn
    SSS1(iii,:)=SSS(KN(iii),:);
    V30(iii)=V3(KN(iii));
end

if all(V30==1)
    Ytest2=1;
elseif all(V30==-1)
    Ytest2=-1;
else
[gamt,sigt2] = tunelssvm({SSS1,V30,'c',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alphat,bt] = trainlssvm({SSS1,V30,'c',gamt,sigt2,'RBF_kernel'});
%predict next 100 points
Ytest2 = simlssvm({SSS1,V30,'c',gamt,sigt2,'RBF_kernel'},{alphat,bt},Xs');
end

SS1=zeros(size(A1,1),qq);%����ڵ�k������

 for y1=1:size(A1,1)
      if A1(y1)>qq&&A1(y1)<=z+qq
           SS1(y1,:)=S(A1(y1)-qq,:);
      else
          TT1(y1)=0.01;
      end
 end
 SS2=zeros(size(A2,1),qq);%����ڵ�k������

 for y2=1:size(A2,1)
       if A2(y2)>qq&&A2(y2)<=z+qq
        SS2(y2,:)=S(A2(y2)-qq,:);
       else
        TT2(y2)=0.01;
       end
 end
 
  SS3=zeros(size(A3,1),qq);%����ڵ�k������

 for y3=1:size(A3,1)
       if A3(y3)>qq&&A3(y3)<=z+qq
        SS3(y3,:)=S(A3(y3)-qq,:);
       else
        TT3(y3)=0.01;
       end
 end
 
  SS4=zeros(size(A4,1),qq);%����ڵ�k������

 for y4=1:size(A4,1)
       if A4(y4)>qq&&A4(y4)<=z+qq
        SS4(y4,:)=S(A4(y4)-qq,:);
       else
        TT4(y4)=0.01;
       end
 end
 
TT1(ismember(TT1,0.01,'rows')==1)=[];
TT2(ismember(TT2,0.01,'rows')==1)=[];
TT3(ismember(TT3,0.01,'rows')==1)=[];
TT4(ismember(TT4,0.01,'rows')==1)=[];

SS1(ismember(SS1,zeros(1,qq),'rows')==1,:)=[];
SS2(ismember(SS2,zeros(1,qq),'rows')==1,:)=[];
SS3(ismember(SS3,zeros(1,qq),'rows')==1,:)=[];
SS4(ismember(SS4,zeros(1,qq),'rows')==1,:)=[];


dd2=NHDTW(SS1,Xs',qq/2);
dd3=NHDTW(SS2,Xs',qq/2);
dd4=NHDTW(SS3,Xs',qq/2);
dd5=NHDTW(SS4,Xs',qq/2);

a=zeros(4,1);
if isempty(dd2)==1
    a(1)=inf;
else
    a(1)=min(dd2);
end
if isempty(dd3)==1
    a(2)=inf;
else
    a(2)=min(dd3);
end
if isempty(dd4)==1
    a(3)=inf;
else
    a(3)=min(dd4);
end
if isempty(dd5)==1
    a(4)=inf;
else
    a(4)=min(dd5);
end
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
end

km=300;

dd0=NHDTW(SS0,Xs',qq/2);

KK=zeros(km,1);
[maxn0 maxi0]=max(dd0);%�����滻�����ֵ
% mmm=size(X,1);

jjj=1;
while (jjj<=km)
%     jjj=1;%��ֵ
    [minn0 mini0]=min(dd0);%�ҵ�һ����Сֵ
    KK(jjj)=mini0;%��¼��Ӧ����
    dd0(mini0)=maxn0;
    jjj=jjj+1;
end
SSS=zeros(km,qq);%����ڵ�k������
H=zeros(km,1);
for iii=1:km
    SSS(iii,:)=SS0(KK(iii),:);
    H(iii)=H0(KK(iii));
end


[gam,sig2] = tunelssvm({SSS,H,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({SSS,H,'f',gam,sig2,'RBF_kernel'});
%predict next 100 points
tempx = predict({SSS,H,'f',gam,sig2,'RBF_kernel'},Xs,1);

prediction(zis)=TXT(h0+zis-1)*(1+tempx);
zis=zis+1;
end

plot(prediction(1:end),'-b+');
hold on;
% plot(Xt((s+1):end),'r')7
plot(TXT(h0+1:H1),'-r*');
xlabel('time');

ylabel('Values of stockdata');
title('stock data test');


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

