M_creater;
fe=21e6;
fg=10e9;
t=10e-3;
N=800;
snr=20;
v=500;
fd=2*v*fg/3e8;
i=1:m*N;
s_in=repmat(m_dline,1,N);
s_in=[zeros(1,180),s_in];
s_in=awgn(s_in,snr,'measured');
for i=180:m*N+180
s_in(i)=s_in(i)*cos(2*pi*fd/fe*i);
end
ht=fliplr(m_dline);
s_out=conv(s_in,ht);
for r=1:N
    for h=1:m
        s_out_t(h,r)=s_out((r-1)*m+h);
    end
end
for h=1:m
s_out_t_1(h,:)=abs(fft(s_out_t(h,:)));
end
for r=1:N
 a(r)=max(s_out_t_1(:,r));
end
 x=find(a==max(a))
mesh(1:N,1:m,s_out_t_1)
