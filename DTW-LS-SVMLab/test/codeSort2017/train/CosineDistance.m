function dd = CosineDistance(Xtra,Xs)
dd=zeros(size(Xtra,1),1);
for i=1:size(Xtra,1)
    metrixD1=kernel_matrix(Xs,'lin_kernel',0,Xtra(i,:));
    metrixD2=kernel_matrix(Xtra(i,:),'lin_kernel',0);
    metrixD3=kernel_matrix(Xs,'lin_kernel',0);
    dd(i)=norm(metrixD1)/(sqrt(norm(metrixD2))*sqrt(norm(metrixD3)));
%     dd1(i)=cosinecjy([Xtra(i,:);Xs'],Xs','lin_kernel',2);
end