%LT, ne (extrordinary), temperature-dependent Sellmeier
            clear all;
            T=25;

	        a=4.514261;           
		    b=0.011901;
		    c=0.110744;
            d=-0.02323;
            e=0.076144;
            f=0.195596;
            bT=(1.82194*1E-8)*(T+273.15)^2;
            cT=(1.5662*1E-8)*(T+273.15)^2;
            

              
            lam1=(0.3:0.001:2.3);
            lam2=0.5*lam1;
            n1=(a+(b+bT)./(lam1.^2-(c+cT)^2)+e./(lam1.^2-f^2)+d*lam1.^2).^0.5 ;
            n2=(a+(b+bT)./(lam2.^2-(c+cT)^2)+e./(lam2.^2-f^2)+d*lam2.^2).^0.5 ;
            delta_n=n2-n1;
            gpr=(n2./lam2-n1./lam1-n1./lam1).^(-1) ;
            delta_k_SHG=2*pi*(n2./(lam2*1E-6)-n1./(lam1*1E-6)-n1./(lam1*1E-6));
            phi=delta_k_SHG.*gpr;
 plot(lam1,gpr);