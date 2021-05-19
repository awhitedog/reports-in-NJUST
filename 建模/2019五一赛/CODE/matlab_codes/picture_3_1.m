rectangle('Position',[0 0 3000 1500])
hold on;
R_11=zeros(4,11);
R_12=[];
R_P11=[];
R_P12=[];
R_P21=[2010,0;2010,477;2010,954;];
R_P22=[2521,0;2292,1218;];
R_P31=[2292,0;2292,406;2292,812;2746,282;2746,688;2769,1094;];
R_P32=[];
R_P41=[2521,282;2521,593;2521,904];
R_P42=[];
for i=2:size(R_11,1)
    R_11(i,1)=R_11(i-1,1)+373;
end
for i=1:size(R_11,1)
for j=3:size(R_11,2)
    R_11(i,j)=R_11(i,j-1)+201;
end
end
0
for i=1:size(R_11,1)
    for j=2:size(R_11,2)
rectangle('Position',[R_11(i,j) R_11(i,1) 201 373],'EdgeColor', 'b', 'LineWidth', 1)
axis equal
hold on;
    end
end

for i=1:size(R_12,1)
rectangle('Position',[R_12(i,1) R_12(i,2) 373 201],'EdgeColor', 'b', 'LineWidth', 1)
axis equal
hold on;
end
for i=1:size(R_P11,1)
rectangle('Position',[R_P11(i,1) R_P11(i,2) 201 373],'EdgeColor', 'b', 'LineWidth', 1)
axis equal
hold on;
end
for i=1:size(R_P12,1)
rectangle('Position',[R_P12(i,1) R_P12(i,2) 373 201],'EdgeColor', 'b', 'LineWidth', 1)
axis equal
hold on;
end

for i=1:size(R_P21,1)
rectangle('Position',[R_P21(i,1) R_P21(i,2) 282 477],'EdgeColor', 'g', 'LineWidth', 1)
axis equal
hold on;
end
for i=1:size(R_P22,1)
rectangle('Position',[R_P22(i,1) R_P22(i,2) 477 282],'EdgeColor', 'g', 'LineWidth', 1)
axis equal
hold on;
end
for i=1:size(R_P31,1)
rectangle('Position',[R_P31(i,1) R_P31(i,2) 229 406],'EdgeColor', 'r', 'LineWidth', 1)
axis equal
hold on;
end
for i=1:size(R_P32,1)
rectangle('Position',[R_P32(i,1) R_P32(i,2) 406 229],'EdgeColor', 'r', 'LineWidth', 1)
axis equal
hold on;
end

for i=1:size(R_P41,1)
rectangle('Position',[R_P41(i,1) R_P41(i,2) 225 311],'EdgeColor', 'm', 'LineWidth', 1)
axis equal
hold on;
end
for i=1:size(R_P42,1)
rectangle('Position',[R_P42(i,1) R_P42(i,2) 311 225],'EdgeColor', 'm', 'LineWidth', 1)
axis equal
hold on;
end
set(gca,'XLim',[0 3000]);%X轴的数据显示范围
set(gca,'YLim',[0 1500]);%设置要显示坐标刻度