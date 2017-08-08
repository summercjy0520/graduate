syms x1 beta real;%快捷构建象征性的变量。
syms x2 beta real
f=(x1-2)^2+(x2-4)^2;
v=[x1,x2];
df=jacobian(f,v);
df=df.';
G=jacobian(df,v);
epson=1e-12;x0=[0,0]';
g1=subs(df,{x1,x2},{x0(1,1),x0(2,1)});
G1=subs(G,{x1,x2},{x0(1,1),x0(2,1)});
k=0;mul_count=0;sum_count=0;
mul_count=mul_count+12;
sum_count=sum_count+6;
while(norm(g1)>epson)
    p=-G1\g1;
    x0=x0+p;
    g1=subs(df,{x1,x2},{x0(1,1),x0(2,1)});
    G1=subs(G,{x1,x2},{x0(1,1),x0(2,1)});
    k=k+1;
    mul_count=mul_count+16;sum_count=sum_count+11;
end;
k
x0
mul_count
sum_count