clear all;
cd('D:\TuanShu');
filename='090820.txt';

%% Reducing Averaging
Reducing_window_index=1000;                  %Reducing averaging    
array=dlmread(filename);
array_reduced=zeros(length(array(:,1))/Reducing_window_index,3);
for j=1:length(array(:,1))-Reducing_window_index                                            %this averaging may cause a shifting in time
    array(j,:)=mean(array(j:j+Reducing_window_index,:));
end
for j=1:fix(length(array(:,1))/Reducing_window_index)                                       %this averaging may cause a shifting in time
    array_reduced(j,:)=mean(array((1+(j-1)*Reducing_window_index):(j*Reducing_window_index),:));
end
time=array_reduced(:,1);
voltage=array_reduced(:,2);
current=array_reduced(:,3);

%% Loop Dividing
if_zero=zeros(length(voltage),1);
for j=1:(length(voltage)-1)
    if (voltage(j)>0&&voltage(j+1)<0)||(voltage(j)<0&&voltage(j+1)>0)||voltage(j)==0
        if_zero(j)=1;
    end
end
index_zero=find(if_zero==1);    
index_half_period=index_zero(2)-index_zero(1);
if index_zero(1)>0.5*index_half_period                 %表start至first zero間有0.25個週期以上
    %first loop: "start" to "second zero"
    index_loop=[1 index_zero(2:2:length(index_zero))];
else
    %first loop: "first zero" to "third zero"
    index_loop=index_zero(1:2:length(index_zero));
end

%% Order
logV=log10(abs(voltage));
logI=log10(abs(current));
D=diff(logI)./diff(logV);                                   %Order of I-V relation


%% Charge (不管loop直接積全部, 反正只會影響reference level)
charge=zeros(length(current),1);
for j=2:length(current)
charge(j)=charge(j-1)+current(j)*(time(j)-time(j-1));          %current(nA) original time spacing=msecond -> charge單位為pC
end

%% Removing Linear (1-st Order) Part of Current
Conductivity=500;
current_R=current-voltage*Conductivity;
charge_R=zeros(length(current_R),1);
for j=2:length(current_R)
charge_R(j)=charge_R(j-1)+current(j)*(time(j)-time(j-1));      %current(nA) original time spacing=msecond -> charge單位為pC
end
plot(voltage,charge_R);
