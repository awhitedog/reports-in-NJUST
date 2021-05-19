function yi=inter_edit(y,N)
x=[1,2+N/2,N+3];
xi=1:N+3;
xi(x)=[];
yi_r=interp1(x,y,xi,'cubic');
for i=1:2
    for j=1:N/2
    yi_r_t(i,j)=yi_r((i-1)*N/2+j);
    end
end
yi=[y(1),yi_r_t(1,:),y(2),yi_r_t(2,:),y(3)];