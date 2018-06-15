clear all;
V0=3*10^3;              %appled field
R=0.5*10^-3;            %radius of electrode
d=0.1*10^-3;              %distance between electrodes (start from the SURFACE of electrodes!!!)
y=[-10:0.001:10]*10^-3;   %position in discussion refer to electrode height
d=d+2*R;                %±N¤§´«¬°CENTER to CENTER
lambda_4piE=V0/2/log((d-R)/R);
E=lambda_4piE*2*((((d/2)^2)+(y.^2)).^-0.5);     %Volt/m
index1=find(E/max(E)>0.5, 1, 'first');
index2=find(E/max(E)>0.5, 1, 'last');
FWHM=y(index2)-y(index1);
plot(y,E);