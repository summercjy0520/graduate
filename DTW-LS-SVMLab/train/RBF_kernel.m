function x = RBF_kernel(a,b, sigma2)
% Radial Basis Function (RBF) kernel function for implicit higher dimension mapping
%
%  X = RBF_kernel(a,b,sig2)
%
% 'sig2' contains the SQUARED variance of the RBF function:
%    X = exp(-||a-b||.^2/sig2)
%  
% 'a' can only contain one datapoint in a row, 'b' can contain N
% datapoints of the same dimension as 'a'. If the row-vector 'sig2'
% contains i=1 to 'dimension' values, each dimension i has a separate 'sig2(i)'.
%
% see also:
%    poly_kernel, lin_kernel, MLP_kernel, trainlssvm, simlssvm

% Copyright (c) 2010,  KULeuven-ESAT-SCD, License & help @ http://www.esat.kuleuven.be/sista/lssvmlab



x = zeros(size(b,1),1);

% ARD for different dimensions.
if size(sigma2,2) == length(a),
  % Example:
  % If
  %     X = rand(2,3,4);
  %  then
   %    d = size(X)              returns  d = [2 3 4]
     %  [m1,m2,m3,m4] = size(X)  returns  m1 = 2, m2 = 3, m3 = 4, m4 = 1
   %    [m,n] = size(X)          returns  m = 2, n = 12
  %     m2 = size(X,2)           returns  m2 = 3
  % rescaling ~ dimensionality 重新缩放维
  [n,d] = size(b);
  for i=1:size(b,1),
      dif = a-b(i,:);
      x(i,1) = exp( -(sum((dif.*dif)./(sigma2.*d))) );           
    end
else
  % a single kernel parameter or one for every inputvariable 单内核参数或者每个输入参数
  for i=1:size(b,1),
    dif = a-b(i,:);
    x(i,1) = exp( -(sum((dif.*dif)./sigma2(1,1))) );
  end
end