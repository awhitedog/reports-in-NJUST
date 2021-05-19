A=imread('C:\Users\loveless\Documents\MATLAB\reflection.jpg');%     读入图像
I=imnoise(A,'salt & pepper',0.025);%       加入椒盐噪声
subplot(1,2,1);imshow(I);title('原图像');%       显示原图像
[a,b]=size(I); %     读取图像尺寸大小
J=double(I); 

for i=2:a-1%   处理图像矩阵
for j=2:b-1
J(i,j)=(J(i-1,j)+J(i,j+1)+J(i+1,j)+J(i,j-1))/4; %4点均值
end
end
J=uint8(J);
subplot(1,2,2);imshow(J);title('4点均值平滑后的图像');%显示处理后的图像
