data = [169, 135, 126, 192;50, 20, 11, 77;50,19.9,11,76.7;42,16.6,9.1,63.9;0.22,3.32,8.95,17.61;1.6,1.35,1.2,1.75];
b = bar(data);
ch = get(b,'children');
% set(ch{1},'FaceVertexCData',[1;1;1;1;2;2;2;2;3;3;3;3;4;4;4;4])
% set(ch{2},'FaceVertexCData',[1;1;1;1;2;2;2;2;3;3;3;3;4;4;4;4])
% set(ch{3},'FaceVertexCData',[1;1;1;1;2;2;2;2;3;3;3;3;4;4;4;4])
% set(ch{4},'FaceVertexCData',[1;1;1;1;2;2;2;2;3;3;3;3;4;4;4;4])
set(gca,'XTickLabel',{'²âÊÔ³ÌÐò','tunelssvm','½»²æÑµÁ·','Ä£ÄâÍË»ð','Newtonss','plotlssvm'})
legend('number807-2000','number807-1500','number807-1200','initial');
xlabel('Function Name ');
ylabel('Time occupied');

% 'number395-1800','number395-1200'

data = [169, 135, 126, 192;50, 20, 11, 77;50,19.9,11,76.7;42,16.6,9.1,63.9;0.22,3.32,8.95,17.61;1.6,1.35,1.2,1.75];
b = bar(data);
ch = get(b,'children');
% set(ch{1},'FaceVertexCData',[1;1;1;1;2;2;2;2;3;3;3;3;4;4;4;4])
% set(ch{2},'FaceVertexCData',[1;1;1;1;2;2;2;2;3;3;3;3;4;4;4;4])
% set(ch{3},'FaceVertexCData',[1;1;1;1;2;2;2;2;3;3;3;3;4;4;4;4])
% set(ch{4},'FaceVertexCData',[1;1;1;1;2;2;2;2;3;3;3;3;4;4;4;4])
set(gca,'XTickLabel',{'²âÊÔ³ÌÐò','tunelssvm','½»²æÑµÁ·','Ä£ÄâÍË»ð','Newtonss','plotlssvm'})
legend('number807-2000','number807-1500','number807-1200','initial');
xlabel('Function Name ');
ylabel('Time occupied');