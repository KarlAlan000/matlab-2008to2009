clear all
cd('G:\090929_SIMS-2 Data Analysis\RAW');
a1=[2];
a2=[2];
for i=1:length(a1)
    for j=1:length(a2)
adress=sprintf('%g-%gA',a1(i),a2(j));
filename1=sprintf('Li%s',adress);
filename2=sprintf('Ta%s',adress);
filename1_m=sprintf('%s_m.txt',filename1);
filename2_m=sprintf('%s_m.txt',filename2);
filename_txt_ratio=sprintf('LiTaRatio%s.txt',adress);
filename_png_ratio=sprintf('LiTaRatio%s.png',adress);
matrix1=dlmread(filename1_m);
matrix2=dlmread(filename2_m);
ratio=matrix1./matrix2;
N=length(ratio);
for p=1:N
    for q=1:N
        if ratio(p,q)==Inf
            ratio(p,q)=0;
        end
    end
end
%ratio=ratio(20:110,:);
img=mat2gray(ratio,[0 max(max(ratio))]);
dlmwrite(filename_txt_ratio,ratio,'delimiter','\t','newline','pc');
imwrite(img,filename_png_ratio,'Bitdepth',16);                      %.........為什麼是顛倒的
    end
end