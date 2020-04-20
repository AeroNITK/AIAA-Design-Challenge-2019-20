%Payload Range Diagram
%forces are in lbs

clear
clc
close all

load('Aircraft.mat');

Max_avail_Fuel = Aircraft.Wing.fuel_volume*7.48052; % Converting from cubic ft to US gallons
Max_avail_Fuel = Max_avail_Fuel*6.71;   % Converting from US gallons to lbs

Opt_Weight = Aircraft.Weight.empty_Weight + Aircraft.Weight.crew + ...
            0.01*Aircraft.Weight.fuel_Weight;   % Operating Weight

MTOW = Aircraft.Weight.MTOW;    % Maximum Take-Off Weight

% Point A
plot(0,Aircraft.Weight.payload,'rx','MarkerSize',10);
hold on

% Line between A and B
x = 0:1:Aircraft.Performance.range1;
y = Aircraft.Weight.payload*ones(1,Aircraft.Performance.range1+1);

plot(x,y);

% Point B
plot(Aircraft.Performance.range1,Aircraft.Weight.payload,'rx','MarkerSize',10);

% Point C
payload_weight = MTOW - Opt_Weight - Max_avail_Fuel;

fuel_fraction = Max_avail_Fuel/MTOW;
weight_fraction = 1 - fuel_fraction;

Cj_cruise = 0.000125;   % Specific Fuel Consumption (in lbs/lbs/s)
Cj_loiter = 0.0001;   % Specific Fuel Consumption (in lbs/lbs/s)

W1byW_TO = 0.99;    % Mission Segement Weight Fraction for Engine Start & Warm Up     
W2byW1 = 0.99;      % Mission Segement Weight Fraction for Taxi to Runway
W3byW2 = 0.995;     % Mission Segement Weight Fraction for Take Off
W4byW3 = 0.985;      % Mission Segement Weight Fraction for Climb to cruise altitude (Raymer)

loiter1 = 3600;  % 10% of the cruising time

W6byW5 = exp(-(loiter1*Cj_loiter)/(Aircraft.Aero.LbyD_max_loiter));

W7byW6 = 0.99;  % Mission Segement Weight Fraction for Descent 
W8byW7 = 0.98;  % Mission Segement Weight Fraction for Climb

% Mission Segement Weight Fraction for Cruise segment 2
range = Aircraft.Performance.range2*1.852*1000;  % nm to meters
[~,~,~,a] = ISA(Aircraft.Performance.altitude_cruise2*0.3048);
V = Aircraft.Performance.M_cruise*a;    % Cruising Speed in m/s

W9byW8 = exp(-(range*Cj_cruise)/(V*Aircraft.Aero.LbyD_max_cruise));

W10byW9 = 0.99; % Mission Segement Weight Fraction for Descent

% Mission Segement Weight Fraction for Loiter segment 2

W11byW10 = exp(-(Aircraft.Performance.loiter2*Cj_loiter)/(Aircraft.Aero.LbyD_max_loiter));    

W12byW11 = 0.995;   % Mission Segement Weight Fraction for  Landing (Raymer)

W5byW4 = fuel_fraction/(W1byW_TO*W2byW1*W3byW2*W4byW3*W6byW5  ...
               *W7byW6*W8byW7*W9byW8*W10byW9*W11byW10*W12byW11);

[~,~,~,a] = ISA(Aircraft.Performance.altitude_cruise1*0.3048);
V = Aircraft.Performance.M_cruise*a;    % Cruising Speed in m/s
           
range = (V/Cj_cruise)*(Aircraft.Aero.LbyD_max_cruise)*log(W5byW4^-1);

plot(payload_weight,range/1852,'rx','MarkerSize',10);

% Wtomax=454971;
% w1byWtomax=0.99;
% w2byw1=0.99;
% w3byw2=0.995;
% w4byw3=0.980;
% w5byw4 = 0.786;
% w6byw5 = 0.983;
% w7byw6 = 0.990;
% w8byw7 = 0.98;
% w9byw8 = 0.987;
% w10byw9 = 0.99;
% w11byw10 = 0.988;
% w12byw11 = 0.992;
% 
% V=237,g=9.81,Cj=0.000139;
% LbyD=13.67;
% 
% Wplmax=94300;Wfmax=4170.84;Wtfo=0.06*Wfmax;Wcrew=1840;We=197830;
% Woe=We+Wtfo+Wcrew;
% 

% 
% w4byw5=1/(w5byw4);
% R=(V/(g*Cj))*(LbyD)*log(w4byw5);
% 
% %point B
% Wf=Wtomax-Woe-Wplmax;
% Mff=1-(Wf/Wtomax);
% w5byw4 = Mff/((w1byWtomax)*(w2byw1)*(w3byw2)*(w4byw3)*(w6byw5)*(w7byw6)*(w8byw7)*(w9byw8)*(w10byw9)*(w11byw10)*(w12byw11));
% 
% plot(R,Wplmax,'rx','MarkerSize',10);
% 
% %point C
% Wpl=Wtomax-Woe-Wfmax;
% Mff=1-(Wfmax/Wtomax);
% w5byw4 = Mff/((w1byWtomax)*(w2byw1)*(w3byw2)*(w4byw3)*(w6byw5)*(w7byw6)*(w8byw7)*(w9byw8)*(w10byw9)*(w11byw10)*(w12byw11));
% 
% plot(R,Wpl,'rx','MarkerSize',10);
% 
% %point D
% Wto=Woe+Wfmax;
% Mff=1-(Wfmax/Wto);
% w5byw4 = Mff/((w1byWtomax)*(w2byw1)*(w3byw2)*(w4byw3)*(w6byw5)*(w7byw6)*(w8byw7)*(w9byw8)*(w10byw9)*(w11byw10)*(w12byw11));
% 
% plot(R,Wpl,'rx','MarkerSize',10);
% 
% grid on;
% xlabel('Range (m)');
% ylabel('Payload (lbs)');
% title('Payload-Range Diagram');


