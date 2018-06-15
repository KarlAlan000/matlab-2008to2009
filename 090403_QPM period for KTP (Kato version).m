clear all;
cd('D:\TuanShu');
Direction='KTPzzz';     %XZ XY
lam_f=(1:0.001:2)';
lam_s=lam_f/2;
T=25;

            ax=3.29100;           
		    bx=0.04140;
		    cx=0.03978;    
            ex=9.35522;
            fx=31.45571;
            nx_f=(a+(bx)./(lam_f.^2-(cx).^2)+ex./(lam_f.^2-fx^2)).^0.5 ;
		    nx_s=(a+(bx)./(lam_s.^2-(cx).^2)+ex./(lam_s.^2-fx^2)).^0.5 ;            

            ay=4.59423;           
		    by=0.06206;
		    cy=0.04763;    
            ey=110.80672;
            fy=86.12171;
            ny_f=(ay+(by)./(lam_f.^2-(cy).^2)+e./(lam_f.^2-fy^2)).^0.5 ;
		    ny_s=(ay+(by)./(lam_s.^2-(cy).^2)+e./(lam_s.^2-fy^2)).^0.5 ;            

            az=4.59423;           
		    bz=0.06206;
		    cz=0.04763;    
            ez=110.80672;
            fz=86.12171;
            nz_f=(az+(bz)./(lam_f.^2-(cz).^2)+ez./(lam_f.^2-fz^2)).^0.5 ;
		    nz_s=(az+(bz)./(lam_s.^2-(cz).^2)+ez./(lam_s.^2-fz^2)).^0.5 ;            

            
           % qpm_period=(ne_s./lam_s-ne_f./lam_f-ne_f./lam_f).^(-1);
            qpm_period=lam_f./(2*ne_s-2*ne_f);
            
%plot(lam_f,ne_s_CLT-ne_f_CLT,lam_f,ne_s_SLT-ne_f_SLT);
plot(lam_f,qpm_period);
M=[lam_f qpm_period];
dlmwrite('QPM_period.txt',M,'delimiter','\t','newline','pc');