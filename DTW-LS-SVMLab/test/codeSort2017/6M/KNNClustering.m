function [re]=KNNClustering(data)

Kinit=6;
Kend=3;

[re,u]=kmeans(data,Kinit);
re=[data,re];
% [u re]=KMeansCJY(data,Kinit);  %最后产生带标号的数据，标号在所有数据的最后，意思就是数据再加一维度
% figure;
% hold on;
% for i=1:size(data,1)
%     if re(i,end)==1   
%          plot(re(i,1),re(i,2),'ro'); 
%     elseif re(i,end)==2
%          plot(re(i,1),re(i,2),'go'); 
%     elseif re(i,end)==3
%          plot(re(i,1),re(i,2),'yo'); 
%     elseif re(i,end)==4
%          plot(re(i,1),re(i,2),'ko'); 
%     elseif re(i,3)==5
%          plot(re(i,1),re(i,2),'o'); 
%     end
% end
% grid on;


q=size(data,2);
utemp=u;

Kcurr=Kinit;
A=1:Kcurr;
% ShatterN=zeros(Kinit-Kend,1);
while Kcurr>Kend
    DSC=zeros(Kcurr,1);
    for i=1:Kcurr
        temp=A;
        temp(temp==A(i))=[];
        Dsc=0;
        for j=1:Kcurr-2
            for h=j+1:Kcurr-1
                C1=find(re(:,end)==temp(j));
                C2=find(re(:,end)==temp(h));
                S1=zeros(size(C1,1),q);
                S2=zeros(size(C2,1),q);
                for k=1:size(C1,1)
                    S1(k,:)=data(C1(k),:);
                end
                
                for k=1:size(C2,1)
                    S2(k,:)=data(C2(k),:);
                end
                Jsc=ComputeCS(S1,S2,q);
                Dsc=Dsc-log(Jsc);
            end            
        end
        DSC(i)=-log((1/(Kcurr-1)*(Kcurr-2)/2)*Dsc);       
    end
    [~,d]=max(DSC); %min(JSC) 
    
    Ctemp=re(re(:,end)==A(d),1:end-1);
    utemp(d,:)=[];
    Kcurr=Kcurr-1;
    A(d)=[];
    for i=1:size(Ctemp,1)
        disCenter=pdist2(Ctemp(i,:),utemp);
%         disCenter(d)=max(disCenter);
        [~,dd]=min(disCenter);
        [~,index]=ismember(re(:,1:end-1),Ctemp(i,:),'rows');
        re(find(index==1),end)=A(dd);       
    end
end
end