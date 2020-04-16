function [ x,z ] = calc_Vtail_cg(Vtail)
%Calculates the CG of the vertical tail wrt to the datum in feet.
%   First Y cg is found. Then the chord length at y CG is found. Then
%   distance from the leading edge is added to the location of the CG on
%   the chord length.
% DFD=distance of the tip of centerline from the nose of the airplane
LEangle=degtorad(Vtail.LEangle);
z=0.38*Vtail.span;
c=(Vtail.span/2)*((z-(Vtail.span/2))/(Vtail.Ctip-Vtail.Croot));
x=0.42*c+z*tan(degtorad(LEangle))+Vtail.DFD;

end

