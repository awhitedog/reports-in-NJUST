%完成M序列自相关移位函数%
function y=m_sh(m_dline,t)
m=length(m_dline);
if (t==0)
    y=m_dline;
elseif (t>0)
 t=rem(t,m);
 a_0=[ones(1,m-t),zeros(1,t)];
 b_0=[zeros(1,m-t),ones(1,t)];
a=m_dline.*a_0;
b=m_dline.*b_0;
a_1=find (a==0);
b_1=find(b==0);
a(a_1)=[];
b(b_1)=[];
y=[b,a];
else (t<0)
 t=rem(t,m);
a_0=[ones(1,-t),zeros(1,m+t)];
b_0=[zeros(1,-t),ones(1,m+t)];
a=m_dline.*a_0;
b=m_dline.*b_0;
a_l=find (a==0);
b_1=find(b==0);
a(a_l)=[];
b(b_1)=[];
y=[b,a];
end