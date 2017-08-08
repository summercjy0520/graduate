clear all;
clc;

TXT= importdata('data\KNN\Laser.txt');
TXT1= importdata('data\KNN\Lasercon.txt');
TXT=[TXT;TXT1];

% [TXT,TX,RAW] = xlsread('data\KNN\EGtemperature.xlsx');
% [TXT,T1]=mapminmax(TXT);
% TXT=TXT(1:end);

C=25;%向前预测多少个样本点
prediction=zeros(C,1);
Gam=zeros(C,1);
Sig2=zeros(C,1);
Omega=zeros(C,1);
TrainDiff=zeros(C,1);
TrainDiffx=zeros(C,1);
Number=zeros(C,1);

k=100;
jia=22;
for zis=1:C
    
X=TXT(1:(5605+jia-1));
% Q=TXT(5591:5600)';
Xt=TXT((5605+jia):5700);
XXt=[X;Xt];


% k=2*round((mm/2)^(1/2));

q=8; %时滞
qq=q+1;
s=1;  %预测窗口
% k=6;
% q=1;
% s=2;
% qq=q+1;
mm=size(TXT(1:(5605+jia-1)),1);
Xtt=XXt((end-size(Xt,1)-q-s+1):end);
MN=X(1:(mm+1-s));
X=X(1:(mm+1-s));
mmm=size(X,1);


z=mm-s-qq+1;
S=zeros(z,qq);
h=0; %用于移动时滞影响的原序列标签

for i=1:z
    for j=1:qq
    if h+j<=mm
    S(i,j)=X(h+j);
%     S(i,2*j)=X(h+2*j);
    end
    end
    h=h+1;
end   %写得很棒！！

Q=Xtt(1:qq)';

% Q=Xt;


dd1=NHDTWnew0(S,Q);


%找临近序列
SS=zeros(k,qq);%最近邻的k个序列
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

class=1:size(SS,1);
p=class(randi(end,1,1));
temp=zeros(2*q,qq);
pivor=1;
SA=SS;
while(isempty(SS)==0)
    index=K(p);
    if index<qq
        temp(1:index-1,:)=S(1:index-1,:);
        temp(qq:2*q,:)=S(index+1:index+q,:);
    elseif index>z-q
        temp(1:q,:)=S((index-q):(index-1),:);
        temp(qq:(qq+(z-index-1)),:)=S(index+1:end,:);
    else
        temp(1:q,:)=S((index-q):(index-1),:);
        temp(qq:2*q,:)=S(index+1:index+q,:);
    end
    TM=intersect(SS,temp,'rows');
    if size(TM,1)>0
        TM=[TM;SA(p,:)];
        for j=1:size(TM,1)
            for i=1:size(SS,1)
                if all(SS(i,:)==TM(j,:))==1
                    SS(i,:)=zeros(1,qq);
                end
            end
        end
        SS(ismember(SS,zeros(1,qq),'rows')==1,:)=[];
        dtemp=NHEHDTW(TM,Q); %NHDTWnew1219NHEH0306
%         dtemp=pdist2(TM,Q);
        [mtemp mitemp]=min(dtemp);
        p=find(ismember(SA,TM(mitemp,:),'rows'));
        if ismember(pivor,p,'rows')==0
            pivor=[pivor;p];
        end
%         pivor=[pivor;TM(mitemp,:)];
    else
%         if ismember(pivor,p,'rows')==0
%              pivor=[pivor;p];
% %             pivor=[pivor;SA(p,:)];
%         end
        for i=1:size(SS,1)
            if all(SS(i,:)==SA(p,:))==1
                SS(i,:)=zeros(1,qq);
            end
        end
        SS(ismember(SS,zeros(1,qq),'rows')==1,:)=[];
        class=1:size(SA,1); %SS
        p=class(randi(end,1,1));
    end
end

SSA=zeros(size(pivor,1),qq);%最近邻的k个序列
for iii=1:size(pivor,1)
    SSA(iii,:)=SA(pivor(iii),:);
end

kk=size(pivor,1);
H=zeros(1,kk)';
for aa=1:kk
    H(aa)=X(K(pivor(aa))+q+s);
end

%tunel 过程
[gam,sig2] = tunelssvm({SSA,H,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

[alpha,b,Maxomega] = trainlssvmtest({SSA,H,'f',gam,sig2,'RBF_kernel'});

%predict
prediction(zis) = predict({SSA,H,'f',gam,sig2,'RBF_kernel'},Q,1);
% prediction(jia) = predictknn({SSS,SSY,'f',gam,sig2,'RBF_kernel'},SSQ,cjy,1);
sum=0;
Sum=0;
for i=1:size(H,1)
    Sum=sum+((H(i)-TXT(5605+jia))/TXT(5605+jia))^2;
    sum=sum+(H(i)-TXT(5605+jia))^2;
end
TrainDiff(zis)=sum/size(H,1);
TrainDiffx(zis)=Sum/size(H,1);
Number(zis)=size(H,1);

Gam(zis)=gam;
Sig2(zis)=sig2;
Omega(zis)=Maxomega;
k=k+100;
end
% end

plot(prediction(1:end),'-+');
hold on;
% plot(Xt((s+1):end),'r')
plot(TXT(5606:5700),'-r*');
xlabel('time');
ylabel('Values of Laser database');
title('DTW:mae=2.2339,rmse=6.8317');

Xt=TXT(5606:5700);
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
