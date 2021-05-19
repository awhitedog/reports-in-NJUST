clear;
clc;
rectangle('Position',[0 0 3000 1500])
hold on;
R_11=[];
R_12=[];
R_P11=[];
R_P12=[];
R_P21=[0,225;0,702;282 , 225 ; 282 , 702 ;
564 , 225 ; 564 , 702 ;
846 , 225 ; 846 , 702 ;
1128 , 225 ; 1128 , 702 ;
1410 , 225 ; 1410 , 702 ;
1692 , 225 ; 1692 , 702 ;
1974 , 225 ; 1974 , 702 ;
2256 , 225 ; 2256 , 702 ;];
R_P22=[];
R_P31=[];
R_P32=[];
R_P41=[2538,225;2760,225;2538 , 536 ; 2760 , 536 ;
2538 , 847 ; 2760 , 847 ;
2538 , 1158 ; 2760 , 1158 ;
0,1179;225 , 1179 ;
450 , 1179 ;
675 , 1179 ;
900 , 1179 ;
1125 , 1179 ;
1350 , 1179 ;
1575 , 1179 ;
1800 , 1179 ;
2025 , 1179 ;
2250 , 1179 ;
];
R_P42=[0,0;311,0;
622 , 0 ;
933 , 0 ;
1244 , 0 ;
1555 , 0 ;
1866 , 0 ;
2177 , 0 ;
2488 , 0 ;];
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