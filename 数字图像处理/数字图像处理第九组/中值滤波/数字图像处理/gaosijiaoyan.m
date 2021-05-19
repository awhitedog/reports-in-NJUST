clc
A=imread('beijing.jpg'); %读取北京图片
J=rgb2gray(A);%将RGB彩色图转化为灰度图，减少运算量，提高图像处理速度
subplot(2,2,1);
P1=imnoise(J,'gaussian',0.2);%对图像生成高斯噪声
subplot(2,2,2);
imshow(P1)                     
title('高斯原图像 ')
[m,n]=size(J) ;                 %取得原图矩阵尺寸
B=zeros(9);         %产生9*9的全零方阵            
for i=2:m-1                     %从第二个开始到倒数第二个结束
    for j=2:n-1
        b=1;
        for p=(i-1):(i+1)%取小框3行
            for q=(j-1):(j+1)%取小框3列
                B(b)=J(p,q);%将选中3*3的值赋给B
                b=b+1;
            end
        end
            for d=1:8          %开始冒泡排序
                if(B(d)>B(d+1))%由小到大排序，大于则交换
                    t=B(d);
                    B(d)=B(d+1);
                    B(d+1)=t;
                end
            end
        J(i,j)=B(5,1);  %排列之后的像素值赋给J        
    end
end
subplot(2,2,4);
imshow(J)
title('高斯中值滤波后 ')
C=rgb2gray(A);
subplot(2,2,1);
P2=imnoise(C,'salt & pepper',0.2);%对图像生成椒盐噪声
imshow(P2)                     
title('椒盐原图像 ')
[m,n]=size(C) ;                 %取得原图矩阵尺寸
D=zeros(9);         %产生9*9的全零方阵            
for i=2:m-1                     %从第二个开始到倒数第二个结束
    for j=2:n-1
        b=1;
        for p=(i-1):(i+1)%取小框3行
            for q=(j-1):(j+1)%取小框3列
                D(b)=C(p,q);%将选中3*3的值赋给B
                b=b+1;
            end
        end
            for d=1:8          %开始冒泡排序
                if(D(d)>D(d+1))%由小到大排序，大于则交换
                    t=D(d);
                    D(d)=D(d+1);
                    D(d+1)=t;
                end
            end
        C(i,j)=D(5,1);  %排列之后的像素值赋给C      
    end
end
subplot(2,2,3);
imshow(C)
title('椒盐中值滤波后 ')

