function [Sh,Sl] = CUSUM2(W,n0)
%CUSUM Yu-Mykland convergence diagnostic for MCMC
%
%   C = cusum(W,n0) or C = cusum(W) returns
%   cumulative sum of each column of W as:
%
%           n
%          ___
%          \
%   C(i) = /__( W(i) - S ),
%         i=n0+1
%
%   where S is "empirical average":
%            n
%           ___
%           \
%   S = 1/T /__ W(i)
%          i=n0+1
%
%   Default value for "burn-in" variable n0 is 0.
%
%   See also
%     HAIR
%
% Copyright (C) 1999 Simo S?rkk?
 
% This software is distributed under the GNU General Public 
% Licence (version 3 or later); please refer to the file 
% Licence.txt, included with the software, for details.
 
if nargin==2
  W = W(n0+1:end,:);
end
T = size(W,2);
S= sum(W) / T;
Std=std(W);
% S=0;Std=0.5;
Temp=W'-repmat(S,size(W,2),1);
Sh=zeros(T,1);
Sl=zeros(T,1);
Ku=(1*Std)/2;
Kl=(1*Std)/2;
for i=2:size(W',1)
    Sh(i)=max(0,W(i)-(S+Ku)+Sh(i-1));
%     Sl(i)=min(0,W(i)-(S-Kl)-Sh(i));
    Sl(i)=min(0,W(i)+(S-Kl)-Sh(i-1));
end
Sh=Sh(1:end)';
Sl=Sl(1:end)';
% C = CUSUM2(W'-repmat(S,size(W,2),1));