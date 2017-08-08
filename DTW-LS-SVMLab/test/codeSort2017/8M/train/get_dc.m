function y=get_dc(dis,percentage,kernel)
max_dis=max(max(dis))/2;
[m,n]=size(dis);
i=0;
for i=0:max_dis/1000:max_dis
    p=get_P(dis,i,kernel);
    p_ave=sum(p)/m;
    if(p_ave>m*percentage)
        break;
    end
end
y=i;