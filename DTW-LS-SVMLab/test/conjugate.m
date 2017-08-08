function f=conjugate(x0,t)
x=x0;
syms xi beta real;
syms yi beta real;
syms a beta real;
f=(xi-2)^2+(yi-4)^2;
fx=diff(f,xi);
fy=diff(f,yi);
fx=subs(fx,{xi,yi},x0);
fy=subs(fy,{xi,yi},x0);
fi=[fx,fy];
count=0;
while double(sqrt(fx^2+fy^2))>t
    s=-fi;
    if count<=0
        s=-fi;
    else
        s=s1;
    end
    x=x+a*s;
    f=subs(f,{xi,yi},x);
    f1=diff(f);
    f1=solve(f1);
    if f1~=0
       ai=double(f1);
    else
        break
          x,f=subs(f,{xi,yi},x),count
    end
    x=subs(x,a,ai);
    f=xi-xi^2+2*xi*yi+yi^2;
    fxi=diff(f,xi);
    fyi=diff(f,yi);
    fxi=subs(fxi,{xi,yi},x);
    fyi=subs(fyi,{xi,yi},x);
    fii=[fxi,fyi];
    d=(fxi^2+fyi^2)/(fx^2+fy^2);
    s1=-fii+d*s;
    count=count+1;
    fx=fxi;
    fy=fyi;
end
x,f=subs(f,{xi,yi},x),count

%ÊäÈë£ºconjugate_grad_2d([0,0],0.0001)?