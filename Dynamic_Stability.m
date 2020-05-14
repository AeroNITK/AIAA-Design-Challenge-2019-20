% Script for Dynamic Stability

clear;
clc;
close all;

load('Aircraft.mat');
d2r = pi/180;

%% Aircraft Geometry & Mass

% Reference Geometry (in SI System)
S = Aircraft.Wing.S * 0.3048^2;  %Surface Area (m^2)
b = Aircraft.Wing.b * 0.3048;  %Wing Span (m)
L = Aircraft.Fuselage.length * 0.3048; %Fuselage length (m)
c_mean = Aircraft.Wing.mac * 0.3048;  %Mean Aerodynamic Chord (m)
AR = Aircraft.Wing.Aspect_Ratio; %Aspect Ratio
e = Aircraft.Drag.M_082.e;

% CG and Mass Characteristics (in FPS System)
m = Aircraft.Weight.MTOW * 0.454; % in kgs
% CG = 0.25*c_mean; %in ft
Ixx = b^2 * m * 0.25^2 / 4; % in kg*m^2
Iyy = L^2 * m * 0.38^2 / 4; % in kg*m^2
Izz = ( (b+L)/2 )^2 * m * 0.46^2 / 4; % in kg*m^2
Ixz = 0;    % Assumed to be zero.

%% Reference condition

C_L = 0.41; % Design Lift Coefficient
C_D = 0.025;    % From Drag Polar
M = Aircraft.Performance.M_cruise;
[~,rho,~,a] = ISA(Aircraft.Performance.altitude_cruise1*0.3048);
u_0 = M*a; %in m/s

q = 0.5*rho*u_0^2;

%% Longitudinal Analysis

% Derivatives needed for stability coefficietns calculation
C_D_u = 0;
C_D_0 = C_D;
C_T_u = 0;  % for jet-powered aircraft it will be zero
C_L_0 = C_L;
C_L_a = Aircraft.Lift.lift_slope_M082;

% Derivatives

% X_u
C_X_u = -(C_D_u + 2*C_D_0) + C_T_u;
X_u = C_X_u * q * S / m / u_0;

% X_w
C_D_a = 2 * C_L_0 * C_L_a / (pi * AR * e);
C_X_w = -(C_D_a - 2*C_L_0);
X_w = C_X_w * q * S / m / u_0;

% Z_u
C_L_u = C_L_0 * M^2/(1 - M^2);
C_Z_u = -(C_L_u + 2*C_L_0) + C_T_u;
Z_u = C_Z_u * q * S / m / u_0;

% Z_w 
C_Z_w = -(C_L_a + C_D_0);
Z_w = C_Z_w * q * S / m / u_0;

% M_u
M_u = 0;    % Assumed

% M_w_dot
downwash = 2 * Aircraft.Lift.lift_slope_M082 / pi / Aircraft.Wing.Aspect_Ratio;
l_t = 107.79 * 0.3048;   % in m
C_m_a_dot = -2 * 0.95 * Aircraft.Tail.Horizontal.lift_slope ...
            * Aircraft.Tail.Horizontal.Coeff * downwash * l_t/ c_mean;
        
M_w_dot = C_m_a_dot * c_mean * q * S * c_mean / (2 * u_0^2 * Iyy);

% M_w
M_w = Aircraft.Stability.Cm_alpha * q * S * c_mean / (u_0 * Iyy);

% M_q
C_m_q = -2 * 0.95 * Aircraft.Tail.Horizontal.lift_slope ...
            * Aircraft.Tail.Horizontal.Coeff * l_t/ c_mean;
        
M_q = C_m_q * c_mean * q * S * c_mean / (2 * u_0 * Iyy);

%% Matrix A

A_long = [X_u, X_w, 0, -9.81;...
     Z_u, Z_w, u_0, 0;...
     M_u + M_w_dot*Z_u, M_w + M_w_dot*Z_w, M_q + M_w_dot*u_0, 0;...
     0, 0, 1, 0];
 
Eigen = eig(A_long);

if abs(real(Eigen(1))) > abs(real(Eigen(3)))
    shortperiod_period = 2*3.14/abs(imag(Eigen(1)));
    shortperiod_t_half = 0.693/abs(real(Eigen(1)));
    shortperiod_zeta = 1/sqrt(1 + imag(Eigen(1))^2 / real(Eigen(1))^2);
    phugoid_period = 2*3.14/abs(imag(Eigen(3)));
    phugoid_t_half = 0.693/abs(real(Eigen(3)));
    phugoid_zeta = 1/sqrt(1 + imag(Eigen(3))^2 / real(Eigen(3))^2);
else
    shortperiod_period = 2*3.14/abs(imag(Eigen(3)));
    shortperiod_t_half = 0.693/abs(real(Eigen(3)));
    shortperiod_zeta = 1/sqrt(1 + imag(Eigen(3))^2 / real(Eigen(3))^2);
    phugoid_period = 2*3.14/abs(imag(Eigen(1)));
    phugoid_t_half = 0.693/abs(real(Eigen(1)));
    phugoid_zeta = 1/sqrt(1 + imag(Eigen(1))^2 / real(Eigen(1))^2);
end

%% Lateral Analysis

% Y_Beta
Factor = 0.724 + 3.06 * Aircraft.Tail.Vertical.S / Aircraft.Wing.S / ( 1 + cos(d2r * Aircraft.Wing.Sweep_qc) ) ...
        + 0.4 * 8 / Aircraft.Fuselage.diameter + 0.009 * Aircraft.Wing.Aspect_Ratio;
    
C_Y_beta = - Aircraft.Tail.Vertical.S * Aircraft.Tail.Vertical.lift_slope * Factor / Aircraft.Wing.S;
Y_beta = C_Y_beta * q * S / m;

% Y_p
C_Y_p = C_L * (AR + cos(d2r * Aircraft.Wing.Sweep_LE)) * tan (d2r * Aircraft.Wing.Sweep_LE) / (AR + 4 * cos(d2r * Aircraft.Wing.Sweep_LE));
Y_p = q * S * b * C_Y_p / (2 * m * u_0);

% Y_r
C_Y_beta_tail = - Aircraft.Tail.Vertical.S * Aircraft.Tail.Vertical.lift_slope * 0.95 / Aircraft.Wing.S;
C_Y_r = -2 * 92.47 * 0.3048 * C_Y_beta_tail /Aircraft.Wing.b;

Y_r = q * S * b * C_Y_r / (2 * m * u_0);

% L_beta
L_beta = Aircraft.Stability.Cl_beta * q * S * b / Ixx;

% L_p
C_l_p = - Aircraft.Lift.lift_slope_M082 * (1 + 3 * Aircraft.Wing.taper_ratio) / 12 / (1 + Aircraft.Wing.taper_ratio);
L_p = C_l_p * q * S * b^2 / (2 * Ixx * u_0);

% L_r
C_l_r = C_L/4 - 2 * 92.47 * 0.3048 * 21.55 * 0.3048 * C_Y_beta_tail / b^2;
L_r = C_l_r * q * S * b^2 / (2 * Ixx * u_0);

% N_beta
C_n_beta = Aircraft.Stability.Cn_beta;
N_beta = q * S * b * C_n_beta / Izz;

% N_p
C_n_p = - C_L / 8;
N_p = q * S * b^2 * C_n_p /2 /Izz /u_0;

% N_r 
C_n_r = - 2 * 0.95 * Aircraft.Tail.Vertical.Coeff * 92.47 * 0.3048 * Aircraft.Tail.Vertical.lift_slope / b ;
N_r = q * S * b^2 * C_n_r /2 /Izz /u_0;

A_lat = [Y_beta/u_0, Y_p/u_0, -(1 - Y_r/u_0), 9.81/u_0;...
         L_beta, L_p, L_r, 0;...
         N_beta, N_p, N_r, 0;...
         0, 1, 0, 0];

Eigen_lat = eig(A_lat);

DR_period = 2*3.14/abs(imag(Eigen_lat(3)));
DR_t_half = 0.693/abs(real(Eigen_lat(3)));
DR_zeta = 1/sqrt(1 + imag(Eigen_lat(3))^2 / real(Eigen_lat(3))^2);

DR_w_n = abs(real(Eigen_lat(3)))/DR_zeta;
