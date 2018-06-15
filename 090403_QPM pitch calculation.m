clear all;
cd('D:\TuanShu');
Material='SLT';     %SLT CLT CLN KTPzzz
lam_f=(0.5:0.0001:1.2)';
lam_s=lam_f/2;
T=25;

% ne = refractive index for extrordinary ray

if strcmp(Material,'CLN')
		    fe=(T-24.5)*(T+570.82);                     %Sellimeier equation 參數 for LN
	        a=5.35583;                                
		    b=0.100473;
		    c=0.20692;
		    e=100;
		    f=11.34927;
		    d=-1.5334e-2;
		    aT=4.629e-7;
		    bT=3.826e-8;
		    cT=-8.9e-9;
		    eT=2.657e-5	;
            ne_f=(a+aT*fe+(b+bT*fe)./(lam_f.^2-(c+cT*fe)^2)+(e+eT*fe)./(lam_f.^2-(f)^2)+d*lam_f.^2).^0.5;  %基頻光折射率 FOR LN  		    
		    ne_s=(a+aT*fe+(b+bT*fe)./(lam_s.^2-(c+cT*fe)^2)+(e+eT*fe)./(lam_s.^2-(f)^2)+d*lam_s.^2).^0.5;  %倍頻光折射率 FOR LN
else if strcmp(Material,'CLT')
	        a=4.514261;           
		    b=0.011901;
		    c=0.110744;
            d=-0.02323;
            e=0.076144;
            f=0.195596;
            bT=(1.82194*1E-8)*(T+273.15)^2;
            cT=(1.5662*1E-8)*(T+273.15)^2;
            ne_f=(a+(b+bT)./(lam_f.^2-(c+cT).^2)+e./(lam_f.^2-f^2)+d*lam_f.^2).^0.5 ;
		    ne_s=(a+(b+bT)./(lam_s.^2-(c+cT).^2)+e./(lam_s.^2-f^2)+d*lam_s.^2).^0.5 ;
    else if strcmp(Material,'SLT')           
            a=4.502483;           
		    b=0.007294;
		    c=0.185087;
            d=-0.02357;
            e=0.073423;
            f=0.199595;
            g=0.001;
            h=7.99724;
            bT=(3.483933*1E-8)*(T+273.15)^2;
            cT=(1.607839*1E-8)*(T+273.15)^2;
            
            ne_f=(a+(b+bT)./(lam_f.^2-(c+cT).^2)+e./(lam_f.^2-f^2)+d*lam_f.^2).^0.5 ;
		    ne_s=(a+(b+bT)./(lam_s.^2-(c+cT).^2)+e./(lam_s.^2-f^2)+d*lam_s.^2).^0.5 ;
        else if strcmp(Material,'KTPzzz')
            a=4.59423;           
		    b=0.06206;
		    c=0.04763;    
            e=110.80672;
            f=86.12171;
            ne_f=(a+(b)./(lam_f.^2-c)+e./(lam_f.^2-f)).^0.5 ;
		    ne_s=(a+(b)./(lam_s.^2-c)+e./(lam_s.^2-f)).^0.5 ;            
            end
        end
    end
end          
           % qpm_period=(ne_s./lam_s-ne_f./lam_f-ne_f./lam_f).^(-1);
            qpm_period=lam_f./(2*ne_s-2*ne_f);
            
%plot(lam_f,ne_s_CLT-ne_f_CLT,lam_f,ne_s_SLT-ne_f_SLT);
plot(lam_f,qpm_period);
M=[lam_f qpm_period];
dlmwrite('QPM_period.txt',M,'delimiter','\t','newline','pc');