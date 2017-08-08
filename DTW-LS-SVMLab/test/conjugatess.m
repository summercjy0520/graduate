function [w]=conjugatess(I1,I2,w0)
w=w0;

% t=0.00010;
% syms wi beta real;
% wi=sym(zeros(1,size(I2,2)));
alpha=zeros(size(I1,1),1);
% beta=zeros(size(I1,1),1);
% syms ci beta real;
% syms yi beta real;
% syms a beta real;
%  for i=1,2,...
  
    I1=I1(:);    
    w=w(:)';
%     I2=I2(:);
%     A=B^-1;
    
    x_old=w;

    N=length(I1);
    M=size(I2,2);
for i=1:N
    b=I1(i,:);
    A=I2(i,:);
    gamma_old=A-b*x_old; %r
    p_old=-gamma_old;
%     z=b*p_old;
    alpha(i)=(p_old*gamma_old')/(norm(p_old*A'*p_old'));%算法2中alpha 步长
    x_new=x_old+p_old*alpha(i);
    B=0;
    
    for j=1:M
        gamma_old=gamma_old-alpha(i)*A*p_old';
        if (norm(gamma_old)<1e-10)
            break;
        else
            B=(norm(gamma_old*A'*p_old'))/(norm(p_old*A'*p_old));
            p_old=-gamma_old+B*p_old;
            z=A*p_old';
            alpha(i)=(p_old*gamma_old')/(norm(p_old*z));%算法2中alpha 步长
            x_new=x_new+p_old*alpha(i);
        end
    end
%     
%     gamma_new=A-b*x_new;
%     beta(i)=-(p_old*b*p_old')/(p_old*b*gamma_new');%算法2中贝塔
%     p_new=p_old+gamma_new*beta(i);
%     
%     x_old=x_new;
%     p_old=p_new;

end
%  end
w=x_new;







% t=0.00010;
% syms wi beta real;
% wi=sym(zeros(1,size(I2,2)));

% syms ci beta real;
% syms yi beta real;
% syms a beta real;
% %  for i=1,2,...
%   
%     I1=I1(:);    
%     w=w(:)';
%     I2=I2(:);
% %     A=B^-1;
%     
%     x_old=w;
% 
%     N=length(I1);
% for i=1:N
%     b=I1(i,:);
%     A=I2(i,:);
%     gamma_old=A-b*x_old;
%     p_old=gamma_old;
%     alpha=(p_old.'*gamma_old)/(p_old.'*b*p_old);%算法2中alpha 步长
%     x_new=x_old+p_old*alpha;
%     
%     gamma_new=A-b*x_new;
%     beta=-(p_old.'*b*p_old)/(p_old.'*b*gamma_new);%算法2中贝塔
%     p_new=p_old+gamma_new*beta;
%     
%     x_old=x_new;
%     p_old=p_new;
% 
% end
% %  end
% w=x_new;


% f=I1(i,:)*w-I2(i,:);
% fw=diff(f,wi);
% % fy=diff(f,yi);
% fw=subs(fw,wi,w0);
% % fy=subs(fy,{xi,yi},x0);
% fi=fw;
% count=0;%搜索次数
% while double(norm(fw))>t
%     s=-fi;
%     if count<=0
%         s=-fi;
%     else
%         s=s1;
%     end
%     w=w+a*s;
%     f=subs(f,wi,w);
%     f1=diff(f);
%     f1=solve(f1);
%     if f1~=0
%        ai=double(f1);
%     else
%         break
%           w,f=subs(f,wi,w),count
%     end
%     w=subs(w,a,ai);
% %     f=wi-I1+I2;
%     f=I1(i,:)*w-I2(i,:);
%     fwi=diff(f,wi);
% %     fyi=diff(f,yi);
%     fwi=subs(fwi,wi,w);
% %     fyi=subs(fyi,{xi,yi},x);
%     fii=fwi;
%     d=(fwi^2)/(fw^2);
%     s1=-fii+d*s; %下一搜索的方向向量
%     count=count+1;
%     fw=fwi;
% %     fy=fyi;
% end
% end
% w=f(count,:),f=subs(f,wi,w),count

%输入：conjugate_grad_2d([0,0],0.0001)?