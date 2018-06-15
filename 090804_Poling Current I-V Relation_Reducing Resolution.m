clear all;
cd('D:\TuanShu');
filename='090820.txt';
Start_time=990;               %(second)
End_time=1203;               %(second)
Start_voltage=-0.01;         %(kV)
Reducing_window_index=1000;
array=dlmread(filename);
array_reduced=zeros(length(array(:,1))/Reducing_window_index,3);
for j=1:length(array(:,1))-Reducing_window_index                                       %this averaging may cause a shifting in time
    array(j,:)=mean(array(j:j+Reducing_window_index,:));
end
for j=1:fix(length(array(:,1))/Reducing_window_index)                                       %this averaging may cause a shifting in time
    array_reduced(j,:)=mean(array((1+(j-1)*Reducing_window_index):(j*Reducing_window_index),:));
end
time=array_reduced(:,1);
pStart_index=find(time-Start_time>0,1,'first');
pEnd_index=find(time-End_time<0,1,'last');
time=array_reduced(pStart_index:pEnd_index,1);
voltage=array_reduced(pStart_index:pEnd_index,2);
current=array_reduced(pStart_index:pEnd_index,3);
if voltage(1)<Start_voltage
    Start_index=find(voltage>Start_voltage,1,'first');
    End_index=find(voltage<Start_voltage,1,'last');
else if voltage(1)>Start_voltage
    Start_index=find(voltage<Start_voltage,1,'first');
    End_index=find(voltage>Start_voltage,1,'last');
    else
        Start_index=0;
        End_index=length(voltage);
    end
end
time=time(Start_index:End_index);
voltage=voltage(Start_index:End_index);
current=current(Start_index:End_index);
logV=log10(abs(voltage));
logI=log10(abs(current));
D=diff(logI)./diff(logV);
plot(voltage(1:length(voltage)-1),D);
