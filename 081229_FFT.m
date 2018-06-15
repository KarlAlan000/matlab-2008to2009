clear all;

cd('D:\TuanShu');
filename=sprintf('RGB.txt');
calibration=0.34465537736/2;      %10x的calibration = 0.34465537736
windowSize=100;                  %micron
array=dlmread(filename);
M=[array(:,1) array(:,3)];      % x-position vs. B intensity
X=M(:,1);
R=M(:,2);
R_ground=filter(ones(1,round(windowSize/calibration))/round(windowSize/calibration),1,R);
R_offset=R-R_ground;
plot(X,R,X,R_ground,X,R_offset);
fftR=abs(fft(R_offset'));
fftRn=fftR(1:(round(length(fftR)/2)));
P=calibration./(1:(round(length(fftR)/2)))*length(fftR);    
plot(P,fftRn);
%%M=[index_considered c_considered];
%%filename_2=sprintf('coeff_%g.txt',averaging_index);
%%dlmwrite(filename_2,M,'delimiter','\t','newline','pc');


%%plot(index_considered,abs(c_considered));   %畫是畫abs, 但用是用complex的, 畫的是最後一個