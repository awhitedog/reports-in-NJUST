function R=Relatival(x,m)  %xΪ��������У�mΪ����غ�����ȡֵ�㣬���ѭ������غ���
 n=length(x);
 h=length(m);
 SUM=zeros(1,h);
 for r=1:h
     Z=0;
     for i=1:n
         if (mod(i+m(r),n)==0)
             u=n;
         else
             u=mod(i+m(r),n);
         end
         Z=x(i)*x(u)+Z;
     end
     SUM(r)=Z;
 end
 R=SUM;


end

