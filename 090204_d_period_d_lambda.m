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
            qpm_period_SHG=(ne_s_CLT./lam_s-ne_f_CLT./lam_f-ne_f_CLT./lam_f).^(-1);
            d_period_d_lambda=diff(qpm_period_SHG)/(lam_f(2)-lam_f(1));
            d_period_d_lambda(length(lam_f))=0;
%plot(lam_f,ne_s_CLT-ne_f_CLT,lam_f,ne_s_SLT-ne_f_SLT);
M=[lam_f ne_f_CLT ne_s_CLT qpm_period_SHG d_period_d_lambda];
dlmwrite('d_period_d_lambda.txt',M,'delimiter','\t','newline','pc');