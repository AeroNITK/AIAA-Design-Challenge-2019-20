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
% Aircraft.Performance.M_cruise = 0.2;

beta = sqrt(1 - 0.2^2);
k = 7.165/2/pi; % 7.165 from XFLR5

F = 1.07 * (1 + Aircraft.Fuselage.diameter/Aircraft.Wing.b)^2;

S_exposed = Aircraft.Wing.S - 850.425;  % Exposed Surface Area (Calculated based on trapezium Approximation)

Aircraft.Wing.Sweep_maxtc = atan( tan(d2r*Aircraft.Wing.Sweep_LE) ...   % Sweepback angle of Maximum Thickness Chord
                            - ( 4*0.3744*(1 - Aircraft.Wing.taper_ratio) ) ...
                            / ( Aircraft.Wing.Aspect_Ratio*(1 + Aircraft.Wing.taper_ratio) ) )/d2r;
                
Aircraft.Lift.lift_slope_M02 = 2*pi*Aircraft.Wing.Aspect_Ratio ...
                    / ( 2 + ( (Aircraft.Wing.Aspect_Ratio*beta/k)^2 ...
                    * ( 1 + ( tan(d2r*Aircraft.Wing.Sweep_maxtc)/beta)^2 ) + 4 )^0.5 );       
                
Aircraft.Lift.lift_slope_M02 = Aircraft.Lift.lift_slope_M02 * 0.98; % S_exposed * F / Aircraft.Wing.S;    % Slope of the lift curve. Raymer Pg. No. 400

% ------------------------------------------------------------------------------------
%%% Maximum CL without Flaps or slats

% Methodology taken from Phillips and Alley (2007)

cl_max = 2.6 * ( cos(d2r * Aircraft.Wing.Sweep_qc) ) ;  % Reduced for sweepeffects

CL_by_clmax_zero_sweep_zero_twist = (0.952 - 0.45*(Aircraft.Wing.taper_ratio - 0.5)^2 ) ...
                                    *( Aircraft.Wing.Aspect_Ratio/12 )^0.03;    % Ratio of CL/cl_max without twist and sweep

Factor = Aircraft.Lift.lift_slope_M02 * Aircraft.Wing.twist * d2r / cl_max;
                                                    
K1 = 0.15 + 18.5 * (Aircraft.Wing.taper_ratio - 0.4) /  Aircraft.Wing.Aspect_Ratio; % Sweep Correction Coefficient 1
K2 = 0.55 + 12 * (Aircraft.Wing.taper_ratio - 0.275) /  Aircraft.Wing.Aspect_Ratio;   % Sweep Correction Coefficient 3

K_sweep = 1 + K1 * d2r * Aircraft.Wing.Sweep_qc ...
            - K2 * ( d2r * Aircraft.Wing.Sweep_qc )^1.2;    % Sweep Correction Factor
        
K_stall = 1 + (0.0042 * Aircraft.Wing.Aspect_Ratio - 0.068) ...
         * (1 + 2.3 * Factor ); % Stalling Correction Factor     
     
K_twist = -0.28; % Calculated from graphs based on the value of "Factor" 

Aircraft.Lift.CL_max_M02 = CL_by_clmax_zero_sweep_zero_twist * K_sweep ...
  * ( cl_max - K_twist * Aircraft.Lift.lift_slope_M02 * Aircraft.Wing.twist * d2r );  

%% Other Lift Parameters 

Aircraft.Lift.CL_max_M082 = 1.229;

Aircraft.Lift.zero_lift_without_flaps_M082 = -3.6;   % in deg (from Roskam Part 6, Chapeter 8)

Aircraft.Lift.zero_lift_without_flaps_M02 = -4.36;  % in deg (from Roskam Part 6, Chapeter 8)

Aircraft.Lift.lift_slope_M02_with_flaps = 5.636;    % 1/rad (from Roskam Part 6, Chpater 8)

Aircraft.Lift.del_CL_zero_alpha = 0.41; % From Part 6, Chapter 8 

Aircraft.Lift.CL_max_TO = Aircraft.Lift.CL_max + Aircraft.HLD.del_CL_max_flaps_TO + Aircraft.HLD.del_CL_max_slats;

Aircraft.Lift.CL_max_L = Aircraft.Lift.CL_max + Aircraft.HLD.del_CL_max_flaps_L + Aircraft.HLD.del_CL_max_slats;


