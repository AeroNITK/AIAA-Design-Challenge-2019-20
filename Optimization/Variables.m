%%% Defining Variables
clc
clear
close all

d2r = pi/180;
in2ft = 1/12;

Aircraft = struct();

Aircraft.Weight.empty_Weight = 180925;
Aircraft.Weight.fuel_Weight = 138095;
Aircraft.Weight.MTOW = 413320;

Aircraft = Performance(Aircraft);
Aircraft = Sizing(Aircraft);
Aircraft = Aero(Aircraft);

%Aircraft.Performance.WbyS = 82.31; 

counter = 0;
error = 1;
                
while error > 0.005
    
    error = Aircraft.Weight.MTOW;
    
    Aircraft = Payload_Weight(Aircraft);
    Aircraft = Empty_Weight(Aircraft);
    Aircraft = Fuel_Weight(Aircraft);
    Aircraft.Weight.MTOW = Aircraft.Weight.payload + Aircraft.Weight.fuel_Weight...
                           + Aircraft.Weight.empty_Weight;
    
    error = abs(error - Aircraft.Weight.MTOW);

    counter = counter + 1;
    
end
                    
%     variables.W_TO_estimated = 0.333*variables.W_TO_guess + 0.95*0.911*(variables.W_TO_guess)^0.947 + variables.W_Pay;
%     error = abs(variables.W_TO_estimated - variables.W_TO_guess);
%     variables.W_TO_guess = variables.W_TO_estimated;    
    
