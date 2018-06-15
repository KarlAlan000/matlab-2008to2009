function out=index(lambda,T)
% index(lambda,T) returns the refraction index
% for a given wavelengrh at a given temperature. 
% "lambda"is the wavelength in um, and "T" is the temperatire in C



   if 1==1   % dummy if-structure for material switching

   % material ==  LiTaO3

        A=4.5284;B=7.2449e-3;C=0.2453;D=-2.3670e-2;
        E=7.7690e-2;F=0.1838;
        b=2.6794e-8*(T+273.15).^2;
        c=1.6234e-8*(T+273.15).^2;
        out=(A+(B+b)./(lambda.^2-(C+c).^2)+E./(lambda.^2-F^2)+D*lambda.^2).^0.5;

        
    else

    
    % material ==  LiNbO3
 
        c1=5.35583;c2=0.100473;c3=0.20692;c4=100;c5=11.34927;c6=-0.015334;
        d1=4.629e-7;d2=3.826e-8;d3=-0.89e-8;d4=2.657e-5;
        fe=(T-24.5).*(T+570.82);
        out=sqrt(c1+d1*fe+(c2+d2*fe)./(lambda.^2-(c3+d3*fe).^2)+(c4+d4*fe)./(lambda.^2-c5^2)+c6*lambda.^2);
        

    end
    
  