clear all;
cd('D:\TuanShu');
lam_f=(1:0.001:2)';
lam_s=lam_f/2;
lam_t=lam_f/3;
T=25;

% ne = refractive index for extrordinary ray

	        a_CLT=4.514261;           
		    b_CLT=0.011901;
		    c_CLT=0.110744;
            d_CLT=-0.02323;
            e_CLT=0.076144;
            f_CLT=0.195596;
            bT_CLT=(1.82194*1E-8)*(T+273.15)^2;
            cT_CLT=(1.5662*1E-8)*(T+273.15)^2;
            
            ne_f_CLT=(a_CLT+(b_CLT+bT_CLT)./(lam_f.^2-(c_CLT+cT_CLT).^2)+e_CLT./(lam_f.^2-f_CLT^2)+d_CLT*lam_f.^2).^0.5 ;
		    ne_s_CLT=(a_CLT+(b_CLT+bT_CLT)./(lam_s.^2-(c_CLT+cT_CLT).^2)+e_CLT./(lam_s.^2-f_CLT^2)+d_CLT*lam_s.^2).^0.5 ;
            ne_t_CLT=(a_CLT+(b_CLT+bT_CLT)./(lam_t.^2-(c_CLT+cT_CLT).^2)+e_CLT./(lam_t.^2-f_CLT^2)+d_CLT*lam_t.^2).^0.5 ;
            qpm_period_SHG=(ne_s_CLT./lam_s-ne_f_CLT./lam_f-ne_f_CLT./lam_f).^(-1);
            qpm_period_SFGcas3rd=3*(ne_t_CLT./lam_t-ne_f_CLT./lam_f-ne_s_CLT./lam_s).^(-1);

            
%plot(lam_f,ne_s_CLT-ne_f_CLT,lam_f,ne_s_SLT-ne_f_SLT);
plot(lam_f,qpm_period_SHG,lam_f,qpm_period_SFGcas3rd);
M=[lam_f qpm_period_SHG qpm_period_SFGcas3rd];
dlmwrite('CLT_QPM_period.txt',M,'delimiter','\t','newline','pc');