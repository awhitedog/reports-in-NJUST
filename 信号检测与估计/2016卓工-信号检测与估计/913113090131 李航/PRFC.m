function y = PRFC(t)
%UNTITLED3 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
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
Fc=10e9; %�ز�Ƶ��
Fm=31e6; %��ԪƵ��
k=mod(floor(t.*Fm),m);
y=Ms(k+1);



end

