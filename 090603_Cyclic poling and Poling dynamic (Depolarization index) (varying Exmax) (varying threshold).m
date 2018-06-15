clear all;
cd('D:\TuanShu');
%% Simulation-Related Parameters
Device_length=1;                                                                                                                    %(mm)
Spatial_Res=0.001;                                                                                                                  %(mm), the pixel size of the Polarization_field and Screening_array
Time_Res=0.00001;                                                                                                                   %(sec), the resolution of External_waveform 必須約小於spa_res/u/Eexmax (for slow varying velocity)

%% Material-Related Parameters
u=12;                                                                                                                               %(mm/sec/(kV/mm)) Constant Related to Doamin Wall Moving Velocity
Erd=1;                                                                                                                              %(kV/mm) 
Eth=0.6;                                                                                                                            %(kV/mm) 
Eexmax=1.8;                                                                                                                         %(kV/mm) 
Eb0=1;                                                                                                                              %(kV/mm) (equal or less than Erd)
tou=100;                                                                                                                            %(sec)
T=0.6;                                                                                                                              %(sec)
Domain_wall=round(Device_length/Spatial_Res)/2;                                                                                     %(pixel) Initial Domain Wall Position
Eb(1:Domain_wall)=Eb0;                                                                                                              %
Eb(Domain_wall+1:Device_length/Spatial_Res)=-Eb0;                                                                                   %Initial Screening Field Distribution

%% External-Field-Related Parameters
N=1024;                                                                                                                             %Cycle number
External_field(1:round(T/2/Time_Res))=-Eexmax*(tripuls(-T/4:Time_Res:T/4-Time_Res,T/2));                                            %
External_field((round(T/2/Time_Res)+1):round(T/Time_Res))=+Eexmax*(tripuls(-T/4:Time_Res:T/4-Time_Res,T/2));                        %

%% Array for Data Storage
Domain_wall_position(1:N,1)=0;                                                                                                      %Storage of Domain Wall Position
Screening_field(Device_length/Spatial_Res,N)=0;                                                                                     %
Screening_field(:,1)=Eb;                                                                                                            %Storage of Screening Field Distribution
Difference(1:N)=0;
%% Simulation
for i=1:N                                                                                                                           %Cycle
    for j=1:length(External_field)                                                                                                  %Time in a cycle                
                                                                                                                                    %To generate the Time-Dependent External field
        Elocal=External_field(j)*(1-(i-1)/N)+Eb;                                                                                    %De-aging那篇paper上這裡沒寫說要加Erd, 可能是因為在domain wall上無淨Depolarization
        %                        ^^^^^^^^^^^ it is the envelope of voltage                      
        Etotal=Elocal;
        Etotal(1:round(Domain_wall))=Etotal(1:round(Domain_wall))-Erd;
        Etotal((round(Domain_wall)+1):length(Etotal))=Etotal((round(Domain_wall)+1):length(Etotal))+Erd;                            %Etotal=Elocal+depolarization field
        Eb=Eb-Etotal*Time_Res/tou;                                                                                                  %Evolution with "time" 若往外移一層則是Evolution with "cycle" 
if Elocal(round(Domain_wall))<(-Eth)                                                                                                %Erd help poling, and Eb prevent LT from poling
        v_domain=u*(Elocal(round(Domain_wall))+Eth);                                                                                %往左(smaller)移
else if Elocal(round(Domain_wall)+1)>Eth                                                                                            %往右(larger)移
        v_domain=u*(Elocal(round(Domain_wall)+1)-Eth);                                                                              %要不要+1其實我不是很確定
    else
        v_domain=0;
    end
end
        Domain_wall=Domain_wall+v_domain*Time_Res/Spatial_Res;                                                                      %Poling, domain wall附近之v決定速度
    end
Screening_field(:,i)=Eb;
Domain_wall_position(i)=Domain_wall;                                                                                                %對應poling效率                                                               
Difference(i)=Screening_field(round(Device_length/Spatial_Res/2),i)-Screening_field(round(Device_length/Spatial_Res/2)+1,i);        %對應backswitching機率
end

%% Data Manipulation
plot(Difference);
Position(1:round(Device_length/Spatial_Res),1)=0;
for k=1:round(Device_length/Spatial_Res)
Position(k,1)=k*Spatial_Res;
end
%Re-build the total field
%Total_E=zeros(round(Device_length/Spatial_Res),N);
%for k=1:N
%    Total_E(1:round(Domain_wall_position(k)),k)=Screening_field(1:round(Domain_wall_position(k)),k)-Erd;
%    Total_E((round(Domain_wall_position(k))+1):round(Device_length/Spatial_Res),k)=Screening_field((round(Domain_wall_position(k))+1):round(Device_length/Spatial_Res),k)-Erd;
%end
dlmwrite('domainwall.txt',Domain_wall_position,'delimiter','\t','newline','pc');
dlmwrite('screeningfield.txt',Screening_field,'delimiter','\t','newline','pc');