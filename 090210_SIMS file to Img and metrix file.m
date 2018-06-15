clear all
cd('D:\TuanShu');
ion='Ta';
number=[1 1.1 2 3 4 4.1 5 6];
for j=1:length(number)
filename_txt=sprintf('%s\\%s%g.txt',ion,ion,number(j));
filename_txt_2d=sprintf('%s\\%s%g_2d.txt',ion,ion,number(j));
filename_png=sprintf('%s\\%s%g.png',ion,ion,number(j));
A=dlmread(filename_txt,'');
count=A(:,2);
N=length(count)^0.5;
matrix=zeros(N);
for k=1:N
    matrix(k,:)=count((1+(k-1)*N):(k*N));
end
img=mat2gray(matrix,[0 max(max(matrix))]);
imwrite(img,filename_png,'Bitdepth',16);
dlmwrite(filename_txt_2d,matrix,'delimiter','\t','newline','pc');           %.........為什麼是顛倒的
end