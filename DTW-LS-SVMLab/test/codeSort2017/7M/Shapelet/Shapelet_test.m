clear all;
close all;
clc;

TXT= importdata('C:\Documents and Settings\Administrator\×ÀÃæ\cjy\2017\7\data\synthetic.txt');
MAXLEN=60;
MINLEN=20;
class=2;

B=[ones(100,1);2*ones(100,1);3*ones(100,1);4*ones(100,1);5*ones(100,1);6*ones(100,1)];
s1=[TXT(1:7,:);TXT(101:107,:)];%;TXT(201:207,:);TXT(301:307,:);TXT(401:407,:);TXT(501:507,:)];
% s2=[B(1:7,:);B(101:107,:);B(201:207,:);B(301:307,:);B(401:407,:);B(501:507,:)];
s2=[ones(7,1);2*ones(7,1)];
S=[s1,s2];

result=Computeshapelet(S,MAXLEN,MINLEN,class);
