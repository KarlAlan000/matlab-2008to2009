clear all;
k=1;
Q=100;
xp=10;
xn=-10;
HALFSIZE=20;
X=zeros(HALFSIZE*2+1);
Y=zeros(HALFSIZE*2+1);
%% Matrix on X-Y Plane ( Ez =0?)
for i=1:(HALFSIZE*2+1)
    X(i,:)=-HALFSIZE:HALFSIZE;
    Y(:,i)=-HALFSIZE:HALFSIZE;
end
Rp=((X-xp).^2+Y.^2).^0.5;
Rn=((X-xn).^2+Y.^2).^0.5;
Vp=-k*Q./Rp;
Vn=k*Q./Rn;
Vtotal=Vp+Vn;
