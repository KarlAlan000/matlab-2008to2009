clear all;
cd('D:\TuanShu');
lam_f=(0.8:0.01:1.1)';
lam_s=lam_f/2;
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
            qpm_period_CLT=(ne_s_CLT./lam_s-ne_f_CLT./lam_f-ne_f_CLT./lam_f).^(-1);
            
	        a_SLT=4.528254;           
		    b_SLT=0.012962;
		    c_SLT=0.242783;
            d_SLT=-0.02288;
            e_SLT=0.068131;
            f_SLT=0.177370;
            g_SLT=1.307470;
            h_SLT=7.061878;
            bT_SLT=(3.483933*1E-8)*(T+273.15)^2;
            cT_SLT=(1.607839*1E-8)*(T+273.15)^2;
            
            ne_f_SLT=(a_SLT+(b_SLT+bT_SLT)./(lam_f.^2-(c_SLT+cT_SLT).^2)+e_SLT./(lam_f.^2-f_SLT^2)+g_SLT./(lam_f.^2-h_SLT^2)+d_SLT*lam_f.^2).^0.5 ;
		    ne_s_SLT=(a_SLT+(b_SLT+bT_SLT)./(lam_s.^2-(c_SLT+cT_SLT).^2)+e_SLT./(lam_s.^2-f_SLT^2)+g_SLT./(lam_f.^2-h_SLT^2)+d_SLT*lam_s.^2).^0.5 ;
            qpm_period_SLT=(ne_s_SLT./lam_s-ne_f_SLT./lam_f-ne_f_SLT./lam_f).^(-1);
            
            
            
                     
		    fe_CLN=(T-24.5)*(T+570.82);                     %Sellimeier equation 參數 for LN
	        c1_CLN=5.35583;                                
		    c2_CLN=0.100473;
		    c3_CLN=0.20692;
		    c4_CLN=100;
		    c5_CLN=11.34927;
		    c6_CLN=-1.5334e-2;
		    d1_CLN=4.629e-7;
		    d2_CLN=3.826e-8;
		    d3_CLN=-8.9e-9;
		    d4_CLN=2.657e-5	;	 
            
            ne_f_CLN=(c1_CLN+d1_CLN*fe_CLN+(c2_CLN+d2_CLN*fe_CLN)./(lam_f.^2-(c3_CLN+d3_CLN*fe_CLN)^2)+(c4_CLN+d4_CLN*fe_CLN)./(lam_f.^2-(c5_CLN)^2)+c6_CLN*lam_f.^2).^0.5;  %基頻光折射率 FOR LN  		    
		    ne_s_CLN=(c1_CLN+d1_CLN*fe_CLN+(c2_CLN+d2_CLN*fe_CLN)./(lam_s.^2-(c3_CLN+d3_CLN*fe_CLN)^2)+(c4_CLN+d4_CLN*fe_CLN)./(lam_s.^2-(c5_CLN)^2)+c6_CLN*lam_s.^2).^0.5;  %倍頻光折射率 FOR LN
            qpm_period_CLN=(ne_s_CLN./lam_s-ne_f_CLN./lam_f-ne_f_CLN./lam_f).^(-1);
            
%plot(lam_f,ne_s_CLT-ne_f_CLT,lam_f,ne_s_SLT-ne_f_SLT);
%plot(qpm_period_CLT,lam_f,qpm_period_SLT,lam_f,qpm_period_CLN,lam_f);
plot(qpm_period_CLN,lam_f);
M=[lam_f qpm_period_CLT qpm_period_SLT qpm_period_CLN];
dlmwrite('QPM_period.txt',M,'delimiter','\t','newline','pc');