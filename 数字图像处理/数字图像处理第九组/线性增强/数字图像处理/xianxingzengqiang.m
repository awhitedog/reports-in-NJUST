clc;
R=imread('����.jpg');
H=2+1.35*(R-2);%���Ա任
X=rgb2gray(R);%�����ɫRGBͼ��ת���ɻҶ�ͼ��
[a,b]=size(X);
for i=1:a-1
    for j=1:b-1
        I(i,j)=2+1.35*(X(i,j)-2);
    end
end

subplot(231);imshow(R);title('ԭʼͼ��');
subplot(232);imshow(H);title('��ǿͼ��');
subplot(233);imshow(X);title('�Ҷ�ͼ��');
subplot(234);imhist(X,256);title('ԭͼֱ��ͼ');
subplot(235);imhist(I,256);title('��ǿֱ��ͼ');
hold on;
x=[0:5];
y=2+1.35*(x-2);
subplot(236);plot(x,y);title('����ͼ��');

