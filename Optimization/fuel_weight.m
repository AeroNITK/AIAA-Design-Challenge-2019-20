%  Aircraft Fuel Weight Calculator for a given mission
%  ------------------------------------------------------------------------
%  Input : Aircraft structure datatpye.
%  Output : Aircraft sturcture datatype with updated Fuel Weight.
%  All units are in FPS System.
%  ------------------------------------------------------------------------
%  Mission Description:
%  Complete mission is divided into various segments. Mission Weight
%  Fraction for each segment is calculated. All the Weight weight fractions
%  are mutliplied to get ratio of weight of the airplane at the end of the
%  mission to start of the mission.
%  Segment No.		Name			
%  1                Engine Start & Warm Up			
%  2                Taxi to Runway			
%  3                Take Off			
%  4                Climb to cruise altitude			
%  5                Cruise to full range			
%  6                Loiter for 10% of flight time for cruise			
%  7                Descent 			
%  8                Climb			
%  9                Cruise for 200 nm to alternate airport			
%  10               Descent 			
%  11               30 min. loiter at 15000 ft			
%  12               Landing			
%  ------------------------------------------------------------------------

function [Aircraft] = Fuel_Weight(Aircraft)
    
    Cj_cruise = 0.000125;   % Specific Fuel Consumption (in lbs/lbs/s)
    Cj_loiter = 0.0001;   % Specific Fuel Consumption (in lbs/lbs/s)

    W1byW_TO = 0.99;    % Mission Segement Weight Fraction for Engine Start & Warm Up     
    W2byW1 = 0.99;      % Mission Segement Weight Fraction for Taxi to Runway
    W3byW2 = 0.995;     % Mission Segement Weight Fraction for Take Off
    W4byW3 = 0.985;      % Mission Segement Weight Fraction for Climb to cruise altitude (Raymer)
    
    % Mission Segement Weight Fraction for Cruise segment 1
    
    range = Aircraft.Performance.range1*1.852*1000;  % nm to meters
    [~,~,~,a] = ISA(Aircraft.Performance.altitude_cruise1*0.3048);
    V = Aircraft.Performance.M_cruise*a;    % Cruising Speed in m/s
    
    W5byW4 = exp(-(range*Cj_cruise)/(V*Aircraft.Aero.LbyD_max_cruise));
    
    % Mission Segement Weight Fraction for Loiter segment 1
    
    loiter1 = 0.1*range/V;  % 10% of the cruising time
    
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
    
    W12byW_TO = W1byW_TO*W2byW1*W3byW2*W4byW3*W5byW4*W6byW5...
               *W7byW6*W8byW7*W9byW8*W10byW9*W11byW10*W12byW11; 
           
    Aircraft.Weight.Landing_Takeoff = W1byW_TO*W2byW1*W3byW2*W4byW3*W5byW4*W6byW5...
               *W7byW6;
           
    Aircraft.Weight.WfbyW_TO = 1.06*(1 - W12byW_TO);    % Fuel to MTOW ratio
    
    Aircraft.Weight.fuel_Weight = Aircraft.Weight.WfbyW_TO * Aircraft.Weight.MTOW;  % Fuel Weight
    
end