% Estimation High Lift Devices

clc;
clear;
close all;

load('Aircraft.mat');

d2r = pi/180;

%% Increment in  cl with flap deflection

% Method for Flap deflection

del_cl_max_base = 1.64; %  From CADP Figure 5.34 (DATCOM Method).

del_f = 25; % Flap Deflection (in degrees)

del_f_ref = 50; % Reference Flap Angle

k1 = 1; % Factor for chord location other than 0.25;

k2 = 0.99; %0.92; %0.6;%0.67; %0.75;  % Based on Flap Deflection 17, 15, 20, 25, 40, 45

k3 = 0.95; %0.87; 0.4;%0.23;%0.4;%0.57;   % Based on the ratio of fal deflection to reference flap deflection 17, 15, 20, 25, 40

del_cl_max_flap = k1 * k2 * k3 * del_cl_max_base;    % Change in the cl of airfoil

% Method for Slat extension

LER = 0.03;

csbyc = 0.2;

dcl_by_slat_def = 0.028;    % in 1/degreee

slat_defl = 20; % in deg

n_del = 0.9;

n_max = 1.1;

del_cl_max_slat = dcl_by_slat_def * n_max * n_del * slat_defl;

% Total change in lift coefficient of the airfoil

del_cl_max = del_cl_max_flap + del_cl_max_slat;

%% Increment in lift coefficient of the wing

% Due to Flaps
K = (1 - 0.08*cos(d2r * Aircraft.Wing.Sweep_qc)^2 ) * cos(d2r * Aircraft.Wing.Sweep_qc)^(3/4);

Aircraft.HLD.S_flaps = 1041.96 + 1458.137;  % 1041.96 for inboard flaps, 1458.137 for outboard flaps

Aircraft.HLD.del_CL_max_flaps_L = del_cl_max_flap * K * Aircraft.HLD.S_flaps / Aircraft.Wing.S;

% Due to slats

Aircraft.HLD.S_slats = 1041.96 + 1978.917;   % 1041.96 for inboard slats, 1978.917  

Aircraft.HLD.del_CL_max_slats = del_cl_max_slat * K * Aircraft.HLD.S_slats / Aircraft.Wing.S;

%% Position of HLD (from CAD Sketch)

Aircraft.HLD.flaps_in_start = 2*12/Aircraft.Wing.b;

Aircraft.HLD.flaps_in_end = 2*18.385/Aircraft.Wing.b;

Aircraft.HLD.flaps_out_start = 2*32.385/Aircraft.Wing.b;

Aircraft.HLD.flaps_out_end = 2*75.944/Aircraft.Wing.b;

Aircraft.HLD.slat_start = 2*12/Aircraft.Wing.b;

Aircraft.HLD.slat_end = 2*99.22/Aircraft.Wing.b;