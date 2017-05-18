clc
clear
close all
img = double(rgb2gray(imread('lena.png')));
%���þ�����
cluster_num = 4;
%�����ʼ������--������Ҫ
%������ѡ����Ը���̶ȵ�������ʵ��ֵ
%�Ӷ�Ч���Ż����
mu = ((1:cluster_num)./(cluster_num + 1))* (max(max(img)));
sigma = mu;
pw = zeros(cluster_num,size(img,1)*size(img,2));
pc = rand(1,cluster_num);
pc = pc/sum(pc);%������ʹ�һ��
max_iter = 50;%�Ե�����������Ϊֹͣ������
iter = 1;
while iter <= max_iter
    %----------E:����mu.sigma ��p-------------------
    for i = 1:cluster_num
        %�������--�ٶȿ�
        MU = repmat(mu(i),size(img,1)*size(img,2),1);
        %��˹ģ��
        temp = 1/sqrt(2*pi*sigma(i))*exp(-(img(:)-MU).^2/2/sigma(i));
        temp(temp<0.000001) = 0.000001;%��ֹ����0
%       pw(i,:) = log(pc(i)) + log(temp);
        pw(i,:) = pc(i) * temp;   %�������Ϸֲ�
    end
    pw = pw./(repmat(sum(pw),cluster_num,1));%��һ
    %----------M:����p ��mu.sigma---------------------
    %���²�����
    for i = 1:cluster_num
         pc(i) = mean(pw(i,:));
         mu(i) = pw(i,:)*img(:)/sum(pw(i,:));
         sigma(i) = pw(i,:)*((img(:)-mu(i)).^2)/sum(pw(i,:));
    end
    %------------show-result---------------
    [~,label] = max(pw);
    %�Ĵ�С
    label = reshape(label,size(img));
    imshow(label,[])
    title(['iter = ',num2str(iter)]);
    pause(0.1);
    M(iter,:) = mu;
    S(iter,:) = sigma;
    iter = iter + 1;
end
%����ֵ�뷽��ĵ���������ʾ����
figure
for i = 1:cluster_num
    plot(M(:,i));
    hold on
end
figure
for i = 1:cluster_num
    plot(S(:,i));
    hold on
end