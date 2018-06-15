clear all;
cd('D:\TuanShu');
Type='YZZ';     %ZZZ
lam_f=(1:0.0001:1.2)';
lam_s=lam_f/2;
T=25;


NCPMtemp=(-21.6306*(lam_f.^4)+112.251*(lam_f.^3)-220.46*(lam_f.^2)+194.153*lam_f-64.6145)*10^3; %©Ç©Çªº


plot(lam_f,NCPMtemp);
M=[lam_f NCPMtemp];
dlmwrite('LBONCPMtemp.txt',M,'delimiter','\t','newline','pc');