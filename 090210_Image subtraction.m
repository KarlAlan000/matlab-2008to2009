clear all
cd('D:\TuanShu');
ion='Mg';
number=[1 1.1 2 3 4 4.1 5];
for j=1:length(number)
filename_txt=sprintf('%s\\%s%g.txt',ion,ion,number(j));
filename_png=sprintf('%s\\%s%g.png',ion,ion,number(j));
A=dlmread(filename_txt,'');
count=A(:,2);
N=length(count)^0.5;
matrix=zeros(N);
for k=1:N
    matrix(k,:)=count((1+(k-1)*N):(k*N));
end
img=mat2gray(matrix);
imwrite(img,filename_png,'Bitdepth',16);
end