clear all
cd('D:\TuanShu');
ion='Ta';
filter_size=[60];      %this means the inner square size in freguency domain
number=1;
for j=1:length(number)
for k=1:length(filter_size)
filename_txt_2d=sprintf('%s\\%s%g_2d.txt',ion,ion,number(j));
filename_txt_ave=sprintf('%sAve%g_fs%g.txt',ion,number(j),filter_size(k));
filename_png_ave=sprintf('%sAve%g_fs%g.png',ion,number(j),filter_size(k));
matrix=dlmread(filename_txt_2d);
cut=matrix(filter_size(k)/2:(length(matrix)-filter_size(k)/2),filter_size(k)/2:(length(matrix)-filter_size(k)/2));
ave=sum(sum(cut))/length(cut)/length(cut);
img=mat2gray(ave,[0 max(max(ave))]);
dlmwrite(filename_txt_ave,ave,'delimiter','\t','newline','pc');
imwrite(img,filename_png_ave,'Bitdepth',16);                      %.........為什麼是顛倒的
end
end