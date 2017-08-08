function [s,alpha]=conjugate_grad_2d(model,G,H,s)
% H=zeros(model.nb_data,1);
alpha=zeros(model.nb_data,1);
% r=zeros(model.xt_dim,model.xt_dim);
% s=zeros(model.nb_data,model.xt_dim);
s=sym(zeros(size(model.xtrain,2),1));
d=sym(zeros(model.nb_data,size(model.xtrain,2)));
r=sym(zeros(model.nb_data,size(model.xtrain,2)));



% g=zeros;
for i=1:model.nb_data
%     for k=1:size(model.xtrain,2)
r_1=-G;
d_1=r_1;
d_i=d(i,:);
alpha_i=alpha(i,:);

% s_k=s&;
r_i=r(i,:);
a=1e-2;
% s_0=zeros(model.nb_data,model.xt_dim);
s_1=zeros(1,model.xt_dim);
k=size(model.xtrain,1);
c_k=1e-1;
r_i=-G(i,:)-H'*s;
r_i=double(r_i);
G=double(G);
if norm(r_i)<=a*norm(G)
    s=s;
end
alpha_i=((norm(r_i))^2)/((d_i)*H*(d_i)');
s=s+alpha_i*(d_i)';
s=double(s);
if norm(s)>=c_k
%     if norm(s_i+t*d_i)==c_k
solve('norm(s+t*d_i)==c_k','t');
        s=s+t*d_i;
%     end
end
j=i+1;
r_j=r_i-alpha_i*H*d_i;
r_j=double(r_j);
r_i=double(r_i);
g_i=((norm(r_j))^2)/((norm(r_i))^2);%梯度
d_j=r_j+g_i*d_i;%更新共轭方向
%     end
end
return 
% syms xi beta real;
% syms yi beta real;
% syms a beta real;
% a=1e-2;
% g(w(k))=(I+2*C*(X1)'*X1)*w(k)-2*C*(X1)'*Y1;
% h=I+2*C*(Xt)'*D*(Xt);
% f(s(k))=(g(w(k)))'*s(k)+1/2*(s(k))'*h*s(k);
% 
% fx=diff(f,xi);
% fy=diff(f,yi);
% fx=subs(fx,{xi,yi},x0);
% fy=subs(fy,{xi,yi},x0);
% fi=[fx,fy];
% count=0;
% while double(sqrt(fx^2+fy^2))>t
%     s=-fi;
%     if count<=0
%         s=-fi;
%     else
%         s=s1;
%     end
%     x=x+a*s;
%     f=subs(f,{xi,yi},x);
%     f1=diff(f);
%     f1=solve(f1);
%     if f1~=0
%        ai=double(f1);
%     else
%         break
%           x,f=subs(f,{xi,yi},x),count
%     end
%     x=subs(x,a,ai);
%     f=xi-xi^2+2*xi*yi+yi^2;
%     fxi=diff(f,xi);
%     fyi=diff(f,yi);
%     fxi=subs(fxi,{xi,yi},x);
%     fyi=subs(fyi,{xi,yi},x);
%     fii=[fxi,fyi];
%     d=(fxi^2+fyi^2)/(fx^2+fy^2);
%     s1=-fii+d*s;
%     count=count+1;
%     fx=fxi;
%     fy=fyi;
% end
% end
% x,f=subs(f,{xi,yi},x),count
% 
% %输入：conjugate_grad_2d([0,0],0.0001)?