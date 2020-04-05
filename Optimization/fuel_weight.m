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

    K = 1/(pi*Aircraft.Wing.Aspect_Ratio*Aircraft.Aero.e_clean);
    LbyD_max = 1/(2*sqrt(Aircraft.Aero.C_D0_clean*K));
    LbyD_max_cruise = 0.866*LbyD_max;

    W1byW_TO = 0.99;    % Mission Segement Weight Fraction for Engine Start & Warm Up     
    W2byW1 = 0.99;      % Mission Segement Weight Fraction for Taxi to Runway
    W3byW2 = 0.995;     % Mission Segement Weight Fraction for Take Off
    W4byW3 = 0.98;      % Mission Segement Weight Fraction for Climb to cruise altitude
    
    % Mission Segement Weight Fraction for Cruise
    
    range = Aircraft.Performance.range*1.852*1000;  % nm to meters
    [~,~,~,a] = ISA(Aircraft.Performance.Altitude_cruise*0.3048);
    V = Aircraft.Performance.M_cruise*a;    % Cruising Speed in m/s
    Cj_cruise = 0.000153;   % Specific Fuel Consumption (in lbs/lbs/s)
    
    W5byW4 = exp(-(range*Cj_cruise)/(V*LbyD_max_cruise));
    
    % Mission Segement Weight Fraction for Loiter 
    
    W6byW5 = ;
    
    W7byW6 = 0.99;  % Mission Segement Weight Fraction for Descent 
    W8byW7 = 0.98;  % Mission Segement Weight Fraction for Climb
    
    W9byW8 = ;
    
    W10byW9 = 0.99; % Mission Segement Weight Fraction for Descent
    
    W11byW10 = ;    
    
    W12byW11 = 0.992;   % Mission Segement Weight Fraction for  Landing
    
    W12byW_TO = W1byW_TO*W2byW1*W3byW2*W4byW3*W5byW4*W6byW5...
               *W7byW6*W8byW7*W10byW9*W11byW10*W12byW11; 
           
    WfbyW_TO = 1.06*(1 - W12byW_TO);    % Fuel to MTOW ratio
    
    Aircraft.Weight.fuel_Weight = WfbyW_TO * Aircraft.Weight.MTOW;  % Fuel Weight
    
end