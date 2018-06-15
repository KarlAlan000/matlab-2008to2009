         clear all;
		 %倍頻程式
   w=0;
         
%===========調變參數===============
          Material='LT';              % LT or LN
          Scanning_method='wavelength';         %wavelength or power
          QPM_wavelength=1.55;   
          Fundamental_wavelength=1.53:0.01:1.57;        %micron
          Ratio=1;
          Averaged_power=0.12;                      %平均入射光功率(W)
          Repetition_rate=4000;         %Hz
          Pulsewidth=27E-9;             %second
          
%=================================

%===========平常不動的參數=========
            q_p=600;                %將每個device分成這麼多個pitch (spitially) (device length/q_p=dz)
            number_of_period=250;

%====================================

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
A(1:length(Scanning_parameter))=0;
B(1:length(Scanning_parameter))=0;
device_length(1:length(Scanning_parameter))=0;
B_t(1:q_p+1)=0;
delta_k_SHG(1:q_p)=0;
position(1:q_p)=0;
M_SHG(1:q_p)=0;
SHG_power(1:length(Scanning_parameter))=0;
%==================================== 
         

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
		  %     迴圈1 (最外圈) ==> 跑波長 or power變化
		  %=======================================! 

for j=1:length(Scanning_parameter)                                
        %write(*,*),j
% lam_p=QPM_wavelength;
        
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
		 
		  B_t(1)=0;                                                        %倍頻光電場初始值
		  
          %下面的是designed pitch, 所以和j無關
		   %lamp_gpr=1.550                  %計算起始週期長度對應之基頻光波長
		    lamp_gpr=QPM_wavelength;
		
            lamc_gpr=lamp_gpr/2;              %計算起始週期長度對應之倍頻光波長
		    
			
			%write(*,*) lamc_gpr
            
if strcmp(Material,'LN')
			np_gpr=(c1+d1*fe+(c2+d2*fe)/(lamp_gpr^2-(c3+d3*fe)^2)+(c4+d4*fe)/(lamp_gpr^2-(c5)^2)+c6*lamp_gpr^2)^0.5;  %計算起始週期長度對應之基頻光折射率	FOR LN	    
		    nc_gpr=(c1+d1*fe+(c2+d2*fe)/(lamc_gpr^2-(c3+d3*fe)^2)+(c4+d4*fe)/(lamc_gpr^2-(c5)^2)+c6*lamc_gpr^2)^0.5;  %計算起始週期長度對應之倍頻光折射率
else if strcmp(Material,'LT')     		                        
            np_gpr=(a+(b+bT)/(lamp_gpr^2-(c+cT)^2)+e/(lamp_gpr^2-f^2)+d*lamp_gpr^2)^0.5 ;
		    nc_gpr=(a+(b+bT)/(lamc_gpr^2-(c+cT)^2)+e/(lamc_gpr^2-f^2)+d*lamc_gpr^2)^0.5 ;
    end
end
           	%gpr_1=(nc_gpr/lamc_gpr-np_gpr/lamp_gpr-np_gpr/lamp_gpr)^(-1) ;   	
%gpr_1=Scanning_pitch*(j-1);
        
		    %write(*,*) np_gpr,nc_gpr,nu_gpr
			
			gpr_1=(nc_gpr/lamc_gpr-np_gpr/lamp_gpr-np_gpr/lamp_gpr)^(-1);	%一階倍頻對應之QPM週期(um) 
            
            device_length(j)=number_of_period*gpr_1*1E-6;
			
            
		    dz=gpr_1/q_p*1E-6;              %計算晶體長度之間距(m)        
			%dz=(gpr_2+d*s+r*h)/600*1E-6 	%計算晶體長度之間距(m)		
                                        



		    %do d_change=1,10000,1
			%deff_1=0.0001*(d_change)*1.939E-22 
if strcmp(Material,'LN')
            d_BPM=34.4E-12;                                                          %不知道這是啥單位 to check FOR LN
            else if strcmp(Material,'LT') 
            d_BPM=8.5E-12;              %    8.5E-12 m/V, 參考Hao 071220           
                end
end
                                                       %非線性係數(AS/V^2) =d_BPM*2/(pi)
 %deff_1_p=0.8962E-22;
            %write(*,*) 2*((perm/sus)**1.5)*((c/lam_p*1E6)**2)*(d_BPM**2)*(0.0032**2)/(np**3)*power_p/(area(j))*100
             %==============================================

             
             A(j)=2*((d_BPM*sus)^2)*(fre_p^2)*(power_p^2)/(area(j)^2)*((perm/sus)^(3/2))*(device_length(j)^2)/(np^2)/nc;

		  %================================================================!
		  %     迴圈2 (第2圈) ==> 給定週期長度與個數
		  %                       
		  %================================================================! 

        for h=1:number_of_period  %週期的數量
		  
		  %===========================================================================!
		  %     迴圈3 (第3圈) ==> 基頻的消耗與倍頻光的產生                     
		  %===========================================================================! 
		
    for q=1:q_p                        %q為position之index   600為一週期
             
    
              if q<=q_p/2              %週期反轉,duty cycle=50%       這邊可以稍微寫的精簡一點, 但這樣比較清楚

                            deff=-1;

              else
                            deff=1;
                         %沒做check時什麼都不做, 也就是不換
               end

	
            delta_k_SHG(q)=2*pi*(nc/(lam_c*1E-6)-np/(lam_p*1E-6)-np/(lam_p*1E-6));   %倍頻相位不匹配程度 這個好像不用是array
			

			position(q+1)=position(q)+dz;                   %光束傳遞位置
           
		    M_SHG(q)=i*delta_k_SHG(q)*position(q);
           
           
		   B_t(q+1)=B_t(q)+dz*exp(M_SHG(q))*deff;            %計算倍頻光之產生
		 
    end                                %迴圈3結束 q
           
		   position(1)=position(q_p+1);           %接續晶體長度
           B_t(1)=B_t(q_p+1);                         %倍頻光接續傳遞

           
        end                               %迴圈2結束 h

        B(j)=B_t(q_p+1);
	                                
         SHG_power(j)=(A(j)*(abs(B(j))^2)/(device_length(j)^2)*(Repetition_rate*Pulsewidth))*area(j);
         
		 position(1)=0;                        %改變波長前須將晶體位置歸零           
         
         
		  
end                                    %迴圈1結束 j

	  plot(Scanning_parameter',SHG_power);
