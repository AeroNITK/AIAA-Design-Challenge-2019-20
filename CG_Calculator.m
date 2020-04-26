% Code for estimating CG of the airplane and to plot CG travel for various
% loading scenarios. All the units are in FPS unless mentioned otherwise.
% Formulas and approx assumption from commercial airplane design principles(CADP)
% UNLESS mentioned otherwise.

clear;
clc;
close all;
load('Aircraft.mat');

% Calculating cg of each component (from nose in ft)
Aircraft = fuselage_cg(Aircraft);
Aircraft = vertical_tail_cg(Aircraft);
Aircraft = wing_cg(Aircraft);
Aircraft = horizontal_tail_cg(Aircraft);
Aircraft = propulsion_cg(Aircraft);
Aircraft = NLG_cg(Aircraft);
Aircraft = MLG_cg(Aircraft);
Aircraft = fixed_equip_cg(Aircraft);
Aircraft = crew_cg(Aircraft);

% Calculating cg of empty weight of plane (from nose in ft)
Aircraft.cg.empty_weight = Aircraft.cg.fuselage*Aircraft.Weight.fuselage ...
                    +  Aircraft.cg.vtail*Aircraft.Weight.vtail ...
                    +  Aircraft.cg.wing*Aircraft.Weight.wing ...
                    +  Aircraft.cg.htail*Aircraft.Weight.htail ...
                    +  Aircraft.cg.propulsion*Aircraft.Weight.pg_ng ...
                    +  Aircraft.cg.nlg*Aircraft.Weight.nlg ...
                    +  Aircraft.cg.mlg*Aircraft.Weight.mlg ...
                    +  Aircraft.cg.fixed_equip*Aircraft.Weight.fixed_equip_weight;

Aircraft.cg.empty_weight = Aircraft.cg.empty_weight/Aircraft.Weight.empty_Weight;

% Calculating cg of Operating Empty Weight of plane (from nose in ft)
Aircraft.Weight.op_empty_weight = Aircraft.Weight.empty_Weight + Aircraft.Weight.crew + 0.01*Aircraft.Weight.fuel_Weight;

Aircraft.cg.op_empty_weight = Aircraft.cg.empty_weight * Aircraft.Weight.empty_Weight ...
                    +  Aircraft.cg.wing * 0.01 * Aircraft.Weight.fuel_Weight ...    % Fuel CG is Wing CG
                    +  Aircraft.cg.crew * Aircraft.Weight.crew;

Aircraft.cg.op_empty_weight = Aircraft.cg.op_empty_weight/Aircraft.Weight.op_empty_weight;

% Calculating cg of MTOW of plane (from nose in ft)
Aircraft.cg.MTOW = Aircraft.cg.wing * 0.99 * Aircraft.Weight.fuel_Weight ...
                 + (Aircraft.Passenger.business +  Aircraft.Passenger.economy) ...
                 * (Aircraft.Weight.baggage + Aircraft.Weight.person) ...
                 * (Aircraft.Fuselage.length_nc + Aircraft.Fuselage.length_cabin/2);
             
Aircraft.cg.MTOW = Aircraft.cg.MTOW/Aircraft.Weight.MTOW;             

% Plotting CG travel
plotting(Aircraft)
    
%     calculating cg and weight of fuselage and wing groups
%     Wcfg=fuselage.wt+Htail.wt+Vtail.wt;
%     Wcwg=wing.wt+propulsion.wt+MLG.wt;
%     Xcfg=(fuselage.wt*fuselage.cg+Vtail.wt*Vtail.cg+Htail.wt*Htail.cg)/Wcfg;
%     Xcwg=(wing.wt*wing.cg+propulsion.wt*propulsion.cg+MLG.wt*MLG.cg)/Wcwg;
% 
%     X_d=wing.MAC*0.25; %X_d= Xoe-LEMAC
%                   Torenbeek(1982):assume 20-25% MAC, CADP: assume 25-30% MAC
%     LEMAC=Xcfg+(Wcwg/Wcfg)*Xcwg-(1+Wcwg/Wcfg)*X_d; %finding the position of the wing
% 
%     fuel.cg=wing.cg+LEMAC; %assumption (to be changed)
% 
%     Xoe=LEMAC+X_d;    %operating empty cg
%     Woe=Wcfg+Wcwg; %operating empty weight
%     Woe_f=Woe+fuel.wt;
%     Xoe_f=(Xoe*Woe+fuel.cg*fuel.wt)/Woe_f; %operating empty weight + fuel
%     Woe_pb=Woe+payload.wt;
%     Xoe_pb=(Xoe*Woe+payload.cg*payload.wt)/Woe_pb; %operating empty +passenger + baggage weight
%     Wto= Woe+fuel.wt+payload.wt;
%     Xto=(Woe*Xoe+fuel.wt*fuel.cg+payload.cg*payload.wt)/Wto; %total weight
% 
%     cg_plotting( Xoe,Woe,Xto,Wto,Xoe_pb,Woe_pb,Xoe_f,Woe_f,LEMAC,wing.MAC )

%% Fuselage CG Estimation
function Aircraft = fuselage_cg(Aircraft)

    fuselage_fineness_ratio = Aircraft.Fuselage.length/Aircraft.Fuselage.diameter;
    nosecone_fineness_ratio = Aircraft.Fuselage.length_nc/Aircraft.Fuselage.diameter;
    
    Aircraft.cg.fuselage = ( Aircraft.Fuselage.length/fuselage_fineness_ratio )*( nosecone_fineness_ratio ... 
        + (fuselage_fineness_ratio - 5)/1.8 );
    
end
%% Vertical Tail CG Estimation
function Aircraft = vertical_tail_cg(Aircraft)

    Aircraft.cg.vtail = Aircraft.Fuselage.length - 18.719;  
    % 18.719 is from cad. Assumed that vertical tip trailing edge is inline with fuselage endpoint 

end
%% Wing CG Estimation
function Aircraft = wing_cg(Aircraft)
    
    Aircraft.cg.wing = Aircraft.Fuselage.length - 117.51;
    % 117.51 is from cad. Calculated from vertical tail moment arm.

end
%% Horizontal Tail CG Estimation
function Aircraft = horizontal_tail_cg(Aircraft)

    Aircraft.cg.htail = Aircraft.Fuselage.length - 10.769;  
    % 10.769 is from cad. Calculated from horizontal tail moment arm. 

end
%% Propulsion CG Estimation
function Aircraft = propulsion_cg(Aircraft)

    Aircraft.cg.propulsion = Aircraft.Fuselage.length - 143.225;  
    % 143.225 is from cad.

end
%% Nose landing CG Estimation
function Aircraft = NLG_cg(Aircraft)

    Aircraft.cg.nlg = 0.17*Aircraft.Fuselage.length;  % From CADP
    
end
%% Main landing CG Estimation
function Aircraft = MLG_cg(Aircraft)

    Aircraft.cg.mlg = 0.55*Aircraft.Fuselage.length;  % From CADP
    
end
%% Fixed Equipment CG Estimation
function Aircraft = fixed_equip_cg(Aircraft)

    Aircraft.cg.fixed_equip = 0.5*Aircraft.Fuselage.length;  
    % At the center of the fuselage (Assumption). Systems are distributed
    % in such a way that weight is equally distributed at front and back.
    % Therefore, weight at center of the fuselage.
    
end
%% Crew CG Estimation
function Aircraft = crew_cg(Aircraft)

    Aircraft.cg.crew = 0.35*Aircraft.Fuselage.length_nc*Aircraft.Crew.pilot*Aircraft.Weight.person ...
                    + (Aircraft.Fuselage.length_nc + Aircraft.Fuselage.length_cabin/2) ...
                    *  Aircraft.Crew.attendants*Aircraft.Weight.person ...
                    + (Aircraft.Crew.pilot + Aircraft.Crew.attendants)*Aircraft.Weight.baggage ...
                    * (Aircraft.Fuselage.length_nc + Aircraft.Fuselage.length_cabin/2);
                
    Aircraft.cg.crew = Aircraft.cg.crew/Aircraft.Weight.crew;            

    % Assuming that pilot is located at 0.35 of length of nose cone.
    % Assuming that flight attendants weight is in center of cabin.
    % Weight of the baggage of the crew is distributed equally around the
    % center of the cabin (in the cargo bay).
    
end
%% Plotting CG Travel
function plotting(Aircraft)

    X_LE_mac = Aircraft.Fuselage.length - 129.382;
    Xe = (Aircraft.cg.empty_weight - X_LE_mac)/Aircraft.Wing.mac;
    Xoe = (Aircraft.cg.op_empty_weight - X_LE_mac)/Aircraft.Wing.mac;
    Xmtow = (Aircraft.cg.MTOW - X_LE_mac)/Aircraft.Wing.mac;
    
    plot(Xe,Aircraft.Weight.empty_Weight,'o');
    
    hold on
    
    plot(Xoe,Aircraft.Weight.op_empty_weight,'x');
    plot(Xmtow,Aircraft.Weight.MTOW,'+');
    
    hold off
    
    title('CG Excursion Diagram')
    xlabel('Percentage of MAC')
    ylabel('Weight (lbs)')
    grid on
    
end