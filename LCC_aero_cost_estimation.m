clc
Wto=123683
x=log(0.1936+0.8645*log(Wto))
Wampr=exp(x) %%(correction required)
Nrdte=5
Vmax=295
Nst=2
CEF=3.10
Cebase=3.02
Fdiff=1.8
Fcad=0.9
Tperengine=23813
Ne=2
y=log(2.304+0.8858*log(Tperengine))    %%(correction required) 
EP=exp(y)
Cer=(CEF/Cebase)*EP
NP=0
We=65133
Tto=47625
Cavionics=2670000 %%(correction required)
MHRbase=62
Rer=(CEF/Cebase)*MHRbase

Rmanufact=34.44
Rmr=(CEF/Cebase)*Rmanufact

Fmat=2.3

Rtooling=43.06
Rtr=(CEF/Cebase)*Rtooling

Nr_r=0.33
Fobs=1
Ftsf=0.2
Fpror=0.1
Ffinr=0.1

%%RDTE Calculations

Caer=0.0396*((Wampr)^0.791)*((Vmax)^1.526)*((Nrdte)^0.183)*Fdiff*Fcad*Rer
Cdstr=0.008325*((Wampr)^0.873)*((Vmax)^1.890)*((Nrdte)^0.346)*Fdiff*CEF*Rer
C_er=((Cer*Ne)+Cavionics)*(Nrdte-Nst)
Cmanr=28.984*((Wampr)^0.740)*((Vmax)^0.543)*((Nrdte)^0.524)*Fdiff*Rmr
Cmatr=37.632*Fmat*((Wampr)^0.689)*((Vmax)^0.624)*((Nrdte)^0.792)*CEF
Ctoolr=4.0127*((Wampr)^0.764)*((Vmax)^0.899)*((Nrdte)^0.178)*Fdiff*((Nr_r)^0.066)*Rtr
Cqcr=0.13*(Cmanr)
Cftar=C_er+Cmanr+Cmatr+Ctoolr+Cqcr

Cftor=0.001244*((Wampr)^1.160)*((Vmax)^1.371)*((Nrdte-Nst)^1.281)*Fdiff*CEF*Fobs

C_RDTE=((Caedr+Cdstr+Cftar+Cftor)/(1-(Ftsf+Fpror+Ffinr)))

Ctsfr=Ftsf*C_RDTE %%Correction
Cpror=Fpror*C_RDTE
Cfinr=Ffinr*C_RDTE %%Correction

%%Acquisition cost:-
Nm=500
Nprogram=Nrdte+Nm
Rem=Rer
Cem=Cer
Rtm=Rtr
Nrm=5
Cops_hr=2500
tpft=10
Fftoh=4
Fint=2000
Fprom
Npax=150 %%no.of passengers

%%manufacturing and acquisition cost calculations

Caedm=(0.0396*((Wampr)^0.791)*((Vmax)^1.526)*((Nprogram)^0.183)*Fdiff*Fcad*Rem)-Caer
Ce_am=((Cem*Ne)+Cavionics)*Nm
Cintm=Fint*Npax*Nm*(CEF/Cebase)
Cmanm=(28.984*((Wampr)^0.740)*((Vmax)^0.543)*((Nprogram)^0.524)*Fdiff*Rmr)-Cmanr
Cmatm=(37.632*Fmat*((Wampr)^0.689)*((Vmax)^0.624)*((Nprogram)^0.792)*CEF)-Cmatr
Ctoolm=(4.0127*((Wampr)^0.764)*((Vmax)^0.899)*((Nprogram)^0.178)*Fdiff*((Nr_r)^0.066)*Rtm)-Ctoolr
Cqcm=0.13*Cmanm
Capcm=Ce_am+Cintm+Cmanm+Cmatm+Ctoolm+Cqcm
Cftom=Nm*Cops_hr*tpft*Fftoh
C_MAN=(Capcm+Caedm+Cftom)/0.9
C_PRO=Fprom*C_MAN

C_ACQ=C_MAN+C_PRO

%%Operation Cost

%%from mission data

Rbl=1500 %%block distance in nauticle miles need correction
t_gm=(0.51*(10^-6)*Wto)+0.125
t_cl=0.23 %%need correction
Rcl=64
V_de=250
H=35000
Hderate=2500
t_de=H/Hderate
Rde=V_de*t_de
Vcr=473
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
SAL_one=85000              %%need correction  
SAL_two=50000
AH_one=750
AH_two=750
TEF_one=11            %%need correction
TEF_two=11
Kj=0.26

Ccrew=((nc_one*((1+Kj)/Vbl)*(SAL_one/AH_one))+(TEF_one/Vbl))+((nc_two*((1+Kj)/Vbl)*(SAL_two/AH_two))+(TEF_two/Vbl))

%%fuel and oil cost

FP=0.65
FD=6.74
Mff=0.853
Wfbl=((1-Mff)*Wto)

Cpol=1.05*(Wfbl/Rbl)*(FP/FD)

%%Insurance cost

%%Cins=0.02*DOC

DOCflt=Ccrew+Cpol

%%Doc for maintainence
t_flt=t_cl+t_cr+t_de
Wa=We-Wpwrplt
Hem=3000

MHRmap_bl=3+0.067*(Wa/1000)
Rl_ap=16   %%will vary.need correction
Clab_ap=1.03*MHRmap_bl*Rl_ap/Vbl

MHRmeng_bl=(0.4956+(0.0532*(Tto/(Ne*1000)))*((1100/Hem)+0.1)
Rl_eng=16
Clab_eng=1.03*1.3*Ne*MHRmeng_bl*Rl_eng/Vbl

AEP=22576000
AFP=AEP-Ne*EP
ATF=1

Cmat_apblhr=(((30)*(CEF/Cebase)*ATF)+(0.79*(10^-5)*AFP))
Cmat_ap=(1.03*Cmat_apblhr)/Vbl

KHem=0.021*(Hem/1000)+0.769
ESPPF=1.5     %%may need correction
Cmateng_blhr=((5.43*(10^-5)*EP)*(ESPPF)-0.47)*(1/KHem)
Cmateng=1.03*1.3*Ne*Cmateng_blhr/Vbl
f_amblab=1.3
f_ambmat=0.6

%%Applied Maintenence Burden Cost
Camb=1.03*((f_amblab)*((MHRmap_bl)*(Rl_ap)+(Ne)*(MHReng_bl)*(Rl_eng))+(f_ambmat)*(Cmat_apblhr+(Ne)*Cmateng_blhr))/(Vbl)

DOCmaint=Clab_ap+Clab_eng+Cmat_ap+Cmateng+Camb

%%DOC of Depreciation
Fdap=0.85
ASP=2670000
DPap=10

Cdap=((Fdap)*((AEP)-(Ne)*(EP)-(ASP)))/((DPap)*(Vbl)*(Uannbl))

Fdeng=0.85
DPeng=7

Cdeng=((Fdeng)*(Ne)*(EP))/((DPeng)*(Uannbl)*(Vbl))

Cdprp=0    %%Since there are no Propellers 

Fdav=1
DPav=5
Cdav=((Fdav)*(ASP))/((DPav)*(Uannbl)*(Vbl))

Fdapsp=0.85
Fapsp=0.1
DPapsp=10

Cdapsp=((Fdapsp)*(Fapsp)*((AEP)-(Ne)*(EP)))/((DPapsp)*(Uannbl)*(Vbl))

Fdengsp=0.85
Fengsp=0.5
DPengsp=7

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

fioc=0.5
IOC=fioc*DOC

%%Total Operating Cost
Nacq=500
Rbl_ann=Vbl*Uannbl
Nyr=10

C_OPS=(DOC*(Rbl_ann)*Nacq*Nyr)+(IOC*(Rbl_ann)*Nacq*Nyr)

%%Total life cycle cost

LCC=(C_RDTE+C_ACQ+C_OPS)/0.99                 %%C_DISPOSAL=0.01*LCC

