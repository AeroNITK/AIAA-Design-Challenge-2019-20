%  Aircraft Sizing based on independent variables
%  ------------------------------------------------------------------------
%  Input : Aircraft structure datatpye.
%  Output : Aircraft sturcture datatype with appended Dimensions of Wing,
%  Tail, Fuselage, Propulsion.
%  All units are in FPS System.
%  ------------------------------------------------------------------------

function Aircraft = Sizing(Aircraft)
    
    d2r = pi/180;
    in2ft = 1/12;
    
    Aircraft = Wing_Sizing(Aircraft);
    
    Aircraft = Fuselage_Sizing(Aircraft);
    
    Aircraft = Tail_Sizing(Aircraft);
    
    Aircraft = Prop_Sizing(Aircraft);
    
    %% Wing Sizing
    function Aircraft = Wing_Sizing(Aircraft)
        
        Aircraft.Wing.Aspect_Ratio = 9;
        Aircraft.Wing.S = Aircraft.Weight.MTOW/Aircraft.Performance.WbyS;
        Aircraft.Wing.b = sqrt(Aircraft.Wing.Aspect_Ratio*Aircraft.Wing.S);
        Aircraft.Wing.taper_ratio = 0.3;
        Aircraft.Wing.Sweep_qc = 35;
        Aircraft.Wing.chord_root = 2*Aircraft.Wing.S/(Aircraft.Wing.b*(1 + Aircraft.Wing.taper_ratio));
        Aircraft.Wing.Sweep_LE = atan(tan(Aircraft.Wing.Sweep_qc*d2r) - (Aircraft.Wing.chord_root...
                            *(Aircraft.Wing.taper_ratio - 1))/2/Aircraft.Wing.b)/d2r;
        Aircraft.Wing.Sweep_hc = atan( tan(Aircraft.Wing.Sweep_qc*d2r) - ...
                                            (1 - Aircraft.Wing.taper_ratio)...
                                            /(Aircraft.Wing.Aspect_Ratio*(1 + Aircraft.Wing.taper_ratio)) )/d2r;                
        Aircraft.Wing.chord_tip = Aircraft.Wing.chord_root*Aircraft.Wing.taper_ratio;
        Aircraft.Wing.mac = 2*Aircraft.Wing.chord_root*(1 + Aircraft.Wing.taper_ratio ...
                            + Aircraft.Wing.taper_ratio^2)/(3*(1 + Aircraft.Wing.taper_ratio));
        Aircraft.Wing.Y = (Aircraft.Wing.b/6)*(1 + 2*Aircraft.Wing.taper_ratio) ...
                            *(1 + Aircraft.Wing.taper_ratio);

        Aircraft.Wing.Dihedral = 3;
        Aircraft.Wing.incidence = 1;
        Aircraft.Wing.t_c_root = 0.15;
        
    end

    %% Tail Sizing
    function Aircraft = Tail_Sizing(Aircraft)
        % ------------------------------------------------------------------------------------------------------------------------
        %%% Horizontal Tail
        % ------------------------------------------------------------------------------------------------------------------------
        Aircraft.Tail.Horizontal.Coeff = 0.82;    % Horizontal Tail Volume Coefficient - Avg data from CADP
        Aircraft.Tail.Horizontal.arm = 0.49*Aircraft.Fuselage.length;    % Horizontal Tail Moment Arm (in ft)
        Aircraft.Tail.Horizontal.Aspect_Ratio = 4.57;   % Avg data from CADP   
        Aircraft.Tail.Horizontal.taper_ratio = 0.34;   % Avg data from CADP
        Aircraft.Tail.Horizontal.dihedral = 5.5;    % Avg data from Roskam (in deg)
        Aircraft.Tail.Horizontal.Sweep_qc = 31.75;   % qc = Quaterchord - Avg data from CADP(in deg)

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
        
        Aircraft.Tail.Horizontal.height = 1.9867;   
        % ------------------------------------------------------------------------------------------------------------------------
        %%% Vertical Tail
        % ------------------------------------------------------------------------------------------------------------------------
        Aircraft.Tail.Vertical.Coeff = 0.083;    % Vertical Tail Volume Coefficient - Avg data from CADP
        Aircraft.Tail.Vertical.arm = 0.45*Aircraft.Fuselage.length;    % Vertical Tail Moment Arm (in ft)
        Aircraft.Tail.Vertical.Aspect_Ratio = 1.87;   % Avg data from CADP   
        Aircraft.Tail.Vertical.taper_ratio = 0.31;   % Avg data from CADP
        Aircraft.Tail.Vertical.dihedral = 90;    % Avg data from Roskam (in deg)
        Aircraft.Tail.Vertical.Sweep_qc = 35.26;   % qc = Quaterchord - Avg data from CADP(in deg)

        Aircraft.Tail.Vertical.S = (Aircraft.Tail.Vertical.Coeff*Aircraft.Wing.S...
                                    *Aircraft.Wing.b)/(Aircraft.Tail.Vertical.arm);

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

        Aircraft.Tail.Vertical.t_c = 0.15;    % NACA 0015
        
        Aircraft.Tail.Vertical.height = 38.68; % Assumed to be constant
    
    end

    %% Fuselage Sizing
    function Aircraft = Fuselage_Sizing(Aircraft)
        Aircraft.Fuselage.length = 240.43;
        Aircraft.Fuselage.diameter = 250.51*in2ft;
    end

    %% Propulsion Sizing
    function Aircraft = Prop_Sizing(Aircraft)
        Aircraft.Propulsion.thrust = Aircraft.Weight.MTOW*Aircraft.Performance.TbyW;
        Aircraft.Propulsion.no_of_engines = 2;
        Aircraft.Propulsion.thrust_per_engine = Aircraft.Propulsion.thrust/Aircraft.Propulsion.no_of_engines;
    end
end