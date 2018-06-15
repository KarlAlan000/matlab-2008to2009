clear all;
cd('D:\TuanShu');
Device_length=1;       %(mm)
Spatial_Res=0.01;      %(mm), the pixel size of the Polarization_field and Screening_array
Time_Res=0.001;         %(sec), the resolution of External_waveform �������p��spa_res/u/(Elocal-Eth)
N=1024;                                                                                               %Cycle number
u=12;                                                                                                %(mm/(kV/mm))
Erd=1;                                                                                              %(kV/mm), assume value
Eth=0.6;                                                                                            %(kV/mm), assume value
Eb0=1;                                                                                              %(kV/mm), assume value (equal or less than Erd)
tou=100;                                                                                            %(sec), assume value
T=4;                                                                                               %(sec), assume value
Screening_field=dlmread('screeningfield.txt');                                                 %Position and time dependent, but for time only record it at each cycle 
Domain_wall=dlmread('domainwall.txt');                                             %The index of domain wall initial position 
for i=1:N
Elocal=Screening_field(:,i);                                                 %De-aging���gpaper�W�o�̨S�g���n�[Erd, �i��O�]���bdomain wall�W�L�bDepolarization
    for j=1:round(T/Time_Res)                                                   %Time in a cycle                           
        Etotal=Elocal;
        Etotal(1:round(Domain_wall(i)))=Etotal(1:round(Domain_wall(i)))-Erd;
        Etotal((round(Domain_wall(i))+1):length(Etotal))=Etotal((round(Domain_wall(i))+1):length(Etotal))+Erd;    %Etotal=Elocal+depolarization field
if Elocal(round(Domain_wall(i)))<(-Eth)                                                 %Erd help poling, and Eb prevent LT from poling
        v_domain=u*(Elocal(round(Domain_wall(i)))+Eth);                                %����(smaller)��
else if Elocal(round(Domain_wall(i))+1)>Eth                                                 %���k(larger)��
        v_domain=u*(Elocal(round(Domain_wall(i))+1)-Eth);                                  %�n���n+1���ڤ��O�ܽT�w
    else
        v_domain=0;
    end
end
        Elocal=Elocal-Etotal*Time_Res/tou;                                                   %Evolution with "time" �Y���~���@�h�h�OEvolution with "cycle" 
        Domain_wall(i)=Domain_wall(i)+v_domain*Time_Res/Spatial_Res;   %Poling, domain wall����v�M�w�t��
    end
end
dlmwrite('domainwall_bs.txt',Domain_wall,'delimiter','\t','newline','pc');
dlmwrite('screeningfield_bs.txt',Elocal,'delimiter','\t','newline','pc');