
path1='E:\baogao\电子信息工程综合实验\latex\picture\pre\';
path2='E:\baogao\电子信息工程综合实验\latex\picture\';
name='TIM20190916004903';
aa=imread([path1,name,'.png']);
cc = imcrop(aa,[640 160 1250 640]);
  figure(1);
  imshow(cc)
imwrite(cc,[path2,name,'.png']);