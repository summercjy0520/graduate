clear all;
% X=importdata('data\diyi.txt');
Xtra=importdata('data\diyier.txt');
Ytra=importdata('data\disan.txt');
% Xs=importdata('data\dianzuSVMtest.txt');
% Xt=importdata('data\Ytest.txt');
% Xs1=Xs(:,1)
% Xs2=Xs(:,2)
[gam,sig2] = tunelssvm({Xtra,Ytra,'f',[],[],'RBF_kernel'},'simplex',...
'leaveoneoutlssvm',{'mse'});
[alpha,b] = trainlssvm({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'});
plotlssvm({Xtra,Ytra,'f',gam,sig2,'lin_kernel'},{alpha,b});
% prediction1= predict({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'},Xs1,30);
% prediction2= predict({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'},Xs2,30);
% ticks=cumsum(ones(72,1));
% plot(ticks(1:size(Ytra)),Ytra);
% hold on;
% plot(ticks(size(Xtra)+1:size(ticks)),[prediction1 Xt]);
% plot(ticks(size(Xtra)+1:size(ticks)),[prediction2 Xt]);
% % plot([prediction Xt]);
% xlabel('time');
% ylabel('dianzu');