clear all;
%===============NOTE (1)========================%
%
%   In ordinary efficient nl coeff calculation, we care only the profile of "one" period  
%   BUT here in random model, we must take the whole device length as one period
%   in calculation of nl coeff calculation
%

QPM_wavelength=1.55;        %(micron)
Number_of_pitch=250;      %
Duty_cycle=0.5;         %0~1, where d=d_plus
N=600;                  %dz=QPM_pitch/N


%=============About Random===========================%

Ratio=1;

%============Spectrum part========================
Material='LT';              % LT or LN
Scanning_method='wavelength';         %wavelength or power
Fundamental_wavelength=1.53:0.01:1.57;        %micron
Averaged_power=0.12;                      %平均入射光功率(W)
Repetition_rate=4000;         %Hz
Pulsewidth=27E-9;             %second
N_2=100;               %discrete each QPM_pitch into N_2 dz_2



%===============以下去找各mode之中心波長, 並考慮1.效率夠高 2.接近中心波長之mode================%

Eff_Threshold=0.2;          %normalized by max eff


%======================陣列宣告====================================%

array(1:N*Number_of_pitch)=0;
coeff(1:N)=0;
%=================================================================%

        
		 W01=0.07;            %輸入晶體前光束光腰半徑(mm)
		 fL=50;                %透鏡焦距(mm)
		 n=1;                   %真空中折射率
		 C=3E8;                 %光速(m/s)
		 pi=3.1415926;          %圓周率
		 d=0.6E-6;              %單位周期位移量(m)

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
            D_BPM=34.4E-12;                                                          %不知道這是啥單位 to check FOR LN
            else if strcmp(Material,'LT') 
            D_BPM=8.5E-12;              %    8.5E-12 m/V, 參考Hao 071220           
                end
end

          %下面的是designed pitch, 所以和j無關
		  %lamp_gpr=1.550                  %計算起始週期長度對應之基頻光波長
		    lamp_gpr=QPM_wavelength;
		
            lamc_gpr=lamp_gpr/2;           %計算起始週期長度對應之倍頻光波長
		    
			
			%write(*,*) lamc_gpr
            
if strcmp(Material,'LN')
			np_gpr=(c1+d1*fe+(c2+d2*fe)/(lamp_gpr^2-(c3+d3*fe)^2)+(c4+d4*fe)/(lamp_gpr^2-(c5)^2)+c6*lamp_gpr^2)^0.5;  %計算起始週期長度對應之基頻光折射率	FOR LN	    
		    nc_gpr=(c1+d1*fe+(c2+d2*fe)/(lamc_gpr^2-(c3+d3*fe)^2)+(c4+d4*fe)/(lamc_gpr^2-(c5)^2)+c6*lamc_gpr^2)^0.5;  %計算起始週期長度對應之倍頻光折射率
else if strcmp(Material,'LT')     		                        
            np_gpr=(a+(b+bT)/(lamp_gpr^2-(c+cT)^2)+e/(lamp_gpr^2-f^2)+d*lamp_gpr^2)^0.5 ;
		    nc_gpr=(a+(b+bT)/(lamc_gpr^2-(c+cT)^2)+e/(lamc_gpr^2-f^2)+d*lamc_gpr^2)^0.5 ;
    end
end
           	%QPM_pitch=(nc_gpr/lamc_gpr-np_gpr/lamp_gpr-np_gpr/lamp_gpr)^(-1) ;   	
%QPM_pitch=Scanning_pitch*(j-1);
        
		    %write(*,*) np_gpr,nc_gpr,nu_gpr
			
			QPM_pitch=((nc_gpr/lamc_gpr-np_gpr/lamp_gpr-np_gpr/lamp_gpr)^(-1))*1E-6;	%一階倍頻對應之QPM週期(m) LN
            Device_length=Number_of_pitch*QPM_pitch;

dz=QPM_pitch/N;         %(m)

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


if strcmp(Scanning_method,'wavelength')
    Scanning_parameter=Fundamental_wavelength';
else if strcmp(Scanning_method,'power')
    Scanning_parameter=Averaged_power';
    end
end


%===========預先宣告陣列長度==========
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
			
          %=======================================!
		  %     迴圈0 (最外圈) ==> 跑波長 or power變化
		  %=======================================! 

for j=1:length(Scanning_parameter)                                

if strcmp(Scanning_method,'wavelength')
            lam_p=Fundamental_wavelength(j);   %基頻光波長(um) 是j的函數
            power_p=Averaged_power/(Repetition_rate*Pulsewidth);    %用peak power算
else if strcmp(Scanning_method,'power')
            lam_p=Fundamental_wavelength;
            power_p=Averaged_power(j)/(Repetition_rate*Pulsewidth);    %用peak power算 是j的函數
    end
end
		    lam_c=lam_p/2;             %倍頻光波長(um)
		
            
			%write(1,*) lam_p*1E3
		
			 
			fre_p=2*pi*C/lam_p*1E6;   %基頻光頻率(Hz)    這裡的fre其實是指角頻率
		    
		    fre_c=2*pi*C/lam_c*1E6;   %倍頻光頻率(Hz)

            
      if strcmp(Material,'LN')
			np=(c1+d1*fe+(c2+d2*fe)/(lam_p^2-(c3+d3*fe)^2)+(c4+d4*fe)/(lam_p^2-(c5)^2)+c6*lam_p^2)^0.5;  %基頻光折射率 FOR LN  		    
		    nc=(c1+d1*fe+(c2+d2*fe)/(lam_c^2-(c3+d3*fe)^2)+(c4+d4*fe)/(lam_c^2-(c5)^2)+c6*lam_c^2)^0.5;  %倍頻光折射率 FOR LN
            
      else if strcmp(Material,'LT')            
            np=(a+(b+bT)/(lam_p^2-(c+cT)^2)+e/(lam_p^2-f^2)+d*lam_p^2)^0.5 ;
		    nc=(a+(b+bT)/(lam_c^2-(c+cT)^2)+e/(lam_c^2-f^2)+d*lam_c^2)^0.5 ;
          end
      end
		    %write(*,*) np
			%write(*,*) nc

			Z01(j)=pi*(W01)^2*n/(lam_p*1E-3);
		
		    W3(j)=(fL/Z01(j))/((1+(fL/Z01(j))^2)^0.5)*W01; %入射晶體後光腰半徑

		    Z03(j)=pi*(W3(j))^2*n/(lam_p*1E-3);             %rayleigh range

			area(j)=pi*(W3(j)*1E-3)^2;                       %光點面積(m^2)
		 
          A(1)=((2*power_p*(perm/sus)^(0.5))/(area(j)*fre_p))^(0.5);     %基頻光電場初始值
		  B(1)=0;                                                        %倍頻光電場初始值
		  
             %==============================================

             
             A(j)=2*((D_BPM*sus)^2)*(fre_p^2)*(power_p^2)/(area(j)^2)*((perm/sus)^(3/2))*(Device_length^2)/(np^2)/nc;

          %================================================================!
		  %     迴圈2 (第2圈) ==> 給定週期長度與個數
		  %                       
		  %================================================================! 

        for h=1:Number_of_pitch  %週期的數量
		  
		  %===========================================================================!
		  %     迴圈3 (第3圈) ==> 基頻的消耗與倍頻光的產生                     
		  %===========================================================================! 
		
    for q=1:N                        %q為position之index

        
        
        
            delta_k_SHG=2*pi*(nc/(lam_c*1E-6)-np/(lam_p*1E-6)-np/(lam_p*1E-6));   %倍頻相位不匹配程度 (1/m)
			

			position(q+1)=position(q)+dz;                   %光束傳遞位置
           
		    M_SHG=i*delta_k_SHG*position(q);

		    B(q+1)=B(q)+dz*exp(M_SHG)*array(h*q);            %計算倍頻光之產生
		 
    end                                %迴圈3結束 q
           
		   position(1)=position(N+1);           %接續晶體長度
           B(1)=B(N+1);                         %倍頻光接續傳遞

           
        end                               %迴圈2結束 h

  
	                                
         SHG_power(j)=((A(j)*(abs(B(N+1))^2)/(Device_length^2)*(Repetition_rate*Pulsewidth))*area(j));
         
		 position(1)=0;                        %改變波長前須將晶體位置歸零           
         
         
		  
end                                    %迴圈1結束 j
SHG_power=SHG_power';
SHG_power_nW=SHG_power*1E9;
plot(Scanning_parameter,SHG_power);
%plot(index_considered,c_considered);
%plot