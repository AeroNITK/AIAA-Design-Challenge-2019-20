%  Performance Calculations
%  ------------------------------------------------------------------------
%  Input : Aircraft structure datatpye.
%  Output : Aircraft sturcture datatype with appended Perfomance Parameters.
%  All units are in FPS System.
%  ------------------------------------------------------------------------

function Aircraft = Performance(Aircraft)
    
    Aircraft.Performance.range1 = 3500;  % in nautical miles
    Aircraft.Performance.range2 = 200;  % in nautical miles
    Aircraft.Performance.altitude_cruise1 = 35000;    % Cruising Altitude in ft
    Aircraft.Performance.altitude_cruise2 = 15000;    % Cruising Altitude in ft
    
    Aircraft.Performance.takeoff_runway_length = 9000;  % in ft
    Aircraft.Performance.landing_runway_length = 9000;  % in ft
    Aircraft.Performance.M_cruise = 0.8;    % Cruising Mach Number
    
    Aircraft.Performance.loiter2 = 30*60;   % loiter time in seconds
    
    %%% Vn Diagram Values
    Aircraft.Vndiagram.n_limt = 2.5;
    Aircraft.Vndiagram.n_ult = 1.5*Aircraft.Vndiagram.n_limt;

end