close all;clear all;clc;
A= imread('E:\baogao\数字图像处理\picture\20120626194823_4tmyV.thumb3.jpg');
original=rgb2gray(A);%转灰度
[h w] = size(original); %获取待处理图片尺寸
p=zeros(6,256);
f=zeros(1,256);
%统计每个像素值出现次数
for i=1:1:h
    for j=1:1:w
        for k=0:1:255
            if original(i,j)==k
                p(1,k+1)=p(1,k+1)+1;
            end
        end
    end
end
%计算概率直方图
for i=1:1:256
    p(2,i)=p(1,i)/(h*w);
end
%求累计概率，得到累计直方图
p(3,1)=p(2,1);
for i = 2 : 256
    p(3, i) = p(3, i - 1) + p(2, i);
end
%用p3数组实现灰度值[0, 255]的映射
for i = 1:1:256
   f(i) = round(p(3, i) * 255);
end
%直方图均衡化
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
%统计每个像素值出现次数
for i=1:1:h
    for j=1:1:w
        for k=0:1:255
            if equalize(i,j)==k
                p(4,k+1)=p(4,k+1)+1;
            end
        end
    end
end
%计算新的概率直方图
for i=1:1:256
    p(5,i)=p(4,i)/(h*w);
end
%求累计概率，得到新的累计直方图
p(6,1)=p(5,1);
for i = 2 : 256
    p(6, i) = p(6, i - 1) + p(5, i);
end
subplot(231)
imshow(original)
title('原图');
subplot(232)
bar(p(2,:))
xlim([0,256]);
set(gca,'XGrid','on');
set(gca,'YGrid','on');
title('原概率直方图');
subplot(233)
bar(p(3,:))
xlim([0,256]);
set(gca,'XGrid','on');
set(gca,'YGrid','on');
title('原累计直方图');
subplot(234)
imshow(equalize)
title('直方图均衡化');
subplot(235)
bar(p(5,:))
xlim([0,256]);
set(gca,'XGrid','on');
set(gca,'YGrid','on');
title('新的概率直方图');
subplot(236)
bar(p(6,:))
xlim([0,256]);
set(gca,'XGrid','on');
set(gca,'YGrid','on');
title('新的累计直方图');