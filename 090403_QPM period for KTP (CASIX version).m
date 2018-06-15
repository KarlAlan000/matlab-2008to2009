clear all;
cd('D:\TuanShu');
Type='ZXX';     %ZZZ ZYY YZY
theta=(0:pi/2000:pi/2);
phi=(0:pi/2000:pi/2);
lam_f=(1:0.0001:1.2)';
lam_s=lam_f/2;
T=25;
QPMperiod=zeros(length(lam_f),1);
for i=1:length(lam_f)
            ax=3.0065;           
		    bx=0.03901;
		    cx=0.04251;    
            dx=-0.01327;
            nx_f=(ax+(bx)./(lam_f(i).^2-cx)+dx*lam_f(i).^2).^0.5 ;
            nx_s=(ax+(bx)./(lam_s(i).^2-cx)+dx*lam_s(i).^2).^0.5 ;        

            ay=3.0333;           
		    by=0.04154;
		    cy=0.04547;    
            dy=-0.01408;
            ny_f=(ay+(by)./(lam_f(i).^2-cy)+dy*lam_f(i).^2).^0.5 ;
            ny_s=(ay+(by)./(lam_s(i).^2-cy)+dy*lam_s(i).^2).^0.5 ;         

            az=3.3134;           
		    bz=0.05694;
		    cz=0.05658;    
            dz=-0.01682;
            nz_f=(az+(bz)./(lam_f(i).^2-cz)+dz*lam_f(i).^2).^0.5 ;
            nz_s=(az+(bz)./(lam_s(i).^2-cz)+dz*lam_s(i).^2).^0.5 ;
            
            
            
            
            
if strcmp(Type,'ZZZ')      
    ni=nz_s;
    nj=nz_f;
    nk=nz_f;
else if strcmp(Type,'ZYY')  %theta=90                              
    ni=nz_s;
    nj=ny_f;
    nk=ny_f;
else if strcmp(Type,'YZY')  
    ni=ny_s;
    nj=nz_f;
    nk=ny_f;    
else if strcmp(Type,'ZXX')  
    ni=nz_s;
    nj=nx_f;
    nk=nx_f;
else if strcmp(Type,'XXZ')     
    ni=nx_s;
    nj=nx_f;
    nk=nz_f;   
    end
        end
     end
    end
end

QPMperiod(i)=abs(lam_f(i)/(2*ni-nj-nk));

end

plot(lam_f,QPMperiod);
M=[lam_f QPMperiod];
dlmwrite('PPKTPQPMperiod.txt',M,'delimiter','\t','newline','pc');