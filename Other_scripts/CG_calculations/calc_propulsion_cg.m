function [ x,y ] = calc_propulsion_cg(wing,engine,nacelle )
%Calculates cg of the propulsion system ( engine+nacelle) wrt the LEMAC.
%   Detailed explanation goes here
%d = distance of engine front from leading edge
y=(0.45*wing.span)/2;

nacelle_cg=0.4*nacelle.L;

combined_cg=(engine.cg*engine.wt+nacelle_cg*nacelle.wt)/(engine.wt+nacelle.wt);
LEangle=degtorad(wing.LEangle);
x=(y*tan(LEangle)-engine.d+combined_cg)-wing.DFC*tan(LEangle);

end

