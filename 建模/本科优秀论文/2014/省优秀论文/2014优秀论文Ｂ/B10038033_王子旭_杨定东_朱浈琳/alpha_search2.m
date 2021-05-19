function [alpha1,alpha2]=alpha_search2(n1,n2)
global H0 D0
% alpha 从90度开始搜索

% [flag,m,changduleft,changduright,distleft,distright,l1,r1] = B3okornot(DD,H,geshu,houdu,namda,namda2,thita,thita2 )



h=3; %设定测试值
% lamda可搜索
% n也是在固定范围内搜素
k=1;
value_a=[];
value_a2=[];
for lamda1=0.3:0.1:0.7
    for lamda2=0.3:0.1:0.7
   for n=n1:1:n2
       
       note_EP=zeros(40,40);
       flag=zeros(40,40);
       
       for c=1:40
           alpha_a=1.57-(c-1)*0.02;  
      for i=1:40           %i也要对应调整
          alpha_b=1.57-(i-1)*0.02;    %间距可调！！
          [flag(c,i),note_EP(c,i)]= B3okornot(D0,H0,n,h,lamda1,lamda2,alpha_a,alpha_b);  %势能公式          
      end
       end
       
       flag_f=0;
       for c=1:40
      for i=1:40
      if i~=40&&i~=1&&c~=1&&c~=40
          if note_EP(c,i)<note_EP(c,i+1)&&note_EP(c,i)<note_EP(c,i-1)&&flag(c,i)&&note_EP(c,i)<note_EP(c+1,i)&&note_EP(c,i)<note_EP(c-1,i)
              value_a(k)=1.57-(i-1)*0.02;
              value_a2(k)=1.57-(c-1)*0.02;
              k=k+1;
              flag_f=1;
              break
          end
      end
      end
      if flag_f
          break
      end
       end
       
   end
    end
end

alpha1(1)=min(value_a);
alpha1(2)=max(value_a);

alpha2(1)=min(value_a2);
alpha2(2)=max(value_a2);



