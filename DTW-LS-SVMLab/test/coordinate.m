function [z]=coordinate(model,w_k,s)
% syms z_i beta real;
z_i=zeros;
Q1=zeros(1,model.x_dim);
Q2=zeros;
C=model.gam;
% z=0;
D1=zeros(1,model.x_dim);
D2=zeros(1,model.x_dim);

for i=1,2,...
        if i==1
        z=0;
        else z=z_i;
        end
for j=1:i
     n=model.ytrain(j)*(w_k(:,i)+z*s(:,i))'*model.xtrain(j,:);
%      n=double(n);
%      if 1-n>0
%        P(j)=j;
%      end
     E1=model.ytrain(j)*model.xtrain(j,i)*(1-n);
     Q1=Q1+E1;
     E2=(model.ytrain(j))^2*(model.xtrain(j,i))^2;
     Q2=Q2+E2;
end
     D1=w_k+z-2*C*Q1;
     D2=1+2*C*Q2;
     D1=double(D1);
     if norm(D1)>0
         
     z_i=z-norm(D1)/D2;
     i=i+1;
     z=z_i;
     end
%     m_0=0;
%     Q(s_k)=(G(w_k))'*s_k+1/2*(s_k)'*H*s_k;
%     m_k=(f(w_k+s_k)-f(w_k))/Q(s_k);
%     %¹«Ê½9
%    if m_k>a0
%     w_(k+1)=w_k+s_k;
%     else w_(k+1)=w_k;
%     end
%     if G(w_k)==zeros(model.xt_dim), stop;
%     end

    
 

   
   
%   w=I2./I1;
end