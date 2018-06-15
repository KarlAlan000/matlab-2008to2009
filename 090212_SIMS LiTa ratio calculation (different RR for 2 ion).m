clear all
cd('D:\TuanShu');
ion1='Li';
ion2='Total';
Previously_reducing_factor1=1;
Previously_reducing_factor2=1;
number=5;
eta=809824/8066194/48.5*51.5;       %if LiTotol>LiTa 809824/8066194/48.5*51.5
for j=1:length(number)
filename_txt_Reduced_1=sprintf('%s\\%s%g_ReducedBy%g.txt',ion1,ion1,number(j),Previously_reducing_factor1);
filename_txt_Reduced_2=sprintf('%s\\%s%g_ReducedBy%g.txt',ion2,ion2,number(j),Previously_reducing_factor2);
filename_txt_ratio=sprintf('%s%sRatio%g_ReducedBy%g_RR%s%g.txt',ion1,ion2,number(j),Previously_reducing_factor1,ion2,Previously_reducing_factor2);
filename_png_ratio=sprintf('%s%sRatio%g_ReducedBy%g_RR%s%g.png',ion1,ion2,number(j),Previously_reducing_factor1,ion2,Previously_reducing_factor2);
matrix1=dlmread(filename_txt_Reduced_1);
matrix2_o=dlmread(filename_txt_Reduced_2);
matrix2=zeros(length(matrix1));
for p=1:length(matrix2_o)
    for q=1:length(matrix2_o)
        matrix2((1+(p-1)*Previously_reducing_factor2/Previously_reducing_factor1):p*Previously_reducing_factor2/Previously_reducing_factor1,(1+(q-1)*Previously_reducing_factor2/Previously_reducing_factor1):q*Previously_reducing_factor2/Previously_reducing_factor1)=matrix2_o(p,q)*(Previously_reducing_factor1/Previously_reducing_factor2)^2;
    end
end
ratio=matrix1./(matrix1+eta*matrix2);
img=mat2gray(ratio,[0 max(max(ratio))]);
dlmwrite(filename_txt_ratio,ratio,'delimiter','\t','newline','pc');
imwrite(img,filename_png_ratio,'Bitdepth',8);                      %.........為什麼是顛倒的
end