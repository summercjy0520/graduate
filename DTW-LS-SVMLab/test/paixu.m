function y=paixu(x) 
%—°‘Ò∑®≈≈–Ú. 
r=length(x); 
for i=1:r
   lowindex=i;
   for j=i+1:r
       if x(j)<x(lowindex) 
        lowindex=j; 
       end
   end
   temp=x(i);
         x(i)=x(lowindex);
           x(lowindex)=temp;
end 
y=x;