function [TXT] = SinSimGenerate(m,n)
Num=m*n;
t=linspace(0,1,Num)*(m*2*pi);
A=sin(sqrt(1.3*t+t.^2));
B=zeros(Num,1);
for i=1:Num
    if sin(sqrt(t(i)+t(i).^2))>0
        B(i)=0.2*sin(sqrt(t(i)+t(i).^2));
    else
        B(i)=-(1+0.2*sin(sqrt(t(i)+t(i).^2)));
    end
end
for j=2:m
    B(n*(j-1)+1:n*j)=[B(n*(j-1)+1);B(n*(j-1)+7:n*(j-1)+9);B(n*(j-1)+2:n*(j-1)+6);B(n*(j-1)+10:n*(j-1)+13)];
end

TXT=A';
for i=1:m-1
    if rem(i+1,3)==0
        TXT(i*n+2:i*n+n-1)=B(i*n+2:i*n+n-1);
        TXT(i*n+1)=abs(TXT(i*n+1))-1;
        temp=sort(TXT(i*n-2:i*n+4));
        TXT(i*n-2:i*n+4)=temp;
%        TXT(i*n-2:i*n+n)=[TXT(i*n:i*n+3);TXT(i*n-2:i*n-1);TXT(i*n+4:i*n+n)];
    end
end
end