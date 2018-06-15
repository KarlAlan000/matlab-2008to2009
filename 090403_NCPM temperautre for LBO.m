clear all;
cd('D:\TuanShu');
Type='YZZ';     %ZZZ
lam_f=(1.31)';
lam_s=lam_f/2;
NCPMtemp=zeros(length(lam_f),1);
T=25;
for i=1:length(lam_f)
            ax=2.4542;           
		    bx=0.01125;
		    cx=0.01135;    
            dx=-0.01388;
            nx_f=(ax+(bx)./(lam_f(i).^2-cx)+dx*lam_f(i).^2).^0.5 ;
            nx_s=(ax+(bx)./(lam_s(i).^2-cx)+dx*lam_s(i).^2).^0.5 ;
            dnxdt_f=(-3.76*lam_f(i)+2.3)*10^-6;
            dnxdt_s=(-3.76*lam_s(i)+2.3)*10^-6;

            ay=2.5390;           
		    by=0.01277;
		    cy=0.01189;    
            dy=-0.01849;
            ey=4.3025*(10^-5);
            fy=-2.9131*(10^-5);
            ny_f=(ay+(by)./(lam_f(i).^2-cy)+dy*lam_f(i).^2+ey*lam_f(i).^4+fy*lam_f(i).^6).^0.5 ;
            ny_s=(ay+(by)./(lam_s(i).^2-cy)+dy*lam_s(i).^2+ey*lam_s(i).^4+fy*lam_s(i).^6).^0.5 ;         
            dnydt_f=(6.01*lam_f(i)-19.4)*10^-6;
            dnydt_s=(6.01*lam_s(i)-19.4)*10^-6;
            
            az=2.5865;           
		    bz=0.01310;
		    cz=0.01223;    
            dz=-0.01862;
            ez=4.5778*(10^-5);
            fz=-3.2526*(10^-5);
            nz_f=(az+(bz)./(lam_f(i).^2-cz)+dz*lam_f(i).^2+ez*lam_f(i).^4+fz*lam_f(i).^6).^0.5 ;
            nz_s=(az+(bz)./(lam_s(i).^2-cz)+dz*lam_s(i).^2+ez*lam_s(i).^4+fz*lam_s(i).^6).^0.5 ;
            dnzdt_f=(1.5*lam_f(i)-9.7)*10^-6;
            dnzdt_s=(1.5*lam_s(i)-9.7)*10^-6;
            
            
if strcmp(Type,'YZZ')      
    ni=ny_s;
    dnidt=dnydt_s;
    nj=nz_f;
    dnjdt=dnzdt_f;
    nk=nz_f;
    dnkdt=dnzdt_f;
else if strcmp(Type,'ZYY')  %theta=90                              
    ni=nz_s;
    dnidt=dnzdt_s;
    nj=ny_f;
    dnjdt=dnydt_f;
    nk=ny_f;
    dnkdt=dnydt_f;
else if strcmp(Type,'YZY')  
    ni=ny_s;
    dnidt=dnydt_s;
    nj=nz_f;
    dnjdt=dnzdt_f;
    nk=ny_f;
    dnkdt=dnydt_f;  
else if strcmp(Type,'ZXX')  
    ni=nz_s;
    dnidt=dnzdt_s;
    nj=nx_f;
    dnjdt=dnxdt_f;
    nk=nx_f;
    dnkdt=dnxdt_f;
else if strcmp(Type,'XXZ')     
    ni=nx_s;
    dnidt=dnxdt_s;
    nj=nx_f;
    dnjdt=dnxdt_f;
    nk=nz_f;
    dnkdt=dnzdt_f;
    end
    end
     end
    end
end

NCPMtemp(i)=-(2*ni-nj-nk)/(2*dnidt-dnjdt-dnkdt)+25; %(degree C)

end

plot(lam_f,NCPMtemp);
M=[lam_f NCPMtemp];
dlmwrite('LBONCPMtemp.txt',M,'delimiter','\t','newline','pc');