rectangle('Position',[0 0 3000 1500])
hold on;
R_1=zeros(4,10);
R_2=[];
R_3=[1809,0;2215,0;2182,603;2588,603;1809,1238;2215,1238;];
R_4=[1809,832;2038,832;2267,832;2496,832;2725,832;];
R_5=[2182,229;2383,229;];
R_6=[2621,0;2621,201;2621,402;1809,229;1809,430;1809,631;2621,1238;];
for i=2:size(R_1,1)
    R_1(i,1)=R_1(i-1,1)+373;
end
for i=1:size(R_1,1)
for j=3:size(R_1,2)
    R_1(i,j)=R_1(i,j-1)+201;
end
end
0
for i=1:size(R_1,1)
    for j=2:size(R_1,2)
rectangle('Position',[R_1(i,j) R_1(i,1) 201 373],'EdgeColor', 'b', 'LineWidth', 1)
axis equal
hold on;
    end
end

for i=1:size(R_2,1)
rectangle('Position',[R_2(i,1) R_2(i,2) 373 201],'EdgeColor', 'b', 'LineWidth', 1)
axis equal
hold on;
end

for i=1:size(R_3,1)
rectangle('Position',[R_3(i,1) R_3(i,2) 406 229],'EdgeColor', 'r', 'LineWidth', 1)
axis equal
hold on;
end
for i=1:size(R_4,1)
rectangle('Position',[R_4(i,1) R_4(i,2) 229 406],'EdgeColor', 'r', 'LineWidth', 1)
axis equal
hold on;
end
for i=1:size(R_5,1)
rectangle('Position',[R_5(i,1) R_5(i,2) 201 373],'EdgeColor', 'b', 'LineWidth', 1)
axis equal
hold on;
end
for i=1:size(R_6,1)
rectangle('Position',[R_6(i,1) R_6(i,2) 373 201],'EdgeColor', 'b', 'LineWidth', 1)
axis equal
hold on;
end
set(gca,'XLim',[0 3000]);%X轴的数据显示范围
set(gca,'YLim',[0 1500]);%设置要显示坐标刻度