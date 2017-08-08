clear all
close all
clc
disp('The only input needed is a distance matrix file')
disp('The format of this file should be: ')
disp('Column 1: id of element i')
disp('Column 2: id of element j')
disp('Column 3: dist(i,j)')

%% 从文件中读取数据
mdist=input('name of the distance matrix file (with single quotes)?\n');
disp('Reading input distance matrix')

TXT= importdata('C:\Documents and Settings\Administrator\桌面\cjy\2017\7\data\Jain.txt');
%TXT= importdata('C:\Documents and Settings\Administrator\桌面\cjy\2017\7\24\Aggregation.txt');
% plot(TXT(:,1),TXT(:,2),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k')
file_data=TXT(:,1:end);


Data = file_data(:,1:end-1);
Label = file_data(:,end);
datasize = size(Data,1);
ND=datasize;
dist = zeros(datasize,datasize);
rou = zeros(1,datasize);
delta = zeros(1,datasize);

xx=zeros(datasize*datasize,1);

for i = 1:datasize
clc;
disp('Distance Runing...');
disp(num2str(i / datasize));
for j = 1:datasize
dist(i,j) = sqrt((Data(i,1) - Data(j,1))^2 + (Data(i,1) - Data(j,1))^2);
xx((i-1)*datasize+j)=sqrt((Data(i,1) - Data(j,1))^2 + (Data(i,1) - Data(j,1))^2);
end
end
%% 确定 dc

% percent=2.0;
% fprintf('average percentage of neighbours (hard coded): %5.6f\n', percent);
% 
% position=round(datasize^2*percent/100); %% round 是一个四舍五入函数
% sda=sort(xx); %% 对所有距离值作升序排列
% dc=sda(position);
percent=2.0;
dc = get_dc(dist,percent,0);

%% 计算局部密度 rho (利用 Gaussian 核)

fprintf('Computing Rho with gaussian kernel of radius: %12.6f\n', dc);

%% 将每个数据点的 rho 值初始化为零
nneigh=zeros(datasize,1);
rho = sum(dist>dc);
for i = 1:datasize
clc;
disp('Delta Runing...');
disp(num2str(i / datasize));
pos = find(rho>rho(i));
if size(pos,2)>0
dis = zeros(1,length(pos));
for j = 1:length(pos)
dis(1,j) = dist(i,pos(j));
end
[delta(i),cc] = min(dis);
nneigh(i)=pos(cc);
else
delta(i) = max(dist(i,:));
nneigh(i)=i;
end
end
% 
%% for i=1:datasize
%   rho(i)=0.;
% end
% 
% % Gaussian kernel
% for i=1:ND-1
%   for j=i+1:ND
%      rho(i)=rho(i)+exp(-(dist(i,j)/dc)*(dist(i,j)/dc));
%      rho(j)=rho(j)+exp(-(dist(i,j)/dc)*(dist(i,j)/dc));
%   end
% end

% "Cut off" kernel
% for i=1:datasize-1
%  for j=i+1:datasize
%    if (dist(i,j)<dc)
%       rho(i)=rho(i)+1.;
%       rho(j)=rho(j)+1.;
%    end
%  end
% end

% 先求矩阵列最大值，再求最大值，最后得到所有距离值中的最大值
% maxd=max(max(dist)); 
% 
% %% 将 rho 按降序排列，ordrho 保持序
% [rho_sorted,ordrho]=sort(rho,'descend');
%  
% %% 处理 rho 值最大的数据点
% delta(ordrho(1))=-1.;
% nneigh(ordrho(1))=0;
% 
% %% 生成 delta 和 nneigh 数组
% for ii=2:datasize
%    delta(ordrho(ii))=maxd;
%    for jj=1:ii-1
%      if(dist(ordrho(ii),ordrho(jj))<delta(ordrho(ii)))
%         delta(ordrho(ii))=dist(ordrho(ii),ordrho(jj));
%         nneigh(ordrho(ii))=ordrho(jj); 
%         %% 记录 rho 值更大的数据点中与 ordrho(ii) 距离最近的点的编号 ordrho(jj)
%      end
%    end
% end
% 
% %% 生成 rho 值最大数据点的 delta 值
% delta(ordrho(1))=max(delta(:));

%% 决策图
[rho_sorted,ordrho]=sort(rho,'descend');
disp('Generated file:DECISION GRAPH') 
disp('column 1:Density')
disp('column 2:Delta')

fid = fopen('DECISION_GRAPH', 'w');
for i=1:datasize
   fprintf(fid, '%6.2f %6.2f\n', rho(i),delta(i));
end

%% 选择一个围住类中心的矩形
disp('Select a rectangle enclosing cluster centers')

%% 每台计算机，句柄的根对象只有一个，就是屏幕，它的句柄总是 0
%% >> scrsz = get(0,'ScreenSize')
%% scrsz =
%%            1           1        1280         800
%% 1280 和 800 就是你设置的计算机的分辨率，scrsz(4) 就是 800，scrsz(3) 就是 1280
scrsz = get(0,'ScreenSize');

%% 人为指定一个位置，感觉就没有那么 auto 了 :-)
figure('Position',[6 72 scrsz(3)/4. scrsz(4)/1.3]);

%% ind 和 gamma 在后面并没有用到
for i=1:datasize
  ind(i)=i; 
  gamma(i)=rho(i)*delta(i);
end

%% 利用 rho 和 delta 画出一个所谓的“决策图”

subplot(2,1,1)
tt=plot(rho(:),delta(:),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
title ('Decision Graph','FontSize',15.0)
xlabel ('\rho')
ylabel ('\delta')

subplot(2,1,1)
rect = getrect(1);
rhomin=rect(1);
deltamin=rect(2);
NCLUST=0;
for i=1:ND
  cl(i)=-1;
end
for i=1:ND
  if ( (rho(i)>rhomin) && (delta(i)>deltamin))
     NCLUST=NCLUST+1;
     cl(i)=NCLUST;
     icl(NCLUST)=i;
  end
end
fprintf('NUMBER OF CLUSTERS: %i \n', NCLUST);
disp('Performing assignation')

%assignation
for i=1:ND
  if (cl(ordrho(i))==-1)
    cl(ordrho(i))=cl(nneigh(ordrho(i)));
  end
end
%halo
for i=1:ND
  halo(i)=cl(i);
end
if (NCLUST>1)
  for i=1:NCLUST
    bord_rho(i)=0.;
  end
  for i=1:ND-1
    for j=i+1:ND
      if ((cl(i)~=cl(j))&& (dist(i,j)<=dc))
        rho_aver=(rho(i)+rho(j))/2.;
        if (rho_aver>bord_rho(cl(i))) 
          bord_rho(cl(i))=rho_aver;
        end
        if (rho_aver>bord_rho(cl(j))) 
          bord_rho(cl(j))=rho_aver;
        end
      end
    end
  end
  for i=1:ND
    if (rho(i)<bord_rho(cl(i)))
      halo(i)=0;
    end
  end
end
for i=1:NCLUST
  nc=0;
  nh=0;
  for j=1:ND
    if (cl(j)==i) 
      nc=nc+1;
    end
    if (halo(j)==i) 
      nh=nh+1;
    end
  end
  fprintf('CLUSTER: %i CENTER: %i ELEMENTS: %i CORE: %i HALO: %i \n', i,icl(i),nc,nh,nc-nh);
end

cmap=colormap;
 figure;
for i=1:NCLUST
   ic=int8((i*64.)/(NCLUST*1.)+1);%int8((i*64.)/(NCLUST*1.);
   subplot(2,1,1)
   hold on
   if ic>64
       ic=64;
   end
   plot(rho(icl(i)),delta(icl(i)),'o','MarkerSize',8,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
end
subplot(2,1,2)
disp('Performing 2D nonclassical multidimensional scaling')
Y1 = mdscale(dist, 2, 'criterion','metricsstress');
plot(Y1(:,1),Y1(:,2),'o','MarkerSize',2,'MarkerFaceColor','k','MarkerEdgeColor','k');
title ('2D Nonclassical multidimensional scaling','FontSize',15.0)
xlabel ('X')
ylabel ('Y')
for i=1:ND
 A(i,1)=0.;
 A(i,2)=0.;
end
figure;
for i=1:NCLUST
  nn=0;
  ic=int8((i*64.)/(NCLUST*1.)+1);
  for j=1:ND
    if (halo(j)==i)
      nn=nn+1;
      A(nn,1)=Y1(j,1);
      A(nn,2)=Y1(j,2);
    end
  end
  hold on
  if ic>64
       ic=64;
  end
  plot(A(1:nn,1),A(1:nn,2),'o','MarkerSize',2,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
end

%for i=1:ND
%   if (halo(i)>0)
%      ic=int8((halo(i)*64.)/(NCLUST*1.));
%      hold on
%      plot(Y1(i,1),Y1(i,2),'o','MarkerSize',2,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
%   end
%end
faa = fopen('E:\cjy\2017\CLUSTER_ASSIGNATION.txt', 'w');
disp('Generated file:CLUSTER_ASSIGNATION')
disp('column 1:element id')
disp('column 2:cluster assignation without halo control')
disp('column 3:cluster assignation with halo control')
for i=1:ND
   fprintf(faa, '%i %i %i\n',i,cl(i),halo(i));
end