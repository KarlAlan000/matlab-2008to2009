clear all;
V0=3*10^3;              %appled field
R=0.5*10^-3;            %radius of electrode
d=1*10^-3;              %distance between electrodes (start from the SURFACE of electrodes!!!)
le=4*10^-3;             %length of each electrode
y=[-4:0.001:4]*10^-3;   %position in discussion refer to electrode height
d=d+2*R;                %±N¤§´«¬°CENTER to CENTER
lambda_4piE=V0/2/log(((R+le/2)^0.5+le/2)/((R+le/2)^0.5-le/2)*(((d-R)+le/2)^0.5-le/2)/(((d-R)+le/2)^0.5+le/2));
E=lambda_4piE*d*le./((d/2)^2+y.^2+(le/2)^2).^0.5./((d/2)^2+y.^2);     %Volt/m
index1=find(E/max(E)>0.5, 1, 'first');
index2=find(E/max(E)>0.5, 1, 'last');
FWHM=y(index2)-y(index1);
plot(y,E);
X=log(((R+le/2)^0.5+le/2)/((R+le/2)^0.5-le/2)*(((d-R)+le/2)^0.5-le/2)/(((d-R)+le/2)^0.5+le/2));