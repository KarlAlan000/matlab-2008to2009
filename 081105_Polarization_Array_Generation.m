clear all;
%===============NOTE (1)========================%
%
%   In ordinary efficient nl coeff calculation, we care only the profile of "one" period  
%   BUT here in random model, we must take the whole device length as one period
%   in calculation of nl coeff calculation
%
%==================Coefficient part======================%
cd('D:\TuanShu');
Start_QPM_wavelength=1.54394;
Final_QPM_wavelength=1.54394;
Number_of_pitch=269;      %
Spatial_resolution=0.1;   %(um) 這個數值要跟file 3一致
Random_pitch=1;          %單位是Spatial_resolution
Duty_cycle=0.5;         %0~1, where d=d_plus
Averaging_times=1;   %在此m-file中, 此數值決定的是生成array之數量

QPM_pitch(1:Number_of_pitch)=0;
%=============About Random===========================%

Ratio=1;

%============Spectrum part========================
Material='SLT';              % LT or LN
%===============以下去找各mode之中心波長, 並考慮1.效率夠高 2.接近中心波長之mode================%

Eff_Threshold=0;          %normalized by max eff


%===============自動生成QPM wavelength array======================%        

if Start_QPM_wavelength==Final_QPM_wavelength
    QPM_wavelength=Start_QPM_wavelength;
else
    QPM_wavelength=Start_QPM_wavelength:((Final_QPM_wavelength-Start_QPM_wavelength)/(Number_of_pitch-1)):Final_QPM_wavelength;
end

		 n=1;                   %真空中折射率
		 C=3E8;                 %光速(m/s)
		 pi=3.1415926;          %圓周率

		 sus=8.854E-12;         %真空中介電常數(F/m)   (C^2/N/m^2)
		 perm=pi*4E-7;          %真空中導磁係數(H/m)   (N/A^2)
         
         T=25;                  %溫度

if strcmp(Material,'LN')
         
		    fe=(T-24.5)*(T+570.82);                     %Sellimeier equation 參數 for LN
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
%=============================以下是LT的
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
             

          %下面的是designed pitch, 所以和j無關
		  %lamp_gpr=1.550                  %計算起始週期長度對應之基頻光波長

if Start_QPM_wavelength==Final_QPM_wavelength
    lamp_gpr=QPM_wavelength;
else
lamp_gpr=QPM_wavelength(j);
end

		
            lamc_gpr=lamp_gpr/2;           %計算起始週期長度對應之倍頻光波長
		    
			
			%write(*,*) lamc_gpr
            
if strcmp(Material,'LN')
			np_gpr=(c1+d1*fe+(c2+d2*fe)/(lamp_gpr^2-(c3+d3*fe)^2)+(c4+d4*fe)/(lamp_gpr^2-(c5)^2)+c6*lamp_gpr^2)^0.5;  %計算起始週期長度對應之基頻光折射率	FOR LN	    
		    nc_gpr=(c1+d1*fe+(c2+d2*fe)/(lamc_gpr^2-(c3+d3*fe)^2)+(c4+d4*fe)/(lamc_gpr^2-(c5)^2)+c6*lamc_gpr^2)^0.5;  %計算起始週期長度對應之倍頻光折射率
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
			
			QPM_pitch(j)=(nc_gpr/lamc_gpr-np_gpr/lamp_gpr-np_gpr/lamp_gpr)^(-1);	%一階倍頻對應之QPM週期(um) LN
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
plot(array);   %畫是畫abs, 但用是用complex的