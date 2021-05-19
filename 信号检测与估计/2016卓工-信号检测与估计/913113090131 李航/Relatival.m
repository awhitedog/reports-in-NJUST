function R=Relatival(x,m)  %x为输入的序列，m为自相关函数的取值点，输出循环自相关函数
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

