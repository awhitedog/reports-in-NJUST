function [s,w]=shang(x)
[row,col]=size(x); 
[X,ps]=mapminmax(x');
ps.ymin=0.002; 
ps.ymax=0.996; 
ps.yrange=ps.ymax-ps.ymin; 
X=mapminmax(x',ps);
X=X'; 
for i=1:row
    for j=1:col
        p(i,j)=X(i,j)/sum(X(:,j));
    end
end
k=1/log(row);
for j=1:col
    e(j)=-k*sum(p(:,j).*log(p(:,j)));
end
c=ones(1,col)-e;  
w=c./sum(c);   
s=w*p';          