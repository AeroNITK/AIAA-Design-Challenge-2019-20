% Drag Estimation of the Plane (Method taken from CADP Chapter 9)

clc;
clear;
close all;

load('Aircraft.mat');

% Flow over the plane is considered to be turbulent. (Conservative
% Approach).

d2r = pi/180;
M = 0.2;

%% Wing Zero Lift Drag Estimation
% -------------------------------------------------------------------------
% Inner Section (Before the crank)

Re_MAC_i = Reynolds_number(M,Aircraft.Wing.mac_i,1);    % Reynolds number based on the MAC

C_F_MAC_i = 0.0315 / Re_MAC_i ^ (1/7);    % Average Fricitional Coefficient over MAC inner wing
% Based on the Prandtl's rule of 1/7th Power law

C_F_MAC_i = (1 - 0.072*M^1.5) * C_F_MAC_i; % Correction Factor for Compressiblity

S_wet = 2467.174;    % From CAD Model in ft^2

C_D_F_i = S_wet * C_F_MAC_i / Aircraft.Wing.Si;   % Integrated Frictional Drag Coefficient for the inner wing

% -------------------------------------------------------------------------
% Outer Section (After the crank)

Re_MAC_o = Reynolds_number(M,Aircraft.Wing.mac_o,1);    % Reynolds number based on the MAC

C_F_MAC_o = 0.0315 / Re_MAC_o ^ (1/7);    % Average Fricitional Coefficient over MAC outer wing
% Based on the Prandtl's rule of 1/7th Power law

C_F_MAC_o = (1 - 0.072*M^1.5) * C_F_MAC_o; % Correction Factor for Compressiblity

S_wet = 4268.14;    % From CAD model in ft^2

C_D_F_o = S_wet * C_F_MAC_o / Aircraft.Wing.So;   % Integrated Frictional Drag Coefficient for the outer wing

% -------------------------------------------------------------------------
% Total Fricitonal Drag Coefficient

C_D_F_wing = C_D_F_i + C_D_F_o;  % Total Frictional Drag Coefficient for the wing

% Factors for accounting parasitic or form darg
p1 = 1.0;   
p2 = 4.2 * Aircraft.Wing.t_c_root;  % From Morrison (176) Supercritical Airfoils

C_D_o_wing = p1 * (1 + p2) * C_D_F_wing;    % Zero Lift Drag due to wing without Sweep correction

Aircraft.Drag.M_02.C_D_o_wing = C_D_o_wing * cos (d2r * Aircraft.Wing.Sweep_qc)^2.5; % Zero Lift Drag due to wing with Sweep correction (DATCOM Method)

%% Fuselage Zero Lift Drag Estimation

F = Aircraft.Fuselage.length / Aircraft.Fuselage.diameter;  % Fineness Ratio

S_wet = 7361.309;   % Wetted Area of Fuselage (in ft^2)

Re_fus_len = Reynolds_number(M,Aircraft.Fuselage.length,1);  % Reynolds number based on the fuselege lengths  

C_F_fus_len = 0.0315 / Re_fus_len ^ (1/7);    % Average Fricitional Coefficient over fuselege length
% Based on the Prandtl's rule of 1/7th Power law

C_F_fus_len = (1 - 0.072*M^1.5) * C_F_fus_len; % Correction Factor for Compressiblity

Aircraft.Drag.M_02.C_D_o_fus = S_wet * C_F_fus_len * (1 + 0.0025*F + 60/F^3) / Aircraft.Wing.S;    % Zero Lift Drag due to fuselage (Hoerner)

%% Horizontal Tail Zero Lift Drag Estimation

Re_MAC = Reynolds_number(M,Aircraft.Tail.Horizontal.mac,1);    % Reynolds number based on the H-Tail MAC

C_F_MAC = 0.0315 / Re_MAC ^ (1/7);    % Average Fricitional Coefficient over H-Tail MAC
% Based on the Prandtl's rule of 1/7th Power law

C_F_MAC = (1 - 0.072*M^1.5) * C_F_MAC; % Correction Factor for Compressiblity

S_wet = 1287.407;    % From CAD Model in ft^2

C_D_o_htail = S_wet * C_F_MAC / Aircraft.Wing.S; % Fricitional Drag Coefficient of the H - Tail   

% Factors for accounting parasitic or form drag (Hoerner (1958)
p1 = 1.0;   
p2 = 2 * Aircraft.Tail.Horizontal.t_c + 60 * Aircraft.Tail.Horizontal.t_c^4;

C_D_o_htail = p1 * (1 + p2) * C_D_o_htail;  % Zero Lift Drag due to H-Tail without Sweep correction

Aircraft.Drag.M_02.C_D_o_htail = C_D_o_htail * cos (d2r * Aircraft.Tail.Horizontal.Sweep_qc)^2.5;  % Zero Lift Drag due to H-Tail with Sweep correction

%% Vertical Tail Zero Lift Drag Estimation

Re_MAC = Reynolds_number(M,Aircraft.Tail.Vertical.mac,1);    % Reynolds number based on the V-Tail MAC

C_F_MAC = 0.0315 / Re_MAC ^ (1/7);    % Average Fricitional Coefficient over V-Tail MAC
% Based on the Prandtl's rule of 1/7th Power law

C_F_MAC = (1 - 0.072*M^1.5) * C_F_MAC; % Correction Factor for Compressiblity

S_wet = 1353.454;    % From CAD Model in ft^2

C_D_o_vtail = S_wet * C_F_MAC / Aircraft.Wing.S;   % Fricitional Drag Coefficient of the V - Tail    

% Factors for accounting parasitic or form darg (Hoerner (1958)
p1 = 1;
p2 = 2 * Aircraft.Tail.Vertical.t_c + 60 * Aircraft.Tail.Vertical.t_c^4;

C_D_o_vtail = p1 * (1 + p2) * C_D_o_vtail;  % Zero Lift Drag due to V-Tail

Aircraft.Drag.M_02.C_D_o_vtail = C_D_o_vtail * cos (d2r * Aircraft.Tail.Vertical.Sweep_qc)^2.5;  % Zero Lift Drag due to V-Tail with Sweep correction

%% Nacelle and Pylon Zero Lift Drag Estimation

Re_MAC = Reynolds_number(M,Aircraft.Propulsion.Nacelle_L,1);    % Reynolds number based on the length of Nacelle

C_F_MAC = 0.0315 / Re_MAC ^ (1/7);    % Average Fricitional Coefficient over the length of Nacelle
% Based on the Prandtl's rule of 1/7th Power law

C_F_MAC = (1 - 0.072*M^1.5) * C_F_MAC; % Correction Factor for Compressiblity

S_wet = pi * Aircraft.Propulsion.Engine_diameter * Aircraft.Propulsion.Nacelle_L;   % Wetted Area of Nacelle (in ft^2)

C_D_o_nac = S_wet * C_F_MAC / Aircraft.Wing.S;   % Fricitional Drag Coefficient of Nacelle and Pylon

% Factors for accounting parasitic or form darg
K_n = 1.25 * ( 1 + 1.2 * (Aircraft.Propulsion.Engine_diameter - Aircraft.Propulsion.inlet_dia) / 2 / Aircraft.Propulsion.Nacelle_L ...
    + 100 * ( (Aircraft.Propulsion.Engine_diameter - Aircraft.Propulsion.inlet_dia) / 2 / Aircraft.Propulsion.Nacelle_L )^4 );

Aircraft.Drag.M_02.C_D_o_nac = 2 * C_D_o_nac * K_n;    % Zero lift drag of Nacelle and Pylon ( Factor of 2 for two nacelles)

%% Landing Gear Zero Lift Drag Estimation

Aircraft.Drag.C_D_o_LG = 3.3e-3 * Aircraft.Weight.MTOW^0.785 / Aircraft.Wing.S;   % Zero Lift Drag due to Landing Gear

%% Flaps Zero Lift Drag Estimation

S_flaps = 1041.96 + 1458.137;  % 1041.96 for inboard flaps, 1458.137 for outboard flaps

Aircraft.Drag.C_D_o_Flaps_TO = 0.9 * 0.25^1.38 * S_flaps * sin (d2r * 25)^2 / Aircraft.Wing.S;

Aircraft.Drag.C_D_o_Flaps_L = 0.9 * 0.25^1.38 * S_flaps * sin (d2r * 43)^2 / Aircraft.Wing.S;

%% Zero Lift of the Aircraft

%Aircraft.Drag.M_02.C_D_o = 1.06*(Aircraft.Drag.M_02.C_D_o_wing + Aircraft.Drag.M_02.C_D_o_fus + Aircraft.Drag.M_02.C_D_o_htail + Aircraft.Drag.M_02.C_D_o_vtail + Aircraft.Drag.M_02.C_D_o_nac);

Aircraft.Drag.M_02.C_D_o_TO = 1.06*(Aircraft.Drag.M_02.C_D_o_wing + Aircraft.Drag.M_02.C_D_o_fus + Aircraft.Drag.M_02.C_D_o_htail + Aircraft.Drag.M_02.C_D_o_vtail + Aircraft.Drag.M_02.C_D_o_nac + Aircraft.Drag.C_D_o_Flaps_TO + Aircraft.Drag.C_D_o_LG);

Aircraft.Drag.M_02.C_D_o_L = 1.06*(Aircraft.Drag.M_02.C_D_o_wing + Aircraft.Drag.M_02.C_D_o_fus + Aircraft.Drag.M_02.C_D_o_htail + Aircraft.Drag.M_02.C_D_o_vtail + Aircraft.Drag.M_02.C_D_o_nac + Aircraft.Drag.C_D_o_Flaps_L + Aircraft.Drag.C_D_o_LG);

%% Wave Drag Estimation (Based on the Lock's Model)

Aircraft.Drag.C_D_w = 20 * (Aircraft.Performance.M_cruise - Aircraft.Performance.Mcr )^4;

%% Calculation of Oswald Efficiency Factor (From CADP, Pg. No. 393)
% Method taken from Nita & Scholz (2012)

del_lamda = 0.45 * exp( -0.375 * d2r * Aircraft.Wing.Sweep_qc ) - 0.357;

lamda_dash = 1 - del_lamda;

f = 0.0524*lamda_dash^4 - 0.15*lamda_dash^3 + 0.166*lamda_dash^2 - 0.0706*lamda_dash + 0.0119;

et = 1 / (1 + Aircraft.Wing.Aspect_Ratio * f);  % Term for taper ratio, aspect ratio and sweep angle

eb = 1 - 2*( Aircraft.Fuselage.diameter/Aircraft.Wing.b )^2;    % Fuselage and span correction

ed = 0.873; %   correction factor 

em = 1;%1 - 1.52 * 1e-4 * (0.82/0.3 - 1)^10.82;    % Mach number correction factor

Aircraft.Drag.M_02.e = et * eb * ed * em;  % Oswald efficiency factor

%% Reynolds number calculation

function Re = Reynolds_number(M,l,flag)

    if flag == 1
        v = 0.0000188606;   % in Pa.s
        rho = 1.16439;    % in kg/m^3 
        alt = 34000 * 0.3048;  % Altitude in m
    end   
    
    [~,~,~,a] = ISA(alt);   % Speed of Sound in m/s
    V = M * a;  % Velocity in m/s
        
    Re = rho * V * l * 0.3048 / v;    % Reynolds Number

end
