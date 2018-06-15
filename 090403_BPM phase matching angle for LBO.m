clear all;
cd('D:\TuanShu');
Plane='XZ';     %XZ XY YZ
theta=(0:pi/20000:pi/2);
phi=(0:pi/20000:pi/2);
lam_f=(1.0:0.0001:1.2)';
lam_s=lam_f/2;
T=25;
PMangle=zeros(length(lam_f),1);
for i=1:length(lam_f)
            ax=2.4542;           
		    bx=0.01125;
		    cx=0.01135;    
            dx=-0.01388;
            nx_f=(ax+(bx)./(lam_f(i).^2-cx)+dx*lam_f(i).^2).^0.5 ;
            nx_s=(ax+(bx)./(lam_s(i).^2-cx)+dx*lam_s(i).^2).^0.5 ;        

            ay=2.5390;           
		    by=0.01277;
		    cy=0.01189;    
            dy=-0.01848;
            ny_f=(ay+(by)./(lam_f(i).^2-cy)+dy*lam_f(i).^2).^0.5 ;
            ny_s=(ay+(by)./(lam_s(i).^2-cy)+dy*lam_s(i).^2).^0.5 ;         

            az=2.5865;           
		    bz=0.01310;
		    cz=0.01223;    
            dz=-0.01861;
            nz_f=(az+(bz)./(lam_f(i).^2-cz)+dz*lam_f(i).^2).^0.5 ;
            nz_s=(az+(bz)./(lam_s(i).^2-cz)+dz*lam_s(i).^2).^0.5 ;
            
            
            
            
            
if strcmp(Plane,'XZ')       %phi=0                                      type II是eoe, 即使用no_f no_f ne_s, no_f=ne_s 因此處ne<no (且no_s>no_f, normal dispersion) 
    no_f=ny_f;                                                          %ooe PM exist, but not sure if corresponding coeff exist
    no_s=ny_s;
    ne_s=((cos(theta).^2/nx_s^2)+(sin(theta).^2/nz_s^2)).^(-0.5);
    ne_f=((cos(theta).^2/nx_f^2)+(sin(theta).^2/nz_f^2)).^(-0.5);
    Q=ne_s-0.5*(no_f+ne_f);
    %Q=no_s-ne_f;
else if strcmp(Plane,'XY')  %theta=90                                   type I是ooe, 即使用no_f no_f ne_s, no_f=ne_s 因此處ne<no (且no_s>no_f, normal dispersion) 
    no_f=nz_f;                                                          
    no_s=nz_s;
    ne_s=((cos(phi).^2/ny_s^2)+(sin(phi).^2/nx_s^2)).^(-0.5);
    ne_f=((cos(phi).^2/ny_f^2)+(sin(phi).^2/nx_f^2)).^(-0.5);
    Q=ne_s-no_f;
else if strcmp(Plane,'YZ')  %phi=90                                   type II是eoo oeo, 即使用no_f ne_f ne_s, 0.5(no_f+ne_f)=no_s 因此處ne>no (且ne_s>ne_f, normal dispersion) 
    no_f=nx_f;
    no_s=nx_s;
    ne_s=((cos(theta).^2/ny_s^2)+(sin(theta).^2/nz_s^2)).^(-0.5);
    ne_f=((cos(theta).^2/ny_f^2)+(sin(theta).^2/nz_f^2)).^(-0.5);
    Q=no_s-0.5*(no_f+ne_f);
    end
    end
end

if Q(1)<0
        index=find(Q>0,1,'first');
else if Q(1)>0
        index=find(Q<0,1,'first');
    else if Q(1)==0
        index=1;
        end
    end
end
    if isempty(index) && (Q(1)<0)
        index=1;
    else if isempty(index) && (Q(1)>0)
        index=length(Q);    
        end
    end

if strcmp(Plane,'XZ')       %phi=0                                      這裡的type II似乎是指eoe oee, 即使用no_f ne_f ne_s, 0.5(no_f+ne_f)=ne_s
    PMangle(i)=theta(index)*180/pi;
else if strcmp(Plane,'XY')  %theta=90
    PMangle(i)=phi(index)*180/pi;
else if strcmp(Plane,'YZ')  %phi=90    
    PMangle(i)=theta(index)*180/pi;
    end
    end
end

end

plot(lam_f,PMangle);
M=[lam_f PMangle];
dlmwrite('PMangle.txt',M,'delimiter','\t','newline','pc');