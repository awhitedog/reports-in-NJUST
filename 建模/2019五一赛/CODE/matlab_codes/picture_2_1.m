rectangle('Position',[0 0 3000 1500])
hold on;
R_1=zeros(4,8);
R_2=[1407,0;1407,201;1407,402];
R_3=[2186,0;2592,0;1780,0;1407,603;1813,603;2219,603;1780,832;1780,1061;2186,832;2186,1061;2592,832;2592,1061];
R_4=[];
R_5=[1780,229;1981,229;2182,229;2383,229];
R_6=[2625,229;2625,430;2625,631;1407,832;1407,1033;1407,1234;1780,1289;2153,1289;2526,1289];
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