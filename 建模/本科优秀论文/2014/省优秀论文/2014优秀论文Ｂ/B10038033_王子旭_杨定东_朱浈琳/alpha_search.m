function [alpha1,alpha2]=alpha_search(n1,n2)
global H0 D0
% alpha ��90�ȿ�ʼ����

% [flag,m,changduleft,changduright,distleft,distright,l1,r1] = B3okornot(DD,H,geshu,houdu,namda,namda2,thita,thita2 )



h=3; %�趨����ֵ
% lamda������
% nҲ���ڹ̶���Χ������
k=1;
value_a=[];
for lamda=0.3:0.1:0.7
   for n=n1:1:n2
       note_EP=zeros(1,40);
       flag=zeros(1,40);
      for i=1:40           %iҲҪ��Ӧ����
          alpha=1.57-(i-1)*0.02;    %���ɵ�����
          [flag(i),note_EP(i)]= B3okornot(D0,H0,n,h,lamda,lamda,alpha,alpha);  %���ܹ�ʽ          
      end
      
      for i=1:40
      if i~=40&&i~=1
          if note_EP(i)<note_EP(i+1)&&note_EP(i)<note_EP(i-1)&&flag(i)
              value_a(k)=1.57-(i-1)*0.02;
              k=k+1;
              break
          end
      end
      end
   end
end

alpha1=min(value_a);
alpha2=max(value_a);