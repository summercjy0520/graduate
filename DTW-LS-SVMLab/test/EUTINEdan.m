clear all;
clc;

[NUMERICY,TY,RAWY] = xlsread('data\KNN\Load1997.xls');
[NUMERICY1,TY1,RAWY1] = xlsread('data\KNN\Load1998.xls');
TYT=NUMERICY(2:366,4:51);
TYT1=NUMERICY1(2:366,4:51);
TYT=[TYT;TYT1];
aa=size(TYT,1);
% aaa=aa-qq;
bb=size(TYT,2);
X=zeros(aa,1);
for i=1:aa
%     X(i)=TXT(i);
    X(i)=max(TYT(i,:));%ȡÿһ������ֵ
end

% Q=TXT(5591:5600)';
Xt=[752,702,677,718,738,707,742,745,733,679,744,739,757,760,752,738,692,780,780,790,798,778,726,700,782,791,788,777,789,762,740]';
XXt=[X;Xt];


% k=2*round((mm/2)^(1/2));
k=200;
q=35; %ʱ��
qq=q+1;
% k=6;
% q=1;
% s=2;
% qq=q+1;
% mm=size(TXT(1:(5605-1)),1);

Q=X(end-qq+1:end)';
prediction=zeros(31,1);
for s=1:31   %Ԥ�ⴰ��
% Xtt=XXt((end-size(Xt,1)-q-s+1):end);
X=X(1:(aa-2*s+1));
mmm=size(X,1);

z=aa-2*s-q+1;
S=zeros(z,qq);
h=0; %�����ƶ�ʱ��Ӱ���ԭ���б�ǩ

for i=1:(z-1)
    for j=1:qq
    if h+j<=(aa+1)
    S(i,j)=X(h+j);
%     S(i,2*j)=X(h+2*j);
    end
    end
    h=h+1;
end   %д�úܰ�����


% Q=Xt;

% %��һ�μ����Ͼ���
dd1=NHDTW(S,Q,qq/2);

%����DTW�㷨
% dd1=zeros(z,1);
% dist = zeros(qq,qq);  
% for a=1:z
%     test=S(a,:);
% for i=1:qq  
%     for j=1:qq    
%         dist(i,j) = DTW(test(i), Q(j));  
%     end
% end
% 
% % for i=1:qq     
% %     [d,j] = min(dist(i,:));     
% % end
% dd1(a)=dist(qq,qq);
% end

%���ٽ�����
SS=zeros(k,qq);%����ڵ�k������
K=zeros(k,1);
[maxn maxi]=max(dd1);%�����滻�����ֵ

jjj=1;
while (jjj<=k)
%     jjj=1;%��ֵ
    [minn mini]=min(dd1);%�ҵ�һ����Сֵ
    if mini>=qq&&mini<=(mmm-q-s)
    K(jjj)=mini;%��¼��Ӧ����
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

%����2q+3��Z����&&������
Z=zeros(qq,k);
% t=zeros(k,1);%����ѡ����ٽ������±�
% t=K;
% for m=1:k
%     t(m)=K(m)-q;
% end
for n=1:qq
    for nn=1:k
    mnn=K(nn)+n-1;
    Z(n,nn)=X(mnn);%��ʽ��7��
%     Z(2*n,nn)=Y(mnn);%��ʽ��7��
%     nn=nn+1;
    end
%     n=n+1;
end   %�ܰ�~~

H=zeros(1,k);
MI=zeros(qq,1);%�洢Z������H֮��Ļ���Ϣ��С�����ڱȽ�
%���㻥��ϢMI�Ĵ�С
for tt=1:k
    H(tt)=X(K(tt)+q+s);
end
for a=1:qq
    MI(a)=mi(Z(a,:)',H'); %���ú������MIֵ
end


M=[]; %��ʼ��{}�����Ԫ��
% s0=s;
d=12;
d0=12;
temp=zeros(d0,k);%���ڴ洢ѡ������Ĳ���ѵ�����ж�Ӧ�����,�����ܴ���q
% % MI��������ÿ����һ��ZiҪ��ô������֪�����s��z����
tem=zeros(d0,1);%���ڴ洢ÿ��ѡ����������ж�Ӧ��ʱ�̵�
Z0=Z;
while(d>0)
    for j=1:d0
    [maxx,maxi]=max(MI);
    tem(j)=maxi;
    temp(j,:)=Z(maxi,:);
    M=[M Z(maxi,:)']; %ÿ�ν�ѡ��õ�Z���мӽ�����ҲҪ�������ѵ����������ȡ
    Z(maxi,:)=zeros(1,k);%��ȥѡ�е���һ��....����ֵ
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
%         break;  %��ֹ����
        
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

% d=s-s0; %̰���㷨�õ������յ�ʱ��
SSS=zeros(k,d0);%kΪ��Ӧ��ԭ��Z��������ÿ�����еĳ���
SSY=zeros(k,1);
% temp=[1,2]';
%�õ�s��z���У�Ҳ�Ϳ��Եõ���Ӧ��Ԥ������
for b=1:k
    for bb=1:d0
    SSS(b,bb)=temp(bb,b);
    SSY(b)=H(b); %ÿ�����ж�Ӧ��Ԥ��ֵ
%     bb=bb+1; 
    end
%     b=b+1;%ѭ��һ�εõ�һ��Ŀ������
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
    SSQ(i)=Q(tem(i));%ȡ��Ӧʱ�̵�ֵ
end

%ģ���Ƶ�������
%���ݹ�ʽ��10����ñ���sai��ֵ��������cjy��ʾ����
%�ڶ��μ����Ͼ���
mediann=median(X); %��ȡ����ѵ����������λֵ
mn=size(X,1);
ymedian=zeros(mn,1);
for ff=1:mn
    ymedian(ff)=X(ff)-mediann;
%     ff=ff+1;
end
ymediann=max(abs(ymedian));%�ڶ����������ӵķ�ĸ
cjy1=zeros(k,1);%��ű�����һ����������
cjy2=zeros(k,1);%��ű����ڶ�����������
cjy=zeros(k,1);%����������
for f=1:k
%     cjy1(f)=NH(SSS(f,:),SSQ,d0/2);
    cjy1(f)=NHDTW(SSS(f,:),SSQ,(d0-1)/2);
% %����DTW�㷨
%      dist = zeros(d0,d0);  
%      for a=1:k
%      test=S(a,:);
%      for i=1:d0  
%          for j=1:d0    
%             dist(i,j) = DTW(test(i), Q(j));  
%          end
%       end
% 
%           cjy1(a)=dist(d0,d0);
%      end
    cjy2(f)=abs(X(f)-mediann)/ymediann;
    cjy(f)=exp((-1/2)*(cjy1(f)+cjy2(f)));
end


%��Ӧ��SVMģ�����棬������Ե������ǹ�������ĺ������õ�alpha��b����Ԥ��

% SST=Xt;%Ԥ������
% SSS=[SSS;SSS];
% SSY=[SSY;SSY];
%tunel ����
[gam,sig2] = tunelssvm({SSS,SSY,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% gam=400;
% sig2=40;
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
ylabel('Values of EUNITE database');
title('the example 1 of KNN');


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
W=0;
for i=1:mn
    w=w+abs(prediction(i)-Xt(i));
    W=W+(prediction(i)-Xt(i))^2;
end
mae=w/mn;
rmse=sqrt(W/mn);