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
% 

clear all;
clc;

TXT= importdata('data\KNN\Laser.txt');
TXT1= importdata('data\KNN\Lasercon.txt');
TXT=[TXT;TXT1];


C=95;%向前预测多少个样本点
prediction=zeros(C,1);
for jia=1:C
    
X=TXT(1:(5605+jia-1));
% Q=TXT(5591:5600)';
Xt=TXT((5605+jia):5700);
XXt=[X;Xt];

q=9; %时滞
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

% 第一次计算混合距离
% dd0=NHDTWnew0(S,Q);

dd1=NHDTWnew0(S,Q);

[K]=FuzzyEntropy(dd1);
k=size(K,1);
% %找临近序列
SS=zeros(k,qq);%最近邻的k个序列
% K=zeros(k,1);
% [maxn maxi]=max(dd1);%用于替换，最大值
% 
% jjj=1;
% while (jjj<=k)
% %     jjj=1;%初值
%     [minn mini]=min(dd1);%找第一个最小值
%     if mini>=qq&&mini<=(mmm-q-s)
%     K(jjj)=mini;%记录对应的行
%     dd1(mini)=maxn;
%     jjj=jjj+1;
%     else
%     dd1(mini)=maxn;
%     end   
% %     jjj=jjj+1;
% end
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