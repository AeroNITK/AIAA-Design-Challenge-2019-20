% Script for Engine Sizing, Installed Thrust Loss Calculation, Nacelle
% geometry estimation, and Inlet Area Calculation.
% All units are FPS, unless otherwise stated.

clc;
clear;
close all;

load('Aircraft.mat');

in2ft = 1/12;

%% Installation losses calculation
% Pressure recovery loss
C_ram = 1.35;   % From Raymer - Pg. No. 474
Precovery_ref = 1;   % From Raymer - Pg. No. 474
Precovery_actual = 0.985;   % Value taken from Raymer Fig 3.7 - Pg. No. 474
Percent_lossP = (C_ram * (Precovery_ref - Precovery_actual) * 100);

Distortion_loss = 0;    % Assumed to be zero as per recommendation of Raymer

% Bleed loss
mr = 0.03;  % Bleed mass flow rate to Engine mass flow, recommended by Raymer
C_bleed = 2; % Bleed Correction Factor, recommended by Raymer
Percent_lossB = C_bleed * mr * 100;  %% Reymer eq.13.8

hp_extract = 0; % Assumed to be zero as per recommendation of Raymer
nozzleeffect = 0;   % Assumed to be zero as per recommendation of Raymer

% Total percent loss
Insll_losspercent = Percent_lossB + Percent_lossP + Distortion_loss  ...
                        + hp_extract + nozzleeffect;

%% Engine Scaling
% Benchmark Engine chosen is PW 4000-94 (Model PW 4462)

T_benchmark = 62000;   % (From EASA TYPE-CERTIFICATE DATA SHEET) (in lbs) (uninstalled)

Aircraft.Propulsion.Un_Ins_thrust = Aircraft.Propulsion.thrust_per_engine * 100 / (100 - Insll_losspercent);    % Calculating  Uninstalled thurst of New Engine

SF = Aircraft.Propulsion.Un_Ins_thrust / T_benchmark;  % Scaling Factor

% New Engine Sizing based on Scale Factor

L_org = 153.6 * in2ft; % (From EASA TYPE-CERTIFICATE DATA SHEET) (in ft) 
Aircraft.Propulsion.Engine_length = L_org*(SF^0.4);   % Raymer Eq.10.1 (in ft)

D_org = 97.5 * in2ft;   % (From EASA TYPE-CERTIFICATE DATA SHEET) (in ft)
Aircraft.Propulsion.Engine_diameter = D_org*(SF^0.5); % Raymer Eq.10.2 (in ft)
% D_final = 1.3*D_new;    % (considering engine accessories attached below engine)

W_act = 9450;   % (From EASA TYPE-CERTIFICATE DATA SHEET) (in lbs)
Aircraft.Propulsion.Weight = W_act * (SF^1.1);   % Raymer eq.10.3

Aircraft.Propulsion.BPR = 5;

% In SI units i.e in 1/hr

% SFC_maxT = 0.67 * exp(-0.12 * Aircraft.Propulsion.BPR); % Raymer Eq.10.7
% SFC_cruise = 0.88 * exp(-0.05 * Aircraft.Propulsion.BPR); %Raymer Eq.10.9

% SFC values are based on recommendation of Raymer (20% improvement) Base
% values are taken from Raymer Part 1.
Aircraft.Propulsion.SFC_cruise = 0.55*0.8;  % in 1/hr
Aircraft.Propulsion.SFC_loiter = 0.45*0.8;  % in 1/hr

%% Nacelle Geometry
% Refer A330 AIRCRAFT CHARACTERISTICS - AIRPORT AND MAINTENANCE PLANNING Report
% For engine length of 14.07 ft, length of nacelle is 20.24 ft

NSF = 20.24 / 14.07;    % Nacelle Scaling Factor
Aircraft.Propulsion.Nacelle_L = NSF * Aircraft.Propulsion.Engine_length;   % New Nacelle Length (in ft)
 
Intake_cowl_original = 3.25;    % (in ft)  
Aircraft.Propulsion.Intake_cowl = ( Intake_cowl_original/20.24 ) * Aircraft.Propulsion.Nacelle_L; % (in ft)
 
Fan_cowl_original = 5.68;   % (in ft)
Aircraft.Propulsion.Fan_cowl = ( Fan_cowl_original/20.24 ) * Aircraft.Propulsion.Nacelle_L; % (in ft)

Thrustreverser_original = 8.53; % (in ft)
Aircraft.Propulsion.Thrust_reverser = ( Thrustreverser_original/20.24 ) * Aircraft.Propulsion.Nacelle_L;   % (in ft)
 
Exhaustnozzle_original = 2.76;  % (in ft)
Aircraft.Propulsion.Exhaust_nozzle = ( Exhaustnozzle_original/20.24 ) * Aircraft.Propulsion.Nacelle_L; % (in ft)
 
% Fancowlclosed_diameter = (3.15/2.72)*D_final;
% Fancowlopen_dia = (5.89/2.72)*D_final;

%% Inlet Geometry

% Mass Flow Rate calculation from Roskam
% k_gas = 0.0011; % Roskam Part 6 Eq.6.20, based on BPR
% m_gas = k_gas * Aircraft.Propulsion.thrust_per_engine;  % (in slugs/sec)
% m_cool = 0.06 * m_gas;  % Roskam Part 6 Eq. 6.21
% m_air = m_gas + m_cool; % Roskam Part 6 Eq. 6.19

% Capture area & Mass Flow Rate calculation from Raymer (Pg. No. 300)

Aircraft.Propulsion.mass_flow_rate = 26 * Aircraft.Propulsion.Engine_diameter^2; % (in lbs/s)

Cap_area_by_mass_flow = 0.0251;  % From Raymer (Fig 10.17) (sq ft)/(lbs per s)

Aircraft.Propulsion.Cap_area = 0.0251 * Aircraft.Propulsion.mass_flow_rate;  % Capture area by Raymer (in ft^2)

Aircraft.Propulsion.inlet_dia = sqrt(Aircraft.Propulsion.Cap_area * 4 / pi);   % Diameter at the start of inlet (in ft)

save('Aircraft.mat','Aircraft','-append');

clear;
clc;
