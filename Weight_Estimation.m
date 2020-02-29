% Code for Weight Estimation
% - Statistical Estimates are taken from "Aircraft Design: A Conceptual
%   Approach" by Daniel Raymer.
% - All the lengths and Area should be in feets.

function [] = Weight_Estimation()
    Wing_Weight = 0.0051*(Wdg*Nz)^0.557*Sw^0.649*A^0.5...
                    *thickness_ratio^(-0.4)*(1 + lamda)^0.1...
                    *cos(Sweep_25)^(-1.0)*S_csw^0.1;
                
    Horizontal_Tail_Weight = 0.0379*K_uht*(1 + Fw/Bh)^(-0.25)...
                             *Wdg^0.639*Nz^0.1*S_ht^0.75*L_ht^-1.0...
                             *K_y^0.704*cos(Sweep_ht)^-1*A_h^0.166...
                             *(1 + S_e/S_ht)^0.1;
                         
    Vertical_Tail_Weight = 0.0026*(1 + Ht_by_Hv)^0.225*Wdg^0.556*Nz^0.536...
                           *L_vt^-0.5*S_vt^0.5*K_z^0.875*cos(Sweep_vt)^-1.0...
                           *A_v^0.35*thickness_ratio^-0.5;
                        
    Fuselage_Weight = 0.328*K_door*K_Lg*(Wdg*Nz)^0.5*L^0.25*S_f^0.302...
                      *(1 + K_ws)^0.04*(L/D)^0.1;
                  
    Main_LG_Weight = 0.0106*K_mp*W_L^0.888*N_L^0.25*L_m^0.4...
                     *N_mw^0.321*N_mss^-0.5*V_stall^0.1;
                 
    Nose_LG_Weight = 0.032*K_ng*W_L^0.646*N_L^0.2*L_n^0.5*N_nw^0.45;
    
    Nacelle_Weight = 0.6724*K_ng*N_Lt^0.1*N_w^0.294*N_z^0.119*Wec^0.611...
                     *N_en^0.984*S_n^0.224;
                 
    Engine_Controls_Weight = 5*N_en + 0.8*L_ec;
    
    Starter_Weight = 49.19*(N_en*W_en/1000)^0.541;
    
    Fuel_System_Weight = 2.405*V_t^0.606*(1 + V_i/V_t)^-1.0...
                         *(1 + V_p/V_t)*N_t^0.5;
                     
    Flight_Control_Weight = 145.9*N_f^0.554*(1 + N_m/N_f)^-1.0*S_cs^0.2...
                            *(I_y * 1e-6)^0.07;
                        
    APU_Weight = 2.2*W_APU_uninst;
    
    Instruments_Weight = 4.509*K_r*K_tp*N_c^0.549*N_en*(L_f + B_w)^0.5;
    
    Hydraulics_Weight = 0.2673*N_f*(L_f + B_w)^0.937;
    
    Electrical_System_Weight = 7.291*R_kva^0.782*L_a^0.346*N_gen^0.1;
    
    Avionics_Weight = 1.73*W_uav^0.983;
    
    Furnishing_Weight = 0.0577*N_c^0.1*W_c^0.393*S_f^0.75;
    
    Air_Conditioning_Weight = 62.36*N_p^0.25*(V_pr/1000)^0.604*W_APU_uninst^0.1;
    
    Anti_Ice_System_Weight = 0.002*Wdg;
    
    Handling_Gear = 3e-4*Wdg;
    
%% Fudge Factors
    Wing_Weight = Wing_Weight*0.89; % Range is 0.85-0.9
    Horizontal_Tail_Weight = Horizontal_Tail_Weight*0.85; %Range is 0.83-0.88
    Vertical_Tail_Weight = Vertical_Tail_Weight*0.85; %Range is 0.83-0.88
    Fuselage_Weight = Fuselage_Weight*0.94; %Range is 0.9-0.95
    Nacelle_Weight = Nacelle_Weight*0.94; %Range is 0.9-0.95
    Main_LG_Weight = Main_LG_Weight*0.98; %Range is 0.95-1.0
    Nose_LG_Weight = Nose_LG_Weight*0.98; %Range is 0.95-1.0
    
end