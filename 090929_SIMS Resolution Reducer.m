clear all
Reducing_ratio=[2 4 8];   %若為N, 則reduce N*N to a pixel)
cd('G:\090929_SIMS-2 Data Analysis\RAW');
filename='Ta2-3A';
filename_txt=sprintf('%s.txt',filename);
A=dlmread(filename_txt,'');
count=A(:,2);
N=length(count)^0.5;
matrix=zeros(N);
for p=1:N
    matrix(p,:)=count((1+(p-1)*N):(p*N));
end
for k=1:length(Reducing_ratio)
filename_txt_reduced=sprintf('%s_ReducedBy%g.txt',filename,Reducing_ratio(k));
filename_png_reduced=sprintf('%s_ReducedBy%g.png',filename,Reducing_ratio(k));
matrix_n=zeros(length(matrix)/Reducing_ratio(k));
for p=1:length(matrix_n)
    for q=1:length(matrix_n)
        matrix_n(p,q)=sum(sum(matrix((1+(p-1)*Reducing_ratio(k)):p*Reducing_ratio(k),(1+(q-1)*Reducing_ratio(k)):q*Reducing_ratio(k))));
    end
end
img=mat2gray(matrix_n,[0 max(max(matrix_n))]);
imwrite(img,filename_png_reduced);
dlmwrite(filename_txt_reduced,matrix_n,'delimiter','\t','newline','pc');           %.........為什麼是顛倒的
end