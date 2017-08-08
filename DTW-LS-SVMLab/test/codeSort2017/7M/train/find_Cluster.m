function [dd]=find_Cluster(re,xx)
data=re(:,1:end-1);
% p1=size(removeINF(C1));
% p2=size(removeINF(C2));
nn=size(xx,1);
dd=zeros(nn,size(re,2));
% dd0=zeros(nn,1);
for s=1:nn
mm=size(xx,1);
distance=zeros(mm,1);
for i=1:mm
    distance(i)=min(pdist2(xx(i,:),data));
end
[~,a]=min(distance);
x=xx(a,:);

B=unique(re(:,end));
m=size(B,1);
q=size(re,2)-1;

    DSC=zeros(m,1);
    J1=zeros(m-1,m-1);
    D1=zeros(m-1,m-1);
    for i=1:m
        temp1=[re;[x,B(i)]]; %re=[re;[x,B(i)]];
        temp2=[data;x]; %data=[data;x];
        Dsc=0;
%         index=1;
        for j=1:m-1
            for h=j+1:m
                C1=find(temp1(:,end)==B(j)); %temp1-re
                C2=find(temp1(:,end)==B(h));
                S1=zeros(size(C1,1),q);
                S2=zeros(size(C2,1),q);
                for k=1:size(C1,1)
                    S1(k,:)=temp2(C1(k),:);%temp2-data
                end
                
                for k=1:size(C2,1)
                    S2(k,:)=temp2(C2(k),:);
                end
%                 Jsc=Jsc+ComputeCS(S1,S2,q);
                Jsc=ComputeCS(S1,S2,q);
                Dsc=Dsc-log(Jsc);
                J1(j,h)=Jsc;
                D1(j,h)=-log(Jsc);
%                 index=index+1;
            end
        end  
        DSC(i)=-log((Dsc*2/((m-1)*(m))));
    end
%     ASC=zeros(m,1);
    if isreal(DSC)==0
            [C,~]=max(J1,[],2);
            [~,d]=min(C);
%         for i=1:size(DSC,1)
%             if imag(DSC(i))~=0
%                 ASC(i)=inf;
%             else
%                 ASC(i)=DSC(i);
%             end
%         end
%         [~,d]=min(ASC); %min(JSC)
    else
        [~,d]=min(DSC); %min(JSC)
    end 
 
 dd(s,:)=[x,B(d)];
 re=[re;[x,B(d)]];
 data=[data;x];
 xx(a,:)=[];
end
end
% data=re(:,1:end-1);
% D=pdist2(data,x);
% [~,A]=sort(D);
% 
% dd=re(A(1),end);