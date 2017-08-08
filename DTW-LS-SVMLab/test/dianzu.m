clear all;
X=importdata('data\dianzu.txt');
Xtra=importdata('data\dianzuSVM.txt');
Ytra=importdata('data\dianzuY.txt');
Xs=importdata('data\dianzuSVMtest.txt');
Xt=importdata('data\Ytest.txt');

[gam,sig2] = tunelssvm({Xtra,Ytra,'f',[],[],'RBF_kernel'},'simplex',...
'leaveoneoutlssvm',{'mse'});
[alpha,b] = trainlssvm({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'});
plotlssvm({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'},{alpha,b});

Xs1=Xs(:,1);
Xs2=Xs(:,2);
prediction1= predict({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'},Xs1,30);
prediction2= predict({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'},Xs2,30);
ticks=cumsum(ones(72,1));
plot(ticks(1:size(Ytra)),Ytra);
hold on;
plot(ticks(size(Xtra)+1:size(ticks)),[prediction1 Xt]);
plot(ticks(size(Xtra)+1:size(ticks)),[prediction2 Xt]);
% plot([prediction Xt]);
xlabel('time');
ylabel('dianzu');