function [re]=KNNC7m(data)
q=size(data,2);

Kinit=10;
Kend=2;
% rowrank=randperm(size(data,1));
% data=data(rowrank,:);

Num=floor(size(data,1)*0.8);
Nint=ceil(Num/Kinit);
% [ue,re]=KMeans(data(1:Num,:),Kinit);  

[re]=InitializeKNN(data(1:Num,:),Kinit,Nint);  
dataR=re;
% [re]=InitializeKNN(data,Kinit);%  KMeansCJY_c
% dataR=[data(1:Num,:),re(:,end)];

% le=zeros(size(data,1)-Num,1);
% for i=Num+1:size(data,1)
%     le(i-Num)=findCluster(dataR,data(i,:));
% %     dataR=[dataR;[data(i,:),le(i-Num)]];
% end

le=find_Cluster(dataR,data(Num+1:end,:));
re=[dataR;le];

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
                if size(C1,1)==1||size(C2,1)==1
                    Dsc=Dsc+0;
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
                Jsc=ComputeCS(S1,S2,q);
%                 Jsc=Jsc+ComputeCS(S1,S2,q);
                Dsc=Dsc-log(Jsc);
            end            
         end
        if Dsc<0
            DSC(i)=log((2*abs(Dsc)/((Kcurr-1)*(Kcurr-2))));
        else
            DSC(i)=-log((2*(Dsc)/((Kcurr-1)*(Kcurr-2))));
        end
     end
%      [~,d]=min(DSC); %min(JSC) 
    ASC=zeros(Kcurr,1);
    if isreal(DSC)==0
        for i=1:size(DSC,1)
            if imag(DSC(i))~=0
                ASC(i)=(real(DSC(i)));
            else
                ASC(i)=DSC(i);
            end
        end
        [~,d]=min(ASC); %min(JSC)
    else
        [~,d]=min(DSC); %min(JSC)
    end
    
    Ctemp=re(re(:,end)==A(d),1:end-1);
    Qtemp=re;
    Qtemp(Qtemp(:,end)==A(d),:)=[];
    Kcurr=Kcurr-1;
    he=find_Cluster(Qtemp,Ctemp);
    re=[Qtemp;he];
%     re=[Qtemp;Ctemp,he];
    A(d)=[];
end
end