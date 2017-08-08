function [dd]=findCluster_2(re,x)
B=unique(re(:,end));
m=size(B,1);
q=size(re,2)-1;
data=re(:,1:end-1);
if m>2
    DSC=zeros(m,1);
    for i=1:m
        re=[re;[x,i]];
        data=[data;x];
        Jsc=0;
        for j=1:m-1
            for h=j+1:m
                C1=find(re(:,end)==B(j));
                C2=find(re(:,end)==B(h));
                S1=zeros(size(C1,1),q);
                S2=zeros(size(C2,1),q);
                for k=1:size(C1,1)
                    S1(k,:)=data(C1(k),:);
                end
                
                for k=1:size(C2,1)
                    S2(k,:)=data(C2(k),:);
                end
                Jsc=Jsc+ComputeCS(S1,S2,q);
            end            
        end
        DSC(i)=-log((Jsc*2/((m-1)*(m))));       
    end
    [~,d]=min(DSC); %min(JSC) 
else
    Jsc=zeros(m,1);
    for i=1:m
        re=[re;[x,i]];
        data=[data;x];
        for j=1:m-1
            for h=j+1:m
                C1=find(re(:,end)==B(j));
                C2=find(re(:,end)==B(h));
                S1=zeros(size(C1,1),q);
                S2=zeros(size(C2,1),q);
                for k=1:size(C1,1)
                    S1(k,:)=data(C1(k),:);
                end
                
                for k=1:size(C2,1)
                    S2(k,:)=data(C2(k),:);
                end
                Jsc(i)=ComputeCS(S1,S2,q);
            end            
        end  
    end
    [~,d]=min(Jsc);
end
dd=B(d);
end