close all;clear all;clc;
A= imread('E:\baogao\����ͼ����\picture\20120626194823_4tmyV.thumb3.jpg');
original=rgb2gray(A);%ת�Ҷ�
[h w] = size(original); %��ȡ������ͼƬ�ߴ�
p=zeros(6,256);
f=zeros(1,256);
%ͳ��ÿ������ֵ���ִ���
for i=1:1:h
    for j=1:1:w
        for k=0:1:255
            if original(i,j)==k
                p(1,k+1)=p(1,k+1)+1;
            end
        end
    end
end
%�������ֱ��ͼ
for i=1:1:256
    p(2,i)=p(1,i)/(h*w);
end
%���ۼƸ��ʣ��õ��ۼ�ֱ��ͼ
p(3,1)=p(2,1);
for i = 2 : 256
    p(3, i) = p(3, i - 1) + p(2, i);
end
%��p3����ʵ�ֻҶ�ֵ[0, 255]��ӳ��
for i = 1:1:256
   f(i) = round(p(3, i) * 255);
end
%ֱ��ͼ���⻯
equalize=uint8(zeros(h,w));
for i=1:1:h
    for j=1:1:w
        for k=0:1:255
            if original(i,j)==k
               equalize(i,j)=f(k+1) ;
            end
        end
    end
end
%ͳ��ÿ������ֵ���ִ���
for i=1:1:h
    for j=1:1:w
        for k=0:1:255
            if equalize(i,j)==k
                p(4,k+1)=p(4,k+1)+1;
            end
        end
    end
end
%�����µĸ���ֱ��ͼ
for i=1:1:256
    p(5,i)=p(4,i)/(h*w);
end
%���ۼƸ��ʣ��õ��µ��ۼ�ֱ��ͼ
p(6,1)=p(5,1);
for i = 2 : 256
    p(6, i) = p(6, i - 1) + p(5, i);
end
subplot(231)
imshow(original)
title('ԭͼ');
subplot(232)
bar(p(2,:))
xlim([0,256]);
set(gca,'XGrid','on');
set(gca,'YGrid','on');
title('ԭ����ֱ��ͼ');
subplot(233)
bar(p(3,:))
xlim([0,256]);
set(gca,'XGrid','on');
set(gca,'YGrid','on');
title('ԭ�ۼ�ֱ��ͼ');
subplot(234)
imshow(equalize)
title('ֱ��ͼ���⻯');
subplot(235)
bar(p(5,:))
xlim([0,256]);
set(gca,'XGrid','on');
set(gca,'YGrid','on');
title('�µĸ���ֱ��ͼ');
subplot(236)
bar(p(6,:))
xlim([0,256]);
set(gca,'XGrid','on');
set(gca,'YGrid','on');
title('�µ��ۼ�ֱ��ͼ');