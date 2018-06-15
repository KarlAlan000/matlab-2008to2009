clear all;
%===============NOTE (1)========================%
%
%   In ordinary efficient nl coeff calculation, we care only the profile of "one" period  
%   BUT here in random model, we must take the whole device length as one period
%   in calculation of nl coeff calculation
%
%==================Coefficient part======================%
cd('D:\TuanShu');
Start_QPM_pitch=50;     %micron
Final_QPM_pitch=50;
Number_of_pitch=250;      %
Spatial_resolution=0.1;   %(um) 硂计璶蛤file 3璓
Random_pitch=50;          %虫琌Spatial_resolution
Duty_cycle=0.5;         %0~1, where d=d_plus
Averaging_times=1;   %m-fileい, 计∕﹚琌ネΘarrayぇ计秖

%=============About Random===========================%

Ratio=1;

%============Spectrum part========================
Material='CLT';              % LT or LN
%===============тmodeぇいみ猧, σ納1.瞯镑蔼 2.钡いみ猧ぇmode================%

Eff_Threshold=0;          %normalized by max eff


%===============笆ネΘQPM wavelength array======================%        

if Start_QPM_pitch==Final_QPM_pitch
    QPM_pitch(1:Number_of_pitch)=Start_QPM_pitch;
else
    QPM_pitch=Start_QPM_pitch:((Final_QPM_pitch-Start_QPM_pitch)/(Number_of_pitch-1)):Final_QPM_pitch;
end

		 n=1;                   %痷いч甮瞯
		 C=3E8;                 %硉(m/s)
		 pi=3.1415926;          %蛾㏄瞯

		 sus=8.854E-12;         %痷いざ筿盽计(F/m)   (C^2/N/m^2)
		 perm=pi*4E-7;          %痷い旧合玒计(H/m)   (N/A^2)
         
         T=25;                  %放

if strcmp(Material,'LN')
         
		    fe=(T-24.5)*(T+570.82);                     %Sellimeier equation 把计 for LN
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
%=============================琌LT
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


           	%QPM_pitch=(nc_gpr/lamc_gpr-np_gpr/lamp_gpr-np_gpr/lamp_gpr)^(-1) ;   	
%QPM_pitch=Scanning_pitch*(j-1);
        
		    %write(*,*) np_gpr,nc_gpr,nu_gpr
			

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
plot(array);   %礶琌礶abs, ノ琌ノcomplex