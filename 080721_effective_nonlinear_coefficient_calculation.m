clear all;
%===============NOTE (1)========================%
%
%   In ordinary efficient nl coeff calculation, we care only the profile of "one" period  
%   BUT here in random model, we must take the whole device length as one period
%   in calculation of nl coeff calculation
%
%===============================================%

D_BPM=8.5;              %(pm/V)
QPM_pitch=20;           %(micron)
Number_of_pitch=100;      %
M=1;                    %Order we care
Duty_cycle=0.5;         %0~1, where d=d_plus
N=1000;                 %discrete each QPM_pitch into N dz


%=============About Random===========================%

Ratio=0.55;
random_pitch=100;       %單位dz, 注意其數量級必須大於dz很多

%======================陣列宣告====================================%

array(1:N*Number_of_pitch)=0;
c(1:N)=0;
%=================================================================%

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

c_all=abs(fft(array)/(N*Number_of_pitch));         %complex form c contribute only a extra phase 
                                                   %/N*Number_of_pitch的理由請參考080724
                                                   %c_all(1)其實是c_all(m=0)

%===============NOTE (2)========================%
%
%   Because of note (1), here c_all(m) is in fact for m*2pi/device_length
%   (instead of m*2pi/QPM_pitch). and c(m)=c_all(m*Number_of_pitch)
%      
%
%===============================================%

for j=1:(N-1)   %我們只能得到c(m=0)~c(m=(N-1)/2)  check一下 老師很愛問這個
    c(j)=c_all(1+j*Number_of_pitch);         
end
plot(c);