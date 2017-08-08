function [en,U,lam] = NHentropy(X)
% Quadratic Renyi Entropy for a kernel based estimator
% 
% Given the eigenvectors and the eigenvalues of the kernel matrix, the entropy is computed by
% 
% >> H = kentropy(X, U, lam)
% 
% The eigenvalue decomposition can also be computed (or
% approximated) implicitly:
% 
% >> H = kentropy(X, kernel, sig2)
% 
%
% Full syntax
% 
% >> H = kentropy(X, kernel, kernel_par)
% >> H = kentropy(X, kernel, kernel_par, type)
% >> H = kentropy(X, kernel, kernel_par, type, nb)
% 
%       Outputs    
%         H          : Quadratic Renyi entropy of the kernel matrix
%       Inputs    
%         X          : N x d matrix with the training data
%         kernel     : Kernel type (e.g. 'RBF_kernel')
%         kernel_par : Kernel parameter (bandwidth in the case of the 'RBF_kernel')
%         type(*)    : 'eig'(*), 'eigs', 'eign'
%         nb(*)      : Number of eigenvalues/eigenvectors used in the eigenvalue decomposition approximation
% 
%
% >> H = kentropy(X, U, lam)
% 
%       Outputs    
%         H   : Quadratic Renyi entropy of the kernel matrix
%       Inputs    
%         X   : N x d matrix with the training data
%         U   : N x nb matrix with principal eigenvectors
%         lam : nb x 1 vector with eigenvalues of principal components
% 
% See also:
%   kernel_matrix, RBF_kernel, demo_fixedsize

% Copyright (c) 2002,  KULeuven-ESAT-SCD, License & help @ http://www.esat.kuleuven.ac.be/sista/lssvmlab



n= size(X,1);
% omega=zeros(size(X,1),size(X,1));
%       for i=1:size(X,1)
%           for j=1:size(X,1)
%               a=X(i,:);
%               b=A1(j,:);
%               omega(i,j)= sqrt((a-b)*(a-b)');
%           end
%       end
omega=pdist2(X,X); 
eval('etype = A3;','etype =''eig'';');
eval('[U,lam] = feval(etype,omega,nb);','[U,lam] = feval(etype,omega);');
    if size(lam,1)==size(lam,2), lam = diag(lam); end
    %onen = ones(n,1)./n; en = -log(onen'*omega*onen);
    
en = -log((sum(U,1)/n).^2 * lam);
% en = -log((sum(U,1)/n) * lam);


  