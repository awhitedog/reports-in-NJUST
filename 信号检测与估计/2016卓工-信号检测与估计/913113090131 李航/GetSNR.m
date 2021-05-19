function y=GetSNR(x,u)
%获得脉压后的SNR
test=x(:,1);
a=max(test);
maxn=find(test==a);
signal=x;
G=x(maxn,:);
signal(maxn,:)=[];
signal=signal.^2;
SUM=sum(sum(signal));
N=numel(signal);
SUM=SUM/N;
G=G.^2;
Gsum=sum(G);
Gsum=Gsum/(length(G));
SNRout=10*log10(Gsum/SUM);
y(1)=SNRout;
%获得FFT后的SNR
Umax=max(max(u));
[a1,b1]=find(u==Umax);
s=u.^2;
sc=sum(sum(s));
pr=(sc-s(a1,b1))/(numel(u)-1);
ps=s(a1,b1);
y(2)=10*log10(ps/pr);

end