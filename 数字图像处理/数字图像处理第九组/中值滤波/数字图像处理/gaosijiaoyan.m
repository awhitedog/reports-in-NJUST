clc
A=imread('beijing.jpg'); %��ȡ����ͼƬ
J=rgb2gray(A);%��RGB��ɫͼת��Ϊ�Ҷ�ͼ�����������������ͼ�����ٶ�
subplot(2,2,1);
P1=imnoise(J,'gaussian',0.2);%��ͼ�����ɸ�˹����
subplot(2,2,2);
imshow(P1)                     
title('��˹ԭͼ�� ')
[m,n]=size(J) ;                 %ȡ��ԭͼ����ߴ�
B=zeros(9);         %����9*9��ȫ�㷽��            
for i=2:m-1                     %�ӵڶ�����ʼ�������ڶ�������
    for j=2:n-1
        b=1;
        for p=(i-1):(i+1)%ȡС��3��
            for q=(j-1):(j+1)%ȡС��3��
                B(b)=J(p,q);%��ѡ��3*3��ֵ����B
                b=b+1;
            end
        end
            for d=1:8          %��ʼð������
                if(B(d)>B(d+1))%��С�������򣬴����򽻻�
                    t=B(d);
                    B(d)=B(d+1);
                    B(d+1)=t;
                end
            end
        J(i,j)=B(5,1);  %����֮�������ֵ����J        
    end
end
subplot(2,2,4);
imshow(J)
title('��˹��ֵ�˲��� ')
C=rgb2gray(A);
subplot(2,2,1);
P2=imnoise(C,'salt & pepper',0.2);%��ͼ�����ɽ�������
imshow(P2)                     
title('����ԭͼ�� ')
[m,n]=size(C) ;                 %ȡ��ԭͼ����ߴ�
D=zeros(9);         %����9*9��ȫ�㷽��            
for i=2:m-1                     %�ӵڶ�����ʼ�������ڶ�������
    for j=2:n-1
        b=1;
        for p=(i-1):(i+1)%ȡС��3��
            for q=(j-1):(j+1)%ȡС��3��
                D(b)=C(p,q);%��ѡ��3*3��ֵ����B
                b=b+1;
            end
        end
            for d=1:8          %��ʼð������
                if(D(d)>D(d+1))%��С�������򣬴����򽻻�
                    t=D(d);
                    D(d)=D(d+1);
                    D(d+1)=t;
                end
            end
        C(i,j)=D(5,1);  %����֮�������ֵ����C      
    end
end
subplot(2,2,3);
imshow(C)
title('������ֵ�˲��� ')

