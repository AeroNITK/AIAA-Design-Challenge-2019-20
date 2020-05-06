clear;
clc;
close all;

d2r = pi/180;
load('Aircraft.mat');

Aircraft.Wing.twist = 3;    % Wing Linear Twist (in deg)

%% Reynolds Number Calculation

%%% Take - Off Condition

rho = 1.164;    % Kg/m^3
d_visc = 0.0000188606;  % Pa.s
M = 0.2;    % Assumption from CADP - Mach Number during Take-off
V = M*349.039;  % a - Speed of sound in m/s
chord = Aircraft.Wing.chord_root - tan( d2r*Aircraft.Wing.Sweep_LE ) ...
    *0.5*Aircraft.Fuselage.diameter;    % Chord at the junction of Wing and fuselage

Re_tip_take_off = rho * Aircraft.Wing.chord_tip * 0.3048 * V / d_visc;

Re_root_take_off = rho * Aircraft.Wing.chord_root * 0.3048 * V / d_visc;

Re_chord_take_off = rho * chord * 0.3048 * V / d_visc;

%%% Cruise Condition

rho = 0.394442;    % Kg/m^3
d_visc = 0.0000145561;  % Pa.s
M = Aircraft.Performance.M_cruise; 
V = M*297.875;  % a - Speed of sound in m/s

Re_tip_cruise = rho * Aircraft.Wing.chord_tip * 0.3048 * V / d_visc;

Re_root_cruise = rho * Aircraft.Wing.chord_root * 0.3048 * V / d_visc;

Re_chord_cruise = rho * chord * 0.3048 * V / d_visc;

%% Slope and Maximum Lift Coefficient of Wing Calculation

% ----------------------------------------------------------------------------
%%% Lift Curve Slope

beta = sqrt(1 - Aircraft.Performance.M_cruise^2);
k = beta * 7.165/2/pi; % 6.875 from

F = 1.07 * (1 + Aircraft.Fuselage.diameter/Aircraft.Wing.b)^2;

S_exposed = Aircraft.Wing.S - 850.425;  % Exposed Surface Area (Calculated based on trapezium Approximation)

Aircraft.Wing.Sweep_maxtc = atan( tan(d2r*Aircraft.Wing.Sweep_LE) ...   % Sweepback angle of Maximum Thickness Chord
                            - ( 4*0.3744*(1 - Aircraft.Wing.taper_ratio) ) ...
                            / ( Aircraft.Wing.Aspect_Ratio*(1 + Aircraft.Wing.taper_ratio) ) )/d2r;
                
Aircraft.Wing.lift_slope = 2*pi*Aircraft.Wing.Aspect_Ratio ...
                    / ( 2 + ( (Aircraft.Wing.Aspect_Ratio*beta/k)^2 ...
                    * ( 1 + ( tan(d2r*Aircraft.Wing.Sweep_maxtc)/beta)^2 ) + 4 )^0.5 );       
                
Aircraft.Wing.lift_slope = Aircraft.Wing.lift_slope * S_exposed * F / Aircraft.Wing.S;    % Slope of the lift curve. Raymer Pg. No. 400

% ------------------------------------------------------------------------------------
%%% Maximum CL at Take off condition

% Aircraft.Wing.CL_max_clean = 0.9 * Aircraft.airfoil.cl_max * cos(d2r*Aircraft.Wing.Sweep_qc); % CL max of the wing

% cl_max = 0.47;

% CL = cl_max * (0.952 - 0.45*(Aircraft.Wing.taper_ratio - 0.5)^2 )*( Aircraft.Wing.Aspect_Ratio/12 )^0.03;

% Methodology taken from Phillips and Alley (2007)

cl_max = 2.6 * ( cos(d2r * Aircraft.Wing.Sweep_qc) ) ;

CL_by_clmax_zero_sweep_zero_twist = (0.952 - 0.45*(Aircraft.Wing.taper_ratio - 0.5)^2 ) ...
                                    *( Aircraft.Wing.Aspect_Ratio/12 )^0.03;    % Ratio of CL/cl_max without twist and sweep

Factor = Aircraft.Wing.lift_slope * Aircraft.Wing.twist * d2r / cl_max;
                                                    
K1 = 0.15 + 18.5 * (Aircraft.Wing.taper_ratio - 0.4) /  Aircraft.Wing.Aspect_Ratio; % Sweep Correction Coefficient 1
K2 = 0.55 + 12 * (Aircraft.Wing.taper_ratio - 0.275) /  Aircraft.Wing.Aspect_Ratio;   % Sweep Correction Coefficient 3

K_sweep = 1 + K1 * d2r * Aircraft.Wing.Sweep_qc ...
            - K2 * ( d2r * Aircraft.Wing.Sweep_qc )^1.2;    % Sweep Correction Factor
        
K_stall = 1 + (0.0042 * Aircraft.Wing.Aspect_Ratio - 0.068) ...
         * (1 + 2.3 * Factor ); % Stalling Correction Factor     
     
K_twist = -0.33; % Calculated from graphs based on the value of "Factor"     

% Aircraft.Wing.CL_max = CL_by_clmax_zero_sweep_zero_twist * K_stall ...
%                       * K_sweep * cl_max * ( 1 - Factor * K_twist );  

Aircraft.Wing.CL_max = CL_by_clmax_zero_sweep_zero_twist * K_sweep ...
  * ( cl_max - K_twist * Aircraft.Wing.lift_slope * Aircraft.Wing.twist * d2r );  
                  
%save('Aircraft');
