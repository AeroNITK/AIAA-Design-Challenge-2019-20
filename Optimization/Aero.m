%  Aircraft Aero Estimator
%  ------------------------------------------------------------------------
%  Input : Aircraft structure datatpye.
%  Output : Aircraft sturcture datatype with required variables appended.
%  Aero Polar : C_D = C_D0 + K*C_L^2
%  All units are in FPS System.
%  ------------------------------------------------------------------------

function Aircraft = Aero(Aircraft)
    
%%% Regression Coefficients which relate MOTW and Wetted Area
%%% Roskam Part 1 - Table 3.5 Pg. No. 122
    c = 0.0199;
    d = 0.7531;
    
%%% Regression Coefficients which relate Parasite Area and Wetted Area
%%% Roskam Part 1 - Table 3.4 Pg. No. 122 cf = 0.003
    a = -2.5229;
    b = 1;
    
    Aircraft.Aero.e_clean = 0.75;
    Aircraft.Aero.e_takeoff_flaps = 0.7;
    Aircraft.Aero.e_landing_flaps = 0.65;
    
    Swet = 10^(c + d*log10(Aircraft.Weight.MTOW));
    f = 10^(a + b*log10(Swet));

    K_LD = 13;
    Aircraft.Aero.C_D0_clean = f/Aircraft.Wing.S;
    Aircraft.Aero.LbyD_max_loiter = K_LD*sqrt(Aircraft.Wing.Aspect_Ratio*Aircraft.Wing.S/Swet);   % Loiter L/D
    Aircraft.Aero.LbyD_max_cruise = 0.866*Aircraft.Aero.LbyD_max_loiter;   % Crusie L/D
    Aircraft.Aero.delta_C_D0_takeoff = 0.015;  % Take-off Flaps
    Aircraft.Aero.delta_C_D0_landing = 0.06;  % Landing Flaps
    Aircraft.Aero.delta_C_D0_LG = 0.017;  % Landing Gear

end