A=imread('C:\Users\loveless\Documents\MATLAB\reflection.jpg');%����ͼ��
I=imnoise(A,'salt & pepper',0.025);%���뽷������
[a,b]=size(I); %��ȡͼ��ߴ��С
J=double(I);
for i=2:a-1
for j=2:b-1
J(i,j)=(J(i-1,j-1)+J(i-1,j)+J(i-1,j+1)+J(i,j-1)+J(i,j+1)+J(i+1,j-1)+J(i+1,j)+J(i+1,j+1))/8;%8���ֵ
end
end
J=uint8(J);
subplot(1,2,1);imshow(I);title('ԭͼ��');%��ʾ���������ͼ��
subplot(1,2,2);imshow(J);title('8���ֵƽ�����ͼ��');%��ʾ������ͼ��
