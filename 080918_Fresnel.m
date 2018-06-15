clear all;

% Refractive index for pure ZnSe
Rn=0.7;
polarization=[0:pi/2/100:pi/2];
theta=pi/4;
n=2.4028;
%n=(1+Rn^0.5)/(1-Rn^0.5);
nair=1;
polarization_degree=polarization*180/pi;

% S-polarization = TE

Rs=((nair*cos(theta)-n*(1-(nair/n*sin(theta)).^2).^0.5)./(nair*cos(theta)+n*(1-(nair/n*sin(theta)).^2).^0.5)).^2;
Ts=1-Rs;

% P-polarization = TM

Rp=((nair*(1-(nair/n*sin(theta)).^2).^0.5-n*cos(theta))./(nair*(1-(nair/n*sin(theta)).^2).^0.5+n*cos(theta))).^2;
Tp=1-Rp;

R=cos(polarization).^2*Rs+sin(polarization).^2*Rp;
T=1-R;

plot(polarization_degree,R);
