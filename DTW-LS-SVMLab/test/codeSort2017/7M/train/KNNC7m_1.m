function [re]=KNNC7m(data)

Kinit=10;
Kend=3;

% [re,u]=kmeans(data,Kinit);
le=clusterdata(data,Kinit);

re=[data,le];

% le=zeros(size(data,1)-Num,1);
% for i=Num+1:size(data,1)
%     le(i-Num)=findCluster(dataR,data(i,:));
%     dataR=[dataR;[data(i,:),le(i-Num)]];
% end
% 
% re=[data,[re;le]];

q=size(data,2);

Kcurr=Kinit;
A=1:Kcurr;
% ShatterN=zeros(Kinit-Kend,1);
while Kcurr>Kend   
    if Kcurr>3
        JSC=zeros(Kcurr,1);
        for i=1:Kcurr
        temp=A;
        temp(temp==A(i))=[];
        Jsc=0;
        for j=1:Kcurr-2
            for h=j+1:Kcurr-1
                C1=find(re(:,end)==temp(j));
                C2=find(re(:,end)==temp(h));
                if size(C1,1)==1||size(C2,1)==1
                    Jsc=Jsc+0;
                    break;
                end
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
        JSC(i)=(2*1/((Kcurr-1)*(Kcurr-2)))*Jsc;       
        end
       [~,d]=min(JSC); %min(JSC) 
    else
        JSC=zeros(Kcurr,1);
        for i=1:Kcurr
        temp=A;
        temp(temp==A(i))=[];
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
                JSC(i)=ComputeCS(S1,S2,q);
            end            
        end
        end
     [~,d]=min(JSC); %min(JSC) 
    end
   
    
    Ctemp=re(re(:,end)==A(d),1:end-1);
    Qtemp=re;
    Qtemp(Qtemp(:,end)==A(d),:)=[];
    Kcurr=Kcurr-1;
    he=zeros(size(Ctemp,1),1);
    for i=1:size(Ctemp,1)
        he(i)=findCluster_1(Qtemp,Ctemp(i,:));
        Qtemp=[Qtemp;[Ctemp(i,:),he(i)]];
%         [~,index]=ismember(re(:,1:end-1),Ctemp(i,:),'rows');
%         if any(index==1)==1
%             Qtemp=[Qtemp;re(find(index==1),1:end-1),A(dd)];
%         end
%         Qtemp(find(index==1),end)=A(dd);       
    end
    re=Qtemp;
%     re=[Qtemp;Ctemp,he];
    A(d)=[];
end
end