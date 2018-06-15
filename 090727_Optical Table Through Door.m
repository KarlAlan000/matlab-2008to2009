clear all;
L=244;
W=122;
theta=0:90;
Height=L*sin(theta*pi/180)+W*cos(theta*pi/180)-200;
Width=L*cos(theta*pi/180)+W*sin(theta*pi/180);
plot(theta,Height,theta,Width);