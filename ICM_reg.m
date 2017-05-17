clc
clear
close all
moving_img = double(imread('modtest1.png'));
fixed_img = double(imread('modtest3.png'));
label_num = 3;
maxiter = 60;
sigma= 0.5;
range=2; % 5*5 search space
%-------------�����ʼ����ǩ----------------
label_m = randi([1,label_num],size(moving_img));
label_f = randi([1,label_num],size(fixed_img));

label=label_m;
displace=1:numel(label);

for ind=1:numel(label) 
   d=ind;
   label_i=label(ind);
   iter = 0;
   while iter < maxiter    
    %ȷ��������Χ
    dis_ind=displacement2d(d,label_m,range);
    %ÿ������λ�ö�Ӧ����,�ҵ���С����λ��
    smooth=zeros(1,length(dis_ind));
    data=zeros(1,length(dis_ind));
    for k=1:numel(dis_ind)       
        label_dis=label(dis_ind(k));
        %ÿ������λ�ö�Ӧ����
        neigh_k=neighborhood(dis_ind(k),label_m,8);
        label_neigh=label(neigh_k);
        %��������λ�õ�����
        smooth(k)=sum(~(~(label_neigh-label_dis)));
        data(k)=((label_f(ind)-label_dis).^2)/sigma;
    end
    E=data+smooth;
    %�ҵ���С������Ӧ��λ�ü�ʹ�ñ�ǩ,��Ϊ��һ�ε���ʹ�ñ�ǩ&λ��
    [E_min,k_new]=min(E);
    displace(ind)=dis_ind(k_new);
    d=dis_ind(k_new);
    iter = iter + 1;   
   end
   
end
 figure,
 subplot(1,2,1);
 imshow(reshape(label(displace),size(label_m)),[]);
 title('label_m');
 subplot(1,2,2);
 imshow(label_f,[]);
 title('label_f')




%ԭʼ����
figure,
r=1:size(moving_img,1);
c=1:size(moving_img,2);
co = rand(size(r,2)*size(c,2),3); 
for i=1:size(r,2)
    plot(repmat(r(i),1,numel(c)),c,'color',co(i,:));
    plot(r,repmat(c(i),1,numel(r)),'color',co(i,:));
    hold on 
end
set(gca,'xtick',[]);
set(gca,'ytick',[]);


%��������
%�����Ժ��������������
figure,

[r_m,c_m]=ind2sub(size(moving_img),displace);
r_e=r_m-repmat(r,1,numel(c));
c_e=c_m-(reshape(repmat(c,numel(r),1),1,numel(c)*numel(r)));
r_e=reshape(r_e,size(moving_img));
c_e=reshape(c_e,size(moving_img));
for i=1:size(r,2)
    plot(repmat(r(i),1,numel(c))+(r_e(:,i))',c,'color',co(i,:));
    plot(r,repmat(c(i),1,numel(r))+(c_e(:,i))','color',co(i,:));
   
    hold on 
end
set(gca,'xtick',[]);
set(gca,'ytick',[]);

   

% r_e=r_m-r;
% c_e=c_m-c;
% 
% [y,p1]=sort(y);
% [x,p2]=sort(x);
% r_e=r_e(p2);
% c_e=c_e(p1);
% figure,
% for i=1:size(x,1)
%     plot(repmat(x(i),1,size(y,1))+r_e',sort(y),'color',co(i,:));
%     plot(sort(x),repmat(y(i),1,size(x,1))+c_e','color',co(i,:));
%     hold on 
% end
% set(gca,'xtick',[]);
% set(gca,'ytick',[]);
% 
% figure(3),
% [r,c]=ind2sub(label_f,(1:numel(label_f))');
% [r_m,c_m]=ind2sub(label_f,displace(:));
% r_e=r_m-r;
% c_e=c_m-c;
% 
% % u=sqrt((r_e-r).^2+(c_e-c).^2);  %����
% % v=(r_e-r)./(c_e-c);  %�Ƕ�
% % quiver(r,c,u,v);
% x=r;
% y=c;
% co = rand(size(x,1)*size(y,1),3); 
% for i=1:size(x,1)
%     plot(repmat(x(i),1,size(y,1))+r_e',y,'color',co(i,:));
%     plot(x,repmat(y(i),1,size(x,1))+c_e','color',co(i,:));
%     hold on 
% end
% set(gca,'xtick',[]);
% set(gca,'ytick',[]);