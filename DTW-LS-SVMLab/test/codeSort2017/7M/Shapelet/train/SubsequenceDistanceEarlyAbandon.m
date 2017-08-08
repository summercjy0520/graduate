function [min_dist]=SubsequenceDistanceEarlyAbandon(T,S)
min_dist=inf;
m=size(S,2);
stop=0;
for i=1:(size(T,2)-m)
    sum_dist=0;
    Ttemp=T(i:i+m-1);
    for j=1:size(S,2)
        sum_dist=sum_dist+(Ttemp(j)-S(j))^2;
        if sum_dist>=min_dist
            stop=1;
            break;
        end
    end
    if stop==0
        min_dist=sum_dist;
    end
end
end


function [boolean]=EntropyEarlyPrune(dataset,bsf_gain,dist_hist,cA,cB)
minend=1;
[index,~]=max(dist_hist);
maxend=index+1;
pred_dist_hist=dist_hist;
boolean=0;
for i=1:size(cA,1)
    pred_dist_hist=[pred_dist_hist;minend];
end
for j=1:size(cB,1)
    pred_dist_hist=[pred_dist_hist;maxend];
end

if CalculateInformationGain(dataset,pred_dist_hist)>bsf_gain
    boolean=0;
end

pred_dist_hist=dist_hist;
for i=1:size(cA,1)
    pred_dist_hist=[pred_dist_hist;maxend];
end
for j=1:size(cB,1)
    pred_dist_hist=[pred_dist_hist;minend];
end
if CalculateInformationGain(dataset,pred_dist_hist)>bsf_gain
    boolean=0;
end
end

