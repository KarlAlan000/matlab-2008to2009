clear all;
cd('D:\TuanShu');
filename='090804_alignment 5 (0.9W)_m2.txt';
Start_time=0;               %(second)
End_time=215;               %(second)
Rounding_window_time=1;     %(second)
Start_voltage=0.02;         %(kV)
array=dlmread(filename);
time=array(:,1);
Rounding_window_index=find(time-time(1)-Rounding_window_time>0,1,'first')-1;
for j=1:length(time)-Rounding_window_index                                       %this averaging may cause a shifting in time
    array(j,:)=mean(array(j:j+Rounding_window_index,:));
end
pStart_index=find(time-Start_time>0,1,'first');
pEnd_index=find(time-End_time<0,1,'last');
time=array(pStart_index:pEnd_index,1);
voltage=array(pStart_index:pEnd_index,2);
current=array(pStart_index:pEnd_index,3);
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
