% This script file estimates the values of static stability derivatives and
% static margin. Formulas are based on CADP and RC Nelson.

clear;
clc;
close all;

d2r = pi/180;
load('Aircraft.mat');

%% Pitching Moment & Static Margin Calculation

Wing_lift_slope = Aircraft.Lift.lift_slope_M082; % Wing lift curve slope (in 1/rad)
h = 0.297;  % Most aft CG ( fraction of Mean Aerodynamic Chord)
h_ac = 0.25;    % Mean Aerodynamic Center ( fraction of Mean Aerodynamic Chord)

Aircraft.Stability.Cm_alpha_w = Wing_lift_slope * (h - h_ac);   % Pitching Moment slope for Wing

Aircraft.Stability.Cm_alpha_f = ( (pi/2) * (1 - 2 * Aircraft.Fuselage.diameter / Aircraft.Fuselage.length) ) ...
            *( Aircraft.Fuselage.diameter^2 * Aircraft.Fuselage.length ...
            / Aircraft.Wing.S / Aircraft.Wing.mac);  % Pitching Moment slope for Fuselage

beta = sqrt(1 - Aircraft.Performance.M_cruise^2);
k = 7.16/2/pi; 
        
Aircraft.Tail.Horizontal.Sweep_maxtc = atan( tan(d2r*Aircraft.Tail.Horizontal.Sweep_LE) ...   % Sweepback angle of Maximum Thickness Chord
                            - ( 4*0.3*(1 - Aircraft.Tail.Horizontal.taper_ratio) ) ...
                            / ( Aircraft.Tail.Horizontal.Aspect_Ratio*(1 + Aircraft.Tail.Horizontal.taper_ratio) ) )/d2r;
                
Aircraft.Tail.Horizontal.lift_slope = 2*pi*Aircraft.Tail.Horizontal.Aspect_Ratio ...
                    / ( 2 + ( (Aircraft.Tail.Horizontal.Aspect_Ratio*beta/k)^2 ...
                    * ( 1 + ( tan(d2r*Aircraft.Tail.Horizontal.Sweep_hc)/beta)^2 ) + 4 )^0.5 ); % Lift slope of Horizontal Tail

nh = 0.95;  % Tail Efficiency Factor
downwash = 2 * Wing_lift_slope / pi / Aircraft.Wing.Aspect_Ratio;   % Downwash (calculated from RC Nelson)

Aircraft.Stability.Cm_alpha_t = -Aircraft.Tail.Horizontal.lift_slope * nh * Aircraft.Tail.Horizontal.Coeff * ( 1 - downwash );  % Pitching Moment slope for Tail

Aircraft.Stability.Cm_alpha = Aircraft.Stability.Cm_alpha_w + Aircraft.Stability.Cm_alpha_f ...
                            + Aircraft.Stability.Cm_alpha_t; % Pithcing Moment slope of whole plane

Aircraft.Stability.neutral_point = h_ac - Aircraft.Stability.Cm_alpha_f / Wing_lift_slope + nh * Aircraft.Tail.Horizontal.Coeff ...
                * Aircraft.Tail.Horizontal.lift_slope * (1 - downwash) / Wing_lift_slope;    % Neutral Point Position (in terms of Mean Aerodynamic Chord)
            
Aircraft.Stability.static_margin_power_on = ( Aircraft.Stability.neutral_point - h );    % Static Margin (in terms of Mean Aerodynamic Chord)

Aircraft.Stability.static_margin_power_off = ( Aircraft.Stability.neutral_point - h ) + 0.03;    % Power off shift in neutral point is 0.03. (From CADP)

%% Directional Moment Calculation

Reynolds_number_fuselage = Aircraft.Performance.M_cruise * 977.28 * Aircraft.Fuselage.length / 0.000397;

Krl = 2.25; % From RC Nelson

Sf = 3767.935;  % From CAD. Sideview Projected Area ( in ft^2 )

kn = 0.0009;    % From RC Nelson

Aircraft.Stability.Cn_beta_wing_fuse = - kn * Krl * Sf * Aircraft.Fuselage.length ...
                                / Aircraft.Wing.S / Aircraft.Wing.b;    % Cn_beta for Wing and Fuselage Combined

Aircraft.Stability.Cn_beta_wing_fuse = Aircraft.Stability.Cn_beta_wing_fuse / d2r;
                            
Aircraft.Tail.Vertical.lift_slope = 2*pi*Aircraft.Tail.Vertical.Aspect_Ratio ...
                    / ( 2 + ( (Aircraft.Tail.Vertical.Aspect_Ratio*beta/k)^2 ...
                    * ( 1 + ( tan(d2r*Aircraft.Tail.Vertical.Sweep_hc)/beta)^2 ) + 4 )^0.5 );
                
Factor = 0.724 + 3.06 * Aircraft.Tail.Vertical.S / Aircraft.Wing.S / ( 1 + cos(d2r * Aircraft.Wing.Sweep_qc) ) ...
        + 0.4 * 8 / Aircraft.Fuselage.diameter + 0.009 * Aircraft.Wing.Aspect_Ratio;    % Factor for V Tail Effectiveness and Sidewash                
                            
Aircraft.Stability.Cn_beta_tail = Aircraft.Tail.Vertical.Coeff * Aircraft.Tail.Vertical.lift_slope * Factor;    

Aircraft.Stability.Cn_beta = Aircraft.Stability.Cn_beta_wing_fuse + Aircraft.Stability.Cn_beta_tail;    % Directional Moment slope of whole plane

%% Lateral Moment Calculation

Aircraft.Stability.Cl_beta_fuse = 0.0006 / d2r; % Fuselage Contribution to Lateral Moment (NPTEL FD - II)

Aircraft.Stability.Cl_beta_wing = -0.25 * Aircraft.Wing.Dihedral * d2r * Wing_lift_slope ...
                    * ( 2*(1 + 2*Aircraft.Wing.taper_ratio) / 3*(1 + Aircraft.Wing.taper_ratio) );  % Cl_beta due to wing dihedral
                
Aircraft.Stability.Cl_beta_wing = Aircraft.Stability.Cl_beta_wing - 0.4052 * sin( d2r * 2 * Aircraft.Wing.Sweep_LE) ...
                                    * Aircraft.Wing.Y / Aircraft.Wing.b;    % Cl_beta due to wing sweep   
                                
Aircraft.Stability.Cl_beta_vtail = - 0.95 * Aircraft.Tail.Vertical.S * 23.54 * Aircraft.Tail.Vertical.lift_slope ...
                                / Aircraft.Wing.S / Aircraft.Wing.b ;    % Cl_beta due to Vertical Tail                                 

Aircraft.Stability.Cl_beta =  Aircraft.Stability.Cl_beta_wing + Aircraft.Stability.Cl_beta_fuse ...
                                + Aircraft.Stability.Cl_beta_vtail;

save('Aircraft.mat','Aircraft','-append');

clear;
clc;
