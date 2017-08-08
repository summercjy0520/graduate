clear all;  %Ñ¡³öÒ»¶¨Á¿£¬É¾³ýÒ»¶¨²¿·Ö
clc;

%TXT= importdata('C:\Documents and Settings\Administrator\×ÀÃæ\cjy\2016\8\data\Riverflow.txt');

TXT= importdata('C:\Documents and Settings\Administrator\×ÀÃæ\cjy\2016\7\data\600036.txt');
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
    TT(t)=(TXT(t+1)-TXT(t))/TXT(t);
    YT(t)=(TXT(t+1)-TXT(t));
%     TT(t)=(TXT(t+1)-TXT(t));
end

TTT=zeros(h1-2,1);

for i=1:h1-2
    TTT(i)=(TT(i+1)-TT(i));
end


h0=2900;

ww=100;
selection=zeros(ww,10);
Distance=zeros(ww,10);

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
if YT(h0+zis-1+2)>=0
    Direction=1;
else
    Direction=-1;
end
% k=39;
for i=1:10
    k=19+10*(i-1);
    [selection(zis,i),Distance(zis,i)]=Kselectmain(S,Xs',YT,TT,qq,Direction,k);
end
zis=zis+1;
end

    