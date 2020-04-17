%Payload Range Diagram
%forces are in lbs

clear
clc
close all

Wtomax=454971;
w1byWtomax=0.99;
w2byw1=0.99;
w3byw2=0.995;
w4byw3=0.980;
w5byw4 = 0.786;
w6byw5 = 0.983;
w7byw6 = 0.990;
w8byw7 = 0.98;
w9byw8 = 0.987;
w10byw9 = 0.99;
w11byw10 = 0.988;
w12byw11 = 0.992;

V=237,g=9.81,Cj=0.000139;
LbyD=13.67;

Wplmax=94300;Wfmax=4170.84;Wtfo=0.06*Wfmax;Wcrew=1840;We=197830;
Woe=We+Wtfo+Wcrew;

%point A
plot(0,Wplmax,'rx','MarkerSize',10);
hold on;

w4byw5=1/(w5byw4);
R=(V/(g*Cj))*(LbyD)*log(w4byw5);

%point B
Wf=Wtomax-Woe-Wplmax;
Mff=1-(Wf/Wtomax);
w5byw4 = Mff/((w1byWtomax)*(w2byw1)*(w3byw2)*(w4byw3)*(w6byw5)*(w7byw6)*(w8byw7)*(w9byw8)*(w10byw9)*(w11byw10)*(w12byw11));

plot(R,Wplmax,'rx','MarkerSize',10);

%point C
Wpl=Wtomax-Woe-Wfmax;
Mff=1-(Wfmax/Wtomax);
w5byw4 = Mff/((w1byWtomax)*(w2byw1)*(w3byw2)*(w4byw3)*(w6byw5)*(w7byw6)*(w8byw7)*(w9byw8)*(w10byw9)*(w11byw10)*(w12byw11));

plot(R,Wpl,'rx','MarkerSize',10);

%point D
Wto=Woe+Wfmax;
Mff=1-(Wfmax/Wto);
w5byw4 = Mff/((w1byWtomax)*(w2byw1)*(w3byw2)*(w4byw3)*(w6byw5)*(w7byw6)*(w8byw7)*(w9byw8)*(w10byw9)*(w11byw10)*(w12byw11));

plot(R,Wpl,'rx','MarkerSize',10);

grid on;
xlabel('Range (m)');
ylabel('Payload (lbs)');
title('Payload-Range Diagram');


