function output = mi(X,Y)
%function output = mi(X,Y)
%X & Y can be matrices which are converted into a joint variable
%before computation
%计算之前 X、Y可以转换成一个联合变量
%expects variables to be column-wise逐列
%
%returns the mutual information between X and Y, I(X;Y)

if (size(X,2)>1)
  mergedFirst = MIToolboxMex(3,X);
else
  mergedFirst = X;
end
if (size(Y,2)>1)
  mergedSecond = MIToolboxMex(3,Y);
else
  mergedSecond = Y;
end
[output] = MIToolboxMex(7,mergedFirst,mergedSecond);
