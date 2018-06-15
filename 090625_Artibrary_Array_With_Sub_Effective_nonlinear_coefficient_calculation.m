clear all;
%===============NOTE (1)========================%
%
%   In ordinary efficient nl coeff calculation, we care only the profile of "one" period  
%   BUT here in random model, we must take the whole device length as one period
%   in calculation of nl coeff calculation
%
%==================Coefficient part======================%
cd('D:\TuanShu');
Averaging_times=1;   %在此m-file中, 此數值決定的是讀取之array量

%===============以下去找各mode之中心波長, 並考慮1.效率夠高 2.接近中心波長之mode================%

%QPM_pitch=Scanning_pitch*(j-1);
        
		    %write(*,*) np_gpr,nc_gpr,nu_gpr

for averaging_index=1:Averaging_times            
filename=sprintf('array_%g.txt',averaging_index);
array=dlmread(filename);
N_all=length(array);
parity=0;
if mod(N_all,2)==1
    N_all=N_all+1;
    parity=1;
end
c_considered=(fft(array)/N_all);         %complex form c contribute only a extra phase <WRONG
                                                   %/N*Number_of_pitch的理由請參考080724
                                                   %c_all(1)其實是c_all(m=0)
%===============NOTE (2)========================%
%
%   Because of note (1), here c_all(m) is in fact for m*2pi/device_length
%   (instead of m*2pi/QPM_pitch). and c(m)=c_all(m*Number_of_pitch)
%      
%
%===============================================%


index_considered=(1-N_all/2):1:(N_all/2-1);   
index_considered=index_considered';
if parity==0
c_considered=[c_considered(N_all/2+2:N_all),c_considered(1:N_all/2)]';
else
c_considered=[c_considered(N_all/2+1:N_all-1), c_considered(1:N_all/2)]';
end
M=[index_considered c_considered];
filename_2=sprintf('coeff_%g.txt',averaging_index);
dlmwrite(filename_2,M,'delimiter','\t','newline','pc');
end

plot(index_considered,abs(c_considered));   %畫是畫abs, 但用是用complex的, 畫的是最後一個