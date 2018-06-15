clear
tic

Length=30000; % (um) the length of the crystal
period=7.8; % (um) QPM period
period_6=0.1; % (um) the standard deviation of the period
poling=0.5*period; % (um) poling width
poling_6=0.1; % (um) poling width deviation
dz=0.1; % (um) pattern precision
No_sample=20; % # of random patterns








dkgenerator;
sf=1./(1/0.532+1./(2*s2));
dks2=2*pi./s2.*index(s2,T)-2*pi./s2.*index(s2*2,T);
dksf=2*pi./sf.*index(sf,T)-2*pi./(2*s2).*index(s2*2,T)-2*pi/0.532*index(0.532,T);
toc




% Random Crystal Generation

No_period=round(Length/period);
N=No_period*round(period/dz);
a=zeros(N,No_sample);
b=zeros(N,1);

periodseed=randn(N,No_sample)*period_6;
polingseed=randn(N,No_sample)*poling_6;

m=zeros(N,No_sample);
for x=1:No_sample
    m(:,x)=(1:N)';
end

u=round((period*m+periodseed)/dz);
v=round((period*m+periodseed)/dz)+round((poling+polingseed)/dz);
uideal=round(period/dz)*m(:,1);
videal=round(period/dz)*m(:,1)+round(poling/dz);

for y=1:No_sample
    for x=1:No_period-1
        if u(x,y)<=0
            u(x,y)=1;
        end
        if v(x,y)<=0
            v(x,y)=1;
        end
        a(u(x,y)+1:v(x,y),y)=1;
        b(uideal(x)+1:videal(x))=1;
    end
end

x=round((poling+polingseed(N,:))/dz);
xideal=round(poling/dz);
for y=1:No_sample
    a(1:x(y),y)=1;
    b(1:xideal)=1;
end
a=2*(a-0.5);b=2*(b-0.5);
a=a(1:N,1:No_sample)*dz;b=b(1:N)*dz;


clear u;clear v;clear periodseed;clear polingseed;clear m;clear f;
clear uideal;clear videal;clear xideal;clear x;clear y;
toc







m=1:N;m=m'*dz;
s2phasor=zeros(N,1);
sfphasor=zeros(N,1);
randSHG=zeros(size(dks2,1),1);
idealSHG=zeros(size(dks2,1),1);
randSFG=zeros(size(dksf,1),1);
idealSFG=zeros(size(dksf,1),1);

for ppp=1:size(dks2,1)
    s2phasor=exp(i*m*dks2(ppp)).';
    randomSHG(ppp)=sum(abs(s2phasor*a).^2)/No_sample;   %Note bt TS: effective length square, the same meaning as effective nonlinear coefficient 
    idealSHG(ppp)=abs(s2phasor*b)^2;
    
    sfphasor=exp(i*m*dksf(ppp)).';
    randomSFG(ppp)=sum(abs(sfphasor*a).^2)/No_sample;
    idealSFG(ppp)=abs(sfphasor*b)^2;
end
toc

% exclude out-of-range temperature
for ppp=1:size(dks2,1)
    if T(ppp)==300 | T(ppp)==0
        randomSHG(ppp)=NaN;idealSHG(ppp)=NaN;randomSFG(ppp)=NaN;idealSFG(ppp)=NaN;
    end
end

sigma=sqrt(period_6^2+poling_6^2/4);
theorySHG=8*Length/period./dks2.^2.*((1-exp(-(sigma*dks2).^2))-cos(poling*dks2).*(exp(-0.5*(poling_6*dks2).^2)-exp(-(sigma*dks2).^2)));
theorySFG=8*Length/period./dksf.^2.*((1-exp(-(sigma*dksf).^2))-cos(poling*dksf).*(exp(-0.5*(poling_6*dksf).^2)-exp(-(sigma*dksf).^2)));

figure
plot(2*s2,T)

figure(1)
plot(s2,randomSHG,'b',s2,idealSHG,'r',s2,theorySHG,'k')

figure(2)
plot(sf,randomSFG,'b',sf,idealSFG,'r',sf,theorySFG,'k')
