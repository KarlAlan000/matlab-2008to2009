clear all
cd('D:\TuanShu');
number=1;
filename_txt_2d=sprintf('LiTaRatio1.1_ReducedBy32.txt');
matrix=dlmread(filename_txt_2d);
ave=sum(sum(matrix))/length(matrix)/length(matrix);