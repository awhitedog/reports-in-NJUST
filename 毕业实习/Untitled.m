
file_path =  'E:\��ѧ����\��Ϸ��\������Ϸ��ȫ51\����\';% ͼ���ļ���·��
img_path_list = dir(strcat(file_path,'*.png'));%��ȡ���ļ���������jpg��ʽ��ͼ��
m='.jpg'
img_num = length(img_path_list);%��ȡͼ��������
if img_num > 0 %������������ͼ��
        for j = 1:img_num %��һ��ȡͼ��
            image_name = img_path_list(j).name;% ͼ����
            image =  imread(strcat(file_path,image_name));
            img=imcrop(image,[90,50,1735,1020]); 
            %img=imcrop(image,[0,0,4000,4000]); 
            %imshow(img);
            eval(['imwrite(img,''',file_path,num2str(j),m,''');']);
        end
end