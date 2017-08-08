[NUMERIC,TXT,RAW] = xlsread('data\ionosphare.xlsx');
mm=size(TXT);
Y1=zeros(mm,1);
sum=0;
for i=1:mm
    if strcmp(TXT(i),'b')
        Y1(i)=1;
    else Y1(i)=-1;
    end
end
X=NUMERIC(51:351,3:34);
Xt=NUMERIC(1:50,3:34);
Y=Y1(51:351);
Yt=Y1(1:50);
type='classification';
L_fold=10; % L_fold crossvalidation
[gam,sig2] = tunelssvm({X,Y,type,[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{L_fold,'misclass'});  %µ•∑÷¿‡
[alpha,b]=trainlssvm({X,Y,type,gam,sig2,'RBF_kernel'});
Ytest=simlssvm({X,Y,type,gam,sig2,'RBF_kernel'},{alpha,b},Xt);
for i=1:size(Ytest)
if Ytest(i)==Yt(i)
    sum=sum+1;
end
end
plotlssvm({X,Y,type,gam,sig2,'RBF_kernel'},{alpha,b});
hold on;
plotlssvm({Xt,Ytest,type,gam,sig2,'RBF_kernel'});
plotlssvm({Xt,Yt,type,gam,sig2,'RBF_kernel'});

        