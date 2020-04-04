%  Tail Sizing
%  ------------------------------------------------------------------------
%  Input : Aircraft structure datatpye.
%  Output : Aircraft sturcture datatype with appended Tail.
%  All units are in FPS System.
%  ------------------------------------------------------------------------

function Aircraft = Tail_Sizing(Aircraft)

    d2r = pi/180;

    %% Horizontal Tail
    Aircraft.Tail.Horizontal.Coeff = 0.9775;    % Horizontal Tail Volume Coefficient
    Aircraft.Tail.Horizontal.arm = 67.725;    % Horizontal Tail Moment Arm (in ft)
    Aircraft.Tail.Horizontal.Aspect_Ratio = 4.75;   % Avg data from Roskam   
    Aircraft.Tail.Horizontal.taper_ratio = 0.445;   % Avg data from Roskam
    Aircraft.Tail.Horizontal.dihedral = 5.5;    % Avg data from Roskam (in deg)
    Aircraft.Tail.Horizontal.Sweep_qc = 27.5;   % qc = Quaterchord - Avg data from Roskam(in deg)
    
    Aircraft.Tail.Horizontal.S = (Aircraft.Tail.Horizontal.Coeff*Aircraft.Wing.S...
                                *Aircraft.Wing.mac)/(Aircraft.Tail.Horizontal.arm);
                            
    Aircraft.Tail.Horizontal.b = sqrt(Aircraft.Tail.Horizontal.Aspect_Ratio...
                                *Aircraft.Tail.Horizontal.S);
                            
    Aircraft.Tail.Horizontal.chord_root = 2*Aircraft.Tail.Horizontal.S/(Aircraft.Tail.Horizontal.b ...
                            *(1 + Aircraft.Tail.Horizontal.taper_ratio));
                        
    Aircraft.Tail.Horizontal.chord_tip = Aircraft.Tail.Horizontal.taper_ratio * Aircraft.Tail.Horizontal.chord_root;
    
    Aircraft.Tail.Horizontal.Sweep_LE = atan(tan(Aircraft.Tail.Horizontal.Sweep_qc*d2r) - (Aircraft.Tail.Horizontal.chord_root...
                        *(Aircraft.Tail.Horizontal.taper_ratio - 1))/2/Aircraft.Tail.Horizontal.b)/d2r;
                    
    Aircraft.Tail.Horizontal.Sweep_hc = atan( tan(Aircraft.Tail.Horizontal.Sweep_qc*d2r) - ...
                                        (1 - Aircraft.Tail.Horizontal.taper_ratio)...
                                        /(Aircraft.Tail.Horizontal.Aspect_Ratio*(1 + Aircraft.Tail.Horizontal.taper_ratio)) )/d2r;
                                    
    Aircraft.Tail.Horizontal.mac = 2*Aircraft.Tail.Horizontal.chord_root*(1 + Aircraft.Tail.Horizontal.taper_ratio ...
                        + Aircraft.Tail.Horizontal.taper_ratio^2)/(3*(1 + Aircraft.Tail.Horizontal.taper_ratio));
                    
    Aircraft.Tail.Horizontal.Y = (Aircraft.Tail.Horizontal.b/6)*(1 + 2*Aircraft.Tail.Horizontal.taper_ratio) ...
                        *(1 + Aircraft.Tail.Horizontal.taper_ratio);
    
    Aircraft.Tail.Horizontal.t_c = 0.12;    % NACA 0012
    
    %% Vertical Tail
    Aircraft.Tail.Vertical.Coeff = 0.084;    % Vertical Tail Volume Coefficient
    Aircraft.Tail.Vertical.arm = 67.725;    % Vertical Tail Moment Arm (in ft)
    Aircraft.Tail.Vertical.Aspect_Ratio = 1.35;   % Avg data from Roskam   
    Aircraft.Tail.Vertical.taper_ratio = 0.495;   % Avg data from Roskam
    Aircraft.Tail.Vertical.dihedral = 90;    % Avg data from Roskam (in deg)
    Aircraft.Tail.Vertical.Sweep_qc = 43;   % qc = Quaterchord - Avg data from Roskam(in deg)
    
    Aircraft.Tail.Vertical.S = (Aircraft.Tail.Vertical.Coeff*Aircraft.Wing.S...
                                *Aircraft.Wing.mac)/(Aircraft.Tail.Vertical.arm);
                            
    Aircraft.Tail.Vertical.b = sqrt(Aircraft.Tail.Vertical.Aspect_Ratio...
                                *Aircraft.Tail.Vertical.S);
                            
    Aircraft.Tail.Vertical.chord_root = 2*Aircraft.Tail.Vertical.S/(Aircraft.Tail.Vertical.b ...
                            *(1 + Aircraft.Tail.Vertical.taper_ratio));
                        
    Aircraft.Tail.Vertical.chord_tip = Aircraft.Tail.Vertical.taper_ratio * Aircraft.Tail.Vertical.chord_root;
    
    Aircraft.Tail.Vertical.Sweep_LE = atan(tan(Aircraft.Tail.Vertical.Sweep_qc*d2r) - (Aircraft.Tail.Vertical.chord_root...
                        *(Aircraft.Tail.Vertical.taper_ratio - 1))/2/Aircraft.Tail.Vertical.b)/d2r;
                    
    Aircraft.Tail.Vertical.Sweep_hc = atan( tan(Aircraft.Tail.Vertical.Sweep_qc*d2r) - ...
                                        (1 - Aircraft.Tail.Vertical.taper_ratio)...
                                        /(Aircraft.Tail.Vertical.Aspect_Ratio*(1 + Aircraft.Tail.Vertical.taper_ratio)) )/d2r;
                                    
    Aircraft.Tail.Vertical.mac = 2*Aircraft.Tail.Vertical.chord_root*(1 + Aircraft.Tail.Vertical.taper_ratio ...
                        + Aircraft.Tail.Vertical.taper_ratio^2)/(3*(1 + Aircraft.Tail.Vertical.taper_ratio));
                    
    Aircraft.Tail.Vertical.Y = (Aircraft.Tail.Vertical.b/6)*(1 + 2*Aircraft.Tail.Vertical.taper_ratio) ...
                        *(1 + Aircraft.Tail.Vertical.taper_ratio);
    
    Aircraft.Tail.Vertical.t_c = 0.12;    % NACA 0012

end