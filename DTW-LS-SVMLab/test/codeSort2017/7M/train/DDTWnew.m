%计算混合距离
function dd = DDTWnew(S,Q)
Xs{1}=S';
Xs{2}=Q';
z=size(Q,1);
dd=zeros(z,1);%hybird distance

Ys = cell(1, 2);
for i = 1 : 2
    Ys{i} = gradient(Xs{i});
%     Z = Xs{i} * lapl(size(Xs{i}, 2), 'gradient');
%     equal('Z', Z, Ys{i});
end

%换成DTW算法
Q=(Ys{1})';
S=(Ys{2})';

for ii=1:z
    dd(ii)=Dtwdistance(S(ii,:),Q);
end
[dd,~]=mapminmax(dd',0,1);
dd=dd';