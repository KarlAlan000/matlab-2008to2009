clear all;

cd('K:\');
filename=sprintf('090316_R=320000 (revised VI).txt');
w=50;
array=dlmread(filename);
M=[array(:,1) array(:,2)];      % x-position vs. B intensity
for j=1:round(length(M)/w)
M2(j,:)=M((j-1)*w+1,:);
end
M2(:,2)=-M2(:,2);
S=diff(M2(:,2))./diff(M2(:,1))*60;
S(length(M2))=0;
M3=[M2 S];