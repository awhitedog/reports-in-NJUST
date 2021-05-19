%画该m序列的循环自相关函数
Start=[0 0 0 0 0 0 1];
n=length(Start);
m=2^n-1;
for i=1:m
    regis=mod((Start(6)+Start(7)),2);
    if(Start(7)==1)
        Ms(i)=Start(7);
    else 
        Ms(i)=-1;
    end
    Start=[regis Start(1:6)];
end
t=0:450;
y=Relatival(Ms,t);
plot(t,y);
grid on;
figure;
stairs(Ms);
axis([-1 150 -1.4 1.4]);