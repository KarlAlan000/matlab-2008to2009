clear all;
%===============NOTE (1)========================%
%
%   In ordinary efficient nl coeff calculation, we care only the profile of "one" period  
%   BUT here in random model, we must take the whole device length as one period
%   in calculation of nl coeff calculation
%
%==================Coefficient part======================%



index_considered=250;
c_considered=2/3.1415926;


QPM_wavelength=1.55;   
Number_of_pitch=25;

%============Spectrum part========================
Material='LT';              % LT or LN
Scanning_method='wavelength';         %wavelength or power
Fundamental_wavelength=1.53:0.001:1.57;        %micron
Averaged_power=0.12;                      %�����J�g���\�v(W)
Repetition_rate=4000;         %Hz
Pulsewidth=27E-9;             %second

%=================================================================%

        
		 W01=0.07;            %��J����e�������y�b�|(mm)
		 fL=50;                %�z��J�Z(mm)
		 n=1;                   %�u�Ť���g�v
		 C=3E8;                 %���t(m/s)
		 pi=3.1415926;          %��P�v
		 d=0.6E-6;              %���P���첾�q(m)

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
              

if strcmp(Material,'LN')
            D_BPM=34.4E-12;                                                          %�����D�o�Oԣ��� to check FOR LN
            else if strcmp(Material,'LT') 
            D_BPM=8.5E-12;              %    8.5E-12 m/V, �Ѧ�Hao 071220           
                end
end

          %�U�����Odesigned pitch, �ҥH�Mj�L��
		  %lamp_gpr=1.550                  %�p��_�l�g�����׹��������W���i��
		    lamp_gpr=QPM_wavelength;
		
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

Device_length=Number_of_pitch*QPM_pitch*1E-6;

%=======�w�o��Ҧ��Ĳv������mode, ���U�ӦҼ{�o��mode�b�W��W���`�M�^�m(SHG only)======%


if strcmp(Scanning_method,'wavelength')
    Scanning_parameter=Fundamental_wavelength';
else if strcmp(Scanning_method,'power')
    Scanning_parameter=Averaged_power';
    end
end


%===========�w���ŧi�}�C����==========
Z01(1:length(Scanning_parameter))=0;
W3(1:length(Scanning_parameter))=0;
Z03(1:length(Scanning_parameter))=0;
area(1:length(Scanning_parameter))=0;
SHG_wavelength_t(1:length(Scanning_parameter))=0;
delta_k_SHG(1:length(Scanning_parameter))=0;
A(1:length(Scanning_parameter))=0;
B(1:length(Scanning_parameter))=0;
position=0;
M_SHG=0;
SHG_power(1:length(Scanning_parameter),1:length(c_considered))=0;
%==================================== 
         


        
			
	      %power_p=q*10


		  %do r=27,30,1
          %write(*,*),r


		  %vi=0.1
          %do rv_round=1,14,1

	      %call random_seed()
		  %do rv=1,301,1
		  %call random_number(r1)
		  %r1_array(rv)=1-vi+2*vi*r1
		  %end do

          
          %=======================================!
		  %     �j��0 (�̥~��) ==> �]�i�� or power�ܤ�
		  %=======================================! 

for j=1:length(Scanning_parameter)                                
        %write(*,*),j
% lam_p=QPM_wavelength;
        
if strcmp(Scanning_method,'wavelength')
            lam_p=Fundamental_wavelength(j);   %���W���i��(um) �Oj�����
            power_p=Averaged_power/(Repetition_rate*Pulsewidth);    %��peak power��
else if strcmp(Scanning_method,'power')
            lam_p=Fundamental_wavelength;
            power_p=Averaged_power(j)/(Repetition_rate*Pulsewidth);    %��peak power�� �Oj�����
    end
end
		    lam_c=lam_p/2;             %���W���i��(um)
		
            
			%write(1,*) lam_p*1E3
		
			 
			fre_p=2*pi*C/lam_p*1E6;   %���W���W�v(Hz)    �o�̪�fre���O�����W�v
		    
		    fre_c=2*pi*C/lam_c*1E6;   %���W���W�v(Hz)

            
      if strcmp(Material,'LN')
			np=(c1+d1*fe+(c2+d2*fe)/(lam_p^2-(c3+d3*fe)^2)+(c4+d4*fe)/(lam_p^2-(c5)^2)+c6*lam_p^2)^0.5;  %���W����g�v FOR LN  		    
		    nc=(c1+d1*fe+(c2+d2*fe)/(lam_c^2-(c3+d3*fe)^2)+(c4+d4*fe)/(lam_c^2-(c5)^2)+c6*lam_c^2)^0.5;  %���W����g�v FOR LN
            
      else if strcmp(Material,'LT')            
            np=(a+(b+bT)/(lam_p^2-(c+cT)^2)+e/(lam_p^2-f^2)+d*lam_p^2)^0.5 ;
		    nc=(a+(b+bT)/(lam_c^2-(c+cT)^2)+e/(lam_c^2-f^2)+d*lam_c^2)^0.5 ;
          end
      end
		    %write(*,*) np
			%write(*,*) nc

			Z01(j)=pi*(W01)^2*n/(lam_p*1E-3);
		
		    W3(j)=(fL/Z01(j))/((1+(fL/Z01(j))^2)^0.5)*W01; %�J�g�������y�b�|

		    Z03(j)=pi*(W3(j))^2*n/(lam_p*1E-3);             %rayleigh range

			area(j)=pi*(W3(j)*1E-3)^2;                       %���I���n(m^2)
		 
          A(1)=((2*power_p*(perm/sus)^(0.5))/(area(j)*fre_p))^(0.5);     %���W���q����l��
		  
			
			%dz=(gpr_2+d*s+r*h)/600*1E-6 	%�p�ⴹ����פ����Z(m)		
                                        



		    %do d_change=1,10000,1
			%deff_1=0.0001*(d_change)*1.939E-22 

                                                       %�D�u�ʫY��(AS/V^2) =d_BPM*2/(pi)
 %deff_1_p=0.8962E-22;
            %write(*,*) 2*((perm/sus)**1.5)*((c/lam_p*1E6)**2)*(d_BPM**2)*(0.0032**2)/(np**3)*power_p/(area(j))*100
             %==============================================

             
             A(j)=2*((D_BPM*sus)^2)*(fre_p^2)*(power_p^2)/(area(j)^2)*((perm/sus)^(3/2))*(Device_length^2)/(np^2)/nc;

		  
             
             
             delta_k_SHG(j)=2*pi*(nc/(lam_c*1E-6)-np/(lam_p*1E-6)-np/(lam_p*1E-6)-index_considered/(Device_length));         
             
             
             B(j)=-2*c_considered/delta_k_SHG(j)*exp(i*delta_k_SHG(j)*Device_length/2)*sin(delta_k_SHG(j)*Device_length/2);

  
         SHG_power(j,:)=((A(j)*(abs(B(j)).^2)/(Device_length^2)*(Repetition_rate*Pulsewidth))*area(j));
         
     
         
         
		  
end                                    %�j��1���� j

SHG_power_nW=SHG_power*1E9;
plot(Scanning_parameter,SHG_power);
dlmwrite('SHG_power.txt',SHG_power,'delimiter','\t','newline','pc');
dlmwrite('index_considered.txt',index_considered,'delimiter','\t','newline','pc');

%plot(index_considered,c_considered);
%plot