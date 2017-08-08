clear all
close all
clc
disp('The only input needed is a distance matrix file')
disp('The format of this file should be: ')
disp('Column 1: id of element i')
disp('Column 2: id of element j')
disp('Column 3: dist(i,j)')

disp('Reading input distance matrix')

TXT= importdata('C:\Documents and Settings\Administrator\×ÀÃæ\cjy\2017\7\data\Jain.txt');
%plot(TXT(:,1),TXT(:,2),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k')
S=TXT(:,1:2);
q=size(S,2);
xx=Computedist(S);
ND=max(xx(:,2));
NL=max(xx(:,1));
if (NL>ND)
  ND=NL;
end
N=size(xx,1);
for i=1:ND
  for j=1:ND
    dist(i,j)=0;
  end
end
for i=1:N
  ii=xx(i,1);
  jj=xx(i,2);
  dist(ii,jj)=xx(i,3);
  dist(jj,ii)=xx(i,3);
end
percent=2.0;
fprintf('average percentage of neighbours (hard coded): %5.6f\n', percent);

position=round(N*percent/100);
sda=sort(xx(:,3));
dc=sda(position)*1;

fprintf('Computing Rho with Cut-off kernel of radius: %12.6f\n', dc);

rho=zeros(ND,1);
% for i=1:ND
%     A=S(i,:);
%     temp=S;
%     temp(i,:)=[];
%     dd=pdist2(temp,A,'Euclidean');
%     rho(i)=minEntropyD(dd);
% %     rho(i)=minEntropyPDFs(dd,size(S,2));
% end
% for i=1:ND
%   rho(i)=0.;
% end
% %
% % Gaussian kernel
% %
for i=1:ND-1
  for j=i+1:ND
     rho(i)=rho(i)+exp(-(dist(i,j)/dc)*(dist(i,j)/dc));
     rho(j)=rho(j)+exp(-(dist(i,j)/dc)*(dist(i,j)/dc));
  end
end
%
% "Cut off" kernel
% 
% for i=1:ND-1
%  for j=i+1:ND
%    if (dist(i,j)<dc)
%       rho(i)=rho(i)+1.;
%       rho(j)=rho(j)+1.;
%    end
%  end
% end

maxd=max(max(dist));

[rho_sorted,ordrho]=sort(rho,'descend');
% delta(ordrho(1))=-1.;
T1=zeros(ND,1);
for f=1:ND
    T1(f)=dist(ordrho(1),f);
end
delta(ordrho(1))=max(T1);
nneigh(ordrho(1))=0;
% mneigh(ordrho(1))=0;

for ii=2:ND
   delta(ordrho(ii))=maxd;
   for jj=1:ii-1
     if(dist(ordrho(ii),ordrho(jj))<delta(ordrho(ii)))
        delta(ordrho(ii))=dist(ordrho(ii),ordrho(jj));
%         mneigh(ordrho(ii))=nneigh(ordrho(ii));
        nneigh(ordrho(ii))=ordrho(jj);
     end
   end
end

% T1=zeros(ND,1);
% for f=1:ND
%     T1(f)=dist(ordrho(1),f);
% end
% delta(ordrho(1))=max(T1);
% delta(ordrho(1))=max(delta(:));
disp('Generated file:DECISION GRAPH')
disp('column 1:Density')
disp('column 2:Delta')

fid = fopen('DECISION_GRAPH', 'w');
for i=1:ND
   fprintf(fid, '%6.2f %6.2f\n', rho(i),delta(i));
end

disp('Select a rectangle enclosing cluster centers')
scrsz = get(0,'ScreenSize');
figure('Position',[6 72 scrsz(3)/4. scrsz(4)/1.3]);
for i=1:ND
  ind(i)=i;
  gamma(i)=rho(i)*delta(i);
end
[gamma,AT]=sort(gamma,'descend');

subplot(2,1,1)
plot(rho(:),delta(:),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
title ('Decision Graph','FontSize',15.0)
xlabel ('\rho')
ylabel ('\delta')


subplot(2,1,1)
rect = getrect(1);
rhomin=rect(1);
deltamin=rect(4);
k=0;
for i=1:ND
  if ( (rho(i)>rhomin) && (delta(i)>deltamin))
     k=k+1;
  end
end

subplot(2,1,2)
tt=plot(ind(:),gamma(:),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
title ('Decision Graph','FontSize',15.0)
xlabel ('\rho')
ylabel ('\delta')

subplot(2,1,2)
rect = getrect(1);
rhomin=rect(1);
deltamin=rect(4);
NCLUST=size(find((gamma>deltamin)>0),2);

%trapz
core1=S(AT(1),:);%AT(1);
cl=ones(ND,1)*(-1);
if k>2
    for f=1:NCLUST
        
    end
else
    distdiff=dist(AT(1),AT(2));
    indexA=AT(2);
    for f=2:NCLUST
        if dist(AT(1),AT(f))>=distdiff
        core2=S(AT(f),:);
        indexA=f;
        end
    end
    cl(AT(1))=1;
    cl(AT(indexA))=2;
    icl(1)=AT(1);
    icl(2)=AT(indexA);
end
NCLUST=k;
fprintf('NUMBER OF CLUSTERS: %i \n', NCLUST);
disp('Performing assignation')

ordrhoAT=ordrho;
ordrhoAT(1)=[];
ordrhoAT(indexA-1)=[];
ordrho=[ordrho(1);ordrho(indexA);ordrhoAT];
for ii=2:ND
   delta(ordrho(ii))=maxd;
   for jj=1:ii-1
     if(dist(ordrho(ii),ordrho(jj))<delta(ordrho(ii)))
        delta(ordrho(ii))=dist(ordrho(ii),ordrho(jj));
%         mneigh(ordrho(ii))=nneigh(ordrho(ii));
        nneigh(ordrho(ii))=ordrho(jj);
     end
   end
end


% %assignation
for i=1:ND
  if (cl(ordrho(i))==-1)
    cl(ordrho(i))=cl(nneigh(ordrho(i)));
  end
end
% for i=2:ND
%   if (cl(ordrho(i))==-1)
%       index=unique(cl(ordrho(1:i)));
%       if size(index,1)>2 && i>2
%           temp=[inf,cl(nneigh(ordrho(i)))];
%           for j=1:i-1
%               if cl(ordrho(j))~=cl(nneigh(ordrho(i)))&&dist(ordrho(i),ordrho(j))<temp(1)
%                   temp(1)=dist(ordrho(i),ordrho(j));
%                   temp(2)=cl((ordrho(j)));
%               end
%           end
%           if cl(nneigh(ordrho(i)))~=temp(2)
%               C1=find(cl==cl(nneigh(ordrho(i)))); %temp1-re
%               C2=find(cl==temp(2));
%               S1=zeros(size(C1,1),q);
%               S2=zeros(size(C2,1),q);
%               for k=1:size(C1,1)
%                   S1(k,:)=S(C1(k),:);%temp2-data
%               end
%                 
%               for k=1:size(C2,1)
%                   S2(k,:)=S(C2(k),:);%temp2-data
%               end
%               JSC(1)=findjsc([S1;S(ordrho(i),:)],S2,q);
%               JSC(2)=findjsc(S1,[S2;S(ordrho(i),:)],q);
%           
%               if JSC(1)<JSC(2)||isempty(isinf(JSC))==0
%                   cl(ordrho(i))=cl(nneigh(ordrho(i)));
%               else
%                   cl(ordrho(i))=temp(2);
%               end
%           else
%               cl(ordrho(i))=cl(nneigh(ordrho(i)));
%           end
%       else
%           cl(ordrho(i))=cl(nneigh(ordrho(i)));
%       end
%   end
% end
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
