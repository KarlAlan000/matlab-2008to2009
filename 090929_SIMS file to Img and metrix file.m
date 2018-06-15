clear all
cd('I:\090929_SIMS-2 Data Analysis\RAW');
ion='Li';
a1=[1 2];
a2=[1 2 3];
half_filter_size=16;     %real filter size will be 2*half_filter_size+1
for i=1:length(a1)
for j=1:length(a2)
filename=sprintf('%s%g-%gA',ion,a1(i),a2(j));
filename_txt=sprintf('%s.txt',filename);
filename_m=sprintf('%s_m.txt',filename);
filename_png=sprintf('%s.png',filename);
A=dlmread(filename_txt,'');
count=A(:,2);
N=length(count)^0.5;
matrix=zeros(N);
for k=1:N
    matrix(k,:)=count((1+(k-1)*N):(k*N));
end
for p=1:N
    for q=1:N
        matrix(p,q)=mean(mean(matrix(max(p-0.5*half_filter_size,1):min(p+0.5*half_filter_size,N),max(q-0.5*half_filter_size,1):min(q+0.5*half_filter_size,N))));
    end
end
img=mat2gray(matrix,[0 max(max(matrix))]);
imwrite(img,filename_png,'Bitdepth',16);
dlmwrite(filename_m,matrix,'delimiter','\t','newline','pc');           %.........為什麼是顛倒的
end
end