%绘制M序列双值自相关函数%
M_creater;
t=-2*m:1:2*m;
for i=1:4*m+1
    m_dline_r=m_sh(m_dline,t(i));
    rx(i)=sum(m_dline_r.*m_dline);
    rx(i)=rx(i)/m;
end
stem(t,rx)
title('M序列双值自相关函数');
xlabel('n');
ylabel('Rx(n)');