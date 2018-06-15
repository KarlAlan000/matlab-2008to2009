clear all;

First_FT='Auto';
Second_FT='Manual';    % Auto Manual



%===============NOTE (1)========================%
%
%   In ordinary efficient nl coeff calculation, we care only the profile of "one" period  
%   BUT here in random model, we must take the whole device length as one period
%   in calculation of nl coeff calculation
%
%==================Coefficient part======================%
Material='LT';              % LT or LN
QPM_wavelength=1.55;    %micron, 用來決定pitch之length
Number_of_pitch=1;
Duty_cycle=0.5;         %0~1, where d=d_plus
N=1000;                 %discrete each QPM_pitch into N dz, 這個也決定了mode數
Ratio=1;
Eff_Threshold=0;
%======================陣列宣告====================================%

array(1:N*Number_of_pitch)=0;
a_reconstructed(1:N*Number_of_pitch)=0;
coeff(1:N)=0;
%=================================================================%

       

          %下面的是designed pitch, 所以和j無關
		  %lamp_gpr=1.550                  %計算起始週期長度對應之基頻光波長
		    lamp_gpr=QPM_wavelength;
		
            lamc_gpr=lamp_gpr/2;           %計算起始週期長度對應之倍頻光波長
		    
			
			%write(*,*) lamc_gpr
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
			
			QPM_pitch=(nc_gpr/lamc_gpr-np_gpr/lamp_gpr-np_gpr/lamp_gpr)^(-1);	%一階倍頻對應之QPM週期(um) LN


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

if strcmp(First_FT,'Auto')

    c_all=(fft(array)/(N*Number_of_pitch))';         %complex form c contribute only a extra phase

else if strcmp(First_FT,'Manual') 

    W=exp(2*pi/(N*Number_of_pitch));
    j=1:N*Number_of_pitch;
for k=1:N*Number_of_pitch
    c_all(k)=sum(array.*W.^((j-1)*(k-1)));
end
    end
end                                         %/N*Number_of_pitch的理由請參考080724
                                                   %c_all(1)其實是c_all(m=0)
Device_length=Number_of_pitch*QPM_pitch*1E-6;
%===============NOTE (2)========================%
%
%   Because of note (1), here c_all(m) is in fact for m*2pi/device_length
%   (instead of m*2pi/QPM_pitch). and c(m)=c_all(m*Number_of_pitch)
%      
%
%===============================================%

for j=1:(N-1)   %我們只能得到c(m=0)~c(m=(N-1)/2)  check一下 老師很愛問這個
    coeff(j)=c_all(1+j*Number_of_pitch);         
end


%==========================================================================
if strcmp(Second_FT,'Auto')
    a_reconstructed=imag(ifft(c_all))';
    else if strcmp(Second_FT,'Manual') 
coeff=coeff';

Max_eff=max(coeff);
[c_sorted,index_sort]=sort(coeff,'descend');
p=0;
while p<length(c_sorted) && (abs(c_sorted(p+1))>=abs(c_sorted(1))*Eff_Threshold)
    p=p+1;
end

index_considered=index_sort(1:p);   

c_considered=coeff(index_considered); %note, must be used with index_considered


for q=1:p                            %把index_considered變成-N/2~N/2之m
    if index_considered(q)>N/2
        index_considered(q)=index_considered(q)-N;
    end
end

[index_considered,index_index]=sort(index_considered);
c_considered=c_considered(index_index);


for j=1:N*Number_of_pitch
a_reconstructed(j)=real(sum(exp(2*pi*index_considered/(QPM_pitch*1E-6)*i*Device_length/Number_of_pitch/N*j).*c_considered));    %是取real part, 不是modulus
end
        end
end
plot(a_reconstructed, 'DisplayName', 'a_reconstructed', 'YDataSource', 'a_reconstructed');