function MI = mi( A, B ) 
%NMI Normalized mutual information
% http://en.wikipedia.org/wiki/Mutual_information
% http://nlp.stanford.edu/IR-book/html/htmledition/evaluation-of-clustering-1.html

% Author: http://www.cnblogs.com/ziqiao/ [2011/12/13] 
% A = [1 1 1 1 1 1   2 2 2 2 2 2    3 3 3 3 3];
% B = [1 2 1 1 1 1   1 2 2 2 2 3    1 1 3 3 3];

% if length( A ) ~= length( B)
%     error('length( A ) must == length( B)');
% end
% total = length(A);
% 
% for i=1:total
%     A(i)=fix(A(i));
%     B(i)=fix(B(i));
%     i=i+1;
% end
% A_ids = unique(A);
% B_ids = unique(B);
% 
% % Mutual information
% MI = 0;
% for idA = A_ids
%     for idB = B_ids
%          idAOccur = find( A == idA );
%          idBOccur = find( B == idB );
%          idABOccur = intersect(idAOccur,idBOccur); %函数求交集
%          
%          px = length(idAOccur)/total;
%          py = length(idBOccur)/total;
%          pxy = length(idABOccur)/total;
%          
%          MI = MI + pxy*log2(pxy/(px*py)+eps); % eps : the smallest positive number
% 
%     end
% end


if length( A ) ~= length( B)
    error('length( A ) must == length( B)');
end
total = length(A);
for i=1:total
    A(i)=fix(A(i));
    B(i)=fix(B(i));
    i=i+1;
end
A_ids = unique(A);
A_class = length(A_ids);
B_ids = unique(B);
B_class = length(B_ids);
% Mutual information
idAOccur = double (repmat( A, A_class, 1) == repmat( A_ids', 1, total ));
idBOccur = double (repmat( B, B_class, 1) == repmat( B_ids', 1, total ));
idABOccur = idAOccur * idBOccur';
Px = sum(idAOccur') / total;
Py = sum(idBOccur') / total;
Pxy = idABOccur / total;
MImatrix = Pxy .* log2(Pxy ./(Px' * Py)+eps);
MI = sum(MImatrix(:))


% % Normalized Mutual information
% Hx = 0; % Entropies
% for idA = A_ids
%     idAOccurCount = length( find( A == idA ) );
%     Hx = Hx - (idAOccurCount/total) * log2(idAOccurCount/total + eps);
% end
% Hy = 0; % Entropies
% for idB = B_ids
%     idBOccurCount = length( find( B == idB ) );
%     Hy = Hy - (idBOccurCount/total) * log2(idBOccurCount/total + eps);
% end
% 
% MIhat = 2 * MI / (Hx+Hy);
end


% Example :  
% (http://nlp.stanford.edu/IR-book/html/htmledition/evaluation-of-clustering-1.html)
% A = [1 1 1 1 1 1   2 2 2 2 2 2    3 3 3 3 3];
% B = [1 2 1 1 1 1   1 2 2 2 2 3    1 1 3 3 3];
% nmi(A,B)

% ans = 0.3646 