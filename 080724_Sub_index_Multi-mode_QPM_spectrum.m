clear all;
%===============NOTE (1)========================%
%
%   In ordinary efficient nl coeff calculation, we care only the profile of "one" period  
%   BUT here in random model, we must take the whole device length as one period
%   in calculation of nl coeff calculation
%
%==================Coefficient part======================%

QPM_wavelength=1.55;   
Number_of_pitch=250;      %
Duty_cycle=0.5;         %0~1, where d=d_plus
N=1000;                 %discrete each QPM_pitch into N dz


%=============About Random===========================%

Ratio=0.505;
Averaging_times=10;

%============Spectrum part========================
Material='LT';              % LT or LN
Scanning_method='wavelength';         %wavelength or power
Fundamental_wavelength=1.525:0.001:1.575;        %micron
Averaged_power=0.12;                      %�����J�g���\�v(W)
Repetition_rate=4000;         %Hz
Pulsewidth=27E-9;             %second
N_2=100;               %discrete each QPM_pitch into N_2 dz_2



%===============�H�U�h��Umode�����ߪi��, �æҼ{1.�Ĳv���� 2.���񤤤ߪi����mode================%

%======================�}�C�ŧi====================================%

array(1:N*Number_of_pitch)=0;
temp=0;
coeff(1:N)=0;
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


dz=QPM_pitch/N;         %(micron)

for j=1:N*Number_of_pitch
    if mod(j*dz,QPM_pitch)<QPM_pitch*Duty_cycle
        if rand<Ratio
            array(j)=1;
        else
            array(j)=-1;
        end
    else
        if rand<Ratio
            array(j)=-1;
        else
            array(j)=1;
        end
    end
end

c_all=abs(fft(array)/(N*Number_of_pitch))';         %complex form c contribute only a extra phase > �n�����O�o�� �]�Umode�ٷ|couple�b�@�_
                                                   %/N*Number_of_pitch���z�ѽаѦ�080724
                                                   %c_all(1)���Oc_all(m=0)
Device_length=Number_of_pitch*QPM_pitch*1E-6;
%===============NOTE (2)========================%
%
%   Because of note (1), here c_all(m) is in fact for m*2pi/device_length
%   (instead of m*2pi/QPM_pitch). and c(m)=c_all(m*Number_of_pitch)
%      
%
%===============================================%
%%consider only near mode (m=1������c_all(Number_of_pitch+1))

index_considered=[(Number_of_pitch+1-5):(Number_of_pitch+1+5)]';
c_considered=c_all(index_considered); %note, must be used with index_considered
index_considered=index_considered-1;                                                    % to check������D�o�[�o��, �`��index�������Om'c_all(1)���Oc_all(m=0)

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
A(1:length(Scanning_parameter))=0;
B(1:N_2+1)=0;
position(1:N_2)=0;
M_SHG=0;
SHG_power(1:length(Scanning_parameter))=0;
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

          
          for w=1:Averaging_times
          
          %=======================================!
		  %     �j��0 (�̥~��) ==> �]�i�� or power�ܤ�
		  %=======================================! 

for j=1:length(Scanning_parameter)                                
        %write(*,*),j
% lam_p=QPM_wavelength;
        
if strcmp(Scanning_method,'wavelength')
            lam_p=Scanning_parameter(j);   %���W���i��(um) �Oj�����
            power_p=Averaged_power/(Repetition_rate*Pulsewidth);    %��peak power��
else if strcmp(Scanning_method,'power')
            lam_p=Fundamental_wavelength;
            power_p=Scanning_parameter(j)/(Repetition_rate*Pulsewidth);    %��peak power�� �Oj�����
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
		  B(1)=0;                                                        %���W���q����l��
		  
			
            
		    dz_2=QPM_pitch/N_2*1E-6;              %�p�ⴹ����פ����Z(m)        
			%dz=(gpr_2+d*s+r*h)/600*1E-6 	%�p�ⴹ����פ����Z(m)		
                                        



		    %do d_change=1,10000,1
			%deff_1=0.0001*(d_change)*1.939E-22 

                                                       %�D�u�ʫY��(AS/V^2) =d_BPM*2/(pi)
 %deff_1_p=0.8962E-22;
            %write(*,*) 2*((perm/sus)**1.5)*((c/lam_p*1E6)**2)*(d_BPM**2)*(0.0032**2)/(np**3)*power_p/(area(j))*100
             %==============================================

             
             A(j)=2*((D_BPM*sus)^2)*(fre_p^2)*(power_p^2)/(area(j)^2)*((perm/sus)^(3/2))*(Device_length^2)/(np^2)/nc;

		  
             
             
             
             
          %================================================================!
		  %     �j��2 (��2��) ==> ���w�g�����׻P�Ӽ�
		  %                       
		  %================================================================! 

        for h=1:Number_of_pitch  %�g�����ƶq
		  
		  %===========================================================================!
		  %     �j��3 (��3��) ==> ���W�����ӻP���W��������                     
		  %===========================================================================! 
		
    for q=1:N_2                        %q��position��index   600���@�g��
             
    

	
            delta_k_SHG=2*pi*(nc/(lam_c*1E-6)-np/(lam_p*1E-6)-np/(lam_p*1E-6)-index_considered/(Device_length));   %���W�ۦ줣�ǰt�{�� �o�ӬO�@��array!!!
			

			position(q+1)=position(q)+dz_2;                   %�����ǻ���m
           
		    M_SHG=i*delta_k_SHG*position(q);
           
           
		   B(q+1)=B(q)+dz_2*sum(exp(M_SHG).*c_considered);            %�p�⭿�W��������
		 
    end                                %�j��3���� q
           
		   position(1)=position(N_2+1);           %���������
           B(1)=B(N_2+1);                         %���W������ǻ�

           
        end                               %�j��2���� h

  
	                                
         SHG_power(j)=((A(j)*(abs(B(N_2+1))^2)/(Device_length^2)*(Repetition_rate*Pulsewidth))*area(j));
         
		 position(1)=0;                        %���ܪi���e���N�����m�k�s           
         
         
		  
end                                    %�j��1���� j

temp=temp+SHG_power;
          end

SHG_power=temp/Averaging_times;
SHG_power=SHG_power';
SHG_power_nW=SHG_power*1E9;
plot(Scanning_parameter,SHG_power);
%plot(index_considered,c_considered);
%plot