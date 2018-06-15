clear all;
Device_length=1;       %(mm)
Spatial_Res=0.01;      %(mm), the pixel size of the Polarization_field and Screening_array
Time_Res=0.0001;         %(sec), the resolution of External_waveform �������p��spa_res/u/Eexmax (for slow varying velocity)
N=1024;                                                                                               %Cycle number
u=12;                                                                                                %(mm/(kV/mm))
Erd=1;                                                                                              %(kV/mm), assume value
Eth=0.8;                                                                                            %(kV/mm), assume value
Eexmax=2;                                                                                           %(kV/mm), assume value
Eb0=1;                                                                                              %(kV/mm), assume value (equal or less than Erd)
tou=100;                                                                                            %(sec), assume value
T=0.6;                                                                                              %(sec), assume value
Depolarization_field=zeros(round(Device_length/Spatial_Res),1);                                            %Position dependent
Screening_field=zeros(Device_length/Spatial_Res,N);                                                 %Position and time dependent, but for time only record it at each cycle 
External_field(1:round(T/2/Time_Res))=-Eexmax*(tripuls(-T/4:Time_Res:T/4-Time_Res,T/2));                %
External_field((round(T/2/Time_Res)+1):round(T/Time_Res))=+Eexmax*(tripuls(-T/4:Time_Res:T/4-Time_Res,T/2));                %
Domain_wall=length(Depolarization_field)/2;                                          %The index of domain wall initial position 
Depolarization_field(1:Domain_wall)=-Erd;                                            %For preexisting domain wall
Depolarization_field(Domain_wall+1:round(Device_length/Spatial_Res))=Erd;                  %For preexisting domain wall
Screening_field(1:Domain_wall,1)=Eb0;                                               %For preexisting domain wall, different sign of Erd and Eb
Screening_field(Domain_wall+1:Device_length/Spatial_Res,1)=-Eb0;                     %For preexisting domain wall Screening field��initial condition�̫ᤣ�|�s�U��
Eb=Screening_field(:,1);                                                             %time template of screening field
Difference(1:N)=0;
Domain_wall_position(1:N)=0;
for i=1:N                                                                            %Cycle
    for j=1:length(External_field)                                                   %Time in a cycle                           
        Elocal=External_field(j)+Eb;                                                 %De-aging���gpaper�W�o�̨S�g���n�[Erd, �i��O�]���bdomain wall�W�L�bDepolarization
        Eb=Eb-(Elocal+Depolarization_field)*Time_Res/tou;                                                   %Evolution with "time" �Y���~���@�h�h�OEvolution with "cycle" 
if Elocal(round(Domain_wall))<(-Eth)                                                 %Erd help poling, and Eb prevent LT from poling
        v_domain=u*(Elocal(round(Domain_wall))+Eth);                                %����(smaller)��
else if Elocal(round(Domain_wall)+1)>Eth                                                 %���k(larger)��
        v_domain=u*(Elocal(round(Domain_wall)+1)-Eth);                                  %�n���n+1���ڤ��O�ܽT�w
    else
        v_domain=0;
    end
end
        Domain_wall=Domain_wall+v_domain*Time_Res/Spatial_Res;   %Poling, domain wall����v�M�w�t��

        Depolarization_field(1:round(Domain_wall))=-Erd;                               %round�|�ˤ��J
        Depolarization_field((round(Domain_wall)+1):length(Depolarization_field))=+Erd;  %New depolarization distribution
    end
Screening_field(:,i)=Eb;
Domain_wall_position(i)=Domain_wall;                                                 %����poling�Ĳv                                                               
Difference(i)=Screening_field(round(Device_length/Spatial_Res/2),i)-Screening_field(round(Device_length/Spatial_Res/2)+1,i);                         %����backswitching���v
end
plot(Difference);
Position(1:round(Device_length/Spatial_Res),1)=0;
for k=1:round(Device_length/Spatial_Res)
Position(k,1)=k*Spatial_Res;
end
Etotal=Elocal+Depolarization_field;