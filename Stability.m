clear;
clc;
close all;

d2r = pi/180;
load('Aircraft.mat');

Wing_lift_slope = 4.17;
h = 0.297;
h_ac = 0.25;

Cm_alpha_w = Wing_lift_slope * (h - h_ac);   % Pitching Moment slope for Wing

Cm_alpha_f = ( (pi/2) * (1 - 2 * Aircraft.Fuselage.diameter / Aircraft.Fuselage.length) ) ...
            *( Aircraft.Fuselage.diameter^2 * Aircraft.Fuselage.length ...
            / Aircraft.Wing.S / Aircraft.Wing.mac);  % Pitching Moment slope for Fuselage

ah = 2*pi;  % Slope of Horizontal tail lift curve
nh = 0.95;  % Tail Efficiency Factor
downwash = 2 * Wing_lift_slope / pi / Aircraft.Wing.Aspect_Ratio;

Cm_alpha_t = -ah * nh * Aircraft.Tail.Horizontal.Coeff * ( 1 - downwash );  % Pitching Moment slope for Tail

Cm_alpha = Cm_alpha_w + Cm_alpha_f + Cm_alpha_t; % Pithcing Momment slope of whole plane

neutral_point = h_ac - Cm_alpha_f / Wing_lift_slope + nh * Aircraft.Tail.Horizontal.Coeff ...
                * Cm_alpha_t * (1 - downwash) / Wing_lift_slope;
