%��127��M����,����������غ���%
clear all;
register=[1,0,1,0,1,0,1];%�Ĵ�����ʼ״̬
n=length(register);
m=2^n-1;
model=[1,0,0,0,0,0,1];%����ϵ��
for i=1:m
    m_line(i)=register(n);
    n_register(1)=mod(sum(register.*model),2);
    for j=2:n
        n_register(j)=register(j-1);
    end
    register=n_register;
end
m_dline=m_line*2-1;


