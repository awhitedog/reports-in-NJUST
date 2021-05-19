
file_path =  'E:\大学生活\游戏？\世界游戏大全51\花牌\';% 图像文件夹路径
img_path_list = dir(strcat(file_path,'*.png'));%获取该文件夹中所有jpg格式的图像
m='.jpg'
img_num = length(img_path_list);%获取图像总数量
if img_num > 0 %有满足条件的图像
        for j = 1:img_num %逐一读取图像
            image_name = img_path_list(j).name;% 图像名
            image =  imread(strcat(file_path,image_name));
            img=imcrop(image,[90,50,1735,1020]); 
            %img=imcrop(image,[0,0,4000,4000]); 
            %imshow(img);
            eval(['imwrite(img,''',file_path,num2str(j),m,''');']);
        end
end