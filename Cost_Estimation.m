clc
Wto=4.293954481940373e+05
%%x=log(0.1936+0.8645*log(Wto))
Wampr=exp((0.1936+0.8645*log(Wto))) %% INVERSE LOG
Nrdte=5          %%average of 2-6 as given in Roskam
Vmax=475.33  %% At cruise altitude 34000 and M_cruise 0.8212
Nst=2
CEF=258.115
Cebase=251.712
Fdiff=2
Fcad=0.8  %% Manufacturer Experienced in CAD
Tperengine=5.187703166293423e+04
Ne=2
%%y=log(2.304+0.8858*log(Tperengine))    
EP=exp((2.304+0.8858*log(Tperengine)))    %%INVERSE LOG 
Cer=(CEF/Cebase)*EP
NP=0
We=2.120197991502634e+05   %%Empty Weight    
Tto=2*Tperengine
AMP=(CEF/Cebase)*exp((3.3191+0.8043*log(Wto)))     %%Aircraft Market Price as per pg.38 of Roskam 
Cavionics=0.1*AMP %% as per pg 38 of Roskam part VIII
MHRbase=33     %%in dollars. as per https://www.salary.com
Rer=(CEF/Cebase)*MHRbase

Rmanufact=21.9  %% in dollars according to tradingeconomics.com
Rmr=(CEF/Cebase)*Rmanufact

Fmat=2

Rtooling=43.06*(CEF/Cebase)    %% tooling manhour rate NEEDS CORRECTION
Rtr=(CEF/Cebase)*Rtooling

Nr_r=0.33      
%%next 4 variables take values as per assumption in Roskam
Fobs=1
Ftsf=0.2
Fpror=0.1
Ffinr=0.1

%%RDTE Calculations

Caer=0.0396*((Wampr)^0.791)*((Vmax)^1.526)*((Nrdte)^0.183)*Fdiff*Fcad*Rer
Cdstr=0.008325*((Wampr)^0.873)*((Vmax)^1.890)*((Nrdte)^0.346)*Fdiff*11.6*Rer
C_er=((Cer*Ne)+Cavionics)*(Nrdte-Nst)
Cmanr=28.984*((Wampr)^0.740)*((Vmax)^0.543)*((Nrdte)^0.524)*Fdiff*Rmr
Cmatr=37.632*Fmat*((Wampr)^0.689)*((Vmax)^0.624)*((Nrdte)^0.792)*11.6
Ctoolr=4.0127*((Wampr)^0.764)*((Vmax)^0.899)*((Nrdte)^0.178)*Fdiff*((Nr_r)^0.066)*Rtr
Cqcr=0.13*(Cmanr)
Cftar=C_er+Cmanr+Cmatr+Ctoolr+Cqcr

Cftor=0.001244*((Wampr)^1.160)*((Vmax)^1.371)*((Nrdte-Nst)^1.281)*Fdiff*11.6*Fobs

C_RDTE=((Caer+Cdstr+Cftar+Cftor)/(1-(Ftsf+Fpror+Ffinr)))

Ctsfr=Ftsf*C_RDTE %%Correction
Cpror=Fpror*C_RDTE
Cfinr=Ffinr*C_RDTE %%Correction

%%Acquisition cost:-
Nm=500
Nprogram=Nrdte+Nm
Rem=Rer
Cem=Cer
Rtm=Rtr
Nrm=5                 %%unit production rate per month.can vary. Assumed as per roskam
Cops_hr=2500          %%NEED CORRECTION
tpft=10
Fftoh=4
Fint=2000           %%according to pg 52 of Roskam
Fprom=0.1           %% pg.56 of Roskam
Npax=400 %%no.of passengers

%%manufacturing and acquisition cost calculations

Caedm=(0.0396*((Wampr)^0.791)*((Vmax)^1.526)*((Nprogram)^0.183)*Fdiff*Fcad*Rem)-Caer
Ce_am=((Cem*Ne)+Cavionics)*Nm
Cintm=Fint*Npax*Nm*(CEF/Cebase)
Cmanm=(28.984*((Wampr)^0.740)*((Vmax)^0.543)*((Nprogram)^0.524)*Fdiff*Rmr)-Cmanr
Cmatm=(37.632*Fmat*((Wampr)^0.689)*((Vmax)^0.624)*((Nprogram)^0.792)*11.6)-Cmatr
Ctoolm=(4.0127*((Wampr)^0.764)*((Vmax)^0.899)*((Nprogram)^0.178)*Fdiff*((Nr_r)^0.066)*Rtm)-Ctoolr
Cqcm=0.13*Cmanm
Capcm=Ce_am+Cintm+Cmanm+Cmatm+Ctoolm+Cqcm
Cftom=Nm*Cops_hr*tpft*Fftoh
C_MAN=(Capcm+Caedm+Cftom)/0.9
C_PRO=Fprom*C_MAN

C_ACQ=C_MAN+C_PRO

%%Operation Cost

%%from mission data

Rbl=3503 %%block distance in nauticle miles need correction
t_gm=(0.51*(10^-6)*Wto)+0.125   %%ground maneuver time
t_cl=13 %%13 minutes 
Rcl=25 %%needs correction
H=34000   
Hderate=2500  %%Average descent rate in ft/min, as per pg 118 Roskam part 8
t_de=H/Hderate
Rde=60      %%V_de*t_de
V_de=Rde/t_de  
Vcr=475.33   %%At 34000 ft and Mach=0.8212    
Vman=Vcr
t_man=(0.25*(10^-6)*Wto)+0.0625
Rman=Vman*t_man
t_cr=((1.01*Rbl)-Rcl-Rde+Rman)/Vcr
t_bl=t_gm+t_cl+t_cr+t_de
Vbl=Rbl/t_bl
Uannbl=(10^3)*(3.4546*(t_bl)+2.994-((12.289*(t_bl^2)-5.6626*(t_bl)+8.964)^0.5))

%%Doc Calculations

%%Direct operating cost of flying

%%Crew cost

nc_one=1
nc_two=1
nc_three=0
SAL_one=198305              %% Average american captain yearly pay as per www.indeed.com 
SAL_two=53898               %% Average american first officer/co-pilot yearly pay as per www.indeed.com 
AH_one=750
AH_two=750
TEF_one=11*(CEF/130.7)            %%130.7 is Annual CPI of 1990  
TEF_two=11*(CEF/130.7)
Kj=0.26

Ccrew=((nc_one*((1+Kj)/Vbl)*(SAL_one/AH_one))+(TEF_one/Vbl))+((nc_two*((1+Kj)/Vbl)*(SAL_two/AH_two))+(TEF_two/Vbl))

%%fuel and oil cost

FP=0.407  %% in USD/gallon as per www.iata.org   
FD=6.74   %%For Jet A fuel in lbs/gallon. taken from Roskam
Mff=0.853        %% NEED CORRECTION
Wfbl=((1-Mff)*Wto)

Cpol=1.05*(Wfbl/Rbl)*(FP/FD)  %% As per eq. 5.30 of Roskam

%%Insurance cost

%%Cins=0.02*DOC

DOCflt=Ccrew+Cpol

%%Doc for maintainence
t_flt=t_cl+t_cr+t_de
Wpwrplt=2.969605150565190e+04
Wa=We-Wpwrplt
Hem=4000     %%as per Roskam

MHRmap_bl=3+0.067*(Wa/1000)
Rl_ap=16*(CEF/130.7)   %% Extrapolated the maintainence cost per manhour according to CPI index
Clab_ap=1.03*MHRmap_bl*Rl_ap/Vbl

MHRmeng_bl=(0.4956+(0.0532*(Tto/(Ne*1000)))*((1100/Hem)+0.1))
Rl_eng=16*(CEF/130.7)    %% Extrapolated the engineering cost per manhour according to CPI index
Clab_eng=1.03*1.3*Ne*MHRmeng_bl*Rl_eng/Vbl

AEP=(C_MAN+C_PRO+C_RDTE)/Nm
AFP=AEP-Ne*EP
ATF=1

Cmat_apblhr=(((30)*(CEF/Cebase)*ATF)+(0.79*(10^-5)*AFP))
Cmat_ap=(1.03*Cmat_apblhr)/Vbl

KHem=0.021*(Hem/1000)+0.769
ESPPF=1.5     %%From pg 106 Roskam. Might Change 
Cmateng_blhr=((5.43*(10^-5)*EP)*(ESPPF)-0.47)*(1/KHem)
Cmateng=1.03*1.3*Ne*Cmateng_blhr/Vbl
f_amblab=1.2        %%As of pg 102 Roskam. Might vary
f_ambmat=0.55       %%As of pg 102 Roskam. Might vary

%%Applied Maintenence Burden Cost
Camb=1.03*((f_amblab)*((MHRmap_bl)*(Rl_ap)+(Ne)*(MHRmeng_bl)*(Rl_eng))+(f_ambmat)*(Cmat_apblhr+(Ne)*Cmateng_blhr))/(Vbl)

DOCmaint=Clab_ap+Clab_eng+Cmat_ap+Cmateng+Camb

%%DOC of Depreciation
Fdap=0.85     %% From Table 5.7, pg 107, Roskam
ASP=Cavionics
DPap=10

Cdap=((Fdap)*((AEP)-(Ne)*(EP)-(ASP)))/((DPap)*(Vbl)*(Uannbl))

Fdeng=0.85  %% from table 5.7 Roskam part 8
DPeng=7     %% from table 5.7 Roskam part 8

Cdeng=((Fdeng)*(Ne)*(EP))/((DPeng)*(Uannbl)*(Vbl))

Cdprp=0    %%Since there are no Propellers 

Fdav=1   %% table 5.7 Roskam Part VIII
DPav=5   %% table 5.7 Roskam Part VIII
Cdav=((Fdav)*(ASP))/((DPav)*(Uannbl)*(Vbl))

Fdapsp=0.85     %% table 5.7 Roskam Part VIII
Fapsp=0.1        %% table 5.7 Roskam Part VIII
DPapsp=10         %% table 5.7 Roskam Part VIII

Cdapsp=((Fdapsp)*(Fapsp)*((AEP)-(Ne)*(EP)))/((DPapsp)*(Uannbl)*(Vbl))

Fdengsp=0.85        %% table 5.7 Roskam Part VIII
Fengsp=0.5           %% table 5.7 Roskam Part VIII
DPengsp=7             %% table 5.7 Roskam Part VIII

Cdengsp=((Fdengsp)*(Fengsp)*(Ne)*(EP)*(ESPPF))/((DPengsp)*(Uannbl)*(Vbl))

DOCdepr=Cdap+Cdeng+Cdav+Cdengsp+Cdapsp+Cdprp

%%DOC of landing, Navigation and Registry Taxes

Caplf=0.002*Wto
Clf=Caplf/(Vbl*t_bl)

Capnf=10
Cnf=Capnf/(Vbl*t_bl)
frt=0.001+((10^-8)*Wto)
%%Crt=frt*DOC

DOClnr=Clf+Cnf

%%DOC of Financing

%%DOCfin=0.07*DOC

%%Total DOC

DOC=(DOCflt+DOCmaint+DOCdepr+DOClnr)/(1-(0.07+0.02+0.001+((10^-8)*Wto)))

%%IOC Calculations

fioc=0.54      %%as per fig 5.12 pg 112 of Roskam Part VIII
IOC=fioc*DOC

%%Total Operating Cost
Nacq=500
Rbl_ann=Vbl*Uannbl
Nyr=10

C_OPS=(DOC*(Rbl_ann)*Nacq*Nyr)+(IOC*(Rbl_ann)*Nacq*Nyr)

%%Total life cycle cost

LCC=(C_RDTE+C_ACQ+C_OPS)/0.99   %%C_DISPOSAL=0.01*LCC
C_DISPOSAL=0.01*LCC  %%As per Roskam Part VIII

%%x=[C_OPS,C_DISPOSAL,C_RDTE,C_ACQ];
%%pie(x);
