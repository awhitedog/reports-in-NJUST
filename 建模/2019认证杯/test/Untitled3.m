clear;
sigma = 10000;                               %�������
T = 2;                                       %���ʱ�䲽��
t1 = 400;                                    %��y�������˶�
t2 = 600;                                    %��x�᷽��ת�� a = 0.075
t3 = 610;                                    %�����˶�
t4 = 660;                                    %90���ת��    a = -0.3
totaltime = 700;                             %�ܵĹ۲�ʱ��Ϊ700�� 350��
V_y = -12;
ax = 0;
V_x = 0;
X_add = 0;
%��ʼֵ
f_k1 = [1 T T^2/2;0 1 T;0 0 1];
f_k2 = [1 T;0 1];
F_k = blkdiag(f_k1,f_k2);                                         %Ԥ��״̬ת�ƾ���
X_k1 = [1000 0 ax 800 -12]';                                       %״̬��ʼֵ

Z_k = [1000;800]; 
H_k = [1 0 0 0 0;0 0 0 1 0];                                      %�۲����Ϊ2x5ά
P_k1 = diag([sigma sigma/T sigma/T^2 sigma sigma/T]);             %��ʼЭ�������
Qvk = sigma*eye(2);                                               %�۲�����Э����

for i=1:450 
   if i>200 && i<=300
        ax = 0.075;
        X_k1(3,1) = ax;
    end
    if i>300 && i<=305
        ax = 0;
        X_k1(3,1) = ax;
    end
    if i>305 && i<=330
        ax = -0.3;
        X_k1(3,1) = ax;
    end
    if i>330
         ax = 0;
         X_k1(3,1) = ax;
    end    
    X_add = X_add + V_x *T + 0.5*(ax*T^2);                       %x�᷽�����ı���
    V_x = V_x + ax*T;  
    Z_k = [1000+X_add+wgn(1,1,40);800+V_y*T*(i - 1)+wgn(1,1,40)];     
    X_k2 = F_k*X_k1;                                  %����״ֵ̬
    P_k2 = F_k*P_k1*F_k';                             %����Э�������
    Gk = P_k2*H_k'*inv(H_k*P_k2*H_k' + Qvk);          %���㿨��������
    P_k3 = (eye(5)-Gk*H_k)*P_k2;                      %����Э�������  
    X_k3 = X_k2 + Gk*(Z_k - H_k*X_k2);       
    P_k1 = P_k3;
    X_k1 = X_k3;

    X_plot(:,i) =  X_k3; 
    Z_plot(:,i) = Z_k;
 end
%��ͼ

%plot(Z_plot(1,:),Z_plot(2,:));
%subplot(2,1,1);

plot(Z_plot(1,:),Z_plot(2,:),X_plot(1,:),X_plot(4,:),'black');
axis([0 6000 -10000 1000])
title('Ŀ��켣');
xlabel('X(��)');
ylabel('Y(��)');
legend('Ŀ������켣','Ŀ����ʵ�켣');