%take-off performance

W_S_to=104.75*32.174;
rho=0.00231*32.174;
CL_to=1.9;
%Finding V_to
V_to=1.2*sqrt((2*W_S_to)/(rho*CL_to));
V_to;
g=32.174;
D_L_to=0.0813;
Fn=124000;  %Net force from engines
M=0.2;
beta=5.1;
%Finding Fg or Fto
F_to=Fn/(1-2*M*((1+beta)/(3+2*beta)));
F_to;
c_to=1112.61;
M_to=V_to/c_to;
%Finding Favg_to
Favg_to=F_to*(1-0.5*M_to*((1+beta)/(2+beta)));
Favg_to;
W=429470;
mu=0.015;
%Finding xg
xg=-((V_to)^2/(2*g))*(1/(D_L_to-mu))*log(((Favg_to/W)-D_L_to)/((Favg_to/W)-mu));
xg;

h_to=35;
%Finding sin(gamma_to)
sin_gamma_to=(Fn/W)-(D_L_to);
%Finding xair
xair=(((V_to)^2/(20*g))+h_to)/sin_gamma_to;
xair;
%Finding xto
x_to=xg+xair;
x_to;
x_to_far = 1.15*x_to;
x_to_approx=1.15*(V_to)^2/(g*(Favg_to/W));

%take-off with single engine failure

Vef=168.781; %Velocity at which engine failure occures
v1=1.2*Vef;
Mef=Vef/c_to;
Favg_to_ef=F_to*(1-0.5*Mef*((1+beta)/(3+2*beta)));
xef=-((Vef)^2/(2*g))*(1/(D_L_to-mu))*log(((Favg_to_ef/W)-D_L_to)/((Favg_to_ef/W)-mu));
x1 = xef + 0.5*3*(v1+Vef);
%Favg_W_to_1EO=0.5*(1-0.5*(Mef+M_to)*((1+beta)/(3+2*beta)))/W;
Favg_W_to_1EO=0.5*Favg_to_ef/W;
%Calculating xg with 1EO
xg_1EO=x1-((V_to)^2/(2*g))*(1/(D_L_to-mu))*log((Favg_W_to_1EO-D_L_to)/(Favg_W_to_1EO-mu-(D_L_to-mu)*(v1/V_to)^2));
xg_1EO;
Fn_Wto_1EO=1;
D_L=1;
%calculating x_air with 1E

Fn_Wto_1EO = (0.5/W)*F_to*(1-2*M_to*((1+beta)/(3+2*beta)));
xair_1EO=((V_to)^2/(20*g)+h_to)/(Fn_Wto_1EO-D_L_to);
xair_1EO;
x_to_ef = (xg_1EO + xair_1EO)

%aborted take-off

%V_1=1; %velocity of aircraft 3 seconds after engine failure
mu_brake=0.3;
C_D=1;
W_S=1;
L_D=1;
k_rev=0.55;
%Finding C1
C1=(1-mu_brake*L_D)*(C_D*rho*g)/(W_S);
C1;
%Finding C2
C2=2*g*(k_rev*(F_to/W)+mu_brake);
x_1=1;
%Finding x_stop
x_stop=x_1+1/C1*log(1+C1*(V_1)^2/C2);
x_stop;

%climb

V_c=295.37;
c = 1100;
M = V_c/c;
delta = 1-2*M*((1+beta)/(3+2*beta));
L_D_c=12.3;
F_W_to=F_to/W;
M_c=0.7;
%Finding V_ROC
V_ROC=V_c*(delta*F_W_to-(1/(L_D_c)))*60;
V_ROC_approx = sin_gamma_to*V_c*60;
V_ROC;

%descent

V_d=1;
L_D_d=1;
%Finding V_ROD
V_ROD=-V_d*1/(L_D_d);
V_ROD;

%landing

W_S_L=0.673*W_S_to/32.147;
Cl_max_L=2.3;
rho_sL=rho;
V_stall_L=sqrt(2*32.147*W_S_L/(Cl_max_L*rho_sL));

V_L=1.225*V_stall_L;
V_a_L=1.3*V_stall_L;
sigma=1.4;
CD_L=0.224;
L_D_L=10;
T_W_L=-0.12;
%Finding A
A=(1-mu_brake*L_D_L)*((CD_L*rho_sL*sigma)/(W_S_L));
A;
%Finding B
B=-2*g*(T_W_L-mu_brake);
B;
%Finding x_air
x_air=-(7.11*((V_L)^2 - (V_a_L)^2))/(2*g);
x_air;
%Finding x_g
x_g=(1/A)*log(1+((A*(V_L)^2)/B));
x_g;
x_g_approx=(V_L)^2/0.7;
x_L_approx=(x_air+x_g_approx)
x_L = x_air + x_g

%Stall velocity

Cl_max=1;
S=4.100e+03;
%Calculating stall velocity
V_stall=sqrt((2*W*g)/(rho*Cl_max*S));
V_stall;

%Range during climb

h_cruise=34000;
time_climb=1;
h_climb=h_cruise-V_ROC*time_climb;
h_climb;

%Range during descent

time_descent=1;
h_descent=h_cruise-V_ROD*time_descent;
h_descent;
