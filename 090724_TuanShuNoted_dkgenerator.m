% output the SHG wavelength: s2 (um), and the corresponding temperature: T (C)

s2=0.4:0.001:0.532;s2=s2';
T=zeros(size(s2,1),1);

for m=1:size(s2,1)
    T(m)=SignalLumbdaPumpforT(0.532,2*s2(m),period);
end

i2=0.5*1./(1/0.532-1./(2*s2)); % SHG of idler wavelength, Note by TS: use 3rd nonlinear
ppp=size(s2,1);
temp=s2;
s2=zeros(2*ppp-1,1);s2(1:ppp)=temp;
temp2=zeros(2*ppp-1,1);temp2(1:ppp)=T;
for qqq=1:ppp-1
    s2(ppp+qqq)=i2(ppp+1-qqq);
    temp2(ppp+qqq)=T(ppp+1-qqq);
end

T=temp2;

clear temp;clear temp2;clear i2;
