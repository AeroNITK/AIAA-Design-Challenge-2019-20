clear all
clc

fuselage.L=240.429;
fuselage.wt=41745.32+39815.52892;
fuselage.Fnc=0.976;
fuselage.Ftc=3.3;
fuselage.Fc=7.241;
Htail.Croot=20.377;
Htail.Ctip=9.068;
Htail.LEangle=27.5;
Htail.span=69.8;
Htail.wt=6152;
Htail.DFD=208.7; %distance from the nose of the airplane

Vtail.Croot=31.772;
Vtail.Ctip=15.727;
Vtail.LEangle=49.767;
Vtail.span=32.06;
Vtail.wt=2279;
Vtail.DFD=197.305; %distance of the tip of centerline from the nose of the airplane

wing.Croot=29.72480716;
wing.Ctip=8.917442148;
wing.LEangle=43.54688934;
wing.span=173.92;
wing.MAC=21.18845228;
wing.DFC=(wing.span*(wing.MAC-wing.Croot))/(2*(wing.Ctip-wing.Croot));
wing.wt=44225;
wing.Fspar=0.25;
wing.Rspar=0.6;

payload.cg=110.91;  %test case from 1st iteration aircraft (to be changed)
payload.wt=94300;

propulsion.wt=25625.84;

MLG.wt=14712.53872;

engine.wt=5091.62;
engine.L=14.034;
engine.cg=0.4*engine.L; %estimate fr test case only
engine.d=18.947; %distance of engine front from leading edge, measured from boeing 777 300 ( to be changed)

nacelle.L=engine.L; %estimate fr test case only
nacelle.wt=4546.52;

fuel.wt=138095;

[Xoe,Xf,Xpb,Xto]=CG_Calculator(wing,Htail,Vtail,engine,nacelle,MLG,fuel,payload,fuselage,propulsion)