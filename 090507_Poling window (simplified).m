clear all;
Z=[0:0.001:10]'*10^-3;
T=20+(1650-20)*exp(-Z/(1.76*10^-3));            %degree C
T=T+273;                                 %degree K
A=2.6224*10^3;
B=-0.543;
Ec=10.^(A./T+B)*100;                      %V/m
index=find(T>(600+273),1,'last');
Zcurie=Z(index);
Ec(1:index)=0;

V0=5*10^3;              %appled field
R=0.5*10^-3;            %radius of electrode
d=0.5*10^-3;              %distance between electrodes (start from the SURFACE of electrodes!!!)
h=2.5*10^-3;              %electrode height
Ze=Z-h;                 %position in discussion refer to electrode height
d=d+2*R;                %±N¤§´«¬°CENTER to CENTER
lambda_4piE=V0/2/log((d-R)/R);
E=lambda_4piE*2*((((d/2)^2)+(Ze.^2)).^-0.5);     %Volt/m
index1=find(E/max(E)>0.5, 1, 'first');
index2=find(E/max(E)>0.5, 1, 'last');
FWHM=Ze(index2)-Ze(index1);
Z=1000*Z;           %mm
T=T-273;            %degree C
E=E/10^6;           %kV/mm
Ec=Ec/10^6;           %kV/mm
plot(Z,E,Z,Ec);