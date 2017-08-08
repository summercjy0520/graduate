function y=get_P(dis,dc,label)
[m,n]=size(dis);
y=zeros(m,1);
for i=1:m
    y(i)=0;
   for j=1:m
      if(i~=j)
          if label==0
             if(dis(i,j)-dc<0)
                 y(i)=y(i)+1;
             end    
          else
              y(i)=y(i)+exp(-(dis(i,j)/dc)^2);
          end
      end      
   end    
end