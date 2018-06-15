clear all;

cd('D:\');
filename=sprintf('321.txt');
array=dlmread(filename);
M=[array(:,1) array(:,2)];      % time vs. B intensity
T=M(:,1);
R=M(:,2);
fftR=abs(fft(R'));
fftRn=fftR(1:(round(length(fftR)/2)));
plot(fftRn);
%%M=[index_considered c_considered];
%%filename_2=sprintf('coeff_%g.txt',averaging_index);
%%dlmwrite(filename_2,M,'delimiter','\t','newline','pc');


%%plot(index_considered,abs(c_considered));   %畫是畫abs, 但用是用complex的, 畫的是最後一個