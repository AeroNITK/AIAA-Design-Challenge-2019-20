% Code for finding optimum values of T/W, and W/S which gives minimum weight
% with all constraints satisfied.
clear
clc
close all

global Aircraft
Aircraft = struct();

d2r = pi/180;

LB = [0.2,25,0.11,0.7,34000,0.2,7,3000];  % Lower Bound
UB = [0.6,35,0.15,0.85,40000,0.3,10,4100]; % Upper Bound

x0 = [0.25,30,0.15,0.8,36000,0.25,9,3500]; % Starting Value

A = [];
B = [];
Aeq = [];
Beq = [];

options = optimoptions('fmincon','Algorithm','sqp','Display','iter-detailed',...
    'FunctionTolerance',1e-6,'OptimalityTolerance',1e-6,'ConstraintTolerance',1e-6,....
    'StepTolerance',1e-20,'MaxFunctionEvaluations',600);
 
[X,~,exitflag] = fmincon(@(x) Obj_Func(x), x0, A, B, Aeq, Beq, LB, UB, @(x) Nonlincon(x),options);

Aircraft.Performance.Mdd = Aircraft.Performance.M_cruise + 0.04;
Aircraft.Performance.Mcr = 0.95/cos( d2r * Aircraft.Wing.Sweep_hc)  ...
                    - Aircraft.Wing.t_c_root/(cos(d2r*Aircraft.Wing.Sweep_hc)^2) ...
                    - Aircraft.Performance.CL_Design/(10*cos(d2r*Aircraft.Wing.Sweep_hc)^3) - 0.108;

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

x = (VS^2)*CL_max_L*rho/(2*32.2*Aircraft.Weight.Landing_Takeoff)*ones(1,101);
y = x1;
plot(x,y,'LineWidth',1.5);

AR = Aircraft.Wing.Aspect_Ratio;
e = Aircraft.Aero.e_takeoff_flaps;
CGR = 0.024;
Thrust_Factor = 0.966;
Speed_Factor = 1.2;
CL_max = 1.9;
Corrected_CL = CL_max/Speed_Factor^2;
CD_o = Aircraft.Aero.C_D0_clean + Aircraft.Aero.delta_C_D0_takeoff;
K = (pi*AR*e)^-1;
L_by_D = Corrected_CL/( CD_o + K*Corrected_CL^2 );

x = x2;
y = 2*(L_by_D^(-1) + CGR)*Thrust_Factor*ones(1,101);

plot(x,y,'LineWidth',1.5);

Cruising_Altitude = Aircraft.Performance.altitude_cruise1; %in feets
[P,rho,T,a] = ISA(Cruising_Altitude*0.3048);
rho = rho*0.0623;
V = Aircraft.Performance.M_cruise*a/0.3048;
q = 0.5*rho*V^2;
q = q/32;
alpha = (P*288.15)/(T*101325);
beta = 0.96;

y = ones(1,101);

for i = 1:101

    y(i) = ( (beta*x2(i) )/(pi*Aircraft.Wing.Aspect_Ratio*Aircraft.Aero.e_clean*q) ...
            + ( (Aircraft.Aero.C_D0_clean + 0.003)*q)/( beta*x2(i) ) )/(alpha/beta);
    
end

plot(x,y,'LineWidth',1.5);

plot(Aircraft.Performance.WbyS,Aircraft.Performance.TbyW,'o');

hold off

title('Constraint Diagram');
ylabel('T/W');
xlabel('W/S (lbs/ft^2)');
legend ('Takeoff','Landing','Climb','Cruising Speed and Altitude');