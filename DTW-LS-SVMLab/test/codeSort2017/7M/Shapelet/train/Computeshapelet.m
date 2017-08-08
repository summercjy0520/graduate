function [bsf_shapelet]=Computeshapelet(S,MAXLEN,MINLEN,class)
index=class;
bsf_shapelet=zeros(class-1,MAXLEN);
while index>0
    [bsf_shapelet(class-index+1,:),D1,D2]=FindingShapeletBF(S,MAXLEN,MINLEN);
    index=index-1;
    if index>0 && isempty(D1)==0
        S=D1;
        [bsf_shapelet(class-index+1),D1,D2]=FindingShapeletBF(S,MAXLEN,MINLEN);
        index=index-1;
    elseif index>0 && isempty(D2)==0
        S=D2;
        [bsf_shapelet(class-index+1),D1,D2]=FindingShapeletBF(S,MAXLEN,MINLEN);
        index=index-1;
    end
        
end
end