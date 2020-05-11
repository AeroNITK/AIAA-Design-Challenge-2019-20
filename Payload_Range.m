%Payload Range Diagram
%forces are in lbs

clear
clc
close all

load('Aircraft.mat');

Max_avail_Fuel = 3850*7.48052; % Converting from cubic ft to US gallons
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

W5byW4 = weight_fraction/(W1byW_TO*W2byW1*W3byW2*W4byW3*W6byW5  ...
               *W7byW6*W8byW7*W9byW8*W10byW9*W11byW10*W12byW11);

[~,~,~,a] = ISA(Aircraft.Performance.altitude_cruise1*0.3048);
V = Aircraft.Performance.M_cruise*a;    % Cruising Speed in m/s
           
range = (V/Cj_cruise)*(Aircraft.Aero.LbyD_max_cruise)*log(W5byW4^-1);

range = range/1852;

plot(range,payload_weight,'rx','MarkerSize',10);    % Point C

% Line between B and C
x = [Aircraft.Performance.range1,range];
y = [Aircraft.Weight.payload,payload_weight];

plot(x,y);

% Point D

MTOW = Opt_Weight + Max_avail_Fuel;

fuel_fraction = Max_avail_Fuel/MTOW;
weight_fraction = 1 - fuel_fraction;

W5byW4 = weight_fraction/(W1byW_TO*W2byW1*W3byW2*W4byW3*W6byW5  ...
               *W7byW6*W8byW7*W9byW8*W10byW9*W11byW10*W12byW11);
           
range1 = (V/Cj_cruise)*(Aircraft.Aero.LbyD_max_cruise)*log(W5byW4^-1);

range1 = range1/1852;

plot(range1,0,'rx','MarkerSize',10);    % Point D    

% Line between C and D
x = [range,range1];
y = [payload_weight,0];

plot(x,y);
text(0,Aircraft.Weight.payload+3000,'A');
text(Aircraft.Performance.range1,Aircraft.Weight.payload+3000,'B');
text(range,payload_weight+3000,'C');
text(range1,3000,'D');

title('Payload Range Diagram');
xlabel('Range(nm)');
ylabel('Payload (lbs)');

hold off