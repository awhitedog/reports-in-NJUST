%% �Ŵ��㷨�ڶ�Լ��������żӹ�����
clc,clear
close all

% ���ڲ�������
global H0 D0


% �Ƕȷ�Χ����ȷ�����ԽǶ�Ϊ�Ա���
% �����ȷ��������ΧʱҪʹ��
% �û�����H0��D0
% �û�����β�����ߺ���������������ڵ��ú�����ģ������᷵�������Ӧ��

H0=53; % �߶� 
D0=40; % ͨ������
pop_num=80;   % ��Ⱥ����
ag_gen=400;   %��������
Pc_min=0.3;   % ��С�������
Pc_max=0.7;  %��󽻲����
Pm_min=0.11;   %��С�������
Pm_max=0.13;  %���������
A=9.903438;   %����Ӧ����/������ʹ�ʽϵ���������ĸ���
% ����Ӧ����/������ʹ�ʽ
P=@(x,P_max,P_min,f_avg,f_max)((P_max-P_min)./(1+exp(A*2*(x-f_avg)/(f_max-f_avg)))+P_min);
% �Ա���ά��
m=6;   % �Ա������Ƕ�alpha��lamda�ֽ�λ�ã�h���ȣ�n�����Ҹ��ֶ���ľ��

   % n1 n2 �������߽�
n1=floor(D0/2.5);    % 2.5 2�Ľ���
n2=ceil(D0/2);

tic
% alpha1,alpha2 ��Ҫ�޸�
[alpha1,alpha2]=alpha_search2(n1,n2);
toc

tic
for k=91 % ���ⲿΪ�������õ����ݵĴ�ѭ��
%% ������ʼ��
max_pop=[];
pop=zeros(pop_num,m);
pop(:,3)=rand(pop_num,1)*1+3;
pop(:,1)=(alpha1(2)-alpha1(1))*rand(pop_num,1)+alpha1(1); %��Ƕ�
pop(:,5)=(alpha2(2)-alpha2(1))*rand(pop_num,1)+alpha2(1);
pop(:,2)=randi([n1,n2],[pop_num,1]);
pop(:,4)=rand(pop_num,1)*0.2+0.4;
pop(:,6)=rand(pop_num,1)*0.2+0.4;


max_fitness=-inf;
max_fitness_note=zeros(1,ag_gen);
avg_fitness_note=zeros(1,ag_gen);

%% ���к�����ɸѡ�������ȫ
%�˹��̺�����ʹ��

% ��fit_and_select �����в���������Ӧ�ȣ����������ƽ������ӵ�ʵ�����ɸѡ�������ϵĸ��壬
% �����ϵĸ�������Ӧ�ȣ�fitnessλ���ã�-inf���
for j=1:pop_num
fitness(j)=fit_and_select2(pop(j,1),pop(j,5),pop(j,3),pop(j,2),pop(j,4),pop(j,6));    
end

not_e_index=find(fitness~=-inf);

% �����ȫ��ɸȥ�ĸ���
% �ڱ�-inf��ǵĲ����ϸ����У����ѡ����Ⱥ��ʣ�µĸ��岹��
for j=1:pop_num
    if fitness(j)==-inf
        temp_index=randi([1,length(not_e_index)],1);
        temp_index2=not_e_index(temp_index);
        fitness(j)=fitness(temp_index2);
        pop(j,:)=pop(temp_index2,:);
    end
end





%% ������ʼ
hbar=waitbar(0,'��������...0%');

for i=1:ag_gen
  pbar=sprintf('��������...%4.1f%%',i*100/ag_gen);
 waitbar(i/ag_gen,hbar,pbar);
 
% fitness=zeros(pop_num,1);


%% ���к�����ɸѡ�������ȫ


m_fitness=max(fitness);
a_fitness=mean(fitness);


%% �������

for j=1:pop_num
p=rand();

if fitness(j)<a_fitness  %������Ӧ��С����Ⱥ��Ӧ����������ȡ���
    p_to_c=Pm_max;
else                     %������Ӧ�ȴ�����Ⱥ��Ӧ����ʹ�ñ����������Ӧ��������������Ӧ��
    p_to_c=P(fitness(j),Pm_max,Pm_min,a_fitness,m_fitness);
end                     % ���ֱ�����ʼ������Ҳ���ڽ�����
if p<p_to_c
     pop(j,3)=rand()*1+3;
     pop(j,1)=(alpha1(2)-alpha1(1))*rand()+alpha1(1); %��Ƕ�
     pop(j,5)=(alpha2(2)-alpha2(1))*rand()+alpha2(1);
     pop(j,2)=randi([n1,n2],1);
     pop(j,4)=rand()*0.2+0.4;
     pop(j,6)=rand()*0.2+0.4;   %���죺��������ı�
end
end

for j=1:pop_num
fitness(j)=fit_and_select2(pop(j,1),pop(j,5),pop(j,3),pop(j,2),pop(j,4),pop(j,6));    
end


% �����ȫ��ɸȥ�ĸ���
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
%% �������

%���á��ŵ����ԡ��ģ��㽻��
[sort_f,index]=sort(fitness); %�����Ӧ�����򣬶���Ӧ������λ�����ڵĵ�����������

for j=1:(pop_num-1)
p=rand();
if sort_f(j)<a_fitness
    p_to_c=Pc_max;
else
    p_to_c=P(sort_f(j),Pc_max,Pc_min,a_fitness,m_fitness);
end

if p<p_to_c
    point=randi([1,m],1);
    switch point     %�Խ��������壬���һ���򣬽��л�������
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

%% ���к�����ɸѡ�������ȫ
for j=1:pop_num
fitness(j)=fit_and_select2(pop(j,1),pop(j,5),pop(j,3),pop(j,2),pop(j,4),pop(j,6));    
end
not_e_index=find(fitness~=-inf);
% �����ȫ��ɸȥ�ĸ���
for j=1:pop_num
    if fitness(j)==-inf
        temp_index=randi([1,length(not_e_index)],1);
        temp_index2=not_e_index(temp_index);
        fitness(j)=fitness(temp_index2);
        pop(j,:)=pop(temp_index2,:);
    end
end



%% ����ѡ����Ÿ���

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

%% һ�ν���������¼
[max_fitness_note(i),index_m]=max(fitness);

flag_v=1;
flag_s=0;
while 1
    
    % �������ܼ���ĺ�ѡ���ֵ����
    nx=pop(index_m,2);
    theta1=pop(index_m,1);
    theta2=pop(index_m,5);
    lamda1=pop(index_m,4);
    lamda2=pop(index_m,6);
    hx=pop(index_m,3);  
    
  
   %����Լ����5�ȵ�����,��������С��Сֵ����1~2��
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
    fitness(index_cluster)=0;     % �������������������ֵ��0
    [max_fitness_note(i),index_m]=max(fitness);   %���ô����ȡ��
    fitness(index_cluster)=max_fitness_note(i);
    
    if all(fitness==0)
        flag_v=0;  % �Ƿ��Ѿ��޷����������������ı�־
        break
    end
end



if flag_v
    %���з���Ҫ��ĸ��壬������ؼ�¼
avg_fitness_note(i)=mean(fitness);
if max_fitness<max_fitness_note(i)
 max_fitness=max_fitness_note(i);
 max_pop=pop(index_m,:);
end

else
    % ���޷������ܱ���Ҫ������Ⱥ�����³�ʼ��
     pop(:,3)=rand(pop_num,1)*1+3;
     pop(:,1)=(alpha1(2)-alpha1(1))*rand(pop_num,1)+alpha1(1); %��Ƕ�
     pop(:,5)=(alpha2(2)-alpha2(1))*rand(pop_num,1)+alpha2(1);
     pop(:,2)=randi([n1,n2],[pop_num,1]);
     pop(:,4)=rand(pop_num,1)*0.2+0.4;
     pop(:,6)=rand(pop_num,1)*0.2+0.4;
    
     for j=1:pop_num
     fitness(j)=fit_and_select2(pop(j,1),pop(j,5),pop(j,3),pop(j,2),pop(j,4),pop(j,6));    
     end
     
     not_e_index=find(fitness~=-inf);
% �����ȫ��ɸȥ�ĸ���
% �ڱ�-inf��ǵĲ����ϸ����У����ѡ����Ⱥ��ʣ�µĸ��岹��
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
 
 
 %% ÿ��һ���Զ�д������
 xlswrite('C:\Users\bingjilin1995ydd\Desktop\M�ļ�����\data_harvest\note2.xlsx',1/max_fitness,'note2',['A',num2str(k)]);
 xlswrite('C:\Users\bingjilin1995ydd\Desktop\M�ļ�����\data_harvest\note2.xlsx',max_pop,'note2',['B',num2str(k),':G',num2str(k)]);
 
 
 %% ��������ͼ
figure(1)
hold on
plot(1:ag_gen,max_fitness_note,'r-*');
plot(1:ag_gen,avg_fitness_note,'b-o');
title('��Ӧ�ȼ�¼');
xlabel('��������');
ylabel('��Ӧ��');
legend('�����Ӧ��','ƽ����Ӧ��');
hold off
saveas(figure(1),['C:\Users\bingjilin1995ydd\Desktop\M�ļ�����\data_harvest\ͼ',num2str(k),'.bmp']);
close all
end

