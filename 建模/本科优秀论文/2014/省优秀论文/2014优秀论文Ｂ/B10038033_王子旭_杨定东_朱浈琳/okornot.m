function [flag  thita] = okornot( DD,H,bianchang,geshu,namda,houdu )


%DD            ֱ��
%H             �߶�
%bianchang     �߳�
%geshu         �ֵĸ���
%namda         0-1�ֽ��ڻ��λ�ı���
%houdu         ľ��ĺ��
%flag          1 ��ʾ����
%zhinxin       ����
%thita         ��һ��ľ���ĽǶ� ������

R=DD/2;H=H-houdu;
dd=DD/geshu;sd=dd/2;sd1=sd;

isjishu=1;
if mod(geshu,2)==1 
    geshu=geshu+1;
    isjishu=0;
end;

dist=zeros(geshu/2,1);%dist��ÿ��ľ��ת�ᴦ���������ߵľ���
z1=zeros(geshu,1);
for i=1:geshu/2
    z1(i)=sd;
    if isjishu==0
        dist(geshu/2-i+1)=sqrt(R^2-(sd-sd1)^2);
    else
        dist(geshu/2-i+1)=sqrt(R^2-sd^2);
    end;
    sd=sd+dd;
end
changdu=bianchang/2-dist;   %��ÿ��ľ���ĳ���
xx=zeros(geshu/2,1);%xx�Ǿ����һ��ת�᳤�ȼ�����ľ���ĺ�����
xx=dist;
if isjishu==0
      z1(geshu/2+1)=z1(geshu/2);
else
      z1(geshu/2+1)=z1(geshu/2)+dd;
end;
for i=geshu/2+2:geshu
    z1(i)=z1(i-1)+dd;
end;
z2=z1;
z1=z1-R;z2=z2-R;

l=namda*(bianchang/2-dist(1));
x1=zeros(geshu,1);y1=zeros(geshu,1);
x1=dist;
thita=asin(H/changdu(1));
x=l*cos(thita)+dist(1);
y=l*sin(thita);
x2=zeros(geshu,1);
y2=zeros(geshu,1);
flag=1;
if l+dist(1)<R 
    flag=0;
end;
for j=1:geshu/2;
    qujian(i,j)=sqrt((x-xx(j))^2+y^2);
    if qujian(i,j)>changdu(j)
       flag=0;
    end;
    y2(j)=changdu(j)/qujian(i,j)*y;
    x2(j)=xx(j)-(changdu(j)/qujian(i,j)*(xx(j)-x));
    if x2(j)<0
        flag=0;
    end;
end



