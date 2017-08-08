function [alpha,b] = exchange(w,X,Y,Xt,Yt) 
X=[X;Xt];
Y=[Y;Yt];
nb_data=size(X,1);
% alpha=zeros(nb_data,1);
alpha=sym(zeros(size(X,1),1));
wss=sym(zeros(size(X,1),size(X,2)));

for j=1:nb_data
%         model.E=model.ytrain(j,:)*model.alpha(j,:)*model.xtrain(j,:);
%         alpha(j,:)=w./X(j,:)/Y(j,:);
%    [alpha,wss]=solve('wss=Y(j,:)*alpha(j,:)*X(j,:)','w=w+wss','alpha','wss');
    wss(j,:)=Y(j,:)*alpha(j,:)*X(j,:);
    w=w+wss(j,:);
%         model.w(j,:)=model.w(j,:)+model.E;
     b=w*X(j,:)'-Y(j,:);
end

% weighted = (length(model.gam)>model.y_dim);
% if and(weighted,length(model.gam)~=model.nb_data),
%   warning('not enough gamma''s for Weighted LS-SVMs, simple LS-SVM applied');
%   weighted=0;
% end
% 
% % computation omega and H计算omega和H
%                                                                                                                        omega = kernel_matrix(model.xtrain(model.selector, 1:model.x_dim), ...
%     model.kernel_type, model.kernel_pars);
% 
% 
% % initiate  b 初始化b
% model.b = zeros(1,model.y_dim);
% 
% for i=1:model.y_dim,
%     H = omega;
%     model.selector=~isnan(model.ytrain(:,i));
%     nb_data=sum(model.selector);
%     if size(model.gam,2)==model.nb_data, 
%       try invgam = model.gam(i,:).^-1; catch, invgam = model.gam(1,:).^-1;end
%       for t=1:model.nb_data, H(t,t) = H(t,t)+invgam(t); end
%     else
%       try invgam = model.gam(i,1).^-1; catch, invgam = model.gam(1,1).^-1;end
%       for t=1:model.nb_data, H(t,t) = H(t,t)+invgam; end
%     end  
% end
return