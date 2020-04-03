%%% Function to calculate Empty Weight of an Airplane.
%%% All the equations are taken from Commercial Airplane
%%% Design Principles. Chapter No. 8. 
%%% All units are in FPS System.

function [Aircraft] = empty_weight(Aircraft)

    W_wing = Wing_Weight(Aircraft);
    W_fuselage = Fuselage_Weight(Aircraft);
    W_LG = Landing_Gear_Weight(Aircraft);
    W_tail = Tail_Weight(Aircraft);
    W_pg_ng = Propulsion_Nacelle_Group_Weight(Aircraft);
    W_fcg = Flight_Controls_group_Weight(Aircraft);
    W_apug = Auxiliary_Power_Unit_group_Weight(Aircraft);
    W_ig = Instrument_group_Weight(Aircraft);
    W_hpg = Hydra_Pneu_group_Weight(Aircraft);
    W_eg = Electrical_group_Weight(Aircraft);
    W_av = Avionics_group_Weight(Aircraft);
    W_ef = Equip_Furnish_group_Weight(Aircraft);
    W_aci = AC_Anti_Icing_group_Weight(Aircraft);
    
    Aircraft.Weight.empty_Weight = W_wing + W_fuselage + W_LG + W_tail ...
                                + W_pg_ng + W_fcg + W_apug + W_ig ...
                                + W_hpg + W_eg + W_av + W_ef + W_aci;    
    
%%  Function for calculating Wing Weight
%%% Formula taken from Commercial Airplane Design Principles
%%% Equation number 8.4; Pg. No. 306
    function W_wg = Wing_Weight(Aircraft)
    
        Kwg = 0.475;
        Sweep_hc = ;
        W_ff = 0.89;    % Wing Fudge Factor (From Raymer)    
        
        W_wg = Kwg*Aircraft.Wing.S^0.7*Aircraft.Wing.A^0.47 ...
            *(Aircraft.Weight.MTOW*Aircraft.Vndiagram.n_ult/1000)^0.52 ...
            *(0.3 + 0.7/cos(d2r*Sweep_hc)) ...
            *((1 + Aircraft.Wing.taper_ratio)/Aircraft.Wing.t_c_root)^0.4;
        
        W_wg = W_ff * W_wg;
      
    end
%%  Function for calculating Fuselage Weight
%%% Formula taken from Commercial Airplane Design Principles
%%% Equation number 8.8; Pg. No. 309
    function W_fus = Fuselage_Weight(Aircraft)
    
        Kfus = 0.0837;
        F_ff = 0.94;    % Fuselage Fudge Factor (From Raymer)
        
        W_fus = Kfus*Aircraft.Vndiagram.n_ult^0.52 ...
            *(Aircraft.Weight.MTOW)^0.33 ...
            *(Aircraft.Fuselage.length)^0.76 ...
            *(2 * Aircraft.Fuselage.diameter)^1.2;
        
        W_fus = W_fus * F_ff;
      
    end
%%  Function for calculating Landing Gear Weight
%%% Formula taken from Commercial Airplane Design Principles
%%% Equation number 8.9; Pg. No. 311
    function W_lg = Landing_Gear_Weight(Aircraft)
    
        LG_ff = 0.98;    % Landing Gear Fudge Factor (From Raymer)
        
        W_lg = 60 + 0.26*Aircraft.Weight.MTOW^0.75 ...
            + 0.19*Aircraft.Weight.MTOW ...
            + 1.7e-5*Aircraft.Weight.MTOW^1.5;
        
        W_lg = W_lg * LG_ff;
      
    end
%%  Function for calculating Tail Weight
%%% Formula taken from Commercial Airplane Design Principles
%%% Equation number 8.13 & 8.14; Pg. No. 312 & 313
    function W_t = Tail_Weight(Aircraft)
    
        T_ff = 0.85;    % Tail Fudge Factor (From Raymer)
        
        W_h = 0.00563*Aircraft.Weight.MTOW^0.6*Aircraft.Tail.Horizontal.S^0.469 ...
            *(Aircraft.Tail.Horizontal.Aspect_Ratio/cos(d2r*Aircraft.Tail.Horizontal.Sweep_hc)^2)^0.539 ...
            *((1 + Aircraft.Tail.Horizontal.taper_ratio)/Aircraft.Tail.Horizontal.t_c)^0.692;
        
        W_v = 0.0909*Aircraft.Weight.MTOW^0.333*Aircraft.Tail.Vertical.S^0.7 ...
            *(Aircraft.Tail.Vertical.Aspect_Ratio/cos(d2r*Aircraft.Tail.Vertical.Sweep_hc)^2)^0.35 ...
            *((1 + Aircraft.Tail.Vertical.taper_ratio)/Aircraft.Tail.Vertical.t_c)^0.5 ...
            *(1 + Aircraft.Tail.Horizontal.height/Aircraft.Tail.Vertical.height)^0.43;
        
        W_t = W_h + W_v;
        
        W_t = W_t * T_ff;
      
    end
%%  Function for calculating Propulsion Group + Nacelle Weight
%%% It includes Engine Weight + it's associated components like
%%% thrust reverser & water injection system + Nacelle + Pylon.
%%% Formula taken from Commercial Airplane Design Principles
%%% Equation number 8.15 & 8.19; Pg. No. 314 & 317
    function W_pg_ng = Propulsion_Nacelle_Group_Weight(Aircraft)
        
        N_ff = 0.95;% Nacelle Fudge Factor (From Raymer); 
        
        W_e = 2.7*thrust_takeoff^0.75;
        
        W_pg_ng = 4.5*(Aircraft.Engine.no_of_engines*W_e)^0.9;
        
        W_pg_ng = W_pg_ng*N_ff;
      
    end
%%  Function for calculating Flight Controls Group Weight
%%% It includes actuation systems for ailerons + rudder + elevator
%%% + rudder + Adjustable stabilizor + high lift devices.
%%% Formula taken from Commercial Airplane Design Principles
%%% Equation number 8.19; Pg. No. 38
    function W_fcg = Flight_Controls_group_Weight(Aircraft)
        
        W_fcg = 1.44*Aircraft.Weight.MTOW^0.625;
      
    end
%%  Function for calculating Auxiliary Power Unit Group Weight
%%% Formula taken from Commercial Airplane Design Principles
%%% Equation number 8.27; Pg. No. 323
    function W_apug = Auxiliary_Power_Unit_group_Weight(Aircraft)
        
        W_apug = 8*Aircraft.Weight.MTOW^0.4;
      
    end
%%  Function for calculating Instrument Group Weight
%%% Includes weights of instruments used for monitoring and control
%%% the aircraft.
%%% Formula taken from Commercial Airplane Design Principles
%%% Equation number 8.28; Pg. No. 324
    function W_ig = Instrument_group_Weight(Aircraft)
        
        W_ig = 0.55*Aircraft.Weight.MTOW^0.6;
      
    end
%%  Function for calculating Hydraulic and Pneumatic Group Weight
%%% Formula taken from Commercial Airplane Design Principles
%%% Equation number 8.30; Pg. No. 325
    function W_hpg = Hydra_Pneu_group_Weight(Aircraft)
        
        W_hpg = 0.1*Aircraft.Weight.MTOW^0.8;
      
    end
%%  Function for calculating Electrical Group Weight
%%% Formula taken from Commercial Airplane Design Principles
%%% Equation number 8.32; Pg. No. 327

    function W_eg = Electrical_group_Weight(Aircraft)
        
        W_eg = 9*Aircraft.Weight.MTOW^0.473;
      
    end
%%  Function for calculating Avionics Group Weight
%%% Formula taken from Commercial Airplane Design Principles
%%% Equation number 8.33; Pg. No. 328

    function W_av = Avionics_group_Weight(Aircraft)
        
        W_av = 600 + 0.005*Aircraft.Weight.MTOW;
      
    end
%%  Function for calculating Equipment & Furnishing Group Weight
%%% Formula taken from Commercial Airplane Design Principles
%%% Equation number 8.42; Pg. No. 332

    function W_aci = AC_Anti_Icing_group_Weight(Aircraft)
        
        W_aci = 5*Aircraft.Weight.MTOW^0.5;
      
    end
end
