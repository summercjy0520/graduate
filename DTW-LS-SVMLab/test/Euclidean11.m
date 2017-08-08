function [euclidean] = Euclidean11(x,y)
%Euclidean distance
% x=[1.140,1.066,1.174,1.114];
% x=[1.066,1.114];

% y=[1.118,1.073,1.116,1.062];%S1
% y=[1.073,1.062];
% x=[-0.002,-0.011];
% y=[0.034,0.048];
% y=[1.116,1.062,1.005,0.3963];%S2
% x=[-0.111,-0.099];

%S16
% x=[1.140,1.066,1.174,1.114];
% y=[1.161,1.097,1.065,0.990];

% x=[0.034,0.048];
% y=[-0.096,-0.107];
% 
% for i =1:size(x,1)
%     for j =1:size(y,1)
%         a = x(i,:); b=y(j,:);
% d1(i,j)=sqrt((a-b)*(a-b)');
%     end
% end
% md1 = pdist2(x,y,'Euclidean');
% D1=[d1,md1];

nn=size(x,2);
c=zeros(nn,1);

q1=0;
q2=0;
for i=1:nn
    c(i)=(x(:,i)-y(:,i)).^2;
end
d1=sqrt(sum(c(:)));

for j=1:nn
    q1=q1+x(:,j)^2;
    q2=q2+y(:,j)^2;
end
d2=sqrt(q1)*sqrt(q2);
euclidean=d1/d2;