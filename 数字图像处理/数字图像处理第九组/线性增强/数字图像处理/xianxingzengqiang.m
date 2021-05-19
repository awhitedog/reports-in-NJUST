clc;
R=imread('蛋糕.jpg');
H=2+1.35*(R-2);%线性变换
X=rgb2gray(R);%将真彩色RGB图像转换成灰度图像
[a,b]=size(X);
for i=1:a-1
    for j=1:b-1
        I(i,j)=2+1.35*(X(i,j)-2);
    end
end

subplot(231);imshow(R);title('原始图像');
subplot(232);imshow(H);title('增强图像');
subplot(233);imshow(X);title('灰度图像');
subplot(234);imhist(X,256);title('原图直方图');
subplot(235);imhist(I,256);title('增强直方图');
hold on;
x=[0:5];
y=2+1.35*(x-2);
subplot(236);plot(x,y);title('函数图像');

