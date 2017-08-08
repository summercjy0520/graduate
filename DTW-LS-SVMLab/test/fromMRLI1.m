t = -10:0.1:10;
x = 2*sin(10*t)+0.5*t.^2+4;
x = (x - min(x)) / (max(x) - min(x));
x = x';
data              = x(1:end-1);
dataLabels        = x(2:end);
trainDataLength   = round(length(data)*70/100);
TrainingSet       = data(1:trainDataLength);
TrainingSetLabels = dataLabels(1:trainDataLength);
TestSet           = data(trainDataLength+1:end);
TestSetLabels     = dataLabels(trainDataLength+1:end);

options = ' -s 3 -t 2 -c 100 -p 0.001 -h 0';
model   = svmtrain(TrainingSetLabels, TrainingSet, options);

[predicted_label, accuracy, decision_values] = svmpredict(TestSetLabels, TestSet, model);

figure(2);
plot(1:length(TestSetLabels), TestSetLabels, '-b');
hold on;
plot(1:length(TestSetLabels), predicted_label, '-r');
hold off;
