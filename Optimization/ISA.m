% International Standard Atmoshpere
%  ------------------------------------------------------------------------
%  Input : Altitude (in meters) (Geopotential Height)
%  Output : Pressure, Density, Temperature, & Speed of Sound (all in SI Units)
%  Range of Altitude : From Sealevel to 51,000 meters.
%  ------------------------------------------------------------------------

function [P, rho, T, a] = ISA(altitude_meters)
    %%% Reference Condtion in SI units
    T_SL = 288.15;  %  Temperature at Sealevel (T_SL)
    P_SL = 101325;  %  Pressure at Sealevel (P_SL)
    R = 287;    %  Gas Constant for Air (R)
    g = 9.81;   %  Acceleration due to Gravity (g)
    %%% If conditions for Altitude Specific Calculation
    %%% Calculation for Troposhpere limit : Sealevel to 11,000 meters.
    if altitude_meters <= 11000
        rate = -0.0065; % Lapse Rate
        T = T_SL + rate*altitude_meters; % T@Given_Altitude
        P = P_SL*((T/T_SL)^(-g/(R*rate))); % P@Given_Altitude
        rho = P/(287*T); % rho@Given_Altitude
        a = sqrt(1.4*287*T); % a@Given_Altitude
    %%% Calculation for Tropopause limit : 11,0000 to 20,000 meters.
    elseif altitude_meters > 11000 && altitude_meters <= 20000
        rate = -0.0065; % Initial Lapse Rate
        T = T_SL + rate*11000; % T@11,000 m
        P = P_SL*((T/T_SL)^(-g/(R*rate))); % P@11,000 m
        P = P*exp((-g*(altitude_meters - 11000))/(R*T)); % P@Given_Altitude
        rho = P/(287*T); % rho@Given_Altitude
        a = sqrt(1.4*287*T); % a@Given_Altitude
    %%% Calculation for Stratosphere limit : 20,000 to 32,000 meters.    
    elseif altitude_meters > 20000 && altitude_meters <= 32000
        rate = -0.0065; % Initial Lapse Rate
        T1 = T_SL + rate*11000; % T@11,000 m
        P = P_SL*((T1/T_SL)^(-g/(R*rate))); % P@11,000 m
        P = P*exp((-g*(20000 - 11000))/(R*T1)); % P@20,000 m
        rate = 0.001; % Change in Lapse Rate
        T = T1 + rate*(altitude_meters - 20000); % T@Given_Altitude
        P = P*((T/T1)^(-g/(R*rate))); % P@Given_Altitude
        rho = P/(287*T); % rho@Given_Altitude
        a = sqrt(1.4*287*T); % a@Given_Altitude
    %%% Calculation for Stratosphere limit : 32,000 to 47,000 meters.
    elseif altitude_meters > 32000 && altitude_meters <= 47000
        rate = -0.0065; % Initial Lapse Rate
        T1 = T_SL + rate*11000; % T@11,000 m
        P = P_SL*((T1/T_SL)^(-g/(R*rate))); % P@11,000 m
        P = P*exp((-g*(20000 - 11000))/(R*T1)); % P@20,000 m
        rate = 0.001; % Change in Lapse Rate
        T2 = T1 + rate*(32000 - 20000); % T@32,000 m
        P = P*((T2/T1)^(-g/(R*rate))); % P@32,000 m
        rate = 0.0028; % Change in Lapse Rate
        T = T2 + rate*(altitude_meters - 32000); % T@Given_Altitude
        P = P*((T/T2)^(-g/(R*rate))); % P@Given_Altitude
        rho = P/(287*T); % rho@Given_Altitude
        a = sqrt(1.4*287*T); % a@Given_Altitude
    %%% Calculation for Stratopause limit : 47,000 to 51,000 meters.
    elseif altitude_meters > 47000 && altitude_meters <= 51000
        rate = -0.0065; % Initial Lapse Rate
        T1 = T_SL + rate*11000; % T@11,000 m
        P = P_SL*((T1/T_SL)^(-g/(R*rate))); % P@11,000 m
        P = P*exp((-g*(20000 - 11000))/(R*T1)); % P@20,000 m
        rate = 0.001; % Change in Lapse Rate
        T2 = T1 + rate*(32000 - 20000); % T@32,000 m
        P = P*((T2/T1)^(-g/(R*rate))); % P@32,000 m
        rate = 0.0028; % Change in Lapse Rate
        T = T2 + rate*(47000 - 32000); % T@47,000 m
        P = P*((T/T2)^(-g/(R*rate))); % P@47,000 m
        P = P*exp((-g*(altitude_meters - 47000))/(R*T)); % P@Given_Altitude
        rho = P/(287*T); % rho@Given_Altitude
        a = sqrt(1.4*287*T); % a@Given_Altitude
    else
        disp('Altitude input is outside the range.');
    end
    
return
end
