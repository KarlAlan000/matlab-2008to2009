clear all
cd('D:\TuanShu');
ion1='Li';
ion2='Ta';
Previously_reducing_factor=16;
number=[1 1.1 2 3 4 4.1 5 6];
eta=119.13/48.5*51.5;
for j=1:length(number)
filename_txt_Reduced_1=sprintf('%s\\%s%g_ReducedBy%g.txt',ion1,ion1,number(j),Previously_reducing_factor);
filename_txt_Reduced_2=sprintf('%s\\%s%g_ReducedBy%g.txt',ion2,ion2,number(j),128);
filename_txt_ratio=sprintf('%s%sRatio%g_ReducedBy%g_uniTa.txt',ion1,ion2,number(j),Previously_reducing_factor);
filename_png_ratio=sprintf('%s%sRatio%g_ReducedBy%g_uniTa.png',ion1,ion2,number(j),Previously_reducing_factor);
matrix1=dlmread(filename_txt_Reduced_1);
AveTaIonEachPixel=dlmread(filename_txt_Reduced_2)/(128/Previously_reducing_factor)/(128/Previously_reducing_factor);
ratio=matrix1./(matrix1+eta*AveTaIonEachPixel);
img=mat2gray(ratio,[0 max(max(ratio))]);
dlmwrite(filename_txt_ratio,ratio,'delimiter','\t','newline','pc');
imwrite(img,filename_png_ratio,'Bitdepth',16);                      %.........為什麼是顛倒的
end