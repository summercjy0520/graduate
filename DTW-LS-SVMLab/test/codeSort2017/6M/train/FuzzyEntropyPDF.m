function [K]=FuzzyEntropyPDF(Y,q)
[Y,KT]=sort(Y);
diff=zeros(size(Y,1),1);
%Renyi's second order entropy;
% for j=2:size(Y,1)
%     Vdistance=0; %-inf
%     for i=2:j
%         Vtemp=((pi^(q/2))/gamma(q/2+1))*(Y(i)^2);
%         Vdistance=Vdistance+1/Vtemp;
%     end
%     diff(j)=-log((j/(size(Y,1)^2))*Vdistance);
% end

for j=1:size(Y,1)
    Vtemp=((pi^(q/2))*(Y(j)^2/gamma(q/2+1)));
    Pdistance=j/(size(Y,1)*Vtemp);
    diff(j)=-Pdistance*log(Pdistance);
end
[c,d]=max(diff);
K=d;
end