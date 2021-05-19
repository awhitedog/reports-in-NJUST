clear;
sigma = 10000;                               %测量误差
T = 2;                                       %间隔时间步长
t1 = 400;                                    %沿y轴匀速运动
t2 = 600;                                    %向x轴方向转弯 a = 0.075
t3 = 610;                                    %匀速运动
t4 = 660;                                    %90°快转弯    a = -0.3
totaltime = 700;                             %总的观测时间为700秒 350步
V_y = -12;
ax = 0;
V_x = 0;
X_add = 0;
%初始值
f_k1 = [1 T T^2/2;0 1 T;0 0 1];
f_k2 = [1 T;0 1];
F_k = blkdiag(f_k1,f_k2);                                         %预测状态转移矩阵
X_k1 = [1000 0 ax 800 -12]';                                       %状态初始值

Z_k = [1000;800]; 
H_k = [1 0 0 0 0;0 0 0 1 0];                                      %观测矩阵为2x5维
P_k1 = diag([sigma sigma/T sigma/T^2 sigma sigma/T]);             %初始协方差矩阵
Qvk = sigma*eye(2);                                               %观测噪声协方差

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
    X_add = X_add + V_x *T + 0.5*(ax*T^2);                       %x轴方向距离改变量
    V_x = V_x + ax*T;  
    Z_k = [1000+X_add+wgn(1,1,40);800+V_y*T*(i - 1)+wgn(1,1,40)];     
    X_k2 = F_k*X_k1;                                  %先验状态值
    P_k2 = F_k*P_k1*F_k';                             %先验协方差矩阵
    Gk = P_k2*H_k'*inv(H_k*P_k2*H_k' + Qvk);          %计算卡尔曼增益
    P_k3 = (eye(5)-Gk*H_k)*P_k2;                      %后验协方差矩阵  
    X_k3 = X_k2 + Gk*(Z_k - H_k*X_k2);       
    P_k1 = P_k3;
    X_k1 = X_k3;

    X_plot(:,i) =  X_k3; 
    Z_plot(:,i) = Z_k;
 end
%画图

%plot(Z_plot(1,:),Z_plot(2,:));
%subplot(2,1,1);

plot(Z_plot(1,:),Z_plot(2,:),X_plot(1,:),X_plot(4,:),'black');
axis([0 6000 -10000 1000])
title('目标轨迹');
xlabel('X(米)');
ylabel('Y(米)');
legend('目标测量轨迹','目标真实轨迹');