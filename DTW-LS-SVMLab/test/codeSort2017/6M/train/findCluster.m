function [dd]=findCluster(re,x)
B=unique(re(:,end));
m=size(B,1);
q=size(re,2)-1;
data=re(:,1:end-1);
if m>2
    DSC=zeros(m,1);
    for i=1:m
        temp1=[re;[x,B(i)]]; %re=[re;[x,B(i)]];
        temp2=[data;x]; %data=[data;x];
        Dsc=0;
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
                Jsc=ComputeCS(S1,S2,q);
                Dsc=Dsc-log(Jsc);
            end            
        end
        DSC(i)=-log((Dsc*2/((m-1)*(m))));       
    end
    [~,d]=min(DSC); %min(JSC) 
else
    Jsc=zeros(m,1);
    for i=1:m
        temp1=[re;[x,i]];
        temp2=[data;x];
        for j=1:m-1
            for h=j+1:m
                C1=find(temp1(:,end)==B(j));
                C2=find(temp1(:,end)==B(h));
                S1=zeros(size(C1,1),q);
                S2=zeros(size(C2,1),q);
                for k=1:size(C1,1)
                    S1(k,:)=temp2(C1(k),:);
                end
                
                for k=1:size(C2,1)
                    S2(k,:)=temp2(C2(k),:);
                end
                Jsc(i)=ComputeCS(S1,S2,q);
            end            
        end  
    end
    [~,d]=min(Jsc);
end
dd=B(d);
end