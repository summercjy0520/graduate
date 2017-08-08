clear all;
close all;
clc;

TXTA= importdata('C:\Documents and Settings\Administrator\×ÀÃæ\cjy\2017\7\data\data\arrowhead_test.txt');

% index1=2;%randperm(size(TXTA,1),1);
% index2=6;%randperm(size(TXTA,1),1);
% index3=8;%randperm(size(TXTA,1),1);
TXT=[TXTA(1:7,30:450);TXTA(end-57:end-51,30:450)];%TXTA(index3,:)];

MAXLEN=450;
MINLEN=100;
class=2;

% B=[ones(100,1);2*ones(100,1);3*ones(100,1);4*ones(100,1);5*ones(100,1);6*ones(100,1)];
% s1=[TXT(1:7,:);TXT(101:107,:)];%;TXT(201:207,:);TXT(301:307,:);TXT(401:407,:);TXT(501:507,:)];
% % s2=[B(1:7,:);B(101:107,:);B(201:207,:);B(301:307,:);B(401:407,:);B(501:507,:)];
% s2=[ones(7,1);2*ones(7,1)];
S=[TXT,[1,1,1,1,1,1,1,2,2,2,2,2,2,2]'];

result=Computeshapelet(S,MAXLEN,MINLEN,class);
