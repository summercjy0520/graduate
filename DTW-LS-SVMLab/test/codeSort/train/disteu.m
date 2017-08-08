function distance = disteu(y, x)
% DISTEU 两个矩阵的列之间的欧氏距离
%
% Input:
%       x, y:   两个矩阵，每一列都是一个矢量
%
% Output:
%       d:      元素 d(i,j) 是两个列向量X(:,i) 和 Y(:,j)之间的欧氏距离
%
% Note:
%       矢量X 和 Y之间的欧氏距离D为:
%       D = sum((x-y).^2).^0.5
[dim1 L]=size(x');
[dim2 cluster]=size(y');
distance = 0;
for i=1:L
    temp = repmat(x(:,i),1,cluster);
    distance = min(sum((temp-y).^2,1))+distance;
end