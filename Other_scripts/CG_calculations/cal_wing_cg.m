function [ x,y ] = cal_wing_cg(wing)
%Calculates CG of the Wing wrt the LEMAC in feet

LEangle=degtorad(wing.LEangle);
y=(0.35*wing.span)/2;
c=(2*y*(wing.Ctip-wing.Croot))/wing.span+wing.Croot;
Xfs=wing.Fspar*c; %wing.Fspar =location of front spar in percentage of wing chord
Xrs=wing.Rspar*c; %wing.Rspar =location of rear spar in percentage of wing chord
x=0.7*(Xrs-Xfs)+y*tan(LEangle)-wing.DFC*tan(LEangle);

end

