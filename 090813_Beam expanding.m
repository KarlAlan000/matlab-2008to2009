clear all;
totaldistance=1000; %(mm) 指CO2 laser waist (不是出口)與chamber的距離 515+445+1885-1150
d=[650:0.1:800];
zi=[0:100:2000];           %(此為L1與laser beam waist的相對位置, ex: 若waist在L1~L2間, 則此數值為負)
lambda=10.6;    %(micron)
wi=0.85;         %(mm)
bi=pi*wi^2/(lambda/1000);

R1=-51.83;       %(mm)
t1=1.6;         %(mm)
R2=-310.98;      %(mm)
t2=1;           %(mm)
n=1.5;          %(ZnSe 2.674)

ML1=[1+(n-1)/n/R1*t1 t1/n;(n-1)/R1 1];
AL1=ML1(1,1);
BL1=ML1(1,2);
CL1=ML1(2,1);
DL1=ML1(2,2);

ML2=[1+(n-1)/n/R2*t2 t2/n;(n-1)/R2 1];
AL2=ML2(1,1);
BL2=ML2(1,2);
CL2=ML2(2,1);
DL2=ML2(2,2);

qi=zeros(length(zi),1);
qL1=zeros(length(zi),1);
zL1=zeros(length(zi),1);
bL1=zeros(length(zi),1);
wL1=zeros(length(zi),1);

qd=zeros(length(d),length(zi));
zd=zeros(length(d),length(zi));
bd=zeros(length(d),length(zi));
wd=zeros(length(d),length(zi));

for q=1:length(zi)

qi(q)=zi(q)+j*bi;

qL1(q)=(AL1*qi(q)+BL1)/(CL1*qi(q)+DL1);
zL1(q)=real(qL1(q));
bL1(q)=imag(qL1(q));
wL1(q)=(bL1(q)*(lambda/1000)/pi)^0.5;

for p=1:length(d)
    Md=[1 d(p);0 1];
    Ad=Md(1,1);
    Bd=Md(1,2);
    Cd=Md(2,1);
    Dd=Md(2,2);
    qd(p,q)=(Ad*qL1(q)+Bd)/(Cd*qL1(q)+Dd);
    zd(p,q)=real(qd(p));
    bd(p,q)=imag(qd(p));
    wd(p,q)=(bd(p)*(lambda/1000)/pi)^0.5;
end
end
qL2=(AL2*qd+BL2)./(CL2*qd+DL2);
zL2=real(qL2);
bL2=imag(qL2);
wL2=(bL2*(lambda/1000)/pi).^0.5;
diffL2=abs((lambda/1000)^2.*zL2./(pi^2.*(wL2.^3).*(1+((lambda/1000).*zL2/pi./(wL2.^2)).^2).^0.5));
spotsizeL2=2*wL2.*(1+((lambda/1000)*zL2/pi./wL2.^2).^2).^0.5;
[Mzi,Md] = meshgrid(zi,d);
dC=totaldistance-Mzi-Md;
zC=zL2+dC;
diffC=abs((lambda/1000)^2.*zC./(pi^2.*(wL2.^3).*(1+((lambda/1000).*zC/pi./(wL2.^2)).^2).^0.5));
spotsizeC=2*wL2.*(1+((lambda/1000)*zC/pi./wL2.^2).^2).^0.5;
spotsizediff=abs(spotsizeC-spotsizeL2);
[graph, handle]=contourf(Mzi,Md,spotsizeC,[0:10:300]);
set(handle,'ShowText','on','TextStep',get(handle,'LevelStep'));