function [w] = Newtonsss(model,X,Y,Xt,Yt) 
% a0=1e-1;
a1=1e-2;
a2=1e-1;
b1=1e-2;
b2=1e-1;
b3=1e+1;
X=[X;Xt];
Y=[Y;Yt];
% tb_data=size(X,1);
w_k=sym(zeros(1,size(X,2)));
s=sym(zeros(size(X,2),1));
z=sym(zeros(size(X,2),1));

% w=zeros(1,size(X,2));
C=model.gam;
if iscell(model),
    model = initlssvm(model{:});
    func=1;
else
    func=0;
end
model.xtrain = Xt;
model.ytrain = Yt;
model.nb_data = size(Xt,1);
% model.yt_data = size(Yt,1);
model.xt_dim = size(Xt,2);
model.yt_dim = size(Yt,2);

% model = lssvmMATLAB(model);

w0=model.w;
% W=(w)';
I=zeros(model.nb_data,1);
P=zeros(model.nb_data,1);

I1=ones(model.nb_data,1);
I2=ones(model.nb_data,size(Xt,2));
I3=ones(model.nb_data,size(Xt,2));
D=diag(I1);
X1=zeros(model.nb_data,model.xt_dim);
Y1=zeros(model.nb_data,model.yt_dim);
s_k=zeros(size(model.w,1),size(model.w,2));
G_0=zeros(model.xt_dim,model.xt_dim);
H=zeros(model.nb_data,1);
% for i=1:model.nb_data
%    m=model.ytrain(i)*w_0(i,:)'*model.xtrain(i,:);
%     if 1-m>0
%         I(i)=i;
%         D(i,i)=1;
%     end
%     if I(i)>0
%         X1(i,:)=Xt(i,:);
%         Y1(i)=Yt(i);
%     end
%     I1(i)=I(i)+2*C*(X1(i,:))*(X1(i,:))';
% %     I2(i)=2*C*(Xt(i,:))'*D*(Xt(i,:));
% end

for k=1:model.nb_data
 %     for i=0,1,...
 %          r(i)=-f(w(k))-h

%     w_0=model.w;

if k==1   
    w_k=model.w;
end
    for i=1:model.nb_data
    m=model.xtrain(i,:)*model.ytrain(i)*(w_k)';
    if 1-m>0
        I(i)=i;
        D(i,i)=1;
    end
    if I(i)>0
        X1(i,:)=X(i,:);
        Y1(i)=Y(i);
    end
    I1(i)=I(i)+2*C*(X1(i,:))*(X1(i,:))';
    I2(i,:)=(2*C*(X1(i,:))'*D(i,i)*(Y1(i,:)))';
    I3(i,:)=(2*C*(X1(i,:))'*(Y1(i,:)))';
% %     I2(i)=2*C*(Xt(i,:))'*D*(Xt(i,:));
%     i=i+1;
    end
    
    
%     %     trust region
%    if m_k<=a1
%        b1*min(norm(s_k),c_k)<=c_(k+1);
%        c_(k+1)<=b2*c_k;
%    else if a1<m_k<a2
%            b1*c_k<=c_(k+1)&c_(k+1)<=b3*c_k;
%        else
%            c_k<=c_(k+1)&c_(k+1)<=b3*c_k;
%        end
%    end
   
% c=0;
   
%    G=I1*(w)-I3;%一次微分
% %    H=I+2*C*(Xt)'*D*(Xt);%二次微分  好好看公式26
% %     H=s+2*C*(X1)'*(D(X1*s)); 
%     H=s+2*C*(X1)'*I; 
% wk=w(k,:);
    
    [w]=conjugatess(I1,I3,w_k);
   s=w-w_k;
   
   [z]=coordinate(model,w_k,s);
   w=w_k+z*s;
%    for j=1:i
%      n=model.ytrain(j)*(w_k+z*s)'*model.xtrain(j,:);
%      if 1-n>0
%        P(j)=j;
%      end
%      E1=model.ytrain(j)*model.xtrain(j,i)*n;
%      Q1=Q1+E1;
%      E2=(model.ytrain(j))^2*(model.xtrain(j,i))^2;
%      Q2=Q2+E2;
%    end
%      D1(i)=w_k+z-2*C*Q1;
%      D2(i)=1+2*C*Q2;
%      z=z_i-D1(i)/D2(i);
%      i=i+1;
%      z_i=z;
% %     m_0=0;
% %     Q(s_k)=(G(w_k))'*s_k+1/2*(s_k)'*H*s_k;
% %     m_k=(f(w_k+s_k)-f(w_k))/Q(s_k);
% %     %公式9
% %    if m_k>a0
% %     w_(k+1)=w_k+s_k;
% %     else w_(k+1)=w_k;
% %     end
% %     if G(w_k)==zeros(model.xt_dim), stop;
% %     end

    
 
   w_k=w;
   k=k+1;
   
%   w=I2./I1;
end
return
