function [tempx]=updown(TXT,S,Xs,qq)
h1=size(TXT,1);
TT1=ones(h1-qq,1)*100;
TT2=ones(h1-qq,1)*100;
TT3=ones(h1-qq,1)*100;
TT4=ones(h1-qq,1)*100;
TT5=ones(h1-qq,1)*100;
TT6=ones(h1-qq,1)*100;
TT7=ones(h1-qq,1)*100;
TT8=ones(h1-qq,1)*100;
TT9=ones(h1-qq,1)*100;
TT10=ones(h1-qq,1)*100;
TT11=ones(h1-qq,1)*100;
TT12=ones(h1-qq,1)*100;
TT13=ones(h1-qq,1)*100;
TT14=ones(h1-qq,1)*100;
TT15=ones(h1-qq,1)*100;
TT16=ones(h1-qq,1)*100;

TT=zeros(h1-qq,1);
DIFF1=zeros(h1-qq,1);
DIFF2=zeros(h1-qq,1);
DIFF3=zeros(h1-qq,1);
DIFF4=zeros(h1-qq,1);

YT=zeros(h1-qq,1);

A1=zeros(h1-qq,1);
A2=zeros(h1-qq,1);
A3=zeros(h1-qq,1);
A4=zeros(h1-qq,1);
A5=zeros(h1-qq,1);
A6=zeros(h1-qq,1);
A7=zeros(h1-qq,1);
A8=zeros(h1-qq,1);
A9=zeros(h1-qq,1);
A10=zeros(h1-qq,1);
A11=zeros(h1-qq,1);
A12=zeros(h1-qq,1);
A13=zeros(h1-qq,1);
A14=zeros(h1-qq,1);
A15=zeros(h1-qq,1);
A16=zeros(h1-qq,1);

for tt=1:h1-qq
    t=tt+qq-1;
    TT(tt)=TXT(t+1)-TXT(t);
    DIFF1(tt)=TXT(t+1)-TXT(t-1);
    DIFF2(tt)=TXT(t-1)-TXT(t-2);
    DIFF3(tt)=TXT(t-2)-TXT(t-3);
    DIFF4(tt)=TXT(t-3)-TXT(t-4);
    if DIFF1(tt)>=0&&DIFF2(tt)>=0&&DIFF3(tt)>=0&&DIFF4(tt)>=0
               TT1(tt)=TT(tt);
               YT(tt)=1;
               A1(tt)=tt;
    elseif DIFF1(tt)>=0&&DIFF2(tt)>=0&&DIFF3(tt)>=0&&DIFF4(tt)<0
                TT2(tt)=TT(tt);
                YT(tt)=2;
                A2(tt)=tt;
    elseif DIFF1(tt)>=0&&DIFF2(tt)>=0&&DIFF3(tt)<0&&DIFF4(tt)>=0
                TT3(tt)=TT(tt);
                YT(tt)=3;
                A3(tt)=tt;
    elseif DIFF1(tt)>=0&&DIFF2(tt)>=0&&DIFF3(tt)<0&&DIFF4(tt)<0
                TT4(tt)=TT(tt);
                YT(tt)=4;
                A4(tt)=tt;                
    elseif DIFF1(tt)>=0&&DIFF2(tt)<0&&DIFF3(tt)>=0&&DIFF4(tt)>=0
                TT5(tt)=TT(tt);
                YT(tt)=5;
                A5(tt)=tt;
    elseif DIFF1(tt)>=0&&DIFF2(tt)<0&&DIFF3(tt)>=0&&DIFF4(tt)<0
                TT6(tt)=TT(tt);
                YT(tt)=6;
                A6(tt)=tt;
    elseif DIFF1(tt)>=0&&DIFF2(tt)<0&&DIFF3(tt)<0&&DIFF4(tt)>=0
               TT7(tt)=TT(tt);
               YT(tt)=7;
               A7(tt)=tt;
    elseif DIFF1(tt)>=0&&DIFF2(tt)<0&&DIFF3(tt)<0&&DIFF4(tt)<0
               TT8(tt)=TT(tt);
               YT(tt)=8;
               A8(tt)=tt;
    elseif DIFF1(tt)<0&&DIFF2(tt)>=0&&DIFF3(tt)>=0&&DIFF4(tt)>=0
               TT9(tt)=TT(tt);
               YT(tt)=-1;
               A9(tt)=tt;
    elseif DIFF1(tt)<0&&DIFF2(tt)>=0&&DIFF3(tt)>=0&&DIFF4(tt)<0
                TT10(tt)=TT(tt);
                YT(tt)=-2;
                A10(tt)=tt;
    elseif DIFF1(tt)<0&&DIFF2(tt)>=0&&DIFF3(tt)<0&&DIFF4(tt)>=0
                TT11(tt)=TT(tt);
                YT(tt)=-3;
                A11(tt)=tt;
    elseif DIFF1(tt)<0&&DIFF2(tt)>=0&&DIFF3(tt)<0&&DIFF4(tt)<0
                TT12(tt)=TT(tt);
                YT(tt)=-4;
                A12(tt)=tt;                
    elseif DIFF1(tt)<0&&DIFF2(tt)<0&&DIFF3(tt)>=0&&DIFF4(tt)>=0
                TT13(tt)=TT(tt);
                YT(tt)=-5;
                A13(tt)=tt;
    elseif DIFF1(tt)<0&&DIFF2(tt)<0&&DIFF3(tt)>=0&&DIFF4(tt)<0
                TT14(tt)=TT(tt);
                YT(tt)=-6;
                A14(tt)=tt;
    elseif DIFF1(tt)<0&&DIFF2(tt)<0&&DIFF3(tt)<0&&DIFF4(tt)>=0
               TT15(tt)=TT(tt);
               YT(tt)=-7;
               A15(tt)=tt;
    elseif DIFF1(tt)<0&&DIFF2(tt)<0&&DIFF3(tt)<0&&DIFF4(tt)<0
               TT16(tt)=TT(tt);
               YT(tt)=-8;
               A16(tt)=tt;
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
TT9(ismember(TT9,100,'rows')==1)=[];
TT10(ismember(TT10,100,'rows')==1)=[];
TT11(ismember(TT11,100,'rows')==1)=[];
TT12(ismember(TT12,100,'rows')==1)=[];
TT13(ismember(TT13,100,'rows')==1)=[];
TT14(ismember(TT14,100,'rows')==1)=[];
TT15(ismember(TT15,100,'rows')==1)=[];
TT16(ismember(TT16,100,'rows')==1)=[];

A1(ismember(A1,0,'rows')==1)=[];
A2(ismember(A2,0,'rows')==1)=[];
A3(ismember(A3,0,'rows')==1)=[];
A4(ismember(A4,0,'rows')==1)=[];
A5(ismember(A5,0,'rows')==1)=[];
A6(ismember(A6,0,'rows')==1)=[];
A7(ismember(A7,0,'rows')==1)=[];
A8(ismember(A8,0,'rows')==1)=[];
A9(ismember(A9,0,'rows')==1)=[];
A10(ismember(A10,0,'rows')==1)=[];
A11(ismember(A11,0,'rows')==1)=[];
A12(ismember(A12,0,'rows')==1)=[];
A13(ismember(A13,0,'rows')==1)=[];
A14(ismember(A14,0,'rows')==1)=[];
A15(ismember(A15,0,'rows')==1)=[];
A16(ismember(A16,0,'rows')==1)=[];


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
 
 SS9=zeros(size(A9,1),qq);%最近邻的k个序列

 for y9=1:size(A9,1)
       if A9(y9)<=z
        SS8(y9,:)=S(A9(y9),:);
       else
        TT9(y9)=100;
       end
 end
 
 SS10=zeros(size(A10,1),qq);%最近邻的k个序列

 for y10=1:size(A10,1)
       if A10(y10)<=z
        SS10(y10,:)=S(A10(y10),:);
       else
        TT10(y10)=100;
       end
 end
 
 SS11=zeros(size(A11,1),qq);%最近邻的k个序列

 for y11=1:size(A11,1)
       if A11(y11)<=z
        SS11(y11,:)=S(A11(y11),:);
       else
        TT11(y11)=100;
       end
 end
 
 SS12=zeros(size(A12,1),qq);%最近邻的k个序列

 for y12=1:size(A12,1)
       if A12(y12)<=z
        SS12(y12,:)=S(A12(y12),:);
       else
        TT12(y12)=100;
       end
 end
 
 SS13=zeros(size(A13,1),qq);%最近邻的k个序列

 for y13=1:size(A13,1)
       if A13(y13)<=z
        SS13(y13,:)=S(A13(y13),:);
       else
        TT13(y13)=100;
       end
 end
 
 SS14=zeros(size(A14,1),qq);%最近邻的k个序列

 for y14=1:size(A14,1)
       if A14(y14)<=z
        SS14(y14,:)=S(A14(y14),:);
       else
        TT14(y14)=100;
       end
 end
 
 SS15=zeros(size(A15,1),qq);%最近邻的k个序列

 for y15=1:size(A15,1)
       if A15(y15)<=z
        SS15(y15,:)=S(A15(y15),:);
       else
        TT15(y15)=100;
       end
 end
 
 SS16=zeros(size(A16,1),qq);%最近邻的k个序列

 for y16=1:size(A16,1)
       if A16(y16)<=z
        SS16(y16,:)=S(A16(y16),:);
       else
        TT16(y16)=100;
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
TT9(ismember(TT9,100,'rows')==1)=[];
TT10(ismember(TT10,100,'rows')==1)=[];
TT11(ismember(TT11,100,'rows')==1)=[];
TT12(ismember(TT12,100,'rows')==1)=[];
TT13(ismember(TT13,100,'rows')==1)=[];
TT14(ismember(TT14,100,'rows')==1)=[];
TT15(ismember(TT15,100,'rows')==1)=[];
TT16(ismember(TT16,100,'rows')==1)=[];

SS1(ismember(SS1,zeros(1,qq),'rows')==1,:)=[];
SS2(ismember(SS2,zeros(1,qq),'rows')==1,:)=[];
SS3(ismember(SS3,zeros(1,qq),'rows')==1,:)=[];
SS4(ismember(SS4,zeros(1,qq),'rows')==1,:)=[];
SS5(ismember(SS5,zeros(1,qq),'rows')==1,:)=[];
SS6(ismember(SS6,zeros(1,qq),'rows')==1,:)=[];
SS7(ismember(SS7,zeros(1,qq),'rows')==1,:)=[];
SS8(ismember(SS8,zeros(1,qq),'rows')==1,:)=[];
SS9(ismember(SS9,zeros(1,qq),'rows')==1,:)=[];
SS10(ismember(SS10,zeros(1,qq),'rows')==1,:)=[];
SS11(ismember(SS11,zeros(1,qq),'rows')==1,:)=[];
SS12(ismember(SS12,zeros(1,qq),'rows')==1,:)=[];
SS13(ismember(SS13,zeros(1,qq),'rows')==1,:)=[];
SS14(ismember(SS14,zeros(1,qq),'rows')==1,:)=[];
SS15(ismember(SS15,zeros(1,qq),'rows')==1,:)=[];
SS16(ismember(SS16,zeros(1,qq),'rows')==1,:)=[];

Ytest1=Xs(end)-Xs(end-1);
Ytest2=Xs(end-1)-Xs(end-2);
Ytest3=Xs(end-2)-Xs(end-3);
Ytest4=Xs(end-3)-Xs(end-4);

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

if Ytest4>=0
    Ytest4=1;
else
    Ytest4=-1;
end

if Ytest1==1&&Ytest2==1&&Ytest3==1&&Ytest4==1
    SS0=SS1;
    H0=TT1;
elseif Ytest1==1&&Ytest2==1&&Ytest3==1&&Ytest4==-1
    SS0=SS2;
    H0=TT2;
elseif Ytest1==1&&Ytest2==1&&Ytest3==-1&&Ytest4==1
    SS0=SS3;
    H0=TT3;
elseif Ytest1==1&&Ytest2==1&&Ytest3==-1&&Ytest4==-1
    SS0=SS4;
    H0=TT4;
elseif Ytest1==1&&Ytest2==-1&&Ytest3==1&&Ytest4==1
    SS0=SS5;
    H0=TT5;
elseif Ytest1==1&&Ytest2==-1&&Ytest3==1&&Ytest4==-1
    SS0=SS6;
    H0=TT6;
elseif Ytest1==1&&Ytest2==-1&&Ytest3==-1&&Ytest4==1
    SS0=SS7;
    H0=TT7;
elseif Ytest1==1&&Ytest2==-1&&Ytest3==-1&&Ytest4==-1
    SS0=SS8;
    H0=TT8;
elseif Ytest1==-1&&Ytest2==1&&Ytest3==1&&Ytest4==1
    SS0=SS9;
    H0=TT9;
elseif Ytest1==-1&&Ytest2==1&&Ytest3==1&&Ytest4==-1
    SS0=SS10;
    H0=TT10;
elseif Ytest1==-1&&Ytest2==1&&Ytest3==-1&&Ytest4==1
    SS0=SS11;
    H0=TT11;
elseif Ytest1==-1&&Ytest2==1&&Ytest3==-1&&Ytest4==-1
    SS0=SS12;
    H0=TT12;
elseif Ytest1==-1&&Ytest2==-1&&Ytest3==1&&Ytest4==1
    SS0=SS13;
    H0=TT13;
elseif Ytest1==-1&&Ytest2==-1&&Ytest3==1&&Ytest4==-1
    SS0=SS14;
    H0=TT14;
elseif Ytest1==-1&&Ytest2==-1&&Ytest3==-1&&Ytest4==1
    SS0=SS15;
    H0=TT15;
elseif Ytest1==-1&&Ytest2==-1&&Ytest3==-1&&Ytest4==-1
    SS0=SS16;
    H0=TT16;
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
