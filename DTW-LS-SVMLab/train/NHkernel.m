%计算混合距离
function dd = NHkernel(S,Q,q)
z=size(S,1);
ed1=zeros(z,1);%euclidean distance
ed2=zeros(z,1);%euclidean distance
dd=zeros(z,1);%hybird distance
qq=size(Q,2);
F1=zeros(z,qq-2);%相对序列1
F2=zeros(1,qq-2);%相对序列2
kernel_type='lin_kernel';
kernel_pars=0;

%换成DTW算法

for ii=1:z
    A=kernel_matrix(S(ii,:)',kernel_type, kernel_pars,Q');
    ed1(ii)=10000000;
    for a=1:qq
        for b=1:qq
        if A(a,b)<ed1(ii)
            ed1(ii)=A(a,b);
        end
        end
    end
    for jj=1:(q-1)
        if qq-1==1
            F1=S(2)-S(1);
            F2=Q(2)-Q(1);
        else
            F1(ii,2*jj-1)=S(ii,2*jj+1)-S(ii,2*jj-1);
%         else
%              F1(ii,jj)=S(ii+1,1)-S(ii,jj);
            F1(ii,2*jj)=S(ii,2*(jj+1))-S(ii,2*jj);
            F2(2*jj-1)=Q(2*jj+1)-Q(2*jj-1);
            F2(2*jj)=Q(2*(jj+1))-Q(2*jj);
%         jj=jj+1;

        end

    end
    B=kernel_matrix(F1(ii)',kernel_type, kernel_pars,F2');
    ed2(ii)=1000000;
    for c=1:qq-2
        if B(c)<ed2(ii)
            ed2(ii)=B(c);
        end
    end
    dd(ii)=(ed1(ii)+ed2(ii))/2;
end