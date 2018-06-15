function out=SignalLumbdaPumpforT(p,s,period)
% input signal wavelength (um) and poling period (um)
% output the operating temperature (C) with a 532nm pump

T1=0;T2=300;
f1=qpm(p,s,T1)-period;
f2=qpm(p,s,T2)-period;
Tm=(T1+T2)/2;

if (f1*f2)>=0
    if abs(f1)<abs(f2)
        out=T1;
    else
        out=T2;
    end
else
    while f1*f2<0 && abs(qpm(p,s,Tm)-period)>0.00001
        if (qpm(p,s,Tm)-period)*f1>0
            T1=Tm;
        else
            T2=Tm;
        end
        Tm=0.5*(T1+T2);
    end
    out=Tm;
end

