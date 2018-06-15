clear all;
cd('D:\TuanShu');
lam_f=(1.4:0.001:1.7)';
lam_s=lam_f/2;
lam_t=lam_f/3;
T=[20];
qpm_period=zeros(length(lam_f),length(T));
% ne = refractive index for extrordinary ray

	        a_CLT=4.514261;           
		    b_CLT=0.011901;
		    c_CLT=0.110744;
            d_CLT=-0.02323;
            e_CLT=0.076144;
            f_CLT=0.195596;
for i=1:1:length(T)
            bT_CLT=(1.82194*1E-8)*(T(i)+273.15)^2;
            cT_CLT=(1.5662*1E-8)*(T(i)+273.15)^2; 
            ne_f_CLT=(a_CLT+(b_CLT+bT_CLT)./(lam_f.^2-(c_CLT+cT_CLT).^2)+e_CLT./(lam_f.^2-f_CLT^2)+d_CLT*lam_f.^2).^0.5 ;
		    ne_s_CLT=(a_CLT+(b_CLT+bT_CLT)./(lam_s.^2-(c_CLT+cT_CLT).^2)+e_CLT./(lam_s.^2-f_CLT^2)+d_CLT*lam_s.^2).^0.5 ;
            ne_t_CLT=(a_CLT+(b_CLT+bT_CLT)./(lam_t.^2-(c_CLT+cT_CLT).^2)+e_CLT./(lam_t.^2-f_CLT^2)+d_CLT*lam_t.^2).^0.5 ;
            qpm_period(:,i)=(ne_s_CLT./lam_s-ne_f_CLT./lam_f-ne_f_CLT./lam_f).^(-1);
end
            
%plot(lam_f,ne_s_CLT-ne_f_CLT,lam_f,ne_s_SLT-ne_f_SLT);
M=[lam_f qpm_period];
dlmwrite('CLT_QPM_period.txt',M,'delimiter','\t','newline','pc');