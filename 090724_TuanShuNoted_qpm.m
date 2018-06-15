function out = qpm(p,s,T)
% qpm(p,s,T) returns the design period. unit:um
% "p" is the wavelength of the pump. unit:um
% "s" is the wavelength of the signal. unit:um
% "T" is the temperature. unit:C

i=1./(1./p-1./s);
out = 1./(index(p,T)./p-index(s,T)./s-index(i,T)./i);
