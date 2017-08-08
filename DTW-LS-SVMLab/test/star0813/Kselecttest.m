clear all;  %Ñ¡³öÒ»¶¨Á¿£¬É¾³ýÒ»¶¨²¿·Ö
clc;

%TXT= importdata('C:\Documents and Settings\Administrator\×ÀÃæ\cjy\2016\8\data\Riverflow.txt');

TXT= importdata('C:\Documents and Settings\Administrator\×ÀÃæ\cjy\2016\7\data\600030.txt');
%TXT= importdata('C:\Documents and Settings\Administrator\×ÀÃæ\cjy\2016\7\data\zxzq0703.txt');
TXT=(TXT.textdata(2:end,5))';% end:2015-03~06:2864-2933  %+2000
TXT=str2double(TXT);
[TXT,T1]=mapminmax(TXT);
TXT=TXT(1:end)';

q=15; %Ê±ï¿½ï¿½
qq=q+1;
s=1;  %Ô¤ï¿½â´°ï¿½ï¿½;
cjy1=0;
cjy2=0;
h1=size(TXT,1);
TT1=ones(h1-1,1)*100;
TT2=ones(h1-1,1)*100;
TT3=ones(h1-1,1)*100;
TT4=ones(h1-1,1)*100;
TT5=ones(h1-1,1)*100;
TT6=ones(h1-1,1)*100;
TT7=ones(h1-1,1)*100;
TT8=ones(h1-1,1)*100;
TT=zeros(h1-1,1);
YT=zeros(h1-1,1);

A1=zeros(h1-1,1);
A2=zeros(h1-1,1);
A3=zeros(h1-1,1);
A4=zeros(h1-1,1);
A5=zeros(h1-1,1);
A6=zeros(h1-1,1);
A7=zeros(h1-1,1);
A8=zeros(h1-1,1);


YYT=zeros(h1-1,1);
v=[];
for t=1:h1-1
    TT(t)=(TXT(t+1)-TXT(t));
    if TT(t)>=0
%         YT(t)=1;
        if abs(TT(t))<0.003
            TT1(t)=TT(t);
            YT(t)=1;
            A1(t)=t;
        elseif abs(TT(t))>=0.003&&abs(TT(t))<0.01
            TT2(t)=TT(t);
            YT(t)=2;
            A2(t)=t;
        elseif abs(TT(t))>=0.01&&abs(TT(t))<0.02
            TT3(t)=TT(t);
            YT(t)=3;
            A3(t)=t;
        else
            TT4(t)=TT(t);
            YT(t)=4;
            A4(t)=t;
        end
    else
%         YT(t)=-1;
        if abs(TT(t))<0.005
            TT5(t)=TT(t);
            YT(t)=-1;
            A5(t)=t;
        elseif abs(TT(t))>=0.005&&abs(TT(t))<0.01
            TT6(t)=TT(t);
            YT(t)=-2;
            A6(t)=t;
        elseif abs(TT(t))>=0.01&&abs(TT(t))<0.02
            TT7(t)=TT(t);
            YT(t)=-3;
            A7(t)=t;
        else
            TT8(t)=TT(t);
            YT(t)=-4;
            A8(t)=t;
        end
    end
   
end

TTT=zeros(h1-2,1);

for i=1:h1-2
    TTT(i)=TT(i+1)-TT(i);
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

h0=2900;

ww=300;
selection=zeros(ww,1);
Distance=zeros(ww,1);

zis=1;
while (zis<=ww)
X=TTT(1:h0+zis-1);
% Q=TXT(5591:5600)';
Xt=TTT((h0+zis-1+1):end);
XXt=[X;Xt];

Xs=XXt((h0+zis-1-s-q+1):(h0+zis-1+1-s));

mm=size(TTT(1:(h0+zis-1)),1);

z=mm-s-qq+1;
S=zeros(z,qq);
h=0; %ï¿½ï¿½ï¿½ï¿½ï¿½Æ¶ï¿½Ê±ï¿½ï¿½Ó°ï¿½ï¿½ï¿½Ô­ï¿½ï¿½ï¿½Ð±ï¿½Ç?

for i=1:z
    for j=1:qq
    if h+j<=mm
    S(i,j)=X(h+j);
%     S(i,2*j)=X(h+2*j);
    end
    end
    h=h+1;
end  

% if TT(h0+zis-1+1)-TT(h0+zis-1)>=0
if TT(h0+zis-1+1)>=0
    Direction=1;
else
    Direction=-1;
end
k=39;
% for i=1:4
%     k=19+10*(i-1);
    [selection(zis),Distance(zis)]=Kselect(S,Xs',TT,qq,Direction,k);
% end
zis=zis+1;
end

    