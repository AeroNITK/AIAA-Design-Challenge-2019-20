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

%%% Vn Diagram Values
    Aircraft.Vndiagram.n_limt = 2.5;
%    Aircraft.Vndiagram.n_ult = 1.5*Aircraft.Vndiagram.nlimt;
%     Aircraft.Vndiagram.Vd = ;
    
%%% Performance
    Aircraft.Performance.range = 3500;  % in nautical miles
    Aircraft.Performance.takeoff_runway_length = 9000;  % in ft
    Aircraft.Performance.landing_runway_length = 9000;  % in ft
    
    
