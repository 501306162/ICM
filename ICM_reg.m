clc
clear
close all
moving_img = double(randi(9,10,10));
fixed_img = double(randi(9,10,10));
label_num = 3;
maxiter = 200;
sigma= 0.1;
range=1; % 3*3 search space
%-------------��ʼ����ǩ---------------
label_m =moving_img;
% 2*ones(size(moving_img));
label_f =fixed_img;
% 2*ones(size(fixed_img));

% label_m(moving_img<=3)=1;
% label_m(moving_img>6)=3;
% label_f(fixed_img<=3)=1;
% label_f(fixed_img>6)=3;

iter = 0;
label=label_m;
displace=1:numel(label);
while iter < maxiter 
   for ind=1:numel(label) 
   d=ind;
   label_i=label(ind);
    %ȷ��������Χ
    dis_ind=displacement(d,label_m,8,range);
    %ÿ������λ�ö�Ӧ����,�ҵ���С����λ��
    smooth=zeros(1,length(dis_ind));
    data=zeros(1,length(dis_ind));
    for k=1:numel(dis_ind)       
        label_dis=label(dis_ind(k));
        %ÿ������λ�ö�Ӧ����
        neigh_k=neighborhood(dis_ind(k),label_m,8);
        label_neigh=label(neigh_k);
        %��������λ�õ�����
        smooth(k)=sum(~(~(label_neigh-label_dis)));  %��ǩ��ͬ��ֵ�ĸ���
        data(k)=((label_f(ind)-label_dis).^2)/sigma;
    end
    E=data+smooth;
    %�ҵ���С������Ӧ��λ�ü�ʹ�ñ�ǩ,��Ϊ��һ�ε���ʹ�ñ�ǩ&λ��
    [E_min,k_new]=min(E);
    displace(ind)=dis_ind(k_new);
    d=dis_ind(k_new); 
  end
   iter = iter + 1;   
end

 figure,
 subplot(1,2,1);
 imshow(reshape(label(displace),size(label_m)),[]);
 title('label_m');
 subplot(1,2,2);
 imshow(label_f,[]);
 title('label_f')
 

 figure,
 subplot(1,2,1);
 imshow(reshape(moving_img(displace),size(label_m)),[]);
 title('moving_img');
 subplot(1,2,2);
 imshow(fixed_img,[]);
 title('fixed_img')


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
[r_f,c_f]=ind2sub(size(moving_img),1:numel(moving_img));
[r_m,c_m]=ind2sub(size(moving_img),displace);

r_e=r_m-r_f;
c_e=c_m-c_f;
r_e=reshape(r_e,size(moving_img));
c_e=reshape(c_e,size(moving_img));
for i=1:size(r,2)
    plot(repmat(r(i),size(moving_img,2),1)+r_e(:,i),c,'color',co(i,:));%'color',co(i,:)
    plot(r,repmat(c(i),size(moving_img,1),1)+c_e(:,i),'color',co(i,:));
%     pause(5);
    hold on 
end
set(gca,'xtick',[]);
set(gca,'ytick',[]);

% %����:
% z=zeros(size(moving_img));
% figure,
% mesh(reshape(r_f,size(moving_img))+r_e,reshape(c_f,size(moving_img))+c_e,z)
% axis off
% view(2)

