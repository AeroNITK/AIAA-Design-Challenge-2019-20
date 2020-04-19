function [c,ceq] = Nonlincon(x)
    global Aircraft
    d2r = pi/180;
    
    %%% Take-Off
    R = 287;
    S_TOFL = Aircraft.Performance.takeoff_runway_length; % Take-off field length in feets
    CL_max_TO = 1.9;
    [P,rho,T,~] = ISA(0);
    sigma = (P/(R*(T+15)))/rho;
    
    c(1) = 37.5*Aircraft.Performance.WbyS/(sigma*CL_max_TO*x(1)) - S_TOFL; % First Constrain
    
    %%% Landing
    S_LFL = Aircraft.Performance.landing_runway_length;
    VA = sqrt(S_LFL/0.3);
    VS = VA/1.3; % Stall Speed in kts
    VS = VS/0.592484; % Stall Speed in ft/s
    CL_max_L = 2.3;
    rho = rho*0.0623; % Density in lbs/ft^3
    
    c(2) = Aircraft.Performance.WbyS/Aircraft.Weight.Landing_Takeoff - (VS^2)*CL_max_L*rho/(2*32.2); % Second Constrain
    
    %%% Climb Requirement
    CGR = 0.024;
    Thrust_Factor = 0.966;
    Speed_Factor = 1.2;
    Corrected_CL = CL_max_TO/Speed_Factor^2;
    CD_o = Aircraft.Aero.C_D0_clean + Aircraft.Aero.delta_C_D0_takeoff;
    L_by_D = Corrected_CL/(CD_o + Corrected_CL^2/(pi*Aircraft.Wing.Aspect_Ratio*Aircraft.Aero.e_takeoff_flaps));
    
    c(3) = 2*(L_by_D^(-1) + CGR)  - x(1)/Thrust_Factor; % Climb Requirement
    
    %%% Cruising Altitude & Speed
    M = Aircraft.Performance.M_cruise;
    Cruising_Altitude = Aircraft.Performance.altitude_cruise1; %in feets
    [P,rho,T,a] = ISA(Cruising_Altitude*0.3048);
    rho = rho*0.0623;
    V = M*a/0.3048;
    q = 0.5*rho*V^2;
    q = q/32;
    
    alpha = (P*288.15)/(T*101325);
    
    beta = 0.96;
    
    c(4) = ( Aircraft.Performance.WbyS*beta/(pi*Aircraft.Wing.Aspect_Ratio*Aircraft.Aero.e_clean*q) ...
            + ( (Aircraft.Aero.C_D0_clean + 0.003)*q)/(beta*Aircraft.Performance.WbyS) ) - x(1)*(alpha/beta);
    
    %%% Equality Constrain
    Aircraft.Performance.CL_Design = 0.956*Aircraft.Performance.WbyS/q;
    
    ceq = (Aircraft.Performance.M_cruise + 0.04) - 0.95/cos(d2r*Aircraft.Wing.Sweep_hc) ...
        + Aircraft.Wing.t_c_root/(cos(d2r*Aircraft.Wing.Sweep_hc)^2) ...
         + Aircraft.Performance.CL_Design/(10*cos(d2r*Aircraft.Wing.Sweep_hc)^3);
%    ceq = [];
end