clear all;

P1=0.05;                %(W)
Wavelength=1.55;        %(micron)
Beam_diameter=0.00014;      %(m)
Repetation_rate=4000;   %(Hz)
Pulse_width=27E-9;      %(second)
Device_length=0.005;    %(m)

pi=3.1415;
e_perm=8.8541878176E-12;
m_perm=1.2566E-6;
n=2.15;
C=3E8;
deff=2/pi*8.5E-12;           %(m/V)

Omega1=2*pi*C/(Wavelength*1E-6);
Area=pi*(0.5*Beam_diameter)^2;
I1=P1/Area/(Repetation_rate*Pulse_width);
I2=2*Omega1^2*e_perm^2*deff^2*Device_length^2/n^3*(m_perm/e_perm)^(3/2)*I1^2;
P2=I2*Area*(Repetation_rate*Pulse_width);

