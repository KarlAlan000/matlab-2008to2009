clear all;
j=1;

for averaging_index=[0.5 1 5 10 50 100 500 1000 5000]
filename_3=sprintf('SHG_CLT_pump0.05W_%gmicron.txt',averaging_index);
SHG=dlmread(filename_3);
wavelength=SHG(:,1);
power=SHG(:,2);
averaged_power(j)=mean(power);
j=j+1;
end
averaged_power=averaged_power';
averaging_index=[0.5 1 5 10 50 100 500 1000 5000]';
M=[averaging_index averaged_power];
dlmwrite('averaged power.txt',M,'delimiter','\t','newline','pc');