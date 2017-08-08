function [tempx]=updown3(TXT,S,Xs,qq)
h1=size(TXT,1);
TT1=ones(h1-qq,1)*100;
TT2=ones(h1-qq,1)*100;
TT3=ones(h1-qq,1)*100;
TT4=ones(h1-qq,1)*100;
TT5=ones(h1-qq,1)*100;
TT6=ones(h1-qq,1)*100;
TT7=ones(h1-qq,1)*100;
TT8=ones(h1-qq,1)*100;

TT=zeros(h1-qq,1);
DIFF1=zeros(h1-qq,1);
DIFF2=zeros(h1-qq,1);
DIFF3=zeros(h1-qq,1);

YT=zeros(h1-qq,1);

A1=zeros(h1-qq,1);
A2=zeros(h1-qq,1);
A3=zeros(h1-qq,1);
A4=zeros(h1-qq,1);
A5=zeros(h1-qq,1);
A6=zeros(h1-qq,1);
A7=zeros(h1-qq,1);
A8=zeros(h1-qq,1);

for tt=1:h1-qq
    t=tt+qq-1;
    TT(tt)=TXT(t+1)-TXT(t);
    DIFF1(tt)=TXT(t)-TXT(t-1);
    DIFF2(tt)=TXT(t-1)-TXT(t-2);
    DIFF3(tt)=TXT(t-2)-TXT(t-3);
    if DIFF1(tt)>=0&&DIFF2(tt)>=0&&DIFF3(tt)>=0
               TT1(tt)=TT(tt);
               YT(tt)=1;
               A1(tt)=tt;
    elseif DIFF1(tt)>=0&&DIFF2(tt)>=0&&DIFF3(tt)<0
                TT2(tt)=TT(tt);
                YT(tt)=2;
                A2(tt)=tt;
    elseif DIFF1(tt)>=0&&DIFF2(tt)<0&&DIFF3(tt)>=0
                TT3(tt)=TT(tt);
                YT(tt)=3;
                A3(tt)=tt;
    elseif DIFF1(tt)>=0&&DIFF2(tt)<0&&DIFF3(tt)<0
                TT4(tt)=TT(tt);
                YT(tt)=4;
                A4(tt)=tt;                
    elseif DIFF1(tt)<0&&DIFF2(tt)>=0&&DIFF3(tt)>=0
                TT5(tt)=TT(tt);
                YT(tt)=5;
                A5(tt)=tt;
    elseif DIFF1(tt)<0&&DIFF2(tt)>=0&&DIFF3(tt)<0
                TT6(tt)=TT(tt);
                YT(tt)=6;
                A6(tt)=tt;
    elseif DIFF1(tt)<0&&DIFF2(tt)<0&&DIFF3(tt)>=0
               TT7(tt)=TT(tt);
               YT(tt)=7;
               A7(tt)=tt;
    elseif DIFF1(tt)<0&&DIFF2(tt)<0&&DIFF3(tt)<0
               TT8(tt)=TT(tt);
               YT(tt)=8;
               A8(tt)=tt;
    end
end

TT1(ismember(TT1,100,'rows')==1)=[];
TT2(ismember(TT2,100,'rows')==1)=[];
TT3(ismember(TT3,100,'rows')==1)=[];
TT4(ismember(TT4,100,'rows')==1)=[];
TT5(ismember(TT5,100,'rows')==1)=[];
TT6(ismember(TT6,100,'rows')==1)=[];
TT7(ismember(TT7,100,'rows')==1)=[];
TT8(ismember(TT8,100,'rows')==1)=[];

A1(ismember(A1,0,'rows')==1)=[];
A2(ismember(A2,0,'rows')==1)=[];
A3(ismember(A3,0,'rows')==1)=[];
A4(ismember(A4,0,'rows')==1)=[];
A5(ismember(A5,0,'rows')==1)=[];
A6(ismember(A6,0,'rows')==1)=[];
A7(ismember(A7,0,'rows')==1)=[];
A8(ismember(A8,0,'rows')==1)=[];


z=size(S,1);

SS1=zeros(size(A1,1),qq);%最近邻的k个序列

 for y1=1:size(A1,1)
      if A1(y1)<=z
           SS1(y1,:)=S(A1(y1),:);
      else
          TT1(y1)=100;
      end
 end
 SS2=zeros(size(A2,1),qq);%最近邻的k个序列

 for y2=1:size(A2,1)
       if A2(y2)<=z
        SS2(y2,:)=S(A2(y2),:);
       else
        TT2(y2)=100;
       end
 end
 
  SS3=zeros(size(A3,1),qq);%最近邻的k个序列

 for y3=1:size(A3,1)
       if A3(y3)<=z
        SS3(y3,:)=S(A3(y3),:);
       else
        TT3(y3)=100;
       end
 end
 
  SS4=zeros(size(A4,1),qq);%最近邻的k个序列

 for y4=1:size(A4,1)
       if A4(y4)<=z
        SS4(y4,:)=S(A4(y4),:);
        else
        TT4(y4)=100;
       end
 end
 
 SS5=zeros(size(A5,1),qq);%最近邻的k个序列
 for y5=1:size(A5,1)
       if A5(y5)<=z
        SS5(y5,:)=S(A5(y5),:);
        else
        TT5(y5)=100;
       end
 end
 
 SS6=zeros(size(A6,1),qq);%最近邻的k个序列

 for y6=1:size(A6,1)
       if A6(y6)<=z
        SS6(y6,:)=S(A6(y6),:);
       else
        TT6(y6)=100;
       end
 end
 
 SS7=zeros(size(A7,1),qq);%最近邻的k个序列

 for y7=1:size(A7,1)
       if A7(y7)<=z
        SS7(y7,:)=S(A7(y7),:);
       else
        TT7(y7)=100;
       end
 end
 
 SS8=zeros(size(A8,1),qq);%最近邻的k个序列

 for y8=1:size(A8,1)
       if A8(y8)<=z
        SS8(y8,:)=S(A8(y8),:);
       else
        TT8(y8)=100;
       end
 end
 

TT1(ismember(TT1,100,'rows')==1)=[];
TT2(ismember(TT2,100,'rows')==1)=[];
TT3(ismember(TT3,100,'rows')==1)=[];
TT4(ismember(TT4,100,'rows')==1)=[];
TT5(ismember(TT5,100,'rows')==1)=[];
TT6(ismember(TT6,100,'rows')==1)=[];
TT7(ismember(TT7,100,'rows')==1)=[];
TT8(ismember(TT8,100,'rows')==1)=[];

SS1(ismember(SS1,zeros(1,qq),'rows')==1,:)=[];
SS2(ismember(SS2,zeros(1,qq),'rows')==1,:)=[];
SS3(ismember(SS3,zeros(1,qq),'rows')==1,:)=[];
SS4(ismember(SS4,zeros(1,qq),'rows')==1,:)=[];
SS5(ismember(SS5,zeros(1,qq),'rows')==1,:)=[];
SS6(ismember(SS6,zeros(1,qq),'rows')==1,:)=[];
SS7(ismember(SS7,zeros(1,qq),'rows')==1,:)=[];
SS8(ismember(SS8,zeros(1,qq),'rows')==1,:)=[];

Ytest1=Xs(end)-Xs(end-1);
Ytest2=Xs(end-1)-Xs(end-2);
Ytest3=Xs(end-2)-Xs(end-3);

if Ytest1>=0
    Ytest1=1;
else
    Ytest1=-1;
end

if Ytest2>=0
    Ytest2=1;
else
    Ytest2=-1;
end

if Ytest3>=0
    Ytest3=1;
else
    Ytest3=-1;
end

if Ytest1==1&&Ytest2==1&&Ytest3==1
    SS0=SS1;
    H0=TT1;
elseif Ytest1==1&&Ytest2==1&&Ytest3==-1
    SS0=SS2;
    H0=TT2;
elseif Ytest1==1&&Ytest2==-1&&Ytest3==1
    SS0=SS3;
    H0=TT3;
elseif Ytest1==1&&Ytest2==-1&&Ytest3==-1
    SS0=SS4;
    H0=TT4;
elseif Ytest1==-1&&Ytest2==1&&Ytest3==1
    SS0=SS5;
    H0=TT5;
elseif Ytest1==-1&&Ytest2==1&&Ytest3==-1
    SS0=SS6;
    H0=TT6;
elseif Ytest1==-1&&Ytest2==-1&&Ytest3==1
    SS0=SS7;
    H0=TT7;
elseif Ytest1==-1&&Ytest2==-1&&Ytest3==-1
    SS0=SS8;
    H0=TT8;
end

cc=size(H0,1);
for i=1:cc
    if H0(i)>=0
        H0(i)=1;
    else
        H0(i)=-1;
    end
end

[gam,sig2] = tunelssvm({SS0,H0,'c',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});
[alpha,b] = trainlssvm({SS0,H0,'c',gam,sig2,'RBF_kernel'});
tempx= simlssvm({SS0,H0,'c',gam,sig2,'RBF_kernel'},{alpha,b},Xs');
% [gam,sig2] = tunelssvm({SS0,H0,'f',[],[],'RBF_kernel'},'simplex',...
% 'crossvalidatelssvm',{10,'mae'});
% 
% tempx = predict({SS0,H0,'f',gam,sig2,'RBF_kernel'},Xs',1);
% 
% if tempx>=0
%     tempx=1;
% else
%     tempx=-1;
% end