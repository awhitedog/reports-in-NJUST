A=imread('C:\Users\loveless\Documents\MATLAB\reflection.jpg');%     ����ͼ��
I=imnoise(A,'salt & pepper',0.025);%       ���뽷������
subplot(1,2,1);imshow(I);title('ԭͼ��');%       ��ʾԭͼ��
[a,b]=size(I); %     ��ȡͼ��ߴ��С
J=double(I); 

for i=2:a-1%   ����ͼ�����
for j=2:b-1
J(i,j)=(J(i-1,j)+J(i,j+1)+J(i+1,j)+J(i,j-1))/4; %4���ֵ
end
end
J=uint8(J);
subplot(1,2,2);imshow(J);title('4���ֵƽ�����ͼ��');%��ʾ������ͼ��
