%LT, ne (extrordinary), temperature-dependent Sellmeier
            clear all;
            T=25;
            length=0.00001;                 %m
	        a=4.514261;           
		    b=0.011901;
		    c=0.110744;
            d=-0.02323;
            e=0.076144;
            f=0.195596;
            bT=(1.82194*1E-8)*(T+273.15)^2;
            cT=(1.5662*1E-8)*(T+273.15)^2;
            
            lam_p(1:2000)=0;
            np(1:2000)=0;
            delta_k_SHG(1:2000)=0;
            lam_1_gpr=1.55;
            lam_2_gpr=lam_1_gpr/2;            
            n1_gpr=(a+(b+bT)/(lam_1_gpr^2-(c+cT)^2)+e/(lam_1_gpr^2-f^2)+d*lam_1_gpr^2)^0.5;
            n2_gpr=(a+(b+bT)/(lam_2_gpr^2-(c+cT)^2)+e/(lam_2_gpr^2-f^2)+d*lam_2_gpr^2)^0.5;
            gpr_1=(n2_gpr/lam_2_gpr-n1_gpr/lam_1_gpr-n1_gpr/lam_1_gpr)^(-1);
            
for j=1:10000
            lam_1(j)=0.6+0.001*j;
            lam_2(j)=0.5*(0.6+0.001*j);
            n1(j)=(a+(b+bT)/(lam_1(j)^2-(c+cT)^2)+e/(lam_1(j)^2-f^2)+d*lam_1(j)^2)^0.5;    
            n2(j)=(a+(b+bT)/(lam_2(j)^2-(c+cT)^2)+e/(lam_2(j)^2-f^2)+d*lam_2(j)^2)^0.5;                
            delta_n(j)=n2(j)-n1(j);
            delta_k_SHG(j)=2*pi*(n2(j)/(lam_2(j)*1E-6)-n1(j)/(lam_1(j)*1E-6)-n1(j)/(lam_1(j)*1E-6)-1/(gpr_1*1E-6));
            w1(j)=3E8*lam_1(j)*1E-6;
            field(j)=w1(j)/delta_k_SHG(j)*sin(delta_k_SHG(j)*length/2);
          % qqqq(j)=w1/delta_k_SHG(j);
end
 
 for j=1:10000
                 lam_1(j)=0.6+0.001*j;
                 w1(j)=3E8*lam_1(j)*1E-6;
     end
 plot(lam_1,field);