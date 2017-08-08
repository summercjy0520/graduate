function [model,H] = lssvmMATLABknneksai(model,K) 


%fprintf('~');
%
% is it weighted LS-SVM ?
%

%compute Alpha
model = lssvmMATLAB(model);

%compute error variables ek
ek=model.alpha/model.gam;

% ss=1.483*MAD(ek);
ek=sort(ek);
g1=round(size(ek,1)*0.25);
g2=round(size(ek,1)*0.75);
IQR=ek(g2)-ek(g1);
ss=IQR/(2*0.6745);

vk=zeros(size(ek,1),1);
c1=2.5;
% c2=5;
% for i=1:size(ek,1)
%     if abs(ek(i)/ss)<=c1
%         vk(i)=1;
%     elseif c1<abs(ek(i)/ss)<=c2
%         vk(i)=(c2-abs(ek(i)/ss))/(c2-c1);
%     else
%         vk(i)=10^-4;
%     end
% end
for i=1:size(ek,1)
    if abs(ek(i)/ss)<=c1
        vk(i)=1;
%         vk(i)=max(K); % =1
    elseif c1<abs(ek(i)/ss) %&&abs(ek(i)/ss)<=c2
        vk(i)=K(i);
%         vk(i)=K(i)*(c2-abs(ek(i)/ss))/(c2-c1);
%         vk(i)=(c2-abs(ek(i)/ss))/(c2-c1);

    else
        vk(i)=10^(-4);
%         vk(i)=10^-4;

    end
end



% vk=K;
weighted = (length(model.gam)>model.y_dim);
if and(weighted,length(model.gam)~=model.nb_data),
  warning('not enough gamma''s for Weighted LS-SVMs, simple LS-SVM applied');
  weighted=0;
end

% computation omega and H计算omega和H
                                                                                                                       omega = kernel_matrix(model.xtrain(model.selector, 1:model.x_dim), ...
    model.kernel_type, model.kernel_pars);


% initiate alpha and b 初始化alpha和b
% model.b = zeros(model.nb_data,model.y_dim);
model.b = zeros(1,model.y_dim);
model.alpha = zeros(model.nb_data,model.y_dim);


for i=1:model.y_dim,
    H = omega;
    model.selector=~isnan(model.ytrain(:,i));
    nb_data=sum(model.selector);
    if size(model.gam,2)==model.nb_data, 
      try invgam = model.gam(i,:).^-1; catch, invgam = model.gam(1,:).^-1;end
      for t=1:model.nb_data, H(t,t) = H(t,t)+invgam(t); end
    else
      invgam=zeros(model.nb_data,1);
      for t=1:model.nb_data,
          try invgam(t) = (model.gam(i,1)*vk(t)).^-1; catch, invgam(t) =(model.gam(1,1)*vk(t)).^-1;end
%           try invgam(t) = (model.gam(i,1)*abs(K(t)/vk(t))).^-1; catch, invgam(t) =(model.gam(1,1)*abs(K(t)/vk(t))).^-1;end
          H(t,t) = H(t,t)+invgam(t); 
      end
    end    
    
    %加上变量sai的作用规整核矩阵omega
%     for j=1:nb_data
%         H(j)=H(j)+K(j)*r;
%         j=j+1;
%     end
    v = H(model.selector,model.selector)\model.ytrain(model.selector,i);
    %eval('v  = pcg(H,model.ytrain(model.selector,i), 100*eps,model.nb_data);','v = H\model.ytrain(model.selector, i);');
    nu = H(model.selector,model.selector)\ones(nb_data,1);
    %eval('nu = pcg(H,ones(model.nb_data,i), 100*eps,model.nb_data);','nu = H\ones(model.nb_data,i);');
    s = ones(1,nb_data)*nu(:,1);
    temp = (nu(:,1)'*model.ytrain(model.selector,i))./s-model.alpha./(model.gam*vk);
    model.alpha(model.selector,i) = v(:,1)-(nu(:,1).*temp);
    model.b(model.selector,i)=temp;
%     temp = (nu(:,1)'*model.ytrain(model.selector,i))./s;
%     model.alpha(model.selector,i) = v(:,1)-(nu(:,1)*temp);
%     model.b=temp;
%     model.b(model.selector,i)=temp;
%     model.b(model.selector,i)=temp-model.alpha./(model.gam*vk);


%     model.alpha(model.selector,i) = v(:,1);
%     model.b(model.selector,i)=model.alpha./(model.gam*vk);
%     model.M=model.xtrain(1,:);
end


%    for i=1:size(model.xtrain,2)
%         model.E=model.ytrain(model.selector,:)*model.alpha(model.selector,:)*model.xtrain(:,model.nb_data);
%         model.w(:,i)=model.w(:,i)+model.E;
%    end
% w=model.w;


function mad=MAD(ek)
A1=zeros(size(ek,1),1);
mm=median(ek);
for h=1:size(ek,1)
    A1(h)=ek(h)-mm;
end
mad=median(abs(A1));
end

end

