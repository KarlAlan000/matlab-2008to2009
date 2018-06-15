clear all
cd('G:\090929_SIMS-2 Data Analysis');
adress='2-3A';
filename1=sprintf('Li%s',adress);
filename2=sprintf('Ta%s',adress);
Previously_reducing_factor1=2;
Previously_reducing_factor2=4;
filename_txt_reduced_1=sprintf('%s_ReducedBy%g.txt',filename1,Previously_reducing_factor1);
filename_txt_reduced_2=sprintf('%s_ReducedBy%g.txt',filename2,Previously_reducing_factor2);
filename_txt_ratio=sprintf('LiTaRatio%s_DRR.txt',adress);
filename_png_ratio=sprintf('LiTaRatio%s_DRR.png',adress);
matrix1=dlmread(filename_txt_reduced_1);
matrix2_o=dlmread(filename_txt_reduced_2);
matrix2=zeros(length(matrix1));
for p=1:length(matrix2_o)
    for q=1:length(matrix2_o)
        matrix2((1+(p-1)*Previously_reducing_factor2/Previously_reducing_factor1):p*Previously_reducing_factor2/Previously_reducing_factor1,(1+(q-1)*Previously_reducing_factor2/Previously_reducing_factor1):q*Previously_reducing_factor2/Previously_reducing_factor1)=matrix2_o(p,q)*(Previously_reducing_factor1/Previously_reducing_factor2)^2;
    end
end
ratio=matrix1./matrix2;
img=mat2gray(ratio,[0 max(max(ratio))]);
dlmwrite(filename_txt_ratio,ratio,'delimiter','\t','newline','pc');
imwrite(img,filename_png_ratio,'Bitdepth',8);                      %.........為什麼是顛倒的