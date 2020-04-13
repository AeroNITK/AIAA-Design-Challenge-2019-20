% Code for finding optimum values of T/W, and W/S which gives minimum weight
% with all constraints satisfied.
clear
clc
close all

global Aircraft
Aircraft = struct();
d2r = pi/180;

% Variables involved in Optimization
% x(1) = Surface Area
% x(2) = Aspect Ratio
% x(3) = Taper Ratio
% x(4) = QC Sweep
% x(5) = t/c
% x(6) = T/W
% x(7) = M
% x(8) = Altitude

LB = [7,0.2,25,0.11,0.15,75,0.8,30000];%,7,0.2,25,0.11,0.15,0.8,30000];  % Lower Bound
UB = [10,0.3,35,0.15,0.3,150,0.85,40000];%,10,0.3,35,0.15,0.25,0.85,45000]; % Upper Bound

x0 = [9,0.25,30,0.13,0.22,125,0.82,35000];%,8.5,0.25,30,0.13,0.20,0.81,35000]; % Starting Value

A = [];
B = [];
Aeq = [];
Beq = [];

options = optimoptions('fmincon','Algorithm','sqp','Display','iter-detailed',...
    'FunctionTolerance',1e-6,'OptimalityTolerance',1e-6,'ConstraintTolerance',1e-6,....
    'StepTolerance',1e-08,'MaxFunctionEvaluations',800);

[X, ~, exitflag] = fmincon(@(x) Obj_Func_TS(x), x0, A, B, Aeq, Beq, LB, UB, @(x) Nonlincon_TS(x),options);

Aircraft.Performance.Mdd = 0.95/cos(d2r*Aircraft.Wing.Sweep_LE) - Aircraft.Wing.t_c_root/cos(d2r*Aircraft.Wing.Sweep_LE)^2 ...
            -0.5/(10*cos(d2r*Aircraft.Wing.Sweep_LE)^3);    % Drag Divergence Mach Number
        
Aircraft.Performance.Mcr = Aircraft.Performance.Mdd - (0.1/80)^(0.33);

%% Plotting
x1 = 0.1:0.005:0.6; % T/W
x2 = 50:1.1:160;    % Wing loading

R = 287;
S_TOFL = Aircraft.Performance.takeoff_runway_length; % Take-off field length in feets
CL_max_TO = 1.9;
[P,rho,T,~] = ISA(0);
sigma = (P/(R*(T+15)))/rho;
y = x2./(sigma*CL_max_TO*S_TOFL/37.5); %T/W Calculated
plot(x2,y,'LineWidth',1.5);

hold on

S_LFL = Aircraft.Performance.landing_runway_length;
VA = sqrt(S_LFL/0.3);
VS = VA/1.3; % Stall Speed in kts
VS = VS/0.592484; % Stall Speed in ft/s
CL_max_L = 2.3;
rho = 0.0726; % Density in lbs/ft^3

x = (VS^2)*CL_max_L*rho/(2*32.2*0.84)*ones(1,101);
y = x1;
plot(x,y,'LineWidth',1.5);

AR = Aircraft.Wing.Aspect_Ratio;
CGR = 0.024;
Thrust_Factor = 0.966;
Speed_Factor = 1.2;
CL_max = 1.9;
Corrected_CL = CL_max/Speed_Factor^2;
CD_o = 0.031;
L_by_D = Corrected_CL/(CD_o + Corrected_CL^2/(pi*AR*0.8));

x = x2;
y = 2*(L_by_D^(-1) + CGR)*Thrust_Factor*ones(1,101);

plot(x,y,'LineWidth',1.5);

M = Aircraft.Performance.M_cruise;
Cruising_Altitude = Aircraft.Performance.altitude_cruise1; %in feets
[~,rho,~,a] = ISA(Cruising_Altitude*0.3048);
V = M*a/0.3048;
rho = rho*1.94e-3;
q = 0.5*rho*V^2;
alpha = 0.324;
K = 2*q*0.016/alpha;
y = K./x;

plot(x,y,'LineWidth',1.5);

plot(Aircraft.Performance.WbyS,Aircraft.Performance.TbyW,'o');

hold off
