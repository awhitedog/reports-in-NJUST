A=imread('beijing.jpg'); %读取北京图片
J=rgb2gray(A);%将RGB彩色图转化为灰度图，减少运算量，提高图像处理速度
subplot(1,2,1);
P1=imnoise(J,'salt & pepper',0.03);%对图像生成椒盐噪声
imshow(P1)                     
title('原图像 ')
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
subplot(1,2,2);
imshow(J)
title('中值滤波后 ')
