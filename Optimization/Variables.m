%%% Defining Variables
    clc
    clear
 
    d2r = pi/180;
    in2ft = 1/12;
    
%%% All dimensions are in FPS system    
%%% Aircraft = struct('Wing',[],'Fuselage',[]);

%%% Crew
    Aircraft.Crew.pilot = 2;
    Aircraft.Crew.attendants = 8;

%%% Passenger
    Aircraft.Passenger.economy = 350;
    Aircraft.Passenger.business = 50;
    
%%% Weight
    Aircraft.Weight.baggage = 30;
    Aircraft.Weight.person = 200;
    Aircraft.Weight.payload = (Aircraft.Weight.baggage + Aircraft.Weight.person)...
                        *(Aircraft.Passenger.economy + Aircraft.Passenger.business + ...
                          Aircraft.Crew.pilot + Aircraft.Crew.attendants);
    Aircraft.Weight.empty_Weight = 184840;
    Aircraft.Weight.fuel_Weight = 143775;
    Aircraft.Weight.MTOW = Aircraft.Weight.payload + Aircraft.Weight.fuel_Weight ...
                        + Aircraft.Weight.empty_Weight;

%%% Wing Geometry
    Aircraft.Wing.Aspect_Ratio = 9;
    Aircraft.Wing.S = 3360;
    Aircraft.Wing.b = sqrt(Aircraft.Wing.Aspect_Ratio*Aircraft.Wing.S);
    Aircraft.Wing.taper_ratio = 0.3;
    Aircraft.Wing.Sweep_qc = 35;
    Aircraft.Wing.chord_root = 2*Aircraft.Wing.S/(Aircraft.Wing.b*(1 + Aircraft.Wing.taper_ratio));
    Aircraft.Wing.Sweep_LE = atan(tan(Aircraft.Wing.Sweep_qc*d2r) - (Aircraft.Wing.chord_root...
                        *(Aircraft.Wing.taper_ratio - 1))/2/Aircraft.Wing.b)/d2r;
    Aircraft.Wing.chord_tip = Aircraft.Wing.chord_root*Aircraft.Wing.taper_ratio;
    Aircraft.Wing.mac = 2*Aircraft.Wing.chord_root*(1 + Aircraft.Wing.taper_ratio ...
                        + Aircraft.Wing.taper_ratio^2)/(3*(1 + Aircraft.Wing.taper_ratio));
    Aircraft.Wing.Y = (Aircraft.Wing.b/6)*(1 + 2*Aircraft.Wing.taper_ratio) ...
                        *(1 + Aircraft.Wing.taper_ratio);
    
    Aircraft.Wing.Dihedral = 3;
    Aircraft.Wing.Dihedral = 1;
    Aircraft.Wing.t_c_root = 0.15;
    
%%% Fuselage Dimensions
    Aircraft.Fuselage.length = 240.43;
    Aircraft.Fuselage.diameter = 250.51*in2ft;
    
%%% Tail
    % Horizontal Tail
    Aircraft.Tail.Horizontal.S = ;
    Aircraft.Tail.Horizontal.Aspect_Ratio = ;
    Aircraft.Tail.Horizontal.b = ;
    Aircraft.Tail.Horizontal.Sweep_hc = ;
    Aircraft.Tail.Horizontal.taper_ratio = ;
    Aircraft.Tail.Horizontal.t_c = ;
    
    % Vertical Tail
    Aircraft.Tail.Vertical.S = ;
    Aircraft.Tail.Vertical.Aspect_Ratio = ;
    Aircraft.Tail.Vertical.b = ;
    Aircraft.Tail.Vertical.Sweep_hc = ;
    Aircraft.Tail.Vertical.taper_ratio = ;
    Aircraft.Tail.Vertical.t_c = ;

%%% Vn Diagram Values
    Aircraft.Vndiagram.n_limt = 2.5;
    Aircraft.Vndiagram.n_ult = 1.5*Aircraft.Vndiagram.nlimt;
%     Aircraft.Vndiagram.Vd = ;

%%% Engine
    Aircraft.Engine.no_of_engines = 2;
    
