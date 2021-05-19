%% 遗传算法在多约束下求较优加工参数
clc,clear
close all

% 初期参数决定
global H0 D0


% 角度范围重新确定，以角度为自变量
% 在最初确定搜索范围时要使用
% 用户给出H0，D0
% 用户给的尾端曲线和桌面边沿曲线是在调用函数里的，函数会返回相关适应度

H0=53; % 高度 
D0=40; % 通过曲线
pop_num=80;   % 种群个数
ag_gen=400;   %进化代数
Pc_min=0.3;   % 最小交叉概率
Pc_max=0.7;  %最大交叉概率
Pm_min=0.11;   %最小变异概率
Pm_max=0.13;  %最大变异概率
A=9.903438;   %自适应变异/交叉概率公式系数，由论文给出
% 自适应变异/交叉概率公式
P=@(x,P_max,P_min,f_avg,f_max)((P_max-P_min)./(1+exp(A*2*(x-f_avg)/(f_max-f_avg)))+P_min);
% 自变量维度
m=6;   % 自变量：角度alpha，lamda钢筋位置，h板厚度，n板左右各分多少木条

   % n1 n2 的两个边界
n1=floor(D0/2.5);    % 2.5 2的解释
n2=ceil(D0/2);

tic
% alpha1,alpha2 还要修改
[alpha1,alpha2]=alpha_search2(n1,n2);
toc

tic
for k=91 % 最外部为了批量得到数据的大循环
%% 样本初始化
max_pop=[];
pop=zeros(pop_num,m);
pop(:,3)=rand(pop_num,1)*1+3;
pop(:,1)=(alpha1(2)-alpha1(1))*rand(pop_num,1)+alpha1(1); %左角度
pop(:,5)=(alpha2(2)-alpha2(1))*rand(pop_num,1)+alpha2(1);
pop(:,2)=randi([n1,n2],[pop_num,1]);
pop(:,4)=rand(pop_num,1)*0.2+0.4;
pop(:,6)=rand(pop_num,1)*0.2+0.4;


max_fitness=-inf;
max_fitness_note=zeros(1,ag_gen);
avg_fitness_note=zeros(1,ag_gen);

%% 进行合理性筛选和随机补全
%此过程后面多次使用

% 在fit_and_select 函数中不但计算适应度，还会根据力平衡和桌子的实际设计筛选掉不符合的个体，
% 不符合的个体是适应度（fitness位置用）-inf标记
for j=1:pop_num
fitness(j)=fit_and_select2(pop(j,1),pop(j,5),pop(j,3),pop(j,2),pop(j,4),pop(j,6));    
end

not_e_index=find(fitness~=-inf);

% 随机补全被筛去的个体
% 在被-inf标记的不符合个体中，随机选择种群中剩下的个体补上
for j=1:pop_num
    if fitness(j)==-inf
        temp_index=randi([1,length(not_e_index)],1);
        temp_index2=not_e_index(temp_index);
        fitness(j)=fitness(temp_index2);
        pop(j,:)=pop(temp_index2,:);
    end
end





%% 进化开始
hbar=waitbar(0,'进化进度...0%');

for i=1:ag_gen
  pbar=sprintf('进化进度...%4.1f%%',i*100/ag_gen);
 waitbar(i/ag_gen,hbar,pbar);
 
% fitness=zeros(pop_num,1);


%% 进行合理性筛选和随机补全


m_fitness=max(fitness);
a_fitness=mean(fitness);


%% 变异过程

for j=1:pop_num
p=rand();

if fitness(j)<a_fitness  %个体适应度小于种群适应度则变异概率取最大
    p_to_c=Pm_max;
else                     %个体适应度大于种群适应度则使用变异概率自适应函数计算具体的适应度
    p_to_c=P(fitness(j),Pm_max,Pm_min,a_fitness,m_fitness);
end                     % 这种变异概率计算策略也用在交叉中
if p<p_to_c
     pop(j,3)=rand()*1+3;
     pop(j,1)=(alpha1(2)-alpha1(1))*rand()+alpha1(1); %左角度
     pop(j,5)=(alpha2(2)-alpha2(1))*rand()+alpha2(1);
     pop(j,2)=randi([n1,n2],1);
     pop(j,4)=rand()*0.2+0.4;
     pop(j,6)=rand()*0.2+0.4;   %变异：整体随机改变
end
end

for j=1:pop_num
fitness(j)=fit_and_select2(pop(j,1),pop(j,5),pop(j,3),pop(j,2),pop(j,4),pop(j,6));    
end


% 随机补全被筛去的个体
for j=1:pop_num
    if fitness(j)==-inf
        temp_index=randi([1,length(not_e_index)],1);
        temp_index2=not_e_index(temp_index);
        fitness(j)=fitness(temp_index2);
        pop(j,:)=pop(temp_index2,:);
    end
end

a_fitness=mean(fitness);
m_fitness=max(fitness);
%% 交叉过程

%采用“门当户对”的，点交叉
[sort_f,index]=sort(fitness); %相对适应度排序，对适应度排序位置相邻的点进行逐个交叉

for j=1:(pop_num-1)
p=rand();
if sort_f(j)<a_fitness
    p_to_c=Pc_max;
else
    p_to_c=P(sort_f(j),Pc_max,Pc_min,a_fitness,m_fitness);
end

if p<p_to_c
    point=randi([1,m],1);
    switch point     %对交叉两个体，随机一基因，进行互换交叉
        case 3
            temp=pop(index(j),3);
            pop(index(j),3)=pop(index(j+1),3);
            pop(index(j+1),3)=temp;
        case 1
            temp=pop(index(j),1);
            pop(index(j),1)=pop(index(j+1),1);
            pop(index(j+1),1)=temp;
        case 2
            temp=pop(index(j),2);
            pop(index(j),2)=pop(index(j+1),2);
            pop(index(j+1),2)=temp;
        case 4
            temp=pop(index(j),4);
            pop(index(j),4)=pop(index(j+1),4);
            pop(index(j+1),4)=temp;
        case 5
            temp=pop(index(j),5);
            pop(index(j),5)=pop(index(j+1),5);
            pop(index(j+1),5)=temp;
        case 6
            temp=pop(index(j),6);
            pop(index(j),6)=pop(index(j+1),6);
            pop(index(j+1),6)=temp;
    end
end
end

%% 进行合理性筛选和随机补全
for j=1:pop_num
fitness(j)=fit_and_select2(pop(j,1),pop(j,5),pop(j,3),pop(j,2),pop(j,4),pop(j,6));    
end
not_e_index=find(fitness~=-inf);
% 随机补全被筛去的个体
for j=1:pop_num
    if fitness(j)==-inf
        temp_index=randi([1,length(not_e_index)],1);
        temp_index2=not_e_index(temp_index);
        fitness(j)=fitness(temp_index2);
        pop(j,:)=pop(temp_index2,:);
    end
end



%% 轮盘选择较优个体

[s_f,index]=sort(fitness);
s_f_p=cumsum(s_f)/sum(s_f);

new_pop=zeros(pop_num,m);

for j=1:pop_num
    p=rand();
    index_f=find(s_f_p>p,1);
    new_pop(j,:)=pop(index(index_f),:);
    fitness(j)=fitness(index(index_f));
end

pop=new_pop;

%% 一次进化代数记录
[max_fitness_note(i),index_m]=max(fitness);

flag_v=1;
flag_s=0;
while 1
    
    % 进行势能计算的候选最大值各量
    nx=pop(index_m,2);
    theta1=pop(index_m,1);
    theta2=pop(index_m,5);
    lamda1=pop(index_m,4);
    lamda2=pop(index_m,6);
    hx=pop(index_m,3);  
    
  
   %给大约左右5度的冗余,允许在最小最小值附近1~2度
   f_s=zeros(11,11);
   
   for t=1:11
       for s=1:11
       [~,f_s(t,s)]= B3okornot(D0,H0,nx,hx,lamda1,lamda2,(theta1+0.01*(t-6)),(theta2+0.01*(s-6)));
       %[flag,m,changduleft,changduright,distleft,distright,l1,r1] = B3okornot(DD,H,geshu,houdu,namda,namda2,thita,thita2 )
       end
   end
   
   
   %flag_f=0;
   for t=1:11
   for s=1:11
       if s~=1&&s~=11&&t~=1&&t~=11
          if f_s(t,s)<f_s(t,s+1)&&f_s(t,s)<f_s(t,s-1)&&f_s(t,s)<f_s(t+1,s)&&f_s(t,s)<f_s(t-1,s)
          flag_s =1;
         % flag_f=1;
          break
          end
       end
   end
   
   if flag_s
       break
   end
   end
   
   if flag_s
       break
   end
   
   
    index_cluster=find(fitness==max_fitness_note(i));
    fitness(index_cluster)=0;     % 不符合势能条件的最大值置0
    [max_fitness_note(i),index_m]=max(fitness);   %并用次最大取代
    fitness(index_cluster)=max_fitness_note(i);
    
    if all(fitness==0)
        flag_v=0;  % 是否已经无符合势能条件变量的标志
        break
    end
end



if flag_v
    %若有符合要求的个体，则做相关记录
avg_fitness_note(i)=mean(fitness);
if max_fitness<max_fitness_note(i)
 max_fitness=max_fitness_note(i);
 max_pop=pop(index_m,:);
end

else
    % 如无符合势能变量要进行种群的重新初始化
     pop(:,3)=rand(pop_num,1)*1+3;
     pop(:,1)=(alpha1(2)-alpha1(1))*rand(pop_num,1)+alpha1(1); %左角度
     pop(:,5)=(alpha2(2)-alpha2(1))*rand(pop_num,1)+alpha2(1);
     pop(:,2)=randi([n1,n2],[pop_num,1]);
     pop(:,4)=rand(pop_num,1)*0.2+0.4;
     pop(:,6)=rand(pop_num,1)*0.2+0.4;
    
     for j=1:pop_num
     fitness(j)=fit_and_select2(pop(j,1),pop(j,5),pop(j,3),pop(j,2),pop(j,4),pop(j,6));    
     end
     
     not_e_index=find(fitness~=-inf);
% 随机补全被筛去的个体
% 在被-inf标记的不符合个体中，随机选择种群中剩下的个体补上
for j=1:pop_num
    if fitness(j)==-inf
        temp_index=randi([1,length(not_e_index)],1);
        temp_index2=not_e_index(temp_index);
        fitness(j)=fitness(temp_index2);
        pop(j,:)=pop(temp_index2,:);
    end
end
     
     
    if i~=1
    max_fitness_note(i)=max_fitness_note(i-1);
    avg_fitness_note(i)=avg_fitness_note(i-1);
    else
    max_fitness_note(1)=0;
    avg_fitness_note(1)=0;
    end
    
end



end
toc
 close(hbar);
 
 
 %% 每做一次自动写入数据
 xlswrite('C:\Users\bingjilin1995ydd\Desktop\M文件整理\data_harvest\note2.xlsx',1/max_fitness,'note2',['A',num2str(k)]);
 xlswrite('C:\Users\bingjilin1995ydd\Desktop\M文件整理\data_harvest\note2.xlsx',max_pop,'note2',['B',num2str(k),':G',num2str(k)]);
 
 
 %% 画出进化图
figure(1)
hold on
plot(1:ag_gen,max_fitness_note,'r-*');
plot(1:ag_gen,avg_fitness_note,'b-o');
title('适应度记录');
xlabel('进化代数');
ylabel('适应度');
legend('最大适应度','平均适应度');
hold off
saveas(figure(1),['C:\Users\bingjilin1995ydd\Desktop\M文件整理\data_harvest\图',num2str(k),'.bmp']);
close all
end

