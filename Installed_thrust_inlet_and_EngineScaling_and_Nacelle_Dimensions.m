%%installation losses calculation
%%Pressure recovery loss
C_ram=1.35       %%From Reymer
Precovery_ref= 1  %%Reymer
Precovery_actual=0.96      %% Value taken from reymer section 13.3.1
Percent_lossP=(C_ram*(Precovery_ref-Precovery_actual)*100)

Distortionloss=0

%%Bleed loss
mr=0.03    %% From Roskam Chapter 6 Table 6.1
Cbleed =2
Percent_lossB =Cbleed*mr*100  %% Reymer eq.13.8

hp_extract=0
nozzleeffect=0

Insll_losspercent =Percent_lossB+Percent_lossP+Distortionloss+hp_extract+nozzleeffect

%%Engine Scaling
%%Base Engine chosen is PW 4000-94 (model PW 4462 ) manufactured by Pratt and Whitney

clc
T_required =52343
T_actual =62000 %% (From European Aviation Safety Agency TYPE-CERTIFICATE DATA SHEET)

T_instll=T_actual-((Insll_losspercent/100)*T_actual)
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
%%All original lengths taken from A330 AIRCRAFT CHARACTERISTICS - AIRPORT
%%AND MAINTENANCE PLANNING Report

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

%%inlet Geometry

k_gas=0.0011 %%Roskam eq.6.20
m_gas=k_gas*T_instll*0.454  %%in kg/sec
m_cool=0.06*m_gas     %%Roskam eq. 6.21
m_air=m_gas+m_cool    %%Roskam eq. 6.19

Vmax=250.8 %%in meter per sec. for altitude 40,000 ft and mach 0.85
density=0.302  %%atmospheric density at 40,000 ft in kg/cubic meter

Ac=(m_air/(density*Vmax))  %% Capture area as per roskam eq.6.22




