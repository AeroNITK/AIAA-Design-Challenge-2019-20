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
Aircraft.Propulsion.length = L_org*(SF^0.4);   % Raymer Eq.10.1 (in ft)

D_org = 97.5 * in2ft;   % (From EASA TYPE-CERTIFICATE DATA SHEET) (in ft)
Aircraft.Propulsion.diameter = D_org*(SF^0.5); % Raymer Eq.10.2 (in ft)
% D_final = 1.3*D_new;    % (considering engine accessories attached below engine)

W_act = 9450;   % (From EASA TYPE-CERTIFICATE DATA SHEET) (in lbs)
Aircraft.Propulsion.Weight = W_act * (SF^1.1);   % Raymer eq.10.3

Aircraft.Propulsion.BPR = 5;

% In SI units i.e in 1/hr

SFC_maxT = 0.67 * exp(-0.12 * Aircraft.Propulsion.BPR); % Raymer Eq.10.7
SFC_cruise = 0.88 * exp(-0.05 * Aircraft.Propulsion.BPR); %Raymer Eq.10.9

%% Nacelle Geometry
% For engine length of 4.29 meters length of nacelle is 6.17 meters

% NSF = 6.17/4.29;
% NL = NSF*L_final;   %%Nacelle Length
% 
% %% Taking length ratios for other dimensions
% %% All original lengths taken from A330 AIRCRAFT CHARACTERISTICS - AIRPORT
% %% AND MAINTENANCE PLANNING Report
% 
% Intake_cowl_original = 0.99;
% Intake_cowl_final = (Intake_cowl_original/6.17) * NL;
% 
% Fan_cowl_original = 1.73;
% Fan_cowl_final = (Fan_cowl_original/6.17) * NL;
% 
% Thrustreverser_original = 2.6;
% Thrustreverser_final = (Thrustreverser_original/6.17)*NL;
% 
% Exhaustnozzle_original = 0.84;
% Exhaustnozzle_final = (Exhaustnozzle_original/6.17)*NL;
% 
% Fancowlclosed_diameter = (3.15/2.72)*D_final;
% Fancowlopen_dia = (5.89/2.72)*D_final;

%% Inlet Geometry

k_gas = 0.0011; % Roskam Eq.6.20, based on BPR
m_gas = k_gas * Aircraft.Propulsion.thrust_per_engine;  % (in slugs/sec)
m_cool = 0.06 * m_gas;  % Roskam Eq. 6.21
m_air = m_gas + m_cool; % Roskam Eq. 6.19

Vmax = 250.8; % in meter per sec. for altitude 40,000 ft and mach 0.85
density = 0.302;  %%atmospheric density at 40,000 ft in kg/cubic meter

Ac = (m_air/(density*Vmax));  % Capture area as per Roskam Eq.6.22 (in ft^2)
