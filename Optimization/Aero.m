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
    
    Aircraft.Aero.e_clean = 0.85;
    Aircraft.Aero.e_takeoff_flaps = 0.8;
    Aircraft.Aero.e_landing_flaps = 0.75;
    
    Swet = 10^(c + d*log10(Aircraft.Weight.MTOW));
    f = 10^(a + b*log10(Swet));
    
    S = Aircraft.Wing.S;
    
    K_LD = 13;
    Aircraft.Aero.C_D0_clean = f/S;
    Aircraft.Aero.LbyD_max_loiter = K_LD*sqrt(Aircraft.Wing.Aspect_Ratio*S/Swet);   % Loiter L/D
    Aircraft.Aero.LbyD_max_cruise = 0.866*Aircraft.Aero.LbyD_max_loiter;   % Cruside L/D
%     Aircraft.Aero.K = 1/(pi*Aircraft.Wing.Aspect_Ratio*Aircraft.Aero.e_clean);
%     Aircraft.Aero.LbyD_max_loiter = 1/(2*sqrt(Aircraft.Aero.C_D0_clean*Aircraft.Aero.K));
%     Aircraft.Aero.LbyD_max_cruise = 0.866*Aircraft.Aero.LbyD_max_loiter;
    Aircraft.Aero.delta_C_D0_takeoff = 0.015;  % Take-off Flaps
    Aircraft.Aero.delta_C_D0_landing = 0.06;  % Landing Flaps
    Aircraft.Aero.delta_C_D0_LG = 0.017;  % Landing Gear

end