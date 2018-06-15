SHG_power=dlmread('SHG_power.txt');
index_considered=dlmread('index_considered.txt');
[sorted_SHG_power sorted_index]=sort(SHG_power(3,:),'descend');
index_high_eff=sorted_index(1:10);
mode_high_eff=index_considered(index_high_eff);


