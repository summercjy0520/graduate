function prediction = predictknncjy(model,cjy,Xp,mm, simfct, args)
% Iterative prediction of a trained LS-SVM NARX model (in recurrent mode)
% 
% >> Yp = predict({Xw,Yw,type,gam,sig2}, Xt, nb)
% >> Yp = predict(model,                 Xt, nb)
% 
% The model needs to be trained using Xw, Yw which is the result of
% windowize or windowizeNARX. The number of time lags for the model
% is determined by the dimension of the input, or if not
% appropriate, by the number of given starting values.
% 
% By default, the model is evaluated on the past points using
% simlssvm. However, if one wants to use this procedure for other
% models, this default can be overwritten by your favorite training
% function. This function (denoted by simfct) has to follow the following syntax:
% 
% >> simfct(model,inputs,arguments)
% 
% thus:
% 
% >> Yp = predict(model, Xt, nb, simfct)
% >> Yp = predict(model, Xt, nb, simfct, arguments)
% 
%
% Full syntax
% 
%     1. Using the functional interface for the LS-SVMs:
% 
% >> Yp = predict({Xw,Yw,type,gam,sig2,kernel,preprocess}, Xt, nb)
% 
%       Outputs    
%         Yp            : nb x m matrix with the predictions
%       Inputs    
%         Xw            : N x d matrix with the inputs of the training data
%         Yw            : N x w matrix with the outputs of the training data
%         type          : 'function estimation' ('f') or 'classifier' ('c')
%         gam           : Regularization parameter
%         sig2          : Kernel parameter (bandwidth in the case of the 'RBF_kernel')
%         kernel(*)     : Kernel type (by default 'RBF_kernel')
%         preprocess(*) : 'preprocess' or 'original' (by default)
%         Xt            : nb*d matrix of the starting points for the prediction
%         nb(*)         : Number of outputs to predict
% 
%
%     2. Using the object oriented interface with LS-SVMs:
% 
% >> Yp = predict(model, Xt, nb)
% 
%       Outputs    
%         Yp    : nb x m matrix with the predictions
%       Inputs    
%         Xt    : nb x d matrix of the starting points for the prediction
%         nb(*) : Number of outputs to predict
% 
%
%     3. Using another model:
% 
% >> Yp = predict(model, Xt, nb, simfct, arguments)
% 
%       Outputs    
%         Yp           : nb x m matrix with the predictions
%       Inputs    
%         Xt           : nb x d matrix of the starting points for the prediction
%         nb           : Number of outputs to predict
%         simfct       : Function used to evaluate a test point
%         arguments(*) : Cell with the extra arguments passed to simfct
% 
% See also:
%   windowize, trainlssvm, simlssvm.

% Copyright (c) 2002,  KULeuven-ESAT-SCD, License & help @ http://www.esat.kuleuven.ac.be/sista/lssvmlab



if size(Xp,2)~=1 & size(Xp,1)~=1,
  error('prediction only implemented for the one-dimensional autonomous case');
end
eval('model = initlssvm(model{:});',' ');
eval('xdim = model.x_dim;','xdim = max(size(Xp)); ');
eval('n; alle=0;','n=length(Xp)-xdim; alle=1;');
Xs=cell2mat(Xp(1));
Xt=cell2mat(Xp(2));

%cell×ª»»³Édouble

Xt = Xt(1:xdim); 
Xt = reshape(Xt,length(Xt),1);
eval('simfct;','simfct=''simlssvm'';');
eval('model = trainlssvmknn(model,cjy);');

n=cell2mat(mm(2));
nn=cell2mat(mm(1));
xdelays = length(Xt);
prediction1 = zeros(xdelays+n,1);
prediction1(1:xdelays) = Xt;
p=0;
m=n;

while(m>0)

prediction = zeros(xdelays+n,1);
for ii=1:xdelays
prediction(ii) = Xs(end-xdelays-n+ii+p*nn);
ii=ii+1;
end
% closed loop
eval('for i=1:n,  prediction(xdelays+i) = feval(simfct,model, prediction(i-1+(1:xdelays))'',args); end',...
     'for i=1:n,  prediction(xdelays+i) = feval(simfct,model,prediction(i-1+(1:xdelays))''); end');
if m>nn
 for i=1:nn
 prediction1(xdelays+i+p*nn)=prediction(xdelays+i);
 end
  p=p+1;
 m=n-p*nn;
else
 for j=1:m
 prediction1(xdelays+j+p*nn)=prediction(xdelays+j);
 end
 m=0;
end
end


 xdelays = length(Xt);

% if ~alle,
  prediction = prediction1(xdelays+1:end);

