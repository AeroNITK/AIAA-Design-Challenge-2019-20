function [c,ceq] = Nonlincon(x)

    global Aircraft

    %%% Take-Off
    R = 287;
    S_TOFL = Aircraft.Performance.takeoff_runway_length; % Take-off field length in feets
    CL_max_TO = 1.9;
    [P,rho,T,~] = ISA(0);
    sigma = (P/(R*(T+15)))/rho;
    
    c(1) = x(2)/x(1) - sigma*CL_max_TO*S_TOFL/37.5; % First Constrain
    
    %%% Landing
    S_LFL = Aircraft.Performance.landing_runway_length;
    VA = sqrt(S_LFL/0.3);
    VS = VA/1.3; % Stall Speed in kts
    VS = VS/0.592484; % Stall Speed in ft/s
    CL_max_L = 2.3;
    rho = 0.0726; % Density in lbs/ft^3
    
    c(2) = x(2)*0.84 - (VS^2)*CL_max_L*rho/(2*32.2); % Second Constrain
    
    %%% Climb Requirement
    A = Aircraft.Wing.Aspect_Ratio;
    CGR = 0.024;
    Thrust_Factor = 0.966;
    Speed_Factor = 1.2;
    CL_max = 1.9;
    Corrected_CL = CL_max/Speed_Factor^2;
    CD_o = 0.031;
    L_by_D = Corrected_CL/(CD_o + Corrected_CL^2/(pi*A*0.8));
    
    c(3) = 2*(L_by_D^(-1) + CGR)  - x(1)/Thrust_Factor; % Climb Requirement
    
    %%% Cruising Altitude / Speed
%     M = Aircraft.Performance.M_cruise;
%     Cruising_Altitude = Aircraft.Performance.altitude_cruise1; %in feets
%     [~,rho,~,a] = ISA(Cruising_Altitude*0.3048);
%     V = M*a/0.3048;
%     rho = rho*1.94e-3;
%     q = 0.5*rho*V^2;
%     alpha = 0.324;
%     K = 2*q*0.016/alpha;
%     c(4) = K - x(1)*x(2);
    
    %%% Equality Constrain
    ceq = [];
    
end