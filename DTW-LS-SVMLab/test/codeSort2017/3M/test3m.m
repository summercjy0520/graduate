% X=[16,14,22,10,14,17,10,13,19,12,18,11]';
% Y=[77,70,85,50,62,70,55,63,88,57,81,51]';
% X=X(1:11);
% Y=Y(1:11);
% Q=11;
% [gam,sig2] = tunelssvm({X,Y,'f',[],[],'lin_kernel'},'simplex',...
% 'crossvalidatelssvm',{3,'mae'});
% [alpha,b] = trainlssvm({X,Y,'f',gam,sig2,'lin_kernel'});
% plotlssvm({X,Y,'f',gam,sig2,'lin_kernel'},{alpha,b});
% prediction = predict({X,Y,'f',gam,sig2,'lin_kernel'},Q,1);
% % 
% 
% % open('C:\Documents and Settings\Administrator\桌面\cjy\2017\3\9\SVM(s=600).fig')
% % lh=get(gca,'Children');
% % ydata=get(lh,'Ydata');
% %  yy=ydata{1};
% %  xx=ydata{2};
%  
% 
clear all;
clc;

TXT= importdata('E:\cjy\2017\dataset\abalone.txt');
% TXT1= importdata('E:\cjy\2017\dataset\abalone_test.txt');
% TXT=[TXT;TXT1];


C=100;%向前预测多少个样本点

h1=size(TXT,1);
h0=h1-C;
qq=size(TXT,2);

prediction=zeros(C,1);
for jia=1:C
    
S=TXT(1:(h0+jia-1),:);
k=150;

Q=TXT(h0+jia,:);

dd1=NHDTWnew0(S,Q);

% [K]=FuzzyEntropy(dd1);
% k=size(K,1);
% %找临近序列
SS=zeros(k,qq);%最近邻的k个序列
K=zeros(k,1);
[maxn maxi]=max(dd1);%用于替换，最大值

jjj=1;
while (jjj<=k)
%     jjj=1;%初值
    [minn mini]=min(dd1);%找第一个最小值
    K(jjj)=mini;%记录对应的行
    dd1(mini)=maxn;
    jjj=jjj+1;

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
        dtemp=NHDTWnew0(TM,Q);
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

k=size(pivor,1);
H=zeros(k,1);
for aa=1:k
    H(aa)=X(K(pivor(aa))+q+s);
end


%tunel 过程
[gam,sig2] = tunelssvm({SSA,H,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% [alpha,b] = trainlssvmknn({SSA,H,'f',gam,sig2,'poly_kernel'},cjy); %lin_kernel

prediction(jia) = predict({SSA,H,'f',gam,sig2,'RBF_kernel'},Q,1);

end