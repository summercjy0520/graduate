function [bsf_shapelet,D1,D2]=FindingShapeletBF(dataset,MAXLEN,MINLEN)
candidates=GenerateCandidates(dataset,MAXLEN,MINLEN);
bsf_gain=0;
for i=1:size(candidates,1)
    [gain,D1,D2]=CheckCandidate(dataset,candidates{i});
    if gain>=bsf_gain
        bsf_gain=gain;
        bsf_shapelet=candidates{i};
    end
end
end

function [pool]=GenerateCandidates(dataset,MAXLEN,MINLEN)
dataset=dataset(:,1:end-1);
pool={};
l=MAXLEN;
m=size(dataset,2);
while(l>=MINLEN)
    for i=1:size(dataset,1)
        for j=1:(m-l+1)
            pool=[pool;dataset(i,j:(j+l-1))];
        end
    end
    l=l-1;
end
end


