%%% Defining Variables
clc
clear
close all

d2r = pi/180;
in2ft = 1/12;

Aircraft = struct();

% Aircraft.Weight.empty_Weight = 180925;
% Aircraft.Weight.fuel_Weight = 138095;

Aircraft = Performance(Aircraft);

Aircraft.Performance.WbyS = 102; 
Aircraft.Performance.TbyW = 0.24;

Aircraft.Weight.MTOW = 400000;

counter = 0;
error = 1;

while error > 0.005

    error = Aircraft.Weight.MTOW;
    
    Aircraft = Sizing(Aircraft);
    Aircraft = Aero(Aircraft);

    Aircraft = Payload_Weight(Aircraft);
    Aircraft = Empty_Weight(Aircraft);
    Aircraft = Fuel_Weight(Aircraft);
    Aircraft.Weight.MTOW = Aircraft.Weight.payload + Aircraft.Weight.fuel_Weight...
                           + Aircraft.Weight.empty_Weight;

    error = abs(error - Aircraft.Weight.MTOW);

    counter = counter + 1;

end