function [V] = entropycjy(A1)

if nargin~=2
  X = A1;
  N=size(X,1);
  V=zeros(N,1);
  %V = zeros(n,length(peff));
  for i=1:length(X),
      V(i,:)=entropy(X(i,:));  
  end
end
