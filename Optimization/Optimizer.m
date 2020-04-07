% Code for finding optimum values of T/W, and W/S which gives minimum weight
% with all constraints satisfied.
clear
clc
close all

global Aircraft
Aircraft = struct();

LB = [0.1,50];  % Lower Bound
UB = [0.6,160]; % Upper Bound

x0 = [0.25,90]; % Starting Value

A = [];
B = [];
Aeq = [];
Beq = [];

options = optimoptions('fmincon','Algorithm','sqp','Display','iter-detailed',...
    'FunctionTolerance',1e-20,'OptimalityTolerance',1e-20,'ConstraintTolerance',1e-20,....
    'StepTolerance',1e-20,'MaxFunctionEvaluations',500);
 
X = fmincon(@(x) Obj_Func(x), x0, A, B, Aeq, Beq, LB, UB, @(x) Nonlincon(x),options);

%% Plotting
 x1 = 0.1:0.005:0.6; % T/W
 x2 = 50:1.1:160;    % Wing loading
% [X1,X2] = meshgrid(x1,x2);
% 
% cost = X1./X2;
% 
% figure(2)
% contour(X2,X1,cost,20);

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

% M = Aircraft.Performance.M_cruise;
% Cruising_Altitude = Aircraft.Performance.altitude_cruise1; %in feets
% [~,rho,~,a] = ISA(Cruising_Altitude*0.3048);
% V = M*a/0.3048;
% rho = rho*1.94e-3;
% q = 0.5*rho*V^2;
% alpha = 0.324;
% K = 2*q*0.016/alpha;
% y = K./x;
% 
% plot(x,y,'LineWidth',1.5);

plot(X(2),X(1),'o');

hold off
