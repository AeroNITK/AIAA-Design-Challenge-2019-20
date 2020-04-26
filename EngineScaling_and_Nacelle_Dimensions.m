%%Engine Scaling
%%Base Engine chosen is PW 4000-94 (model PW 4056 ) manufactured by Pratt and Whitney

clc
T_required=52343
T_actual=56750 %% (From European Aviation Safety Agency TYPE-CERTIFICATE DATA SHEET)

SF=T_required/T_actual  %%Scaling Factor

%%dimensions in meter
L_org=3.9 %% (From European Aviation Safety Agency TYPE-CERTIFICATE DATA SHEET)
L_final=L_org*(SF^0.4) %%Reymer eq.10.1


D_org=2.3876 %% from www.pw.utc.com (Pratt & Whitney official data)(fan tip diameter)
D_new=D_org*(SF^0.5) %%Reymer eq.10.2
D_final=1.3*D_new  %%(considering engine accessories attached below engine)

%%weight in kg

W_act=4272.84    %%(From European Aviation Safety Agency TYPE-CERTIFICATE DATA SHEET)
W_new=W_act*(SF^1.1) %%Reymer eq.10.3

BPR=5

%%in SI units i.e in mg/Ns

SFCmaxT=19*exp(-0.12*BPR) %%Reymer eq.10.7
SFCcruise=25*exp(-0.05*BPR) %%Reymer eq.10.9

%%Nacelle Geometry
%%for engine length of 4.29 meters length of nacelle is 6.17 meters

NSF=6.17/4.29
NL=NSF*L_final   %%Nacelle Length

%%taking length ratios for other dimensions

Intake_cowl_original=0.99
Intake_cowl_final=(Intake_cowl_original/6.17)*NL

Fan_cowl_original=1.73
Fan_cowl_final=(Fan_cowl_original/6.17)*NL

Thrustreverser_original=2.6
Thrustreverser_final=(Thrustreverser_original/6.17)*NL

Exhaustnozzle_original=0.84
Exhaustnozzle_final=(Exhaustnozzle_original/6.17)*NL

Fancowlclosed_diameter=(3.15/2.72)*D_final
Fancowlopen_dia=(5.89/2.72)*D_final