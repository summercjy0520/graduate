function [Dist,D,k,w,rw,tw]=dtwdistance(r,t,pflag)
%
% [Dist,D,k,w,rw,tw]=dtw(r,t,pflag)
%
% Dynamic Time Warping Algorithm
% Dist is unnormalized distance between t and r
% D is the accumulated distance matrix
% k is the normalizing factor
% w is the optimal path
% t is the vector you are testing against
% r is the vector you are testing
% rw is the warped r vector
% tw is the warped t vector
% pflag  plot flag: 1 (yes), 0(no)
%
% Version comments:
% rw, tw and pflag added by Pau Mic

[row,M]=size(r); if (row > M) M=row; r=r'; end;
[row,N]=size(t); if (row > N) N=row; t=t'; end;
d=abs(repmat(r',1,N)-repmat(t,M,1));%.^2; %this makes clear the above instruction Thanks Pau Mic

D=zeros(size(d));
D(1,1)=d(1,1);

for m=2:M
    D(m,1)=d(m,1)+D(m-1,1);
end
for n=2:N
    D(1,n)=d(1,n)+D(1,n-1);
end
for m=2:M
    for n=2:N
        D(m,n)=d(m,n)+min(D(m-1,n),min(D(m-1,n-1),D(m,n-1))); % this double MIn construction improves in 10-fold the Speed-up. Thanks Sven Mensing
    end
end

 Dist=D(M,N);
% n=N;
% m=M;
% k=1;
% w=[M N];
% while ((n+m)~=2)
%     if (n-1)==0
%         m=m-1;
%     elseif (m-1)==0
%         n=n-1;
%     else
%         [values,number]=min([D(m-1,n),D(m,n-1),D(m-1,n-1)]);
%         switch number
%             case 1
%                 m=m-1;
%             case 2
%                 n=n-1;
%             case 3
%                 m=m-1;
%                 n=n-1;
%         end
%     end
%     k=k+1;
%     w=[m n; w]; % this replace the above sentence. Thanks Pau Mic
% end
% 
% % warped waves
% rw=r(w(:,1));
% tw=t(w(:,2));