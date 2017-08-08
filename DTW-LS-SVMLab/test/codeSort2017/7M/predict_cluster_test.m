S0=S;
S=S(end-2000:end,:);
Ytra=X0(end-2000:end);

S1=zeros(598,9);
H1=zeros(598,1);
for i=1:size(S,1)
if A(i,2)==1
S1(i,:)=S(i,:);
H1(i)=Ytra(i);
end
end
S1(ismember(S1,zeros(1,9),'rows')==1,:)=[];
H1(ismember(H1,0,'rows')==1,:)=[];

S2=zeros(598,9);
H2=zeros(598,1);
for i=1:size(S,1)
if A(i,2)==2
S2(i,:)=S(i,:);
H2(i)=Ytra(i);
end
end
S2(ismember(S2,zeros(1,9),'rows')==1,:)=[];
H2(ismember(H2,0,'rows')==1,:)=[];

[gam,sig2] = tunelssvm({S1,H1,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

[alpha,b] = trainlssvm({S1,H1,'f',gam,sig2,'RBF_kernel'});

d=1;
C=h1-h0;
X0=TXT(1:5605);
prediction=zeros(C,1);
for i=1:C
    X0=[X0(1:end-1);TXT(h0+i-1)];
    Xs=X0(end-q:end);
    prediction(i) = predict({S1,H1,'f',gam,sig2,'RBF_kernel'},Xs,1);
end
% prediction = predictcjy({S1,H1,'f',gam,sig2,'RBF_kernel'},{[X0;Xt],Xs},{d,95});

Xt=TXT(5606:5700);

plot(prediction,'-+');
hold on;
plot(Xt,'-r*');
xlabel('time');
ylabel('Laser(1:5605)');
title('mae=');
mn=size(prediction,1);
w=0;
W=0;
PW=0;
for i=1:mn
    w=w+abs(prediction(i)-Xt(i));
    PW=PW+abs(prediction(i)-Xt(i))/Xt(i);
    W=W+(prediction(i)-Xt(i))^2;
end
mae=w/mn;
rmse=sqrt(W/mn);
mape=100*PW/mn;


