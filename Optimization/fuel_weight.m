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

function [Aircraft] = fuel_weight(Aircraft)

    K = 1/(pi*Aircraft.Wing.Aspect_Ratio*Aircraft.Aero.e_clean);
    LbyD_max = 1/(2*sqrt(Aircraft.Aero.C_D0_clean*K));
    LbyD_max_cruise = 0.866*LbyD_max;

    W1byW_TO = 0.99;    
    W2byW1 = 0.99;      
    W3byW2 = 0.995;
    W4byW3 = 0.98;
    
    % Mission Segement Weight Fraction for Cruise
    range = 3500;
    V = ;
    
    W5byW3 = exp(-(range*C)/(V*LbyD_max_cruise));
    
    
    

end