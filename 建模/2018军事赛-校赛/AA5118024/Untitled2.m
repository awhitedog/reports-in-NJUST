x=rand(1).*2.*pi;
count=1;
for v=10.3:0.1:12.3
    for y=(x-5):0.1:(x+5)
       a=asin((v/18.01)*sin(y))
       k=44;
       for n=1:k;
          if -pi+0.1*(k-1)<a<pi+0.1*k
             count=count+1;
          end
       end
    end
end
count