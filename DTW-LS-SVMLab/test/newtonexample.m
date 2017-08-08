R=[2 1; 1 3];
P=[6;4]; 
W=[3;2]; 
u=0.1; 
ww=zeros(2,201); 
ww(:,1)=W; 
for i=1:200 
    deta=R*W-P;     
    W=W-u*eye(2,2)/R*deta;    
    ww(:,i+1)=W;
end  
[W0,W1] = meshgrid(0:0.05:4,-1:0.05:2); 
Z=2*W0.^2+2*W0.*W1+3*W1.^2-12*W0-8*W1+36; 
[X,Y] = contour(W0,W1,Z,20,'LineWidth',2); 
xlabel('W0');ylabel('W1');zlabel('Z'); 
clabel(X,Y,'manual'); 
hold on;  
plot(ww(1,:),ww(2,:),'LineWidth',2);
