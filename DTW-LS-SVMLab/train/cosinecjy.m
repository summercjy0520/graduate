%计算cosine sum 
function csum = cosinecjy(S,Q,kernel_type,k)
%S为中心样本点对应的k个临近序列的矩阵
%Q为中心样本点的序列

% sum=0;
%计算sum
ssum=zeros(k,1);
sum=0;
csum=0;
kernel_pars=0;
for a=1:k
    for b=1:k
        omega6= kernel_matrix(S(a,:)',kernel_type, kernel_pars,S(b,:)');
        sum=sum+omega6;
    end
end
for i=1:k
    omega1= kernel_matrix(Q',kernel_type, kernel_pars); %第一项
    omega2= kernel_matrix(Q',kernel_type, kernel_pars,S(i,:)');%第二项
    sum3=0;
    sum4=0;
    for j=1:k
        omega3= kernel_matrix(Q',kernel_type, kernel_pars,S(j,:)');
        sum3=sum3+omega3;
        omega4= kernel_matrix(S(i,:)',kernel_type, kernel_pars,S(j,:)');
        sum4=sum4+omega4;
    end
    omega3=(1/k)*sum3;
    omega4=(1/k)*sum4;
    omega5=kernel_matrix(S(i,:)',kernel_type, kernel_pars);
    omega=omega1-omega2-omega3+omega4;
    d1=omega1-(2/k)*sum3+(1/(k^2))*sum;
    d2=omega1-2*omega2+omega5;
    ssum(i)=norm(omega)/(sqrt(norm(d1))*sqrt(norm(d2)));
end
for ii=1:k
    csum=csum+ssum(ii);
end
end


% sum1=0;
% kernel_pars=0;
% for i=1:k
%     omega0= kernel_matrix(Q',kernel_type, kernel_pars,S(i,:)');%第二项
%     sum1=sum1+omega0;
% end
% 
% sum2=0;
% % sum3=0;
% for ii=1:k
% %     omega1= omega1+kernel_matrix(Q,kernel_type, kernel_pars,S(ii));
%     omega2= kernel_matrix(Q',kernel_type, kernel_pars);
%     for j=1:k
%          omega3= kernel_matrix(S(ii,:)',kernel_type, kernel_pars,S(j,:)');
%          sum2=sum2+omega3;
%     end
% end
% csum=0;
% for iii=1:k
%     omega1= kernel_matrix(Q',kernel_type, kernel_pars,S(iii,:)');
%     omega4= kernel_matrix(S(iii,:)',kernel_type, kernel_pars);
%     dsum=norm(omega2)-norm(omega1)-norm((1/k)*sum1)+norm((1/k)*sum2);
% %     dsum=csum+sum3;
%     d1=norm(omega2)-norm((2/k)*sum1)+norm((1/k^2)*sum2);
%     d2=norm(omega2)-2*norm(omega1)+norm(omega4);
%     csum=csum+dsum/(sqrt(d1)*sqrt(d2));
% end
% 
% end