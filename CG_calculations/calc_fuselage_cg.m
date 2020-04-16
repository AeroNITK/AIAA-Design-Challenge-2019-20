function [ x ] = calc_fuselage_cg( fuselage )
%Calculates the cg of the fuselage wrt nose
%includes fixed equipment

F=0.9*fuselage.Fc+5;
x=(fuselage.L/F)*(fuselage.Fnc+(F-5)/1.8);

end

