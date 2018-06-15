clear all;
%===============NOTE (1)========================%
%
%   In ordinary efficient nl coeff calculation, we care only the profile of "one" period  
%   BUT here in random model, we must take the whole device length as one period
%   in calculation of nl coeff calculation
%
%==================Coefficient part======================%
cd('D:\TuanShu');
Start_QPM_wavelength=1.55;
Final_QPM_wavelength=1.55;
Number_of_pitch=250;      %
Spatial_resolution=0.1;   %(um) �o�Ӽƭȭn��file 3�@�P
Random_pitch=50000;          %���OSpatial_resolution
Duty_cycle=0.5;         %0~1, where d=d_plus
Averaging_times=10;   %�b��m-file��, ���ƭȨM�w���O�ͦ�array���ƶq

QPM_pitch(1:Number_of_pitch)=0;
%=============About Random===========================%

Ratio=0.5;

%============Spectrum part========================
Material='CLT';              % LT or LN
%===============�H�U�h��Umode�����ߪi��, �æҼ{1.�Ĳv���� 2.���񤤤ߪi����mode================%

Eff_Threshold=0;          %normalized by max eff


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
else if strcmp(Material,'CLT')
	        a_CLT=4.514261;           
		    b_CLT=0.011901;
		    c_CLT=0.110744;
            d_CLT=-0.02323;
            e_CLT=0.076144;
            f_CLT=0.195596;
            bT_CLT=(1.82194*1E-8)*(T+273.15)^2;
            cT_CLT=(1.5662*1E-8)*(T+273.15)^2;
    else if strcmp(Material,'SLT')
	        a_SLT=4.528254;           
		    b_SLT=0.012962;
		    c_SLT=0.242783;
            d_SLT=-0.02288;
            e_SLT=0.068131;
            f_SLT=0.177370;
            g_SLT=1.307470;
            h_SLT=7.061878;
            bT_SLT=(3.483933*1E-8)*(T+273.15)^2;
            cT_SLT=(1.607839*1E-8)*(T+273.15)^2;
        end
    end
end          

for j=1:Number_of_pitch
             

          %�U�����Odesigned pitch, �ҥH�Mj�L��
		  %lamp_gpr=1.550                  %�p��_�l�g�����׹��������W���i��

if Start_QPM_wavelength==Final_QPM_wavelength
    lamp_gpr=QPM_wavelength;
else
lamp_gpr=QPM_wavelength(j);
end

		
            lamc_gpr=lamp_gpr/2;           %�p��_�l�g�����׹��������W���i��
		    
			
			%write(*,*) lamc_gpr
            
if strcmp(Material,'LN')
			np_gpr=(c1+d1*fe+(c2+d2*fe)/(lamp_gpr^2-(c3+d3*fe)^2)+(c4+d4*fe)/(lamp_gpr^2-(c5)^2)+c6*lamp_gpr^2)^0.5;  %�p��_�l�g�����׹��������W����g�v	FOR LN	    
		    nc_gpr=(c1+d1*fe+(c2+d2*fe)/(lamc_gpr^2-(c3+d3*fe)^2)+(c4+d4*fe)/(lamc_gpr^2-(c5)^2)+c6*lamc_gpr^2)^0.5;  %�p��_�l�g�����׹��������W����g�v
elseif strcmp(Material,'CLT')
            np_gpr=(a_CLT+(b_CLT+bT_CLT)./(lamp_gpr.^2-(c_CLT+cT_CLT).^2)+e_CLT./(lamp_gpr.^2-f_CLT^2)+d_CLT*lamp_gpr.^2).^0.5 ;
		    nc_gpr=(a_CLT+(b_CLT+bT_CLT)./(lamc_gpr.^2-(c_CLT+cT_CLT).^2)+e_CLT./(lamc_gpr.^2-f_CLT^2)+d_CLT*lamc_gpr.^2).^0.5 ;
elseif strcmp(Material,'SLT')    	
            np_gpr=(a_SLT+(b_SLT+bT_SLT)./(lamp_gpr.^2-(c_SLT+cT_SLT).^2)+e_SLT./(lamp_gpr.^2-f_SLT^2)+g_SLT./(lamp_gpr.^2-h_SLT^2)+d_SLT*lamp_gpr.^2).^0.5 ;
		    nc_gpr=(a_SLT+(b_SLT+bT_SLT)./(lamc_gpr.^2-(c_SLT+cT_SLT).^2)+e_SLT./(lamc_gpr.^2-f_SLT^2)+g_SLT./(lamp_gpr.^2-h_SLT^2)+d_SLT*lamc_gpr.^2).^0.5 ;

end
           	%QPM_pitch=(nc_gpr/lamc_gpr-np_gpr/lamp_gpr-np_gpr/lamp_gpr)^(-1) ;   	
%QPM_pitch=Scanning_pitch*(j-1);
        
		    %write(*,*) np_gpr,nc_gpr,nu_gpr
			
			QPM_pitch(j)=(nc_gpr/lamc_gpr-np_gpr/lamp_gpr-np_gpr/lamp_gpr)^(-1);	%�@�����W������QPM�g��(um) LN
end

Device_length=sum(QPM_pitch)*1E-6; %(m)

array(1:floor(Device_length*1E6/Spatial_resolution))=0;
for averaging_index=1:Averaging_times
p=1;
for j=1:Number_of_pitch
while p*Random_pitch*Spatial_resolution<sum(QPM_pitch(1:j))
    if p*Random_pitch*Spatial_resolution<sum(QPM_pitch(1:(j-1)))+QPM_pitch(j)*Duty_cycle
        if rand<Ratio
            array((p-1)*Random_pitch+1:p*Random_pitch)=1;
        else
            array((p-1)*Random_pitch+1:p*Random_pitch)=-1;
        end
    else
        if rand<Ratio
            array((p-1)*Random_pitch+1:p*Random_pitch)=-1;
        else
            array((p-1)*Random_pitch+1:p*Random_pitch)=1;
        end
    end
    p=p+1;
end
end
filename_1=sprintf('array_%g.txt',averaging_index);
dlmwrite(filename_1,array,'delimiter','\t','newline','pc');
end
plot(array);   %�e�O�eabs, ���άO��complex��

%===============NOTE (1)========================%
%
%   In ordinary efficient nl coeff calculation, we care only the profile of "one" period  
%   BUT here in random model, we must take the whole device length as one period
%   in calculation of nl coeff calculation
%
%==================Coefficient part======================%
cd('D:\TuanShu');

%===============�H�U�h��Umode�����ߪi��, �æҼ{1.�Ĳv���� 2.���񤤤ߪi����mode================%

%QPM_pitch=Scanning_pitch*(j-1);
        
		    %write(*,*) np_gpr,nc_gpr,nu_gpr

for averaging_index=1:Averaging_times            
filename=sprintf('array_%g.txt',averaging_index);
array=dlmread(filename);
N_all=length(array);
parity=0;
if mod(N_all,2)==1
    N_all=N_all+1;
    parity=1;
end
c_considered=(fft(array)/N_all);         %complex form c contribute only a extra phase <WRONG
                                                   %/N*Number_of_pitch���z�ѽаѦ�080724
                                                   %c_all(1)���Oc_all(m=0)
%===============NOTE (2)========================%
%
%   Because of note (1), here c_all(m) is in fact for m*2pi/device_length
%   (instead of m*2pi/QPM_pitch). and c(m)=c_all(m*Number_of_pitch)
%      
%
%===============================================%


index_considered=(1-N_all/2):1:(N_all/2-1);   
index_considered=index_considered';
if parity==0
c_considered=[c_considered(N_all/2+2:N_all),c_considered(1:N_all/2)]';
else
c_considered=[c_considered(N_all/2+1:N_all-1),c_considered(1:N_all/2)]';
end
M=[index_considered c_considered];
filename_2=sprintf('coeff_%g.txt',averaging_index);
dlmwrite(filename_2,M,'delimiter','\t','newline','pc');
end

plot(index_considered,abs(c_considered));   %�e�O�eabs, ���άO��complex��, �e���O�̫�@��


%============Spectrum part========================
Material='CLT';              % LT or LN
Scanning_method='wavelength';         %wavelength or power
Fundamental_wavelength=1.5:0.001:1.6;        %micron
Averaged_power=0.05;                      %�����J�g���\�v(W)
Repetition_rate=4000;         %Hz
Pulsewidth=27E-9;             %second

cd('D:\TuanShu');

%=================================================================%


%===============NOTE (1)========================%
%
%   In ordinary efficient nl coeff calculation, we care only the profile of "one" period  
%   BUT here in random model, we must take the whole device length as one period
%   in calculation of nl coeff calculation
%
%==================Coefficient part======================%

%Device_length=20.42*250*1E-6;


        
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
else if strcmp(Material,'CLT')
	        a_CLT=4.514261;           
		    b_CLT=0.011901;
		    c_CLT=0.110744;
            d_CLT=-0.02323;
            e_CLT=0.076144;
            f_CLT=0.195596;
            bT_CLT=(1.82194*1E-8)*(T+273.15)^2;
            cT_CLT=(1.5662*1E-8)*(T+273.15)^2;
    else if strcmp(Material,'SLT')
	        a_SLT=4.502483;           
		    b_SLT=0.007294;
		    c_SLT=0.185087;
            d_SLT=-0.02357;
            e_SLT=0.073423;
            f_SLT=0.199595;
            g_SLT=0.001;
            h_SLT=7.99724;
            bT_SLT=(3.483933*1E-8)*(T+273.15)^2;
            cT_SLT=(1.607839*1E-8)*(T+273.15)^2;
        end
    end
end         
              

if strcmp(Material,'LN')
            D_BPM=34.4E-12;                                                          %�����D�o�Oԣ��� to check FOR LN
elseif strcmp(Material,'CLT') 
            D_BPM=8.5E-12;              %    8.5E-12 m/V, �Ѧ�Absolute scale of second-order nonlinear-optical
                                        % coefficients �H��Hao's fitting 071220
elseif strcmp(Material,'SLT')            
            D_BPM=10.6E-12;              %   �Ѧ�Optical-damage-free guided second-harmonic
                                         %generation in 1% MgO-doped stoichiometric lithium tantalate
end

            
           	%QPM_pitch=(nc_gpr/lamc_gpr-np_gpr/lamp_gpr-np_gpr/lamp_gpr)^(-1) ;   	
%QPM_pitch=Scanning_pitch*(j-1);
        
		    %write(*,*) np_gpr,nc_gpr,nu_gpr
			
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
B(1:length(Scanning_parameter))=0;
M_SHG=0;
averaging_temp(1:length(Scanning_parameter))=0;
%==================================== 
         
          %=======================================!
		  %     �j��0 (�̥~��) ==> �]�i�� or power�ܤ�
		  %=======================================! 
for averaging_index=1:Averaging_times
filename_1=sprintf('array_%g.txt',averaging_index);
filename_2=sprintf('coeff_%g.txt',averaging_index);

array=dlmread(filename_1);
Coefficient=dlmread(filename_2);

index_considered=Coefficient(:,1);
c_considered=Coefficient(:,2);


Device_length=Spatial_resolution*length(array)*1E-6; %(m)
          
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
            
elseif strcmp(Material,'CLT')
            np=(a_CLT+(b_CLT+bT_CLT)./(lam_p.^2-(c_CLT+cT_CLT).^2)+e_CLT./(lam_p.^2-f_CLT^2)+d_CLT*lam_p.^2).^0.5 ;
		    nc=(a_CLT+(b_CLT+bT_CLT)./(lam_c.^2-(c_CLT+cT_CLT).^2)+e_CLT./(lam_c.^2-f_CLT^2)+d_CLT*lam_c.^2).^0.5 ;
elseif strcmp(Material,'SLT')    	
            np=(a_SLT+(b_SLT+bT_SLT)./(lam_p.^2-(c_SLT+cT_SLT).^2)+e_SLT./(lam_p.^2-f_SLT^2)+g_SLT./(lam_p.^2-h_SLT^2)+d_SLT*lam_p.^2).^0.5 ;
		    nc=(a_SLT+(b_SLT+bT_SLT)./(lam_c.^2-(c_SLT+cT_SLT).^2)+e_SLT./(lam_c.^2-f_SLT^2)+g_SLT./(lam_p.^2-h_SLT^2)+d_SLT*lam_c.^2).^0.5 ;

end
		    %write(*,*) np
			%write(*,*) nc

			Z01(j)=pi*(W01)^2*n/(lam_p*1E-3);
		
		    W3(j)=(fL/Z01(j))/((1+(fL/Z01(j))^2)^0.5)*W01; %�J�g�������y�b�|

		    Z03(j)=pi*(W3(j))^2*n/(lam_p*1E-3);             %rayleigh range

			area(j)=pi*(W3(j)*1E-3)^2;                       %���I���n(m^2)
		 
           
             delta_k_SHG=2*pi*(nc/(lam_c*1E-6)-np/(lam_p*1E-6)-np/(lam_p*1E-6)-index_considered/(Device_length));   %���W�ۦ줣�ǰt�{�� �o�ӬO�@��array!!!

             A(j)=2*((D_BPM*sus)^2)*(fre_p^2)*(power_p^2)/(area(j)^2)*((perm/sus)^(3/2))*(Device_length^2)/(np^2)/nc;

             B(j)=sum(-2*c_considered./delta_k_SHG.*exp(i*delta_k_SHG*Device_length/2).*sin(delta_k_SHG*Device_length/2));
    %delta_k_SHG*Device_length�Q�������delta_k_SHG*Device_length/2 (�]�n��)
    %�e����-2�]�O�o�˨Ӫ�
             averaging_temp(j)=averaging_temp(j)+((A(j)*(abs(B(j))^2)/(Device_length^2)*(Repetition_rate*Pulsewidth))*area(j));  %�o�̦��I��²
end %�j��1���� j         
end
SHG_power=averaging_temp/Averaging_times;
SHG_power=SHG_power';
SHG_power_nW=SHG_power*1E9;
M=[Scanning_parameter SHG_power];
[power_max,index_max]=max(SHG_power);
index_leftHM=find(SHG_power>=max(SHG_power)/2,1, 'first');
index_rightHM=find(SHG_power>=max(SHG_power)/2,1, 'last');
HM_left_parameter=Scanning_parameter(index_leftHM);
HM_right_parameter=Scanning_parameter(index_rightHM);
FWHM=HM_right_parameter-HM_left_parameter;
dlmwrite('SHG.txt',M,'delimiter','\t','newline','pc');
plot(Scanning_parameter,SHG_power);
%plot(index_considered,c_considered);
%plot