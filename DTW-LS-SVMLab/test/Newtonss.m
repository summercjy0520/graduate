function [w_k] = Newtonss(model,Xt,Yt) 
a0=1e-1;
a1=1e-2;
a2=1e-1;
b1=1e-2;
b2=1e-1;
b3=1e+1;
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

w_0=model.w;
% W=(w)';
I=zeros(model.nb_data,1);
I1=ones(model.nb_data,1);
% I2=ones(model.nb_data,1);
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

for k=0,1,...
 %     for i=0,1,...
 %          r(i)=-f(w(k))-h
 for i=1:model.nb_data
    m_k=model.ytrain(i)*w_k(i,:)'*model.xtrain(i,:);
    if 1-m_k>0
        I(i)=i;
        D(i,i)=1;
    end
    if I(i)>0
        X1(i,:)=Xt(i,:);
        Y1(i)=Yt(i);
    end
    I1(i)=I(i)+2*C*(X1(i,:))*(X1(i,:))';
%     I2(i)=2*C*(Xt(i,:))'*D*(Xt(i,:));
end
    w_0=model.w;
    G_k=(w_k)'*I1-2*C*(X1)'*Y1;%一次微分
    H=I+2*C*(Xt)'*D*(Xt);%二次微分  好好看公式26
    s_k=conjugate_grad_2d(-G(w_k),H,c_k);
    m_0=0;
    Q(s_k)=(G(w_k))'*s_k+1/2*(s_k)'*H*s_k;
    m_k=(f(w_k+s_k)-f(w_k))/Q(s_k);
    %公式9
   if m_k>a0
    w_(k+1)=w_k+s_k;
    else w_(k+1)=w_k;
    end
    if G(w_k)==zeros(model.xt_dim), stop;
    end

    
 
%     trust region
   if m_k<=a1
       b1*min(norm(s_k),c_k)<=c_(k+1)&c_(k+1)<=b2*c_k;
   else if a1<m_k<a2
           b1*c_k<=c_(k+1)&c_(k+1)<=b3*c_k;
       else
           c_k<=c_(k+1)&c_(k+1)<=b3*c_k;
       end
   end
       
    
end
return
