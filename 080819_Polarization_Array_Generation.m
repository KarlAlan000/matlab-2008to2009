clear all;
%===============NOTE (1)========================%
%
%   In ordinary efficient nl coeff calculation, we care only the profile of "one" period  
%   BUT here in random model, we must take the whole device length as one period
%   in calculation of nl coeff calculation
%
%==================Coefficient part======================%
cd('D:\TuanShu');
Start_QPM_wavelength=1.5;
Final_QPM_wavelength=1.5;
Number_of_pitch=250;      %
Duty_cycle=0.5;         %0~1, where d=d_plus
N=100;                 %discrete each QPM_pitch into N dz, �o�Ӥ]�M�w�Fmode��
N_all=N*Number_of_pitch;

%=============About Random===========================%

Ratio=1;

%============Spectrum part========================
Material='LT';              % LT or LN
%===============�H�U�h��Umode�����ߪi��, �æҼ{1.�Ĳv���� 2.���񤤤ߪi����mode================%

Eff_Threshold=0;          %normalized by max eff


%======================�}�C�ŧi====================================%

array(1:N_all)=0;
coeff(1:N_all)=0;
%=================================================================%

%===============�۰ʥͦ�QPM wavelength array======================%        

if Start_QPM_wavelength==Final_QPM_wavelength
    QPM_wavelength=Start_QPM_wavelength;
else
QPM_wavelength=Start_QPM_wavelength:((Final_QPM_wavelength-Start_QPM_wavelength)/(Number_of_pitch-1)):Final_QPM_wavelength;
end

		 n=1;                   %�u�Ť���g�v
		 C=3E8;                 %���t(m/s)
		 pi=3.1415926;          %��P�v

		 sus=8.854E-12;         %�u�Ť����q�`��(F/m)   (C^2/N/m^2)
		 perm=pi*4E-7;          %�u�Ť��ɺϫY��(H/m)   (N/A^2)
         
         T=25;                  %�ū�

if strcmp(Material,'LN')
         
		    fe=(T-24.5)*(T+570.82);                     %Sellimeier equation �Ѽ� for LN
	        c1=5.35583;                                
		    c2=0.100473;
		    c3=0.20692;
		    c4=100;
		    c5=11.34927;
		    c6=-1.5334e-2;
		    d1=4.629e-7;
		    d2=3.826e-8;
		    d3=-8.9e-9;
		    d4=2.657e-5	;	 
%=============================�H�U�OLT��
else if strcmp(Material,'LT')
	        a=4.514261                      ;           
		    b=0.011901;
		    c=0.110744;
            d=-0.02323;
            e=0.076144;
            f=0.195596;
            bT=(1.82194*1E-8)*(T+273.15)^2;
            cT=(1.5662*1E-8)*(T+273.15)^2;
    end
end          


for p=1:Number_of_pitch
             

          %�U�����Odesigned pitch, �ҥH�Mj�L��
		  %lamp_gpr=1.550                  %�p��_�l�g�����׹��������W���i��

if Start_QPM_wavelength==Final_QPM_wavelength
    lamp_gpr=QPM_wavelength;
else
lamp_gpr=QPM_wavelength(p);
end

		
            lamc_gpr=lamp_gpr/2;           %�p��_�l�g�����׹��������W���i��
		    
			
			%write(*,*) lamc_gpr
            
if strcmp(Material,'LN')
			np_gpr=(c1+d1*fe+(c2+d2*fe)/(lamp_gpr^2-(c3+d3*fe)^2)+(c4+d4*fe)/(lamp_gpr^2-(c5)^2)+c6*lamp_gpr^2)^0.5;  %�p��_�l�g�����׹��������W����g�v	FOR LN	    
		    nc_gpr=(c1+d1*fe+(c2+d2*fe)/(lamc_gpr^2-(c3+d3*fe)^2)+(c4+d4*fe)/(lamc_gpr^2-(c5)^2)+c6*lamc_gpr^2)^0.5;  %�p��_�l�g�����׹��������W����g�v
else if strcmp(Material,'LT')     		                        
            np_gpr=(a+(b+bT)/(lamp_gpr^2-(c+cT)^2)+e/(lamp_gpr^2-f^2)+d*lamp_gpr^2)^0.5 ;
		    nc_gpr=(a+(b+bT)/(lamc_gpr^2-(c+cT)^2)+e/(lamc_gpr^2-f^2)+d*lamc_gpr^2)^0.5 ;
    end
end
           	%QPM_pitch=(nc_gpr/lamc_gpr-np_gpr/lamp_gpr-np_gpr/lamp_gpr)^(-1) ;   	
%QPM_pitch=Scanning_pitch*(j-1);
        
		    %write(*,*) np_gpr,nc_gpr,nu_gpr
			
			QPM_pitch=(nc_gpr/lamc_gpr-np_gpr/lamp_gpr-np_gpr/lamp_gpr)^(-1);	%�@�����W������QPM�g��(um) LN


dz=QPM_pitch/N;         %(micron)
for q=1:N
    if q*dz<QPM_pitch*Duty_cycle
        if rand<Ratio
            array((p-1)*N+q)=1;
        else
            array((p-1)*N+q)=-1;
        end
    else
        if rand<Ratio
            array((p-1)*N+q)=-1;
        else
            array((p-1)*N+q)=1;
        end
    end
end
end
dlmwrite('array.txt',array,'delimiter','\t','newline','pc');
plot(array);   %�e�O�eabs, ���άO��complex��