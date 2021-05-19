rectangle('Position',[0 0 3000 1500])
hold on;
R_1=zeros(7,2);
R_2=zeros(4,14);
for i=2:size(R_1,1)
    R_1(i,1)=0;
    R_1(i,2)=R_1(i-1,2)+201;
end
R_2(1,2)=373;

for i=2:size(R_2,1)
    R_2(i,1)=373+R_2(i-1,1);
    R_2(i,2)=373;
    for j=3:size(R_2,2)
    R_2(i,j)=R_2(i,j-1)+201;
    end
end
for i=2:size(R_2,2)
    R_2(1,i)=R_2(2,i);
end

for i=1:size(R_1,1)
rectangle('Position',[R_1(i,1) R_1(i,2) 373 201],'EdgeColor', 'b', 'LineWidth', 1)
axis equal
hold on;
end
for i=1:size(R_2,1)
    for j=2:size(R_2,2)
rectangle('Position',[R_2(i,j) R_2(i,1) 201 373],'EdgeColor', 'b', 'LineWidth', 1)
axis equal
hold on;
    end
end
set(gca,'XLim',[0 3000]);%X轴的数据显示范围
set(gca,'YLim',[0 1500]);%设置要显示坐标刻度