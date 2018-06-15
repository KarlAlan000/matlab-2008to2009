clear all;
Z=[0:0.001:4]*10^-3;
T=20+(1650-20)*exp(-Z/(0.577*10^-3));            %degree C
T=T+273;                                 %degree K
A=2.6224*10^3;
B=-0.543;
E=10.^(A./T+B)*100;                      %V/m
index=find(T>(600+273),1,'last');
Zcurie=Z(index);
E(1:index)=0;
plot(Z,E);