clear all;
clc;

TXT= importdata('C:\Documents and Settings\Administrator\×ÀÃæ\cjy\2016\7\data\600030.txt');
%TXT= importdata('C:\Documents and Settings\Administrator\×ÀÃæ\cjy\2016\7\data\zxzq0703.txt');
TXT=(TXT.textdata(2:end,5))';% end:2015-03~06:2864-2933  %+2000
TXT=str2double(TXT);
[TXT,T1]=mapminmax(TXT);
TXT=TXT(1:end)';

ww=70;
number=10;
prediction=zeros(ww,1);
class=zeros(ww,1);

H1=size(TXT,1);

zis=1;

% h0=H1;
h0=H1-1-ww;
k=200;
tempy=0;

selection=zeros(ww,5);
Distance=zeros(ww,5);

while(zis<ww+1)

s=1;  
h1=size(TXT,1);
TT=zeros(h1-1,1);
TTT=zeros(h1-2,1);

v=[];
for t=1:h1-1
    TT(t)=TXT(t+1)-TXT(t);  
end

for t=1:h1-2
    TTT(t)=TT(t+1)-TT(t);  
end

X=TT(1:h0+zis-1);
% Q=TXT(5591:5600)';
Xt=TT((h0+1+zis-1):H1-1);
XXt=[X;Xt];


mm=size(TT(1:(h0-1+zis)),1);

q=1; 
while(abs(TT(h0+zis-1-q))<0.012||q<=3)
    q=q+1;
end

Xs=XXt((h0-s-q+zis):(h0+zis-s));

qq=q+1;
z=mm-s-qq+1;
S=zeros(z,qq);
h=0;

for i=1:z
    for j=1:qq
    if h+j<=mm
    S(i,j)=X(h+j);
%     S(i,2*j)=X(h+2*j);
    end
    end
    h=h+1;
end  


if TT(h0+zis-1+1)>=0
    Direction=1;
else
    Direction=-1;
end
% k=69;
for i=1:5
    k=19+10*(i-1);
    [selection(zis,i),Distance(zis,i)]=KKselect(S,Xs',TT,qq,Direction,k);
end

zis=zis+1;
end