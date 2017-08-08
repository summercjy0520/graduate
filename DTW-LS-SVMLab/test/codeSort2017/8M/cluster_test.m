TXT=  importdata('C:\Documents and Settings\Administrator\×ÀÃæ\cjy\2017\7\data\Spirals.txt');
%TXT= importdata('C:\Documents and Settings\Administrator\×ÀÃæ\cjy\2017\7\24\Aggregation.txt');
% plot(TXT(:,1),TXT(:,2),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k')
file_data=TXT(:,1:end-1);
Data = file_data(:,1:end-1);
Label = file_data(:,end);
datasize = size(Data,1);
distance = zeros(datasize,datasize);
rou = zeros(1,datasize);
delta = zeros(1,datasize);
% dc = getdc(Data);
for i = 1:datasize
clc;
disp('Distance Runing...');
disp(num2str(i / datasize));
for j = 1:datasize
distance(i,j) = sqrt((Data(i,1) - Data(j,1))^2 + (Data(i,1) - Data(j,1))^2);
end
end
percent=2.0;
dc = get_dc(distance,percent,1);
clc;
disp('End');
rou = sum(distance>dc);
for i = 1:datasize
clc;
disp('Delta Runing...');
disp(num2str(i / datasize));
pos = find(rou>rou(i));
if size(pos,2)>0
dis = zeros(1,length(pos));
for j = 1:length(pos)
dis(1,j) = distance(i,pos(j));
end
delta(i) = min(dis);
else
delta(i) = max(distance(i,:));
end
end
clc;
disp('End');
figure,
subplot(1,2,1)
plot_mcpt(Data,Label);
subplot(1,2,2)
scatter(rou,delta)