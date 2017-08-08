%计算混合距离
function dd = NHDTWnewa(S,Q)
z=size(S,1);
ed1=zeros(z,1);%NH distance
dd=zeros(z,1);%hybird distance
% A=zeros(1,qq);

%换成DTW算法

ed2=pdist2(S,Q);
[ed2,t2]=mapminmax(ed2',0,1);
for ii=1:z   
     ed1(ii)=Dtwdistance(S(ii,:),Q);     
end
[ed1,t1]=mapminmax(ed1',0,1);

for jj=1:z
    dd(jj)=(ed1(jj)+ed2(jj))/2; 
end
[dd,T1]=mapminmax(dd',0,1);
dd=dd';