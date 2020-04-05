%%% Defining Variables
    clc
    clear
 
    d2r = pi/180;
    in2ft = 1/12;
    
%%% All dimensions are in FPS system    
%%% Aircraft = struct('Wing',[],'Fuselage',[]);

%%% Vn Diagram Values
    Aircraft.Vndiagram.n_limt = 2.5;
%    Aircraft.Vndiagram.n_ult = 1.5*Aircraft.Vndiagram.nlimt;
%     Aircraft.Vndiagram.Vd = ;

    Aircraft.Weight.empty_Weight = 184840;
    Aircraft.Weight.fuel_Weight = 143775;
    Aircraft.Weight.MTOW = Aircraft.Weight.payload + Aircraft.Weight.fuel_Weight ...
                        + Aircraft.Weight.empty_Weight;
    
    
