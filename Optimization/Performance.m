%  Performance Calculations
%  ------------------------------------------------------------------------
%  Input : Aircraft structure datatpye.
%  Output : Aircraft sturcture datatype with appended Perfomance Parameters.
%  All units are in FPS System.
%  ------------------------------------------------------------------------

function Aircraft = Performance(Aircraft)

    Aircraft.Performance.WbyS = 123;    % in lbs/ft^2
    Aircraft.Performance.TbyW = 0.3;
    Aircraft.Performance.range = 3500;  % in nautical miles
    Aircraft.Performance.takeoff_runway_length = 9000;  % in ft
    Aircraft.Performance.landing_runway_length = 9000;  % in ft
    Aircraft.Performance.M_cruise = 0.8;    % Cruising Mach Number
    Aircraft.Performance.Altitude_cruise = 35000;    % Cruising Altitude in ft

end