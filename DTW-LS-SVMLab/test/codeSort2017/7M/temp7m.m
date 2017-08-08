le=re(:,end);
figure;
hold on;
for i=1:size(le,1)
if le(i)==1
plot(re(i,1),re(i,2),'ro');
elseif le(i)==2
plot(re(i,1),re(i,2),'go');
elseif le(i)==3
plot(re(i,1),re(i,2),'bo');
elseif le(i)==4
plot(re(i,1),re(i,2),'ko');
elseif le(i)==5
plot(re(i,1),re(i,2),'mo');
elseif le(i)==6
plot(re(i,1),re(i,2),'r*');
elseif le(i)==7
plot(re(i,1),re(i,2),'co');
elseif le(i)==8
plot(re(i,1),re(i,2),'b*');
elseif le(i)==9
plot(re(i,1),re(i,2),'c*');
elseif le(i)==10
plot(re(i,1),re(i,2),'g*');
elseif le(i)==11
plot(re(i,1),re(i,2),'k*');
else
    plot(re(i,1),re(i,2),'m*');
end
end
grid on


plot(S1(:,1),S1(:,2),'.k')
hold on
plot(S2(:,1),S2(:,2),'r*')

 C1=find(temp1(:,end)==B(h));
                S1=zeros(size(C1,1),q);
                S2=zeros(size(C2,1),q);
                for k=1:size(C1,1)
                    S1(k,:)=temp2(C1(k),:);%temp2-data
                end
plot(S1(:,1),S1(:,2),'.k')
hold on
plot(x(1),x(2),'r*')



le=re(:,end);
figure;
hold on;
for i=1:size(le,1)
if le(i)==1
plot3(re(i,1),re(i,2),re(i,3),'ro');
elseif le(i)==2
plot3(re(i,1),re(i,2),re(i,3),'go');
elseif le(i)==3
plot3(re(i,1),re(i,2),re(i,3),'bo');
elseif le(i)==4
plot3(re(i,1),re(i,2),re(i,3),'ko');
elseif le(i)==5
plot3(re(i,1),re(i,2),re(i,3),'mo');
elseif le(i)==6
plot3(re(i,1),re(i,2),re(i,3),'r*');
elseif le(i)==7
plot3(re(i,1),re(i,2),re(i,3),'co');
elseif le(i)==8
plot3(re(i,1),re(i,2),re(i,3),'b*');
elseif le(i)==9
plot3(re(i,1),re(i,2),re(i,3),'c*');
elseif le(i)==10
plot3(re(i,1),re(i,2),re(i,3),'g*');
elseif le(i)==11
plot3(re(i,1),re(i,2),re(i,3),'k*');
else
    plot3(re(i,1),re(i,2),re(i,3),'m*');
end
end
grid on

X2=zscore(TXTA);
Y2=pdist(X2);
Z2=linkage(Y2);
C2=cophenet(Z2,Y2);
T=cluster(Z2,6);
H=dendrogram(Z2);