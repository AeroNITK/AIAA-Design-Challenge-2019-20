function [ x,y] = calc_Htail_cg(Htail)
%Calculates the CG of the horizonatal tail wrt Datum in feet.
%DFD= distance from datum.
%   First Y cg is found. Then the chord length at y CG is found. Then
%   distance from the leading edge is added to the location of the CG on
%   the chord length.
% DFD= distance from the nose of the airplane
LEangle=degtorad(Htail.LEangle);
y=(0.38*Htail.span)/2;
c=(Htail.span/2)*((y-(Htail.span/2))/(Htail.Ctip-Htail.Croot));
x=0.42*c+y*tan(degtorad(LEangle))+Htail.DFD;


end

