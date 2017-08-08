% signal(1:250)=0;
% signal(251:1000)=1;
% [estimate,nbias,sigma,descriptor] =entropy(signal,[0,2,2],'u');

% signal=normrnd(0,1,1,1000);
% [estimate,nbias,sigma,descriptor] =entropy(signal);


% signal=[2,2;3,2;4,2;5,2;2,3;3,3;4,3;5,3;2,4;3,4;5,4;4,4;1,1;2,1;3,1;4,1;5,1;6,1;6,2;6,3;6,4;6,5;5,5;4,5;3,5;2,5;1,5;1,4;1,3;1,2];
% A=[0,0];
% [estimate] =entropy(signal);

signal=[2,2;3,2;2,3;3,3;4,4;5,4;4,5;5,5;6,6];

[estimate1] =NHentropy(signal);
[estimate] =kentropy(signal,'lin_kernel',0);