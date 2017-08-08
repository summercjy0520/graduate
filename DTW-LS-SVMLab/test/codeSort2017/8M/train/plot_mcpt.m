function plot_mcpt(Data1, Label1)
Data = Data1;
Label = Label1;
ClsNum = length(unique(Label));
if ClsNum > 7
error('Cannot plot data more than 6 classes');
end
DatNum = size(Data,1);
x = Data(:,1);
y = Data(:,2);
hold on;
for i = 1:DatNum
disp(num2str(i/DatNum));
switch Label(i)
case 1
scatter(x(i),y(i),'b');
clc;
disp('Runing...');
case 2
scatter(x(i),y(i),'g');
clc;
disp('Runing...');
case 3
scatter(x(i),y(i),'r');
clc;
disp('Runing...');
case 4
    scatter(x(i),y(i),'c');
clc;
disp('Runing...');
case 5
scatter(x(i),y(i),'m');
clc;
disp('Runing...');
case 6
scatter(x(i),y(i),'y');
clc;
disp('Runing...');
case 7
scatter(x(i),y(i),'k');
clc;
disp('Runing...');
end
end