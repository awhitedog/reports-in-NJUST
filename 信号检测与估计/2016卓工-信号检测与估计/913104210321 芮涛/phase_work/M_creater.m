%求127点M序列,并绘制自相关函数%
clear all;
register=[1,0,1,0,1,0,1];%寄存器初始状态
n=length(register);
m=2^n-1;
model=[1,0,0,0,0,0,1];%反馈系数
for i=1:m
    m_line(i)=register(n);
    n_register(1)=mod(sum(register.*model),2);
    for j=2:n
        n_register(j)=register(j-1);
    end
    register=n_register;
end
m_dline=m_line*2-1;


