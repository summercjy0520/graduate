function sum=Match(A,B)
n=length(B);
sum=0;
for i=1:n
    sum=sum+length(find(A==B(i)));
end