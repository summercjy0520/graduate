function new_label=cluster_density(phi_index,r,cluster_num)

m=length(phi_index);
new_label=zeros(m,1);
[~,index_r1]=sort(r,'descend');

for i=1:cluster_num
    new_label(index_r1(i))=i;
    tt=index_r1(i);
end

for i=1:m
    if (new_label(i)==0)
        j=i;
        while(new_label(j)==0)
            j=phi_index(j);
        end
        new_label(i)=new_label(j);
    end
    
end